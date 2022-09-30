------------------------------------------------------------------------------
-- user_logic.vhd - filter block  
------------------------------------------------------------------------------
--	 Written by: Kjell Ljøkelsøy. Sintef Energy research. 2013
--
-- The low pass filter function is a reverse Euler –integration, 
-- which uses the delta transform, is accumulator based. The algorithm looks like this: 
--
--  	M(t) = M(t-1)  +  Inn  - M(t-1) / K;  	   Ut =  M(t) / K
--   	
-- The highpass filter uses the mechanics of the low pass filter: 
--
--		M(t) = M(t-1)  +  Inn  - M(t-1) / K;  	   Ut =  Inn - M(t) / K
--
-- The filter time constant is governed by the constant K.  
--
--		K =  Tfilter/Ttast + 1    
--
--	The extra + 1 must be included in order to obtain correct time constant.  
-- In order to avoid roundoff errors the multiplication is done in two steps,
-- a multiplier and a shift right operation.  
--
-- This gives a modified algorithm: 
--
--		M(t) = M(t-1) + (Inn -M(t-1)/Ks) * K1, 	   Ut = 1/Ks * M
--
-- The factor 1/K is modified to K1/Ks , where Ks is a fixed power of two value.  
--
--		Ks = 2 ** (ACCUMULATOR_ADDITIONAL_BITS) 
--
--		K = K1/Ks     =>     K = Ks / K1
--
--	Elaboration gives: 
--
--		(Tfilter/ Tsamp) +1 = K =  Ks/K2, 	=>    K1 = Ks / (Tfilter/ Tsamp) +1 )
--
--	Reordering: 
--
--		K1 = Ks / (Fsamp *  Tfilter +1) 
-- 
--

------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

