library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library ad_converter_serial_receiver_v1_00_a;
use ad_converter_serial_receiver_v1_00_a.user_logic;


entity ad_converter_serial_receiver is
	generic (
		-- Users to add parameters here
	
		OUTPUT_SIGNAL_CLOCK_DOMAIN_SELECTOR		: std_logic_vector(7 downto 0)  	:= X"00"; 		-- Selects clock domain for AD_SIGNAL_x. 0: bus clock. 1: AD signal clock.	 -- bit 7: H bit 6: G, bit 5: F, bit 4: E, bit 3: D, bit 2: C, bit 1:B, bit 0: A 
		INIT_DELAY_COUNTER_START_VALUE				: integer                       	:= 10; 			-- antall AD-avlesinger f?r clk_bus_signal_ny begynner ? flagge nye signaler.
		INVERT_OPUTPUT_SIGNAL					: std_logic_vector(7 downto 0)	:= X"00"; 		-- 0: not inverting 1: invertering. Compensates for inversion in buffer amplifier stage. 
		USE_OFFSET_COMPENSATION				: std_logic                    	:= '1'; 			-- 0: Ingen USE_OFFSET_COMPENSATION. 1: Offserkompensering. NB! Utgangssignalene skiftes et hakk ned n?r offserkompensering brukes. Unng?r dermed overflyt.
		AD_CLOCK_IOBDELAY_VALUE			: integer								:= 7; 			-- Justering av bitklokk. Kompenserer for signalforsinkelse i AD klokka. Ca 85 ps pr. trinn.
		AD_SIGNAL_IOBDELAY_VALUE		: integer								:= 14; 			-- Tuning of signal skew compensation for data lines.  -- Net compensation is:  AD_SIGNAL_IOBDELAY_VALUE -  AD_CLOCK_IOBDELAY_VALUE
		USE_INTERNAL_DELAYCTRL    	: std_logic                     	:= '1'; -- IDELAY m? ha en DELAYCTRL-enhet. Det kan kun finnes en eneste DELAYCYTL med uspesifisert posisjon i et system. M? kutte ut denne hvis det finnes en i en annen IP modul, som i DRAM-kontrolleren. 
		DOWNSAMPLING_FACTOR_WIDTH    	: integer                       	:= 0; -- Nedsamplingsfaktoren angir forholdet mellom samplerate i AD omformeren og samplerate ut fra seriemottakeren. Verdien p? Nedsamlingsfaktoren er en toerpotens. Den angis med bredde i bit. Det gir:   n = 2 ** DOWNSAMPLING_FACTOR_WIDTH. 0 bit  gir 1:1 nedsamplingsfaktor.	
		NUMBER_OF_CHANNELS               	: integer                       	:= 8;
		AD_CONVERTER_SIGNAL_WIDTH 		: integer 					:= 12;			-- Word size in the data from the AD converter 	
		WIDTH_OUT                    	: integer                       	:= 13; -- One bit wider than AD converter signal width when offset compensation is used.	

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

		C_S_AXI_DATA_WIDTH	: integer	:= 32;	-- Width of S_AXI data bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 7		-- Width of S_AXI address bus
			
	 
	);
	port (
		-- Users to add ports here
		
	-- External ports towards the AD-converter. These are LVDS  signal pairs: xxx_p og xxx_n
		ad_d_p                   : in  std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0); -- bit 7: H bit 6: G, bit 5: F, bit 4: E, bit 3: D, bit 2: C, bit 1:B, bit 0: A
		ad_d_n                   : in  std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0);
		ad_fcop                  : in  std_logic;
		ad_fcon                  : in  std_logic;
		ad_dcop                  : in  std_logic;
		ad_dcon                  : in  std_logic;

		-- Internal porters towards FPGA circuitry. 
		ad_200MHz_delay_ref_clock : in  std_logic; -- 200 MHz referanseklokke for DELAYCTRL. 

		ad_data_clock_out        : out std_logic;

		ad_signal_out             : out std_logic_vector(NUMBER_OF_CHANNELS * WIDTH_OUT - 1 downto 0); -- ad_h & ad_f & ad_e & ad_d & ad_c & ad_b & ad_a;

		ad_signal_a              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_b              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_c              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_d              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_e              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_f              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_g              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_h              : out std_logic_vector(WIDTH_OUT - 1 downto 0);
		ad_signal_new_busclk      : out std_logic; -- Ny sample, bus clock domain
		ad_signal_new_adclk       : out std_logic; -- Ny sample, AD clock domain
   
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
end ad_converter_serial_receiver;

