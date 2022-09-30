--***************************************************************************
-- Driver interface. 
--
--  Kjell Ljøkelsøy. Sintef Energi. 2009- 2016
--
-- Interface inverter driver signal interface as specified in: Driver interface v2.3. 
-- Ref:  Sintef Energy AN 14.12.77 Driver interface v2.3”
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

------------------------------------------------------------------------------

entity user_logic is
  generic
  (
  	NUMBER_OF_SIGNAL_SOURCES				: integer  := 1;  
		
	SEPARATE_SIGNALS_FOR_LOWER_DRIVERS		: integer range 1 downto 0 	:= 0;   -- 1: Use separate control signals 0: Common for upper and lower drivers.
		
	CONFIG_REG_DEFAULT_VALUE : std_logic_vector(31 downto 0) :=  X"00131313"; -- cba+: pwm, cba: fast på.
		-- bit 1-0: driver A-, 	bit 5-4: driver A+, 	bit 9-8: driver B-,	bit 13-12: driver B+,	bit 17-16: driver C-,  bit 21-20  driver C+.
		-- Configuration:	2 bit pr driver: 	0: Permanently off. 1: Signal, 2: Inverted signal 3: Permanently on. 
		-- bit 27. Driver reset.		1: reset 0: normal operation.
	
	SIGNAL_SOURCE_REG_DEFAULT_VALUE	: std_logic_vector(31 downto 0) := (others => '0'); 	-- Sets default signal source. 4 bit pr. driver.
		--	bit 23-20  CH, bit 19-16 CL, bit 15- 12 BH, bit 11-8  BL bit 7-4 AH, bit 3-0 AL

	USE_WATCHDOG_TIMER						: integer  := 1;  		-- 0: No watchdog. 1: Use watchdog timer.	
	
	PILOT_SIGNAL_BITNR						: integer := 6;     --	Selects bit in watchdog timer for pilot signal pin. 
		-- Determines frequency of pilot signal: Fp = Fclock/(2**PILOT_SIGNAL_BITNR).
	
	NUMBER_OF_DISABLE_IN_SIGNALS				: integer  range 4 downto 1 := 1;   -- Signals from FPGA fabric. 

    -- Bus protocol parameters.
    C_SLV_AWIDTH                   			: integer              := 32;
    C_SLV_DWIDTH                   			: integer              := 32

  );
  port
  (
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

    --------------------------------------------------------

		Bus2IP_Clk               : in  std_logic;
		Bus2IP_Resetn            : in  std_logic;
		Bus2IP_RdCe              : in std_logic;
		Bus2IP_WrCe              : in std_logic;		
	 	Bus2IP_RdAddr			 : in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0);--:= (others => '0');
		Bus2IP_WrAddr			 : in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0) := (others => '0');
		Bus2IP_Data              : in  std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		Bus2IP_BE                : in  std_logic_vector(C_SLV_DWIDTH / 8 - 1 downto 0);
		IP2Bus_Data              : out std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		IP2Bus_RdAck             : out std_logic;
		IP2Bus_WrAck             : out std_logic

  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  constant  NUM_REG 					: integer := 5; 
  
	--====================================================================
	 -- Register numbers 
  
	
	constant STATUS_REGISTER_REGNR 					: integer := 0;
  	constant ENABLE_SIGNAL_REGNR					: integer := 1;
	constant CONFIG_REGISTER_REGNR 					: integer := 2;
	constant SIGNAL_SOURCE_SELECTOR_REGNR			: integer := 3;	
	constant WATCHDOG_COUNTER_REGNR					: integer := 4;

	------------------------------
	-- Bit allocation for config register. 

	-- Bit 1-0:   	driver A-	Bit 5-4:   	driver A+ 
	-- Bit 9-8:   	driver B-	Bit 13-12  	driver B+
	-- Bit 17-16  	driver C-	Bit 21-20  	driver C+ 
	constant DRIVER_RESET_REG_BITNR					: integer := 27;   
	
	--	Operating mode settings for each individual driver. 	
	constant PERMANENT_OFF 							: std_logic_vector(1 downto 0) := "00"; 
	constant SIGNAL_IN 								: std_logic_vector(1 downto 0) := "01"; 
	constant INVERTED_SIGNAL_IN						: std_logic_vector(1 downto 0) := "10"; 
	constant PERMANENT_ON 							: std_logic_vector(1 downto 0) := "11";
	
	-------------------
	-- Bit allocation for status register. 		
		
	constant DISABLE_IN_SIGNAL_BIT_STARTNR  		: integer := 28;
	constant DRIVER_RESET_STATUS_BITNR  			: integer := 27;
	constant DRIVER_WATCHDOG_EXPIRED_BITNR   		: integer := 26;
	constant DRIVER_ENABLE_REGISTER_VALUE_BITNR		: integer := 25;
	constant RESULTING_DRIVER_ENABLE_SIGNAL_BITNR	: integer := 24;
	constant DRIVERSIGNALS_BIT_STARTNR  			: integer := 16;
	constant DRIVER_OK_SIGNAL_REG_BITNR  			: integer := 8;
	constant DRIVER_STATUS_SIGNAL_REG_BITNR  		: integer := 0;
	
	---------------
	-- Misc. 

	constant NUMBER_OF_PHASES						: integer  := 3;    -- Interface for three phase drivers.

	constant NUMBER_OF_DRIVER_STATUS_SIGNALS		: integer :=  4;
   
	constant NUMBER_OF_DRIVERS_PR_PHASE				: integer :=  2;  -- 2 drivers pr phase/ halfbridge 

	constant NUMBER_OF_DRIVERS						:integer := NUMBER_OF_DRIVERS_PR_PHASE * NUMBER_OF_PHASES;
	
	
	constant SIGNAL_SOURCE_SELECTOR_WIDTH			: integer := 4;  -- 4 bit pr. driver.  bit 23-20  CH, bit 19-16 CL, bit 15- 12 BH, bit 11-8  BL bit 7-4 AH, bit 3-0 AL. 
	
	constant ASYNC_RESET_COUNTER_LOAD_VALUE			: integer :=  3;  -- loadvalue for reset counter for enable signal. Asynchron reset in.
   	constant DRIVER_CONFIG_VALUE_WIDTH				: integer :=  4; 
   
   
	signal clock 									: std_logic := '0';  
	signal reset 									: std_logic := '1';  

		
	signal statusreg								: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	

	signal config_reg								: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal config_reg_read							: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	

	signal signal_source_selector_reg				: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal signal_source_selector_read_reg			: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');		
	
	
	signal watchdog_reg								: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal watchdog_reg_read						: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');		


	signal disable_in_summary						: std_logic := '0';
	signal disable_in_ok_compare_vector				: std_logic_vector( NUMBER_OF_DISABLE_IN_SIGNALS -1  downto 0):= (others => '0'); 					
	
		
	signal enable_signal_out						 : std_logic := '0';
	signal enable_signal_reg					     : std_logic := '0';
	signal watchdog_has_expired					    : std_logic := '0';  
	
	signal driver_reset_signal						: std_logic := '0';  
	
	signal driver_status_signal						: std_logic_vector ( NUMBER_OF_DRIVER_STATUS_SIGNALS-1 downto 0) := (others => '0');

	signal driversignal_LH				         	: std_logic_vector(NUMBER_OF_DRIVERS-1 downto 0 ) := (others => '0');		
		
	signal driver_control_signals					: std_logic_vector(NUMBER_OF_DRIVERS-1 downto 0 ) := (others => '0');		
	
	type driversignal_in_array_type 				is array  (NUMBER_OF_SIGNAL_SOURCES -1 downto 0) of std_logic_vector(NUMBER_OF_PHASES-1 downto 0);	
	signal driver_signal_in_array					: driversignal_in_array_type := (others => (others => '0'));	
	signal driver_signal_in_L_array					: driversignal_in_array_type := (others => (others => '0'));	
	
	type driver_signal_selector_reg_array_type		is array  (NUMBER_OF_DRIVERS -1 downto 0) of integer range 2**SIGNAL_SOURCE_SELECTOR_WIDTH -1 downto 0;
	signal drive_signal_selector_reg_H				: driver_signal_selector_reg_array_type := (others => 0);
	signal drive_signal_selector_reg_L				: driver_signal_selector_reg_array_type := (others => 0);
	
	type driver_signal_selector_array_type			is array  (NUMBER_OF_DRIVERS -1 downto 0) of integer range NUMBER_OF_SIGNAL_SOURCES -1 downto 0;
	signal driver_signal_selector_H					: driver_signal_selector_array_type := (others => 0);
	signal driver_signal_selector_L					: driver_signal_selector_array_type := (others => 0);
	
	signal driversignal_H							: std_logic_vector(NUMBER_OF_PHASES - 1 downto 0 ) := (others => '0');		
	signal driversignal_L							: std_logic_vector(NUMBER_OF_PHASES - 1 downto 0 ) := (others => '0');

	
	signal driver_ok_signal							: std_logic := '0';
	signal driver_ok_m								: std_logic := '0';
	
	signal async_reset_sig							: std_logic := '1';	
	signal async_reset_counter						: integer range ASYNC_RESET_COUNTER_LOAD_VALUE downto 0:= ASYNC_RESET_COUNTER_LOAD_VALUE;
		
	type driver_configuration_array_type 			is array  (NUMBER_OF_DRIVERS -1 downto 0) of std_logic_vector(1 downto 0);	
	signal driver_configuration_array 				: driver_configuration_array_type := (others => (others => '0'));	
	
	
	------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------


		function i_log2 (x : positive) return integer is   -- Needed to extract size of array index  
			variable i : integer;
				begin
					i := 0;  
					while (2 ** i < x) and i < 512 loop
						i := i + 1;
					end loop;
				return i;
		end function;
		
		----------------
		constant REG_ADDR_WIDTH 		: integer := i_log2(NUM_REG);
		constant REG_ADDR_SHIFT			: integer := i_log2(C_SLV_DWIDTH/8 -1);
		
		constant P_NUM_REG				: integer  := 2 ** REG_ADDR_WIDTH; 
				
		signal slv_ip2bus_data   		: std_logic_vector(C_SLV_DWIDTH - 1 downto 0) := (others => '0');
		
		signal reg_read_enable   		: std_logic                               	:= '0';
		signal reg_write_enable  		: std_logic                               	:= '0';
		signal reg_read_enable_dly1  	: std_logic                               	:= '1';
		signal reg_read_ack      		: std_logic                               	:= '0';
		signal reg_write_ack     		: std_logic                               	:= '0';	
		

		signal reg_wr_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
		signal reg_rd_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
		
		signal reg_wr_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
		signal reg_rd_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
		
		type register_array_type is array (P_NUM_REG - 1 downto 0) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);


		signal register_array_read   	: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
		signal register_array_write 	: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
		signal register_array_init 	: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
	--	signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

	--	signal load 					: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
		

	
	--====================================================================