Library UNISIM;
use UNISIM.vcomponents.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
	 
		OPERATION_MODE							: integer range 0 to 2  := 1; 	 -- 0: Integrator. 1: 1.order low pass filter. 2: 1.order high pass filter
		NUMBER_OF_CHANNELS					: integer					:= 1;
		SIGNAL_IN_WIDTH						: integer					:= 12;
		SIGNAL_OUT_WIDTH						: integer					:= 12;		
		MULTIPLIER_WIDTH						: integer 					:= 25;  	-- Multiplier register width. MULTIPLIER_WIDTH and SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS + 1 should fit in the 18 x 25 bit input of a DSP48 hardware multplier.
		ACCUMULATOR_ADDITIONAL_BITS		: integer 					:= 0;		-- Additional width of accumulator. Max time constant and time constant at fixed scaling is t = ts * 2** (ACCUMULATOR_ADDITIONAL_BITS + MULTIPLIER_WIDTH) 
		INPUT_FRACTIONAL_BITS				: integer 					:= 0; 	-- Additional bits added below the least significant bit in the input signal. Determines resolution of difference added to accumulator. SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS should not be less than SIGNAL_OUT_WIDTH  in order to avoid DC error in output signal. Roundoff error gives time constant nonlinearities at small signal amplitudes. 
		INPUT_SOURCE_CONFIG					: integer range 0 to 2	:= 2;		-- 0: External signal.  1: Register. 2: Selectable, either external or register
		SCALING									: integer range 0 to 2  := 1; 	-- Scaling: 0: Fixed, power of 2. 1: Multiplier  2: Multiplier and shifter.
		COMMON_PARAMETERS 					: integer range 0 to 1 	:= 0;		-- 0: Separate 1: Common, channel 0 used for all channels.
		ACCUMULATOR_WRITE						: integer range 0 to 1	:= 1;	   -- Allows writing values to the accumulator.  0: No writes. 1: write allowed. 
		
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
		
    --	 DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
	 
	C_SLV_DWIDTH                  : integer        				      := 32;
	C_SLV_AWIDTH                	: integer                       	:= 32	        
    
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    
	 signal_load								: in std_logic := '0';			-- Must keep signal_load and signal_load_value for two clock pulses to avoid contamination from old feedback signal.
	 signal_in_new 							: in std_logic := '1';			-- Update accumulator. Flag
	 signal_out_new							: out std_logic:= '0';			-- New output signals. Accumulator has been updated. Flag

    signal_in									: in std_logic_vector (NUMBER_OF_CHANNELS * SIGNAL_IN_WIDTH-1 downto 0) := (others => '0');   -- Signals concatenated into an array. d & c & b & a
	 signal_load_value						: in std_logic_vector  (NUMBER_OF_CHANNELS * SIGNAL_OUT_WIDTH-1 downto 0):= (others => '0');
	 signal_out									: out std_logic_vector (NUMBER_OF_CHANNELS * SIGNAL_OUT_WIDTH-1 downto 0);
	 
	 signal_out_a								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_b								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_c								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_d								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_e								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
    signal_out_f								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_g								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 signal_out_h								: out std_logic_vector(SIGNAL_OUT_WIDTH-1 downto 0);  
	 
	 --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete

	 
		Bus2IP_Clk               : in  std_logic;
		Bus2IP_Resetn            : in  std_logic;
		Bus2IP_RdCe               : in std_logic;
		Bus2IP_WrCe               : in std_logic;		
	 	Bus2IP_RdAddr					: in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0);--:= (others => '0');
		Bus2IP_WrAddr				 : in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0) := (others => '0');
		Bus2IP_Data              : in  std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		Bus2IP_BE                : in  std_logic_vector(C_SLV_DWIDTH / 8 - 1 downto 0);
		IP2Bus_Data              : out std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		IP2Bus_RdAck             : out std_logic;
		IP2Bus_WrAck             : out std_logic

    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    	: signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  	: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  -----------------

		function i_log2 (x : positive) return integer is   -- Needed to extract size of array index  
			variable i : integer;
				begin
					i := 0;  
					while (2 ** i < x) and i < 512 loop
						i := i + 1;
					end loop;
				return i;
		end function;
		
	------------	
	
	-- Vunction	
	constant INTEGRATOR_OPERATION_MODE 			: integer := 0;
	constant LAVPASSFILTER_OPERATION_MODE 		: integer := 1;
	constant HOYPASSFILTER_OPERATION_MODE 		: integer := 2;

	-- Scaling	
	constant FIXED_SHIFT_SCALING					: integer := 0;
	constant MULTIPLIER_SCALING					: integer := 1;		
	constant MULTIPLY_AND_SHIFT_SCALING			: integer := 2;		
	
			

	constant MULTIPLIER_REG_INIT_VALUE			: integer := (2**(MULTIPLIER_WIDTH-1)-1); 	-- Max gain. Gives small time constant at startup, partial substitute for loading initial values into accumulator at startup. 

	------------
	--  Register adresse
	constant CONFIG_REG_NR 							: integer := 0;
	
	constant REG_ARRAYS_START_NR 					: integer := 1;

	constant SIGNAL_REG_NR_START					: integer := REG_ARRAYS_START_NR + NUMBER_OF_CHANNELS * 0;
	constant MULTIPLIER_REG_NR_START 			: integer := REG_ARRAYS_START_NR + NUMBER_OF_CHANNELS * 1;
	constant NUMBER_OF_SHIFTS_REG_NR_START 	: integer := REG_ARRAYS_START_NR + NUMBER_OF_CHANNELS * 2;
	constant SIGNAL_IN_REG_NR_START 				: integer := REG_ARRAYS_START_NR + NUMBER_OF_CHANNELS * 3;
	
	constant NUM_REG 									: integer := REG_ARRAYS_START_NR + NUMBER_OF_CHANNELS * 4 ;
		
	constant NUMBER_OF_SIGNAL_OUTPUT_LINES		: integer :=  8; 	--	 Individual output signal lines. 
	
		--		Config reg
	constant CONFIG_REG_INIT_VALUE				: std_logic_vector(0 to C_SLV_DWIDTH-1):=(others => '0');
	
	constant UPDATE_INHIBIT_BIT_NR 				: integer := 0; 	-- 0: Normal operation  1: Update inhibit.
	constant LOAD_INIT_VALUES_BIT_NR 			: integer := 1;	-- 0: Normal operation  1: Load init values.
	constant SOURCE_SELECTOR_BIT_NR				: integer := 2;	-- 0: Eksternal input	1: Register input.
	
	
	-- Input source selector
	constant INPUT_SOURCE_EXTERNAL				: integer :=  0;	
	constant INPUT_SOURCE_REGISTER				: integer :=  1;	
	constant INPUT_SOURCE_SELECTABLE				: integer :=  2;	
	
	constant INPUT_SOURCE_EXT						: std_logic :=  '0';	
	constant INPUT_SOURCE_REG						: std_logic :=  '1';	

	-- Parameters     
	
	constant SEPARATE									: integer :=  0;	  -- Individual parameters for each channel 
	constant COMMON									: integer :=  1;	  -- register(0) is used for all channels.
	
	constant SIGNAL_IN_SHIFTED_WIDTH				: integer := SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS;
	
	constant DIFF_IN_WIDTH							: integer := SIGNAL_IN_SHIFTED_WIDTH + 1;		
	

	constant PRODUCT_WIDTH							: integer := DIFF_IN_WIDTH + MULTIPLIER_WIDTH;

	constant MAX_NUMBER_OF_SHIFTS					: integer := ACCUMULATOR_ADDITIONAL_BITS + MULTIPLIER_WIDTH-1; -- One less than total width, due to sign bit.
	
	constant SHIFT_FACTOR_WIDTH 					: integer := i_log2(MAX_NUMBER_OF_SHIFTS); 
	
	constant ACCUMULATOR_WIDTH						: integer := ACCUMULATOR_ADDITIONAL_BITS + PRODUCT_WIDTH;
	

	
	-------
	
	signal config_register		 					: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal config_register_read					: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	

	signal input_source_selector					: std_logic :=  '0';
	
	type signal_in_array_type 						is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(SIGNAL_IN_WIDTH-1 downto 0 );
	
	signal signal_in_array 							: signal_in_array_type	:= (others => (others => '0'));
	signal signal_in_selected_array 				: signal_in_array_type	:= (others => (others => '0'));
	signal signal_in_register_array 				: signal_in_array_type	:= (others => (others => '0'));

	
	type diff_in_signal_array_type				is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(DIFF_IN_WIDTH-1 downto 0 );	
	
	signal signal_in_shifted_array				: diff_in_signal_array_type	:= (others => (others => '0'));
	signal akk_fb_shifted_array					: diff_in_signal_array_type	:= (others => (others => '0'));
	signal diff_in_signal_array					: diff_in_signal_array_type	:= (others => (others => '0'));	
	signal diff_in_signal_reg_array					: diff_in_signal_array_type	:= (others => (others => '0'));		

	type multiplier_array_type  					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of   signed (MULTIPLIER_WIDTH-1 downto 0);
	
	signal multiplier_array_write 				: multiplier_array_type :=  (others => (others => '0')); 
	signal multiplier_array 						: multiplier_array_type :=  (others => to_signed(MULTIPLIER_REG_INIT_VALUE,MULTIPLIER_WIDTH));  
	
	type product_array_type 						is array (NUMBER_OF_CHANNELS-1 downto 0 ) of   signed (PRODUCT_WIDTH -1 downto 0);

	signal product_array 							: product_array_type := (others => (others => '0'));  

	type accumulator_array_type 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of   signed( ACCUMULATOR_WIDTH -1 downto 0);
	
	signal accumulator_array						: accumulator_array_type :=  (others => (others => '0')); 
	signal accumulator_new_array					: accumulator_array_type :=  (others => (others => '0')); 
	signal accumulator_load_array					: accumulator_array_type :=  (others => (others => '0')); 
	signal accumulator_shifted_array				: accumulator_array_type :=  (others => (others => '0')); 
	
	
	signal accumulator_write_value				: signed (ACCUMULATOR_WIDTH -1 downto 0) := (others => '0'); 
	signal accumulator_write_value_reg				: signed (ACCUMULATOR_WIDTH -1 downto 0) := (others => '0'); 
	
	type number_of_shifts_array_type  			is array (NUMBER_OF_CHANNELS-1 downto 0 ) of   unsigned (SHIFT_FACTOR_WIDTH-1 downto 0);

	signal number_of_shifts_array 				: number_of_shifts_array_type := (others => (others => '0')); 
	
	type number_of_shifts_int_array_type  		is array (NUMBER_OF_CHANNELS-1 downto 0 ) of   integer range MAX_NUMBER_OF_SHIFTS downto 0;
	
	signal number_of_shifts_int_array 			: number_of_shifts_int_array_type := (others => MAX_NUMBER_OF_SHIFTS); 
	signal write_shift_index						: integer range NUMBER_OF_CHANNELS-1 downto 0 := 0; 

	type signal_out_array_type 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(SIGNAL_OUT_WIDTH-1 downto 0);
	
	signal signal_out_array							: signal_out_array_type := (others => (others => '0')); 	
	signal signal_lp_out_array						: signal_out_array_type := (others => (others => '0')); 
	signal signal_hp_out_array						: signal_out_array_type := (others => (others => '0')); 	
	signal signal_load_value_array				: signal_out_array_type := (others => (others => '0')); 	
	
	type hp_diff_array_type							is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(SIGNAL_OUT_WIDTH+1-1 downto 0 );	
	signal hp_diff_array								: hp_diff_array_type := (others => (others => '0')); 	
	signal hp_sig_in_array							: hp_diff_array_type := (others => (others => '0')); 
	signal hp_akk_array								: hp_diff_array_type := (others => (others => '0')); 	
 	
	
	signal hp_diff_reg_array						: signal_out_array_type := (others => (others => '0')); 

	signal acc_write_enable							: std_logic := '0'; 
	signal acc_write_enable_old					: std_logic := '1'; 
	signal acc_write									: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0 )  := (others=> '0');


	--===========	

  	signal clock 										: std_logic := '0';  
	signal reset 										: std_logic := '0';  
		
	
	type signal_line_out_arraytype 				is array (NUMBER_OF_SIGNAL_OUTPUT_LINES-1 downto 0 ) of  signed(SIGNAL_OUT_WIDTH-1 downto 0);
	signal signal_line_out_array					: signal_line_out_arraytype := (others => (others => '0'));


		
  	 signal use_acc_feedback						: integer range 0 to 1;		

	 signal update_inhibit_flag					: std_logic := '0'; 
	
	 signal load_into_accumulator_flag			: std_logic := '0';  
	 signal load_into_accumulator_old			: std_logic := '1';  	

	signal acc_update									: std_logic := '0';
	signal signal_in_new_reg 						: std_logic := '0';
	signal acc_load									: std_logic := '0';
	signal acc_out_new								: std_logic := '0';	
	signal highpass_out_new							: std_logic := '0';