architecture arch_imp of ad_converter_serial_receiver is
 
--	signal axi_arready_u	: std_logic;
--	signal axi_awready_u	: std_logic;
	 
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
	--signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		signal reg_data_out_u	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

		
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
	         -- axi_rdata <= reg_data_out;     -- register read data
				 axi_rdata <= reg_data_out_u;     -- register read data
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
			OUTPUT_SIGNAL_CLOCK_DOMAIN_SELECTOR   => OUTPUT_SIGNAL_CLOCK_DOMAIN_SELECTOR,
			INIT_DELAY_COUNTER_START_VALUE         => INIT_DELAY_COUNTER_START_VALUE,
			INVERT_OPUTPUT_SIGNAL            => INVERT_OPUTPUT_SIGNAL,
			USE_OFFSET_COMPENSATION           => USE_OFFSET_COMPENSATION,
			AD_CLOCK_IOBDELAY_VALUE		  => AD_CLOCK_IOBDELAY_VALUE,	
			AD_SIGNAL_IOBDELAY_VALUE     => AD_SIGNAL_IOBDELAY_VALUE,
			USE_INTERNAL_DELAYCTRL    => USE_INTERNAL_DELAYCTRL,
			DOWNSAMPLING_FACTOR_WIDTH    => DOWNSAMPLING_FACTOR_WIDTH,
			NUMBER_OF_CHANNELS               => NUMBER_OF_CHANNELS,
			AD_CONVERTER_SIGNAL_WIDTH		=> AD_CONVERTER_SIGNAL_WIDTH,
			WIDTH_OUT                    => WIDTH_OUT,

			-- MAP USER GENERICS ABOVE THIS LINE ---------------

			
			C_SLV_AWIDTH          			=> C_S_AXI_ADDR_WIDTH,
			C_SLV_DWIDTH                 => C_S_AXI_DATA_WIDTH
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
      --USER ports mapped here

			ad_d_p                   => ad_d_p,
			ad_d_n                   => ad_d_n,
			ad_fcop                  => ad_fcop,
			ad_fcon                  => ad_fcon,
			ad_dcop                  => ad_dcop,
			ad_dcon                  => ad_dcon,
			ad_200MHz_delay_ref_clock => ad_200MHz_delay_ref_clock,
			ad_data_clock_out        => ad_data_clock_out,
			ad_signal_out             => ad_signal_out,
			ad_signal_a              => ad_signal_a,
			ad_signal_b              => ad_signal_b,
			ad_signal_c              => ad_signal_c,
			ad_signal_d              => ad_signal_d,
			ad_signal_e              => ad_signal_e,
			ad_signal_f              => ad_signal_f,
			ad_signal_g              => ad_signal_g,
			ad_signal_h              => ad_signal_h,
			ad_signal_new_busclk      => ad_signal_new_busclk,
			ad_signal_new_adclk       => ad_signal_new_adclk,
		
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      Bus2IP_Clk                     => S_AXI_ACLK,
      Bus2IP_Resetn                  => S_AXI_ARESETN,
      Bus2IP_WrAddr                    => axi_awaddr,
	  Bus2IP_RdAddr						 => axi_araddr,
      Bus2IP_Data                    => S_AXI_WDATA,
      Bus2IP_BE                      => S_AXI_WSTRB,
      Bus2IP_RdCE                    => slv_reg_rden,
      Bus2IP_WrCE                    => slv_reg_wren,
      IP2Bus_Data                    => reg_data_out_u,
      IP2Bus_RdAck                   => rd_ack,
      IP2Bus_WrAck                   => wr_ack,
      IP2Bus_Error                   => open
    );

	-- User logic ends

end arch_imp;
