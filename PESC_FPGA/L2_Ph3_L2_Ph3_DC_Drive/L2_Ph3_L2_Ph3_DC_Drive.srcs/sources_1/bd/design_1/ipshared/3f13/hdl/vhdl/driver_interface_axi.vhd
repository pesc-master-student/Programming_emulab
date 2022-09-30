library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library driver_interface_v1_00_a;
use driver_interface_v1_00_a.user_logic;


entity driver_interface is
	generic (
		-- Users to add parameters here
	NUMBER_OF_SIGNAL_SOURCES				: integer  := 1;  
		
	SEPARATE_SIGNALS_FOR_LOWER_DRIVERS		: integer range 1 downto 0 	:= 0;   -- 1: Use separate control signals 0: Common for upper and lower drivers.
		
	CONFIG_REG_DEFAULT_VALUE : std_logic_vector(31 downto 0) :=  X"00131313"; -- cba+: pwm, cba: fast på.
		-- bit 1-0: driver A-, 	bit 5-4: driver A+, 	bit 9-8: driver B-,	bit 13-12: driver B+,	bit 17-16: driver C-,  bit 21-20  driver C+.
		-- bit 27. Driver reset.		1: reset 0: normal operation.
		-- Configuration:	2 bit pr driver: 	0: Permanently off. 1: Signal, 2: Inverted signal 3: Permanently on. 

	SIGNAL_SOURCE_REG_DEFAULT_VALUE	: std_logic_vector(31 downto 0) := X"00000000"; 	-- Sets default signal source. 4 bit pr. driver.
		--	bit 23-20  CH, bit 19-16 CL, bit 15- 12 BH, bit 11-8  BL bit 7-4 AH, bit 3-0 AL

	USE_WATCHDOG_TIMER						: integer  := 1;  		-- 0: No watchdog. 1: Use watchdog timer.	
	
	PILOT_SIGNAL_BITNR						: integer := 6;     --	Selects bit in watchdog timer for pilot signal pin. 
		-- Determines frequency of pilot signal: Fp = Fclock/(2**PILOT_SIGNAL_BITNR).
	
	NUMBER_OF_DISABLE_IN_SIGNALS				: integer  range 4 downto 1 := 1;   -- Signals from FPGA fabric. 

		-- User parameters ends
		-- Do not modify the parameters beyond this line
		-- C_S_AXI_ACLK_FREQ_HZ  : integer                       := 100_000_000;  	-- Hz. Clock frequency.  Value is updated automatically. 
		 -- EDK: MPD file entry: 	PARAMETER C_S_AXI_ACLK_FREQ_HZ = 100000000, DT = INTEGER, BUS = S_AXI, IO_IS = clk_freq, CLK_PORT = S_AXI_ACLK, CLK_UNIT = HZ, ASSIGNMENT = REQUIRE
		
		-- Dummy parameters for EDK: Not used inside the module.
		C_S_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
		C_S_HIGHADDR                     : std_logic_vector     := X"00000000";
		--- The 	C_S_BASEADDR, C_S_HIGHADDR can be removed from the VHDL file by inserting TYPE = NON_HDL for thpse parameters in the MPD file.
		-- EDK: MPD file entry:  	PARAMETER C_BASEADDR = 0xffffffff, DT = std_logic_vector(31 downto 0), PAIR = C_HIGHADDR, ADDRESS = BASE, BUS = S_AXI, MIN_SIZE = 0x1000, ASSIGNMENT = REQUIRE, TYPE = NON_HDL
		-- EDK: MPD file entry:		PARAMETER C_HIGHADDR = 0x00000000, DT = std_logic_vector(31 downto 0), PAIR = C_BASEADDR, ADDRESS = HIGH, BUS = S_AXI, ASSIGNMENT = REQUIRE, TYPE = NON_HDL

			
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
		

	-- Eksternal signals to drivers etc.
 	driver_status						: in	std_logic_vector (3 downto 0); -- Status signal from drivers. Inverted logic levels: H : 0, L: 1.  
	driver_ok							: in  	std_logic; -- 1: ready.    0: Not ready
	driver_enable						: out	std_logic;
	driver_signals						: out	std_logic_vector (2 * 3 -1 downto 0); -- bit 5: C+, bit 4: C-, bit 3: B+, bit 2: B-, bit 1: A+, bit 0: A-.   
	driver_reset						: out	std_logic;
	pilot_signal 						: out	std_logic; 		
	
	--  Internal signals from FPGA fabric.	
	driver_signal_in					: in	std_logic_vector(3 * NUMBER_OF_SIGNAL_SOURCES -1  downto 0):= (others => '0');  	-- Control signal from FPGA fabric.  
	driver_signal_in_L					: in	std_logic_vector(3 * NUMBER_OF_SIGNAL_SOURCES -1  downto 0):= (others => '0');  	-- Separate control signals for lower driver.
		-- 3 bits per source: bit 2: C, bit 1: B	bit 0: A.	 source 2 &source1 &source 0
	disable_in							: in	std_logic_vector( NUMBER_OF_DISABLE_IN_SIGNALS -1  downto 0):= (others => '0'); 		-- 1: driver enable signal is disabled.  
	ok_out								: out std_logic; -- 1: OK.
	watchdog_expired					: out std_logic; -- 0: OK. 1: Watchdog timer expired.
	
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    -- privilege and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0) := (others=> '0');
		-- Write address valid. This signal indicates that the master signaling
    -- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    -- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    -- valid data. There is one write strobe bit for each eight
    -- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    -- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    -- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    -- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    -- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    -- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether the
    -- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0) := (others=> '0');
		-- Read address valid. This signal indicates that the channel
    -- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    -- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    -- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    -- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end driver_interface;