------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
-- Moved upwards.
		-- function i_log2 (x : positive) return integer is   -- Needed to extract size of array index  
			-- variable i : integer;
				-- begin
					-- i := 0;  
					-- while (2 ** i < x) and i < 512 loop
						-- i := i + 1;
					-- end loop;
				-- return i;
		-- end function;
		
		----------------
		
		constant REG_ADDR_WIDTH 		: integer := i_log2(NUM_REG);
		constant REG_ADDR_SHIFT			: integer := i_log2(C_SLV_DWIDTH/8);
		
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
		
		type register_array_type 		is array (P_NUM_REG - 1 downto 0) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);

		signal register_array_read   	: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
		signal register_array_write 	: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
		signal register_array_init 	: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
	--	signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

	--	signal load 						: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
		

	--====================================================================

begin

	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;

	assert (SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS <= 18 and MULTIPLIER_WIDTH <= 25) or  (SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS <= 25 and MULTIPLIER_WIDTH <= 18) 
		report "####  SIGNAL_IN_WIDTH + INPUT_FRACTIONAL_BITS and MULTIPLIER_WIDTH does not fit into a single the 18 and 24 bit inputs of a signle DSP48 multiplier"
		severity warning;
		
	assert ACCUMULATOR_WIDTH < 42
		report "####  MULTIPLIER_WIDTH + ACCUMULATOR_ADDITIONAL_BITS does not fit into a single DSP48 multiplier"
		severity warning;		
		
	
 		---===========================================================	
	
	reg_read_enable <= Bus2IP_RdCE;
	reg_write_enable <= Bus2IP_WrCE;

	 
	reg_wr_addr <= Bus2IP_WrAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);
	
	reg_rd_addr <= Bus2IP_RdAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);

	reg_wr_index <= to_integer(unsigned(reg_wr_addr));
	
	reg_rd_index <= to_integer(unsigned(reg_rd_addr));



	
	----------------------------------------------------------------------------
	-- Register write process. Bytewise write.
	
	Register_array_process : process(Bus2IP_Clk) is
		begin
			if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
				if Bus2IP_Resetn = '0' then
					register_array_write   <= register_array_init;
				else	
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
 

	clock <= Bus2IP_Clk;
   reset <= '1' when Bus2IP_Resetn = '0' else '0';
	
	-------	
	-- Register and signal connection
	
	
	
	register_array_init(CONFIG_REG_NR) <= CONFIG_REG_INIT_VALUE;		
	
	
	config_register 	<= register_array_write(CONFIG_REG_NR);

	register_array_read(CONFIG_REG_NR) 	<= config_register_read; 
	
	register_array_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate 

		--  Register init values 
		register_array_init(n + MULTIPLIER_REG_NR_START) 			<= std_logic_vector(to_signed(MULTIPLIER_REG_INIT_VALUE,C_SLV_DWIDTH));
		register_array_init(n + NUMBER_OF_SHIFTS_REG_NR_START) 	<= std_logic_vector(to_signed(MAX_NUMBER_OF_SHIFTS,C_SLV_DWIDTH));
	
		--  Register writes 
		signal_in_register_array(n)		<= signed(register_array_write(n + SIGNAL_IN_REG_NR_START)(signal_in_register_array(n) 'length -1 downto 0));

		multiplier_array_write(n) 			<= signed(register_array_write(n + MULTIPLIER_REG_NR_START)(multiplier_array_write(n) 'length -1 downto 0)) when COMMON_PARAMETERS = SEPARATE  else 
														signed(register_array_write(0 + MULTIPLIER_REG_NR_START)(multiplier_array_write(0) 'length -1 downto 0));
												
		
		number_of_shifts_array(n) 	<=	unsigned(register_array_write(n + NUMBER_OF_SHIFTS_REG_NR_START)(number_of_shifts_array(n) 'length  -1 downto 0)) when COMMON_PARAMETERS = SEPARATE  else
												unsigned(register_array_write(0 + NUMBER_OF_SHIFTS_REG_NR_START)(number_of_shifts_array(0) 'length -1 downto 0));
												


	
		-- Register reads
		register_array_read(n + SIGNAL_REG_NR_START) 				<= std_logic_vector(resize(signal_out_array(n),C_SLV_DWIDTH)); 

		register_array_read(n + MULTIPLIER_REG_NR_START) 			<= std_logic_vector(resize(multiplier_array(n),C_SLV_DWIDTH));
		register_array_read(n + NUMBER_OF_SHIFTS_REG_NR_START) 	<= std_logic_vector(to_unsigned(number_of_shifts_int_array(n),C_SLV_DWIDTH));
			
		register_array_read(n + SIGNAL_IN_REG_NR_START) 			<= std_logic_vector(resize(signal_in_selected_array(n),C_SLV_DWIDTH)) when INPUT_SOURCE_CONFIG /= INPUT_SOURCE_EXTERNAL ; 
		
		
	end generate;	
		
	
	-------------------------------------
	
		-- Config_register	


	input_source_selector			<= INPUT_SOURCE_EXT when INPUT_SOURCE_CONFIG = INPUT_SOURCE_EXTERNAL else									
												INPUT_SOURCE_REG when INPUT_SOURCE_CONFIG = INPUT_SOURCE_REGISTER else 
												config_register(SOURCE_SELECTOR_BIT_NR);
													
	update_inhibit_flag 				<= config_register(UPDATE_INHIBIT_BIT_NR);
	load_into_accumulator_flag 	<= config_register(LOAD_INIT_VALUES_BIT_NR); 
 	
	config_register_read(UPDATE_INHIBIT_BIT_NR)	<= update_inhibit_flag;
	
	
	config_register_read(LOAD_INIT_VALUES_BIT_NR)		<= load_into_accumulator_flag;
	config_register_read(SOURCE_SELECTOR_BIT_NR)			<= input_source_selector;
		
	---------------------------------------------------------------
	--	 Feedback control 
	
	use_acc_feedback 				<=  	0 when OPERATION_MODE = INTEGRATOR_OPERATION_MODE else
												1 when OPERATION_MODE = LAVPASSFILTER_OPERATION_MODE else 				
												1 when OPERATION_MODE = HOYPASSFILTER_OPERATION_MODE; 				

																								
	-------------------------------------------------------
		
	--	 Concatenating in and output signals.
	
	signal_array_in_out_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate   
	
		signal_in_array(n) <= signed(signal_in(n * SIGNAL_IN_WIDTH + SIGNAL_IN_WIDTH-1 downto n * SIGNAL_IN_WIDTH));	

		signal_load_value_array(n) <= signed(signal_load_value(n * SIGNAL_OUT_WIDTH + SIGNAL_OUT_WIDTH-1 downto n * SIGNAL_OUT_WIDTH));
	
		signal_out(n * SIGNAL_OUT_WIDTH + SIGNAL_OUT_WIDTH-1 downto n * SIGNAL_OUT_WIDTH)	<= std_logic_vector(signal_out_array(n));	
		
		signal_line_out_array_generate: if (n < NUMBER_OF_SIGNAL_OUTPUT_LINES) generate
			
			signal_line_out_array(n) <= signal_out_array(n); -- Sets  values in the discrete output signals. 
			
		end generate;

	-- Output signal lines.
	signal_out_a <= std_logic_vector(signal_line_out_array(0));
	signal_out_b <= std_logic_vector(signal_line_out_array(1));
	signal_out_c <= std_logic_vector(signal_line_out_array(2));
	signal_out_d <= std_logic_vector(signal_line_out_array(3));
	signal_out_e <= std_logic_vector(signal_line_out_array(4));		
	signal_out_f <= std_logic_vector(signal_line_out_array(5));	
	signal_out_g <= std_logic_vector(signal_line_out_array(6));	
	signal_out_h <= std_logic_vector(signal_line_out_array(7));		
	end generate;

	
	-- Input signals	
	Diff_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate   
				
		multiplier_array(n) 					<= multiplier_array_write(n) when SCALING  = MULTIPLIER_SCALING or SCALING  = MULTIPLY_AND_SHIFT_SCALING else
														to_signed(1,multiplier_array(n) 'length);
	
		number_of_shifts_int_array(n)		<= MAX_NUMBER_OF_SHIFTS  when SCALING  /= MULTIPLY_AND_SHIFT_SCALING	else		
														MAX_NUMBER_OF_SHIFTS  when number_of_shifts_array(n) > MAX_NUMBER_OF_SHIFTS else
														0 when number_of_shifts_array(n) < 0 else 
														to_integer(number_of_shifts_array(n));
		
										
		signal_in_selected_array(n) 		<= signal_in_array(n) when input_source_selector = INPUT_SOURCE_EXT else signal_in_register_array(n);	
		
		signal_in_shifted_array(n) 		<= shift_left(resize(signal_in_selected_array(n),signal_in_shifted_array(n) 'length),INPUT_FRACTIONAL_BITS);	

		diff_in_signal_array(n) 			<= signal_in_shifted_array(n) - akk_fb_shifted_array(n) when use_acc_feedback = 1 else signal_in_shifted_array(n);

	--	accumulator_load_array(n) 			<= shift_left(resize(signal_load_value_array(n),ACCUMULATOR_WIDTH),number_of_shifts_int_array(n));
		accumulator_load_array(n)			<= shift_left(resize(signal_load_value_array(n),ACCUMULATOR_WIDTH),(ACCUMULATOR_WIDTH-1 - SIGNAL_OUT_WIDTH)- (MAX_NUMBER_OF_SHIFTS +1 -number_of_shifts_int_array(n)) );

	end generate;
		
	------------------
	-- Accumulator. 

	write_shift_index <= 0 when reg_wr_index < SIGNAL_REG_NR_START  else 
								0 when reg_wr_index >= SIGNAL_REG_NR_START + NUMBER_OF_CHANNELS-1 else
								reg_wr_index - SIGNAL_REG_NR_START;

	Accumulator_control_signal_prosess : process(clock)
		begin
			if clock 'event and clock = '1' then
				if reset = '1' then
				
					signal_in_new_reg <= '0';					
					acc_out_new <= '0';
	
					acc_write_enable_old <= '1';					
				else 						
					
					signal_in_new_reg <=  signal_in_new;
					
					acc_out_new <= acc_update;				
					accumulator_write_value_reg <= accumulator_write_value;
					
					acc_write_enable_old <= acc_write_enable;
					
				end if;
			end if; 
		end process;
	
	--signal_in_new_reg <=  signal_in_new;
	--diff_in_signal_reg_array(n)  <= diff_in_signal_array(n);		
	acc_update 			<= '0'  when  update_inhibit_flag = '1'  else signal_in_new  when SCALING = FIXED_SHIFT_SCALING else signal_in_new_reg; 		
	
	acc_load 			<= '1' when signal_load = '1' or  load_into_accumulator_flag = '1' else '0';	
	
	Acc_write_enable 	<=   reg_write_enable when ACCUMULATOR_WRITE = 1 else '0';

			
	Accumulator_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate   
	
		
		product_array(n) <=	diff_in_signal_reg_array(n) * multiplier_array(n) when SCALING /= FIXED_SHIFT_SCALING else 
									to_signed(0,product_array(n) 'length);
		
		-- Multiplier and acccumulator
		-- Clearing product_array would have been tidier, but it didnt work, it wasnt recognized as a MAC.
		-- Write to accumulator is delayed by one clock cycle. Must do this in order to let the clearing of the diff_in_signal_reg_array be done. This is meeeded bechause it is not possible to load the MAC accumulator directly.

		Accumulator_process : process(clock)
		begin
			if clock 'event and clock = '1' then
				if reset = '1' then
					accumulator_array(n) <= (others => '0');
					diff_in_signal_reg_array(n)  <= (others => '0');
					acc_write(n) <= '0';		
				else	
					acc_write(n) <= '0';													
					diff_in_signal_reg_array(n)  <= diff_in_signal_array(n);				
					if 	acc_update = '1' then						
						if SCALING = FIXED_SHIFT_SCALING then 							  
							accumulator_array(n) <= diff_in_signal_array(n) + accumulator_array(n);								
						else						
							accumulator_array(n) <= product_array(n) + accumulator_array(n);						
						end if;
					end if;
					-- Loading external values.  Load must be held for two clock pulses, in order to clear old feedback signals. 
					if acc_load = '1' then 
						diff_in_signal_reg_array(n) <= (others => '0');
						accumulator_array(n) <= product_array(n) + accumulator_load_array(n);
					end if;
				
					-- Writing to accumulator from processor bus.
					if reg_wr_index = n + SIGNAL_REG_NR_START then 					
						if acc_write_enable_old = '0' and acc_write_enable = '1' then 
							diff_in_signal_reg_array(n) <= (others => '0');
							acc_write(n) <= '1';
						end if;
					end if;	
					if acc_write(n) = '1' then -- two step process, using one clock delay in write signal in order to clear input register first, so contamination from old feedback signals are removed.						
						accumulator_array(n) <= product_array(n) + accumulator_write_value_reg;
						diff_in_signal_reg_array(n) <= (others => '0');
					end if;
										
				end if;
			end if;
		end process;	
		


	end generate;

	

	signal_out_new <= highpass_out_new when  OPERATION_MODE  = HOYPASSFILTER_OPERATION_MODE else acc_out_new;	
	--------------------------------------------------------------------------------------
-- Accumulator output shifts.


	-- accumulator_write_value	<= shift_left(resize(signed(Bus2IP_Data), ACCUMULATOR_WIDTH),number_of_shifts_int_array(write_shift_index));
	
	accumulator_write_value	<= shift_left(resize(signed(Bus2IP_Data), ACCUMULATOR_WIDTH),(ACCUMULATOR_WIDTH-1 - SIGNAL_OUT_WIDTH)- (MAX_NUMBER_OF_SHIFTS +1 -number_of_shifts_int_array(write_shift_index)) );
	
	Acc_out_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate  

		accumulator_shifted_array(n)			<= shift_left(accumulator_array(n),MAX_NUMBER_OF_SHIFTS + 1 - number_of_shifts_int_array(n)); --  Shifts towards the top of the accumulator. One bit extra, compensates for the sign bit in the multiplier width.
			
	--	Cannot use resize here. It does not overflow properly. It puts the msb sign bit as the msb in the shifted value. Overflows goes to zero, not to the opposite side. 
	
		signal_lp_out_array(n)				<= accumulator_shifted_array(n)(ACCUMULATOR_WIDTH-1-1 downto ACCUMULATOR_WIDTH-1 - SIGNAL_OUT_WIDTH); -- Fixed shifts down.  Takes output signal one bit from the top. 
		
		akk_fb_shifted_array(n)				<= accumulator_shifted_array(n)(ACCUMULATOR_WIDTH -1 downto ACCUMULATOR_WIDTH  - DIFF_IN_WIDTH); -- Fixed shifts down.  Takes output signal from the top. 

	
			
		signal_out_array(n)					<= signal_lp_out_array(n) when OPERATION_MODE /= HOYPASSFILTER_OPERATION_MODE else signal_hp_out_array(n);
		
		
	---------------------------------------------	
	-- Highpass filter.	
	-- Highpass signal is shifted down one bit, as its output may swing to twice the input range at a full range step.

	Highpass_filter_generate: if OPERATION_MODE = HOYPASSFILTER_OPERATION_MODE generate	
	
	
		hp_akk_array(n)		<= accumulator_shifted_array(n)(ACCUMULATOR_WIDTH-1 downto ACCUMULATOR_WIDTH- SIGNAL_OUT_WIDTH-1	); -- Fixed shifts down.  Takes output signal one bit from the top. 
		
		hp_sig_in_array(n)	<= shift_left(resize(signal_in_array(n),hp_sig_in_array(n) 'length) ,SIGNAL_OUT_WIDTH-SIGNAL_IN_WIDTH) when  SIGNAL_OUT_WIDTH > SIGNAL_IN_WIDTH else 
										resize(shift_right(signal_in_array(n),SIGNAL_IN_WIDTH - SIGNAL_OUT_WIDTH),hp_sig_in_array(n) 'length); 
			
	
		hp_diff_array(n) <= hp_sig_in_array(n) -hp_akk_array(n);
				
		highpassfilter_reg_process : process(clock)
			begin
				if clock 'event and clock = '1' then	
				if reset ='1' then				
					highpass_out_new <= '0';
					hp_diff_reg_array(n)  <= (others => '0');			
				else 	
					highpass_out_new <= '0';
					if signal_in_new_reg = '1' then
						hp_diff_reg_array(n) <= hp_diff_array(n)(SIGNAL_OUT_WIDTH+1-1 downto 1);
						highpass_out_new <= '1';
					end if;
					end if;
				end if;
			end process;		
		
		signal_hp_out_array(n) <= hp_diff_reg_array(n);
		
		end generate;

	end generate;		
	
		

	------------------------------------------------------------------------------------


end IMP;