begin

	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;

		
 	assert ( NUMBER_OF_SIGNAL_SOURCES < 2 ** SIGNAL_SOURCE_SELECTOR_WIDTH)
		report "#### NUMBER_OF_SIGNAL_SOURCES too large. Eexceeds available width of selector vector."
		severity warning;
		

	clock <= Bus2IP_Clk;
   reset <= '1' when Bus2IP_Resetn = '0' else '0';

  ------------------------------------------

	
	
	---===========================================================	
	
	reg_read_enable <= Bus2IP_RdCE;
	reg_write_enable <= Bus2IP_WrCE;

	 
	reg_wr_addr <= Bus2IP_WrAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);
	
	reg_rd_addr <= Bus2IP_RdAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);

	reg_wr_index <= conv_integer(unsigned(reg_wr_addr));
	
	reg_rd_index <= conv_integer(unsigned(reg_rd_addr));
	
	----------------------------------------------------------------------------
	-- Register write process. Bytewise write.
	
	Register_array_process : process(Bus2IP_Clk) is
		begin
			if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
				if Bus2IP_Resetn = '0' then								
					register_array_write   <= register_array_init;					
					watchdog_has_expired <= '0';   -- Set to '0'  when wachdog is not used.
					
				else			
				----------------------
				
				-- Watchdog counter inserted here. Uses registers array as counter directly. 
				-- This allows counter value is overwritten when the processor writes to the counter.  
				if USE_WATCHDOG_TIMER = 1 then 
					if 	unsigned(register_array_write(WATCHDOG_COUNTER_REGNR)) = 0 then
						watchdog_has_expired  <= '1'; 
					else 
						register_array_write(WATCHDOG_COUNTER_REGNR) <= register_array_write(WATCHDOG_COUNTER_REGNR) -1;
						watchdog_has_expired <= '0';
					end if;
				end if;				
				---------------
				
					if  reg_write_enable = '1' then
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop					 
							if (Bus2IP_BE(byte_index) = '1')  then						
								register_array_write(reg_wr_index)(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 +7 downto byte_index * 8);
							end if;
						end loop;
					end if;
				end if;	
			end if;		
		end process;
	
 	-------------
	-- Read.
	
	slv_ip2bus_data <= register_array_read(reg_rd_index) when  reg_read_enable = '1' else (others => '0');
	reg_read_ack     <= reg_read_enable;

	reg_write_ack 	<= reg_write_enable;
	 
	IP2Bus_Data <= slv_ip2bus_data;
	
	IP2Bus_WrAck <= reg_write_ack;
	IP2Bus_RdAck <= reg_read_ack;
 	
