--***************************************************************************
-- AD converter serial signal receiver
--
--	 Author: Kjell Ljøkelsøy. Sintef Energi. 2009- 2017
--
-- Interface circuit that receives data on LVDS serieformat from an 
-- Analog Devices AD9222, 8x12 bit 40 MSps AD converter 



------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;


Library UNISIM;
use UNISIM.vcomponents.all;


entity user_logic is
	generic(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		--USER generics added here



		OUTPUT_SIGNAL_CLOCK_DOMAIN_SELECTOR		: std_logic_vector(7 downto 0)  	:= X"00"; 		-- Selects clock domain for AD_SIGNAL_x. 0: bus clock. 1: AD signal clock.	 -- bit 7: H bit 6: G, bit 5: F, bit 4: E, bit 3: D, bit 2: C, bit 1:B, bit 0: A 
		INIT_DELAY_COUNTER_START_VALUE			: integer                       	:= 10; 			-- Number of AD samples before signal_new becomes active.
		INVERT_OPUTPUT_SIGNAL				: std_logic_vector(7 downto 0)		:= X"00"; 		-- 0: not inverting 1: invertering. Compensates for inversion in buffer amplifier stage. 
		USE_OFFSET_COMPENSATION				: std_logic                    		:= '1'; 			-- 0: no offset compensation 1: offset compensation used.  NB! Output signals are shifted down one bit when offset compensation is used in order to avoid overflow.
		AD_CLOCK_IOBDELAY_VALUE			: integer							:= 16; 			-- Delay of AD bitclock signal. Compensates for signal skew. Ca 85 ps pr. step
		AD_SIGNAL_IOBDELAY_VALUE		: integer							:= 20; 			-- Tuning of signal skew compensation for data lines.  -- Net compensation is:  AD_SIGNAL_IOBDELAY_VALUE -  AD_CLOCK_IOBDELAY_VALUE
		USE_INTERNAL_DELAYCTRL    	: std_logic                     	:= '1'; -- IDELAY requires a DELAYCTRL-unit. There can only be one DELAYCYTL witout predefined location in a system. Must remove this one if there is one in another block, as in a DRAM-controller. 
		DOWNSAMPLING_FACTOR_WIDTH    	: integer                       	:= 0; -- Downsampling factor determines ratio between sample rate for AD converter and output signals. Ratio is a power of two, specified by counter width:   n = 2 ** DOWNSAMPLING_FACTOR_WIDTH. (0 gives 1:1 ratio).	
		NUMBER_OF_CHANNELS               	: integer                       	:= 8;
		AD_CONVERTER_SIGNAL_WIDTH 		: integer 					:= 12;			-- Word size in the data from the AD converter 	
		WIDTH_OUT                    	: integer                       	:= 13; -- One bit wider than AD converter signal width when offset compensation is used.	

		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete


	C_SLV_AWIDTH                 : integer        				      := 32;
	C_SLV_DWIDTH                 : integer                       	:= 32	

		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);
	port(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		--USER ports added here

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
		ad_signal_new_busclk      : out std_logic; -- New sample, bus clock domain
		ad_signal_new_adclk       : out std_logic; -- New sample, AD clock domain


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
		IP2Bus_WrAck             : out std_logic;
		IP2Bus_Error             : out std_logic
	-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);

	attribute SIGIS : string;
	attribute SIGIS of Bus2IP_Clk : signal is "CLK";
	attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;