architecture arch_imp of driver_interface is

	
	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	

	
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);


		
			signal rd_ack	: std_logic;
			signal wr_ack : std_logic;
begin
	-- I/O Connections assignments

--	S_AXI_AWREADY	<= axi_awready;
	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	--	S_AXI_ARREADY	<= axi_arready;
	
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	       axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	slv_reg_wren <= axi_wready;
	
-- wr_ack

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	     -- if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
		  if rd_ack = '1' then 
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;



	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (rd_ack = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
				axi_rdata <= reg_data_out;     -- register read data

	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here
------------------------------------------
  -- instantiate User Logic
  ------------------------------------------
  USER_LOGIC_I : entity user_logic
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
      --USER generics mapped here

      NUMBER_OF_SIGNAL_SOURCES 				=> NUMBER_OF_SIGNAL_SOURCES,		
		SEPARATE_SIGNALS_FOR_LOWER_DRIVERS 		=> SEPARATE_SIGNALS_FOR_LOWER_DRIVERS,
		SIGNAL_SOURCE_REG_DEFAULT_VALUE	=> SIGNAL_SOURCE_REG_DEFAULT_VALUE,
		CONFIG_REG_DEFAULT_VALUE	=> CONFIG_REG_DEFAULT_VALUE,
		USE_WATCHDOG_TIMER 			=> USE_WATCHDOG_TIMER,	
		PILOT_SIGNAL_BITNR 				=> PILOT_SIGNAL_BITNR,
		NUMBER_OF_DISABLE_IN_SIGNALS				=> NUMBER_OF_DISABLE_IN_SIGNALS,
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

		C_SLV_AWIDTH                   => C_S_AXI_ADDR_WIDTH,
		C_SLV_DWIDTH                   => C_S_AXI_DATA_WIDTH
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
      --USER ports mapped here

		
		driver_status					=> driver_status,		
		driver_ok						=> driver_ok,		
		driver_enable					 => driver_enable,		
		driver_signals					 => driver_signals,		
		driver_reset					=> driver_reset,	
		pilot_signal					=> pilot_signal,

		driver_signal_in				=> driver_signal_in,	
		driver_signal_in_L				=> driver_signal_in_L,
		disable_in						=> disable_in,
		ok_out							=> ok_out,
		watchdog_expired					=> watchdog_expired,
		
		
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      Bus2IP_Clk                     => S_AXI_ACLK,
      Bus2IP_Resetn                  => S_AXI_ARESETN,
      Bus2IP_WrAddr                  => axi_awaddr,
	  Bus2IP_RdAddr					 => axi_araddr,
      Bus2IP_Data                    => S_AXI_WDATA,
      Bus2IP_BE                      => S_AXI_WSTRB,
      Bus2IP_RdCE                    => slv_reg_rden,
      Bus2IP_WrCE                    => slv_reg_wren,
      IP2Bus_Data                    => reg_data_out,
      IP2Bus_RdAck                   => rd_ack,
      IP2Bus_WrAck                   => wr_ack

    );

	-- User logic ends

end arch_imp;