--=============================================================================



	-- Register array allocation.  

	-- Intital values. 
	
	register_array_init(CONFIG_REGISTER_REGNR) 		<= CONFIG_REG_DEFAULT_VALUE;
	register_array_init(SIGNAL_SOURCE_SELECTOR_REGNR) 	<= SIGNAL_SOURCE_REG_DEFAULT_VALUE;	
		
	-- Write. 
		
	config_reg 						<= register_array_write(CONFIG_REGISTER_REGNR);	
	enable_signal_reg				<= register_array_write(ENABLE_SIGNAL_REGNR)(0);	-- Only one bit in this register. 
	signal_source_selector_reg		<= register_array_write(SIGNAL_SOURCE_SELECTOR_REGNR);

	-- Read
		
	register_array_read(STATUS_REGISTER_REGNR) 					<= statusreg;
	register_array_read(ENABLE_SIGNAL_REGNR)(0)					<= enable_signal_reg;   -- Only one bit in this register. 
	register_array_read(CONFIG_REGISTER_REGNR) 					<= config_reg_read; 
	register_array_read(SIGNAL_SOURCE_SELECTOR_REGNR) 			<= signal_source_selector_read_reg;
	
  	register_array_read(WATCHDOG_COUNTER_REGNR) 				<= 	register_array_write(WATCHDOG_COUNTER_REGNR);
	
	
	---------------------------------------------------------------

	statusreg(RESULTING_DRIVER_ENABLE_SIGNAL_BITNR)					<= enable_signal_out;
	statusreg(DISABLE_IN_SIGNAL_BIT_STARTNR + NUMBER_OF_DISABLE_IN_SIGNALS-1 downto DISABLE_IN_SIGNAL_BIT_STARTNR)			<= disable_in;
	statusreg(DRIVER_ENABLE_REGISTER_VALUE_BITNR)					<= enable_signal_reg;
	statusreg(DRIVER_WATCHDOG_EXPIRED_BITNR)							<= watchdog_has_expired;
	statusreg(DRIVER_RESET_STATUS_BITNR) 							<= driver_reset_signal;

	statusreg(DRIVERSIGNALS_BIT_STARTNR + NUMBER_OF_DRIVERS-1  downto DRIVERSIGNALS_BIT_STARTNR)	<= driver_control_signals;

	statusreg(DRIVER_OK_SIGNAL_REG_BITNR)							<= driver_ok_signal;
	statusreg(DRIVER_STATUS_SIGNAL_REG_BITNR +NUMBER_OF_DRIVER_STATUS_SIGNALS-1 downto DRIVER_STATUS_SIGNAL_REG_BITNR)		<= driver_status_signal;

	-- Setter opp signaler rundt konfigregistret.	
	
	config_reg_read(DRIVER_RESET_REG_BITNR) 					<= driver_reset_signal;

	---------------------------------------------
	-- connects signsls and ports. 
	
	
	driver_enable 						<= enable_signal_out;	
	driver_signals						<= driver_control_signals;			
	
	disable_in_summary 					<= '0' when disable_in = disable_in_ok_compare_vector else '1';
	
	ok_out								<= driver_ok_signal;  -- ok signal available for FPGA fabric.

	watchdog_expired 						<= watchdog_has_expired;	
	pilot_signal <= register_array_write(WATCHDOG_COUNTER_REGNR)(PILOT_SIGNAL_BITNR);
	
	driver_reset_signal <= config_reg(DRIVER_RESET_REG_BITNR);
	
	driver_reset <= driver_reset_signal;
	
		
	driversignal_funksjon_sammenkobling_generate : for d in 0 to NUMBER_OF_DRIVERS-1 generate   	
			driver_configuration_array(d) <= 	config_reg(DRIVER_CONFIG_VALUE_WIDTH * d +1 downto DRIVER_CONFIG_VALUE_WIDTH * d ) ; -- One hex value pr. driver.  cp,cn,bp,bn,ap,an,  		
		config_reg_read(4 * d + 1 downto 4 * d ) <= driver_configuration_array(d) ; 		
	
	end generate;

	signal_source_array_generate: for n in 0 to NUMBER_OF_SIGNAL_SOURCES-1 generate 
	  
		driver_signal_in_array(n) 		<= driver_signal_in(n * NUMBER_OF_PHASES + NUMBER_OF_PHASES-1 downto n * NUMBER_OF_PHASES);
		driver_signal_in_L_array(n) 	<= driver_signal_in_L(n * NUMBER_OF_PHASES + NUMBER_OF_PHASES-1 downto n * NUMBER_OF_PHASES);
		
	end generate; 
	
	
	signal_source_selector_array_register_allocation_generate: for f in 0 to NUMBER_OF_PHASES-1 generate 
	
		drive_signal_selector_reg_H(f) <=   CONV_INTEGER( '0' & signal_source_selector_reg( ( f * NUMBER_OF_DRIVERS_PR_PHASE + 1 + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH  -1 downto  ( f * NUMBER_OF_DRIVERS_PR_PHASE + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH)); 	
		drive_signal_selector_reg_L(f) <=   CONV_INTEGER( '0' &  signal_source_selector_reg( ( f * NUMBER_OF_DRIVERS_PR_PHASE + 0 + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH  -1 downto  ( f * NUMBER_OF_DRIVERS_PR_PHASE + 0) * SIGNAL_SOURCE_SELECTOR_WIDTH)); 	

		driver_signal_selector_H(f) <= drive_signal_selector_reg_H(f) when drive_signal_selector_reg_H(f) < NUMBER_OF_SIGNAL_SOURCES else 0;
		driver_signal_selector_L(f) <= drive_signal_selector_reg_L(f) when drive_signal_selector_reg_L(f) < NUMBER_OF_SIGNAL_SOURCES else 0;
		-- h & l 
		signal_source_selector_read_reg(( f * NUMBER_OF_DRIVERS_PR_PHASE + 1 + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH  -1 downto  ( f * NUMBER_OF_DRIVERS_PR_PHASE + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH)  <=   CONV_STD_LOGIC_VECTOR(driver_signal_selector_H(f),SIGNAL_SOURCE_SELECTOR_WIDTH);   	
		signal_source_selector_read_reg(( f * NUMBER_OF_DRIVERS_PR_PHASE + 0 + 1) * SIGNAL_SOURCE_SELECTOR_WIDTH  -1 downto  ( f * NUMBER_OF_DRIVERS_PR_PHASE + 0) * SIGNAL_SOURCE_SELECTOR_WIDTH)  <=   CONV_STD_LOGIC_VECTOR(driver_signal_selector_L(f),SIGNAL_SOURCE_SELECTOR_WIDTH);   	
				
	end generate;
	
	
	signalsource_selector_generate: for f in 0 to NUMBER_OF_PHASES-1 generate 
	
		driversignal_H(f)   <= driver_signal_in_array(driver_signal_selector_H(f))(f); 
		 
		driversignal_L(f)   <= 	driver_signal_in_L_array(driver_signal_selector_L(f))(f) when  (SEPARATE_SIGNALS_FOR_LOWER_DRIVERS = 1) 	else 	driversignal_H(f);  
				
	
	end generate; 
	---------------------		
	
	-- Driver signal assembly. Two driver_control_signals pr. phase: ch & cl & bh & bl & ah & al
		
	driversignal_generate : for f in 0 to NUMBER_OF_PHASES -1 generate  

		driversignal_LH(NUMBER_OF_DRIVERS_PR_PHASE * f + 0 )  <= driversignal_L(f);
		driversignal_LH(NUMBER_OF_DRIVERS_PR_PHASE * f + 1 )  <= driversignal_H(f);
	end generate;

	-- Configurtation of each of the driver signals.
	driver_signal_generate : for d in 0 to NUMBER_OF_DRIVERS-1 generate   	

		driver_control_signals(d) <= '1' 					when (driver_configuration_array(d) = "11") 
					else	driversignal_LH(d) 		when (driver_configuration_array(d) = "01")
					else (not driversignal_LH(d))	when (driver_configuration_array(d) = "10") 
					else	'0';
				

	end generate;	
	

	
	-- Registers for input signals from drivers. Removes metastability etc. 
	
	signalsynkprosess : process(clock) is 
		begin
			if (clock 'event and clock = '1') then		
				driver_ok_m 					<= driver_ok;
				driver_ok_signal 				<= driver_ok_m;						
				driver_status_signal			<= not driver_status;
			end if;
		end process;	

	
	
	-- Reset of enable signal.  Asyncronous setting of reset signal, synchronous clearing.
	-- Ensures that enable signal can be cleared by an asynchronous reset signal.
	
	Enable_signal_reset_prosess : process(clock, reset) is   
		begin
			if reset = '1' then
				async_reset_sig <= '1';
				async_reset_counter <= ASYNC_RESET_COUNTER_LOAD_VALUE;  -- A few clockpulses.
			elsif (clock 'event and clock = '1') then 	
				if async_reset_counter = 0 then
					async_reset_sig <= '0'; 
				else 
					async_reset_counter <= async_reset_counter-1;
					async_reset_sig <= '1'; 
				end if;	
			end if;
		end process;
		
	-------- Ansd-ing of the enable signal to the drivers.
	enable_signal_out <= '1' when ((disable_in_summary = '0') 
							and (watchdog_has_expired = '0') 
							and (enable_signal_reg = '1') 
							and (async_reset_sig = '0')) 
							else '0'; 


	---------------------------------------------------------------------------	
end IMP;