------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

	--USER signal declarations added here, as needed for user logic



	constant SKIFT_BUNN : integer := 2;

	constant SKIFTEREG_BREDDE     : integer := AD_CONVERTER_SIGNAL_WIDTH + SKIFT_BUNN;
	constant OFFSETREG_STARTREGNR : integer := NUMBER_OF_CHANNELS;
	constant KONFIGREG_REGNR      : integer := 2 * NUMBER_OF_CHANNELS;

	constant NUM_REG 					: integer := 2 * NUMBER_OF_CHANNELS +1;
	
	constant AKKUMULATOR_BREDDE : integer := AD_CONVERTER_SIGNAL_WIDTH + DOWNSAMPLING_FACTOR_WIDTH;

	constant NEDSAMPLINGSTELLER_MAKS_VERDI : integer := 2 ** DOWNSAMPLING_FACTOR_WIDTH - 1;

	constant BLOCK_NEW_VALUE_FLAG_BITNR		: natural := 0;
	constant BLOCK_SIGNAL_UPDATES_BITNR		: natural := 1;
	constant STARTUP_BLOCK_IS_ACTIVE_BITNR : natural := 4;
	constant IODELAY_RESET_BITNR 				: natural := 8;
	constant IODELAY_UP_BITNR 					: natural := 9;
	constant IODELAY_DOWN_BITNR 				: natural := 10;
	
	constant AKK_UT_NY_SKIFTEREG_BREDDE               :natural := (AD_CONVERTER_SIGNAL_WIDTH/(2*3))-1; -- Antall klokkepulser= (AD_bredde/2, Skift = antall køokkepulser /2    60 grader faseforskyving. 
	
	signal iodelay_rst_bit 						: std_logic := '0';
	signal iodelay_up_bit  						: std_logic := '0';
	signal iodelay_down_bit						: std_logic := '0';
	
	signal iodelay_rst_bit_old 				: std_logic := '0';
	signal iodelay_up_bit_old  				: std_logic := '0';
	signal iodelay_down_bit_old				: std_logic := '0';

	
	signal iodelay_rst : std_logic := '0';
	signal iodelay_ce  : std_logic := '0';
	signal iodelay_inc : std_logic := '0';

	signal reset_h    : std_logic := '1';
	signal reset_ad_h : std_logic := '1';

	signal signal_ad_inn       : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');
	signal signal_ad_inn_m     : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');
	--
	signal signal_ad_inn_m1_q2 : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');
	signal signal_ad_inn_m1_q1 : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');
	--
	signal signal_ad_inn_q2    : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');
	signal signal_ad_inn_q1    : std_logic_vector(NUMBER_OF_CHANNELS - 1 downto 0) := (others => '0');

	type ad_skifteregister_array_type is array (NUMBER_OF_CHANNELS - 1 downto 0) of std_logic_vector(SKIFTEREG_BREDDE - 1 downto 0);

	signal ad_skifteregister_array : ad_skifteregister_array_type := (others => (others => '0'));

	signal ad_skifteregister_rammesynk : std_logic_vector(SKIFT_BUNN downto 0) := (others => '0');

	type ad_omf_signal_array_type is array (NUMBER_OF_CHANNELS - 1 downto 0) of signed(AD_CONVERTER_SIGNAL_WIDTH - 1 downto 0);

	type akkumulator_array_type is array (NUMBER_OF_CHANNELS - 1 downto 0) of signed(AKKUMULATOR_BREDDE - 1 downto 0);

	signal akkumulator_array : akkumulator_array_type := (others => (others => '0'));

	type ad_signal_out_array_type is array (NUMBER_OF_CHANNELS - 1 downto 0) of signed(WIDTH_OUT - 1 downto 0);

	signal clk_ad_signal_array : ad_signal_out_array_type := (others => (others => '0'));

	signal ad_signal_out_array : ad_signal_out_array_type := (others => (others => '0'));

	signal akk_ut_array : ad_signal_out_array_type := (others => (others => '0'));
	
	signal clk_ad_akk_ut_array : ad_signal_out_array_type := (others => (others => '0'));

	signal clk_bus_akk_ut_array_synk1 : ad_signal_out_array_type := (others => (others => '0'));
	signal clk_bus_akk_ut_array_synk2 : ad_signal_out_array_type := (others => (others => '0'));	

	signal akk_m_ut_array : ad_signal_out_array_type := (others => (others => '0'));

	signal ad_offset_reg_array : ad_signal_out_array_type := (others => (others => '0'));

	signal clk_ad_signal_ny : std_logic := '0';

	signal clk_bus_signal_array : ad_signal_out_array_type := (others => (others => '0'));

	signal clk_bus_signal_ny : std_logic := '0';


	signal ad_data_klokke     : std_logic := '0';
	signal ad_data_klokke_inn : std_logic := '0';
	signal ad_data_klokke_m   : std_logic := '0';

	signal rammesynk_ad    : std_logic := '0';
	signal rammesynk_ad_m  : std_logic := '0';
	signal rammesynk_ad_q1 : std_logic := '0';
	signal rammesynk_ad_q2 : std_logic := '0';
    
    signal akk_ut_ny_skiftereg : std_logic_vector (AKK_UT_NY_SKIFTEREG_BREDDE-1 downto 0) := (others=> '0');
    
	signal clk_ad_settflagg  : std_logic                    := '0';
	signal clk_bus_settflagg : std_logic_vector(1 downto 0) := (others => '0');
	signal clk_bus_settflagg_synk1 : std_logic                    := '0';
	signal clk_bus_settflagg_synk2 : std_logic                    := '0';
	

	signal ny_flagg_blokkering    : std_logic                                   := '0';
	signal blokker_oppdatering    : std_logic;
	signal ad_blokker_oppdatering : std_logic_vector(1 downto 0)                := (others => '0');
	signal oppstartteller         : integer range INIT_DELAY_COUNTER_START_VALUE downto 0 := INIT_DELAY_COUNTER_START_VALUE;
	signal oppstartflagg          : std_logic                                   := '0';

	signal akk_ut_ny : std_logic := '0';

	signal nedsamplingsteller : integer range NEDSAMPLINGSTELLER_MAKS_VERDI downto 0 := 0;

	signal oppsettregister      : std_logic_vector(C_SLV_DWIDTH - 1 downto 0) := (others => '0');
	signal oppsettregister_lese : std_logic_vector(C_SLV_DWIDTH - 1 downto 0) := (others => '0');
	
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
	
	---===========================================================	
		
	reg_read_enable <= Bus2IP_RdCE;
	reg_write_enable <= Bus2IP_WrCE;
	--reg_read_enable  <= '1' when Bus2IP_CS = '1' and  Bus2IP_RNW = '1' else '0';
	--reg_write_enable <= '1' when Bus2IP_CS = '1' and  Bus2IP_RNW = '0' else '0';
	 
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
	IP2Bus_Error <= '0';
 	
--=============================================================================
		

	reset_h <= not  Bus2IP_Resetn;

	ad_signal_a <= std_logic_vector(ad_signal_out_array(0));
	ad_signal_b <= std_logic_vector(ad_signal_out_array(1));
	ad_signal_c <= std_logic_vector(ad_signal_out_array(2));
	ad_signal_d <= std_logic_vector(ad_signal_out_array(3));
	ad_signal_e <= std_logic_vector(ad_signal_out_array(4));
	ad_signal_f <= std_logic_vector(ad_signal_out_array(5));
	ad_signal_g <= std_logic_vector(ad_signal_out_array(6));
	ad_signal_h <= std_logic_vector(ad_signal_out_array(7));

	ad_signal_out_array_generate : for n in 0 to NUMBER_OF_CHANNELS - 1 generate
		ad_signal_out_array(n)                                            <= clk_ad_signal_array(n) when (OUTPUT_SIGNAL_CLOCK_DOMAIN_SELECTOR(n) = '1') else clk_bus_signal_array(n);
		ad_signal_out(n * WIDTH_OUT + WIDTH_OUT - 1 downto n * WIDTH_OUT) <= std_logic_vector(ad_signal_out_array(n));

	end generate;

	ad_signal_new_busclk <= clk_bus_signal_ny;
	ad_signal_new_adclk  <= clk_ad_signal_ny;


	ad_data_clock_out <= ad_data_klokke;
	
	-- Kobler bit i oppsetregistret. 
	ny_flagg_blokkering <= oppsettregister(BLOCK_NEW_VALUE_FLAG_BITNR);
	blokker_oppdatering <= oppsettregister(BLOCK_SIGNAL_UPDATES_BITNR);

	iodelay_rst_bit <= oppsettregister(IODELAY_RESET_BITNR);
	iodelay_up_bit <= oppsettregister(IODELAY_UP_BITNR);
	iodelay_down_bit <= oppsettregister(IODELAY_DOWN_BITNR);
		
	oppsettregister_lese(BLOCK_NEW_VALUE_FLAG_BITNR)  <= ny_flagg_blokkering;
	oppsettregister_lese(BLOCK_SIGNAL_UPDATES_BITNR)  <= blokker_oppdatering;
	oppsettregister_lese(STARTUP_BLOCK_IS_ACTIVE_BITNR) <= oppstartflagg;
	
	oppsettregister_lese(IODELAY_RESET_BITNR) <= iodelay_rst_bit;
	oppsettregister_lese(IODELAY_UP_BITNR) <= iodelay_up_bit;
	oppsettregister_lese(IODELAY_DOWN_BITNR) <= iodelay_down_bit;
	
		
	-- kobler prosessorregistre.

	

	oppsettregister          <= register_array_write(KONFIGREG_REGNR);
	register_array_read(KONFIGREG_REGNR) <= oppsettregister_lese;

	reg_koble_generate : for n in 0 to NUMBER_OF_CHANNELS - 1 generate
		register_array_read(n) <= std_logic_vector(resize(clk_bus_signal_array(n), C_SLV_DWIDTH));

		register_array_read(OFFSETREG_STARTREGNR + n) <= std_logic_vector(resize(ad_offset_reg_array(n), C_SLV_DWIDTH));

		ad_offset_reg_array(n) <= signed(register_array_write(OFFSETREG_STARTREGNR + n)(WIDTH_OUT - 1 downto 0)) when USE_OFFSET_COMPENSATION = '1' else (others => '0');

	end generate;


	----------------------------------------------------------------------------
	-- En slik en er påkrevd om en bruker IDELAY, i følge Skriften
	-- Kun en eneste som ikke har låst plassering på brikken er tillatt.
	-- Bruker derfor  en som ligger utenfor denne modulen, eksempelvis en i ddr2-dram-en. eller en laus en i en egen modul.



	IDELAYCTRL_generate : if USE_INTERNAL_DELAYCTRL = '1' generate
	begin
		IDELAYCTRL_inst : IDELAYCTRL
			port map(
				RDY    => open,         -- 1-bit output indicates validity of the REFCLK
				REFCLK => ad_200MHz_delay_ref_clock, -- 1-bit reference clock input
				RST    => reset_h       -- 1-bit reset input
			);

	end generate;

	-------------------------------------------------------------------------------
	-- LVDS buffer og DDR- registre. for klokkesignaler, synksignaler og  og datasignaler

	-- Klokkesignalbufre.
	--  Må bruke regionalklokkebuffer, da det blir kluss med buffer elllers.

	ad_data_klokke_LVDS_buffer : IBUFDS
		generic map(
			DIFF_TERM  => TRUE,
			IOSTANDARD => "LVDS_25")
		port map(
			O  => ad_data_klokke_inn,
			I  => ad_dcop,
			IB => ad_dcon
		);

	-- Klokkesignalet trekkes også gjenom en IODELAY-blokk slik at det får samme signalveien som data og rammesynksignalene. 

		IODELAY_inst : IODELAY
			generic map(
				DELAY_SRC             => "I", -- Specify which input port to be used "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
				HIGH_PERFORMANCE_MODE => FALSE, -- TRUE specifies lower jitterat expense of more power
				IDELAY_TYPE           => "FIXED", --"FIXED",  -- "FIXED" or "VARIABLE" 
				IDELAY_VALUE          => AD_CLOCK_IOBDELAY_VALUE, -- 0 to 63 tap values
				REFCLK_FREQUENCY      => 200.0, -- Frequency used for IDELAYCTRL     -- 175.0 to 225.0
				SIGNAL_PATTERN        => "CLOCK") -- Input signal type, "CLOCK" or "DATA" 
			port map(
				DATAOUT => ad_data_klokke_m, -- 1-bit delayed data output
				C       => '0',             -- 1-bit clock input
				CE      => '0',             -- 1-bit clock enable input
				IDATAIN => ad_data_klokke_inn, -- 1-bit input data input (connect to port)
				DATAIN  => '0',
				ODATAIN => '0',
				INC     => '0',             -- 1-bit increment/decrement input
				RST     => reset_h,         -- 1-bit active high, synch reset input
				T       => '1'              -- 1-bit 3-state control input
			);

	--ad_data_klokke_m <= ad_data_klokke_inn;

--	ad_data_regionalklokkebuffer : BUFR
--		generic map(
--			BUFR_DIVIDE => "BYPASS",    -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
--			SIM_DEVICE  => "VIRTEX5")   -- Specify target device, "VIRTEX4" or "VIRTEX5" 
--		port map(
--			O   => ad_data_klokke,      -- Clock buffer output
--			CE  => '1',                 -- Clock enable input
--			CLR => '0',                 -- Clock buffer reset input
--			I   => ad_data_klokke_m     -- Clock buffer input
--		);

	ad_data_klokke <= ad_data_klokke_m; 
	


	-- IODELAY Process. Stigende flanke trinner IOdelay opp eller ned. 
	iodelay_pulse_proc : process(Bus2IP_Clk)
	begin
		if rising_edge(Bus2IP_Clk) then
			iodelay_rst_bit_old <= iodelay_rst_bit;
			iodelay_up_bit_old <= iodelay_up_bit;
			iodelay_down_bit_old <= iodelay_down_bit;
			iodelay_ce           <= '0';
			iodelay_inc          <= '0';

			-- RESET
			if (iodelay_rst_bit = '1' and iodelay_rst_bit_old = '0') then
				iodelay_rst <= '1';
			else
				iodelay_rst <= '0';
			end if;

			-- INCREASE
			if (iodelay_up_bit = '1' and iodelay_up_bit_old = '0') then
				iodelay_ce  <= '1';
				iodelay_inc <= '1';
			end if;

			-- DECREASE
			if (iodelay_down_bit = '1' and iodelay_down_bit_old = '0') then
				iodelay_ce  <= '1';
				iodelay_inc <= '0';
			end if;

		end if;
	end process;

	-- Signalinnganger.

	ad_innganger_generate : for n in 0 to NUMBER_OF_CHANNELS - 1 generate
	begin
		signal_ad_inn_LVDS_buffer : IBUFDS
			generic map(
				DIFF_TERM  => TRUE,
				IOSTANDARD => "LVDS_25")
			port map(
				O  => signal_ad_inn(n),
				I  => ad_d_p(n),
				IB => ad_d_n(n)
			);

		IODELAY_data : IODELAY
			generic map(
				DELAY_SRC             => "I", -- Specify which input port to be used   -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
				HIGH_PERFORMANCE_MODE => FALSE, -- TRUE specifies lower jitter - at expense of more power
				IDELAY_TYPE           => "VARIABLE", -- "FIXED",  -- "FIXED" or "VARIABLE" 
				IDELAY_VALUE          => AD_SIGNAL_IOBDELAY_VALUE, -- 0 to 63 tap values
				REFCLK_FREQUENCY      => 200.0, -- Frequency used for IDELAYCTRL    -- 175.0 to 225.0
				SIGNAL_PATTERN        => "DATA") -- Input signal type, "CLOCK" or "DATA" 
			port map(
				DATAOUT => signal_ad_inn_m(n), -- 1-bit delayed data output
				C       => Bus2IP_Clk,  -- 1-bit clock input
				CE      => iodelay_ce,  -- 1-bit clock enable input
				DATAIN  => '0',
				ODATAIN => '0',
				IDATAIN => signal_ad_inn(n), -- 1-bit input data input (connect to port)
				INC     => iodelay_inc, -- 1-bit increment/decrement input
				RST     => iodelay_rst, -- 1-bit active high, synch reset input
				T       => '1'          -- 1-bit 3-state control input
			);

		ad_ddr_reg_signal_ad_inn : IDDR
			generic map(
				DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
				INIT_Q1      => '0',
				INIT_Q2      => '0',
				SRTYPE       => "SYNC"
			)
			port map(
				Q1 => signal_ad_inn_m1_q1(n),
				Q2 => signal_ad_inn_m1_q2(n),
				C  => ad_data_klokke,
				CE => '1',
				D  => signal_ad_inn_m(n),
				R  => '0',
				S  => '0'
			);

	end generate;

	--signal_ad_inn_m <= signal_ad_inn;





	-- rammesynk_adsignal.

	rammesynk_ad_LVDS_buffer : IBUFDS
		generic map(
			DIFF_TERM  => TRUE,
			IOSTANDARD => "LVDS_25")
		port map(
			O  => rammesynk_ad,
			I  => ad_fcop,
			IB => ad_fcon
		);

	IODELAY_data : IODELAY
		generic map(
			DELAY_SRC             => "I", -- Specify which input port to be used  -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
			HIGH_PERFORMANCE_MODE => FALSE, -- TRUE specifies lower jitter at expense of more power
			IDELAY_TYPE           => "VARIABLE",
			IDELAY_VALUE          => AD_SIGNAL_IOBDELAY_VALUE, -- 0 to 63 tap values
			REFCLK_FREQUENCY      => 200.0, -- Frequency used for IDELAYCTRL -- 175.0 to 225.0
			SIGNAL_PATTERN        => "DATA") -- Input signal type, "CLOCK" or "DATA" 
		port map(
			DATAOUT => rammesynk_ad_m,  -- 1-bit delayed data output
			C       => Bus2IP_Clk,      -- 1-bit clock input
			CE      => iodelay_ce,      -- 1-bit clock enable input
			IDATAIN => rammesynk_ad,    -- 1-bit input data input (connect to port)
			DATAIN  => '0',
			ODATAIN => '0',
			INC     => iodelay_inc,     -- 1-bit increment/decrement input
			RST     => iodelay_rst,     -- 1-bit active high, synch reset input
			T       => '1'              -- 1-bit 3-state control input
		);

	ad_ddr_reg_rammesynk : IDDR
		generic map(
			DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
			INIT_Q1      => '0',
			INIT_Q2      => '0',
			SRTYPE       => "SYNC"
		)
		port map(
			Q1 => rammesynk_ad_q1,
			Q2 => rammesynk_ad_q2,
			C  => ad_data_klokke,
			CE => '1',
			D  => rammesynk_ad_m,
			R  => '0',
			S  => '0'
		);

	---------------------------------------------------------------------------------------------------------
	-- Eventuell invertering av signalene. Korrigering av invertering i differensialforsterkeren foran AD omformeren.

	INVERT_OPUTPUT_SIGNAL_generate : for n in 0 to NUMBER_OF_CHANNELS - 1 generate
		signal_ad_inn_q1(n) <= (not signal_ad_inn_m1_q1(n)) when (INVERT_OPUTPUT_SIGNAL(n) = '1') else signal_ad_inn_m1_q1(n);
		signal_ad_inn_q2(n) <= (not signal_ad_inn_m1_q2(n)) when (INVERT_OPUTPUT_SIGNAL(n) = '1') else signal_ad_inn_m1_q2(n);

	end generate;

	-- Skifteregistre. Disse drives av AD-klokka. 

	ad_skifteregisterprosess : process(ad_data_klokke)
		variable ad_omf_signal_array     : ad_omf_signal_array_type := (others => (others => '0'));
		variable neste_akkumulator_array : akkumulator_array_type   := (others => (others => '0'));

	begin
		if (ad_data_klokke'event and ad_data_klokke = '1') then
			reset_ad_h <= reset_h;

			if (reset_ad_h = '1') then
				clk_ad_signal_array <= (others => (others => '0'));

				clk_ad_signal_ny   <= '0';
				clk_ad_settflagg   <= '0';
				oppstartteller     <= INIT_DELAY_COUNTER_START_VALUE;
				oppstartflagg      <= '1';
				akkumulator_array  <= (others => (others => '0'));
				nedsamplingsteller <= 0;
			else
				akk_ut_ny        <= '0';
				clk_ad_signal_ny <= '0';

				ad_skifteregister_rammesynk <= ad_skifteregister_rammesynk(SKIFT_BUNN - 2 downto 0) & rammesynk_ad_q1 & rammesynk_ad_q2;
				for n in 0 to NUMBER_OF_CHANNELS - 1 loop
					ad_skifteregister_array(n) <= ad_skifteregister_array(n)(SKIFTEREG_BREDDE - 2 - 1 downto 0) & signal_ad_inn_q1(n) & signal_ad_inn_q2(n);
				end loop;

				-- Synkroniserer blokkeringsflagg
				ad_blokker_oppdatering <= ad_blokker_oppdatering(0) & blokker_oppdatering;

				--Nå har det kommet et ferskt datasett i skifteregistret.
				if ((ad_skifteregister_rammesynk(SKIFT_BUNN) = '0') and (ad_skifteregister_rammesynk(SKIFT_BUNN - 1) = '1') and (ad_blokker_oppdatering(1) = '0')) then

					-- Teller opp antall inngangsverdier. nedsamplingsteller. 
					if nedsamplingsteller >= NEDSAMPLINGSTELLER_MAKS_VERDI then
						nedsamplingsteller <= 0;
					else
						nedsamplingsteller <= nedsamplingsteller + 1;
					end if;

					neste_akkumulator_array := akkumulator_array;

					if nedsamplingsteller = 0 then
						neste_akkumulator_array := (others => (others => '0')); -- Nullstiller akkumulatoren.
					end if;

					for n in 0 to NUMBER_OF_CHANNELS - 1 loop

							-- Snur øverste bit for å lage fortegnstall. 
						--	ad_omf_signal_array(n)     := signed((not ad_skifteregister_array(n)(SKIFTEREG_BREDDE - 1)) & ad_skifteregister_array(n)(SKIFTEREG_BREDDE - 2 downto SKIFT_BUNN));
							ad_omf_signal_array(n)  :=  signed(unsigned(ad_skifteregister_array(n)(SKIFTEREG_BREDDE - 1 downto SKIFT_BUNN))  -  2**(AD_CONVERTER_SIGNAL_WIDTH-1));
							neste_akkumulator_array(n) := neste_akkumulator_array(n) + resize(ad_omf_signal_array(n), AKKUMULATOR_BREDDE);

					end loop;

					akkumulator_array <= neste_akkumulator_array;

					if nedsamplingsteller = NEDSAMPLINGSTELLER_MAKS_VERDI then -- Har telt til topps. Nå settes nye signaler ut.

						clk_ad_signal_array <= akk_ut_array; -- Signaler som skrives direkte ut bufres.  		

						

						-- Nye signaler flagges bare hvis det er tillatt, og det har passert et visst antall pulser etter reset. 
						if ((oppstartflagg = '0') and (ny_flagg_blokkering = '0')) then
							akk_ut_ny <= '1';
						end if;


						if (oppstartteller = 0) then
							oppstartflagg <= '0';
						else
							oppstartflagg  <= '1';
							oppstartteller <= oppstartteller - 1;
						end if;
					end if;

		

				end if;
	           akk_ut_ny_skiftereg <= akk_ut_ny_skiftereg(  AKK_UT_NY_SKIFTEREG_BREDDE-1-1 downto 0) &  akk_ut_ny;				 
				clk_ad_signal_ny <= akk_ut_ny; --- En klokkepuls forsinket, synkron med clk_ad_signal_array.
				if akk_ut_ny_skiftereg(AKK_UT_NY_SKIFTEREG_BREDDE-1) = '1' then
					clk_ad_settflagg <= not clk_ad_settflagg; ---  Invertering av clk_ad_settflagg indikerer nye signaler. Skjer midt mellom to dataoppdateringer, dvs ca. 90 grader fasforskjøvet, slik at verdiene er ferdig oppdatert før flipping, slik at en unngår meetastabilitet i klokkedomenekryssingen. 
				end if;
				
			end if;
		end if;
	end process;

	-----------------------------------------------------------------------------------------------------
	-- Lesing av verdier fra akkumulatoren. 
	-- Formatet på utgangssignalene er forskjellig avhengig om offsetkompenserng brukes eller ikke 

	akk_ut_generate : for n in 0 to NUMBER_OF_CHANNELS - 1 generate
		utgang_uten_offset_generate : if USE_OFFSET_COMPENSATION = '0' generate

			-- Uten USE_OFFSET_COMPENSATION utnytter AD-signalet full bredde i utgangssignalet.

			smal_ut_generate : if AKKUMULATOR_BREDDE >= WIDTH_OUT generate
				akk_ut_array(n) <= akkumulator_array(n)(AKKUMULATOR_BREDDE - 1 downto AKKUMULATOR_BREDDE - WIDTH_OUT);
			end generate;

			bred_ut_generate : if AKKUMULATOR_BREDDE < WIDTH_OUT generate
				akk_ut_array(n)(WIDTH_OUT - 1 downto WIDTH_OUT - AKKUMULATOR_BREDDE) <= akkumulator_array(n);
			end generate;

		end generate;
		-- Når USE_OFFSET_COMPENSATION brukes blir resultatet skjåvet en bit ned, slik at en unngår overflyt ved fullt utslag.
		-- AD signalet utnytter dermed ikke den øverste bitten.
		-- 	
		utgang_med_offset_generate : if USE_OFFSET_COMPENSATION = '1' generate
			smal_ut_off_generate : if AKKUMULATOR_BREDDE >= WIDTH_OUT  generate
				akk_m_ut_array(n) <= shift_right(akkumulator_array(n),1)(AKKUMULATOR_BREDDE - 1 downto AKKUMULATOR_BREDDE - WIDTH_OUT);

			end generate;

			bred_ut_off_generate : if AKKUMULATOR_BREDDE < WIDTH_OUT  generate
				akk_m_ut_array(n)(WIDTH_OUT - 1 downto WIDTH_OUT - AKKUMULATOR_BREDDE - 1) <= resize(akkumulator_array(n), AKKUMULATOR_BREDDE + 1);

			end generate;

			akk_ut_array(n) <= akk_m_ut_array(n) + ad_offset_reg_array(n);

		end generate;
	end generate;

	---------------------------------------------------------------------------------------------------------------
	--  Synkroniseringsregisre. Overgang fra AD klokke til bussklokkedomene. 
	-- Disse drives av bussklokka. 
	
	clk_ad_akk_ut_array <= akk_ut_array;

	synkroniseringsprosess : process(Bus2IP_Clk)
	begin
		if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then	
			
			if (reset_h = '1') then
				clk_bus_signal_array <= (others => (others => '0'));
				clk_bus_signal_ny    <= '0';
			else
			
				-- Her er selve domenekryssingen. Ekstra synkroniseringsregistre for å unngå metastabile tilstander.. 
				clk_bus_akk_ut_array_synk1    <= clk_ad_akk_ut_array;
				clk_bus_settflagg_synk1 <= clk_ad_settflagg ;
				-- Synkronisering.
				clk_bus_akk_ut_array_synk2    <= clk_bus_akk_ut_array_synk1;
				clk_bus_settflagg_synk2 <= clk_bus_settflagg_synk1;   
				
				clk_bus_signal_ny <= '0';
				clk_bus_settflagg <= clk_bus_settflagg(0) & clk_bus_settflagg_synk1;

				if (not (clk_bus_settflagg(1) = clk_bus_settflagg(0))) then
					for n in 0 to NUMBER_OF_CHANNELS - 1 loop
						clk_bus_signal_array(n) <= clk_bus_akk_ut_array_synk2(n);
					end loop;

					if ((oppstartflagg = '0') and (ny_flagg_blokkering = '0')) then
						clk_bus_signal_ny <= '1';
					end if;

				end if;
			end if;	
		end if;

	end process;


end IMP;
