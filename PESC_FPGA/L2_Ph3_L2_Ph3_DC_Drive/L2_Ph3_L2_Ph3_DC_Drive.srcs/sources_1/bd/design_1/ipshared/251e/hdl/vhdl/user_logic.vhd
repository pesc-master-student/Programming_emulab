---****************************************************************************

-- DA-converter interface.

-- 2x Analog devices AD5447 2x12 bit  DA converter  

-- Author: Kjell Ljøkelsøy. Sintef Energi. 2009-2017
 
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;

Library UNISIM;
use UNISIM.vcomponents.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

------------------------------------------------------------------------------

entity user_logic is
  generic
  (
	 -- ADD USER GENERICS BELOW THIS LINE ---------------
	 --USER generics added here
	
  
	NUMBER_OF_SIGNAL_SOURCES			: integer				:= 1;   -- Number of concatenated signal sources per channel.
 	WIDTH_IN							: integer		 		:= 12;	
	USE_SCALING 						: std_logic  			:= '0'; -- 0: No scaling. 1: Use scaling, offset compensation and saturation. NB! 24 bit only. . 
	SCALE_SHIFTS 						: integer 	 		 	:= 8;	--  Number of shifts down after multiplying with scale factor. Scale factor of 2**SCALE_SHIFTS gives 1:1 scaling.
 	CONFIG_REG_DEFAULT_VALUE			: std_logic_vector		:= X"00000000";  	-- Input config, one bit per channel 1: external signals, 0: registers. bit 3: D, bit 2: C, bi 1: B bit 0: A:   
	CLOCK_PULSES_CS_LOW					: integer				:= 2;   -- -- Duration of CS low signal. Write to one DA channel. Update rate is four times CS low duration. p  =  fclk /  (4*fsamp)
	DA_CONVERTER_WIDTH					: integer		 		:= 12;	-- 12 bit for AD 5447.
	NUMBER_OF_CHANNELS					: integer			 	:= 4; 	-- Two 2 cahannel converters gives 4 channels, 2x2 interleaved. 

	
	-- ADD USER GENERICS ABOVE THIS LINE ---------------

	 -- DO NOT EDIT BELOW THIS LINE ---------------------
	 -- Bus protocol parameters, do not add to or delete
	 
	 
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
	 
	 -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
	 -- ADD USER PORTS BELOW THIS LINE ------------------
		  
 	 	-- External ports towards the DA converters.
	 	
		da_d  							: out std_logic_vector (DA_CONVERTER_WIDTH-1 downto 0);
		da_a_b							: out std_logic;
		da_rw							: out std_logic;
		da_ab_cs						: out std_logic;
		da_cd_cs						: out std_logic;
		
-- internal ports, towards the FPGA fabric.

		signal_in_new					: in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0)  := (others => '1'); -- Flag new samples at the inputs. Triggers write to the DA converters. -- bit 3: D, bit 2: C, bi 1: B bit 0: A

		signal_in_a	 					: in std_logic_vector(NUMBER_OF_SIGNAL_SOURCES * WIDTH_IN-1 downto 0) := (others => '0'); -- Signal sources: s2 & s1 & s0
		signal_in_b	 					: in std_logic_vector(NUMBER_OF_SIGNAL_SOURCES * WIDTH_IN-1 downto 0) := (others => '0'); -- Concatenation of signal sources: da_x_sn &  -- & da_x_s1 & da_x_s0 
		signal_in_c	 					: in std_logic_vector(NUMBER_OF_SIGNAL_SOURCES * WIDTH_IN-1 downto 0) := (others => '0');
		signal_in_d	 					: in std_logic_vector(NUMBER_OF_SIGNAL_SOURCES * WIDTH_IN-1 downto 0) := (others => '0');
			-- Concatenation of signal sources: da_x_sn &  -- & da_x_s1 & da_x_s0 
			-- Narrow signals must be stuffed at the bottom, in order to preserve signal amplitude.
			-- In the MHS file it is done manually in this way: 
			--	One signal with stuffing: 	PORT 	signal_in_a = 	 smal_sig & 0b0000 
			-- Multiple signals:    			PORT signal_in_a = sig1 & 0b00  & sig_0 & 0b0000	
		
	

	 
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
  attribute SIGIS of Bus2IP_Clk	 : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

	--USER signal declarations added here, as needed for user logic
	constant NUM_REG 					: integer :=  2 +  3* NUMBER_OF_CHANNELS; -- 2 +  3* NUMBER_OF_CHANNELS when USE_SCALING ? '1' else 2 +  1* NUMBER_OF_CHANNELS;

			
	
	constant DA_REG_STARTNR 					: integer := 0;
	constant KONFIGREG_REGNR 					: integer := NUMBER_OF_CHANNELS-1 +1;
	constant SIGNALKILDEVELGEREG_REGNR 		: integer := NUMBER_OF_CHANNELS-1 +2;		-- bit 15-12: kanal D, bit 11-8: kanal C, bit 7-4:kanal B, bit 3-0 kanal A	
	constant SKALA_STARTNR 						: integer := 1 * NUMBER_OF_CHANNELS + 2;
	constant OFFSET_STARTNR 					: integer := 2 * NUMBER_OF_CHANNELS + 2;

	
	constant SIGNALVELGER_BREDDE				: integer := 8; -- bit, en byte or kanal.		

	-- constant CLOCK_PULSES_CS_LOW		: integer :=  2; -- ((DA_OMFORMER_CS_LAV_TID-1) ) / C_SPLB_CLK_PERIOD_PS;

	constant DA_BUSSREG_BREDDE 				: integer := 25; -- DSP_BLOKK_INN_A_BREDDE; -- Samme bredde som multiplikatoren.
	constant DA_SKALAREG_BREDDE 				: integer := 18; -- DSP_BLOKK_INN_B_BREDDE; -- 

	type kanal_rekkefolge_tabell_type 		is array 	(NUMBER_OF_CHANNELS-1 downto 0) of integer range NUMBER_OF_CHANNELS-1 downto 0;

	
	constant KANAL_REKKEFOLGE_TABELL 		: kanal_rekkefolge_tabell_type := (3,1,2,0);  -- Styrer rekklefølgen. Skriver  vekselvis til annenhver DA omformer
	constant STYRESIGNAL_UT_SKIFTEREGBREDDE		: integer := 3;

	constant PRODUKT_BREDDE 				: integer := DA_BUSSREG_BREDDE + DA_SKALAREG_BREDDE;
	constant PRODUKT_SUM_BREDDE 			: integer := PRODUKT_BREDDE +1;
	
	
	signal mult									: signed (PRODUKT_BREDDE-1 downto 0);
	signal mult_s								: signed (PRODUKT_SUM_BREDDE-1 downto 0);	
	
	signal m_offset							: signed (PRODUKT_SUM_BREDDE-1 downto 0);	
	signal mult_offset_sum					: signed (PRODUKT_SUM_BREDDE-1 downto 0);	

	signal mult_offset_sum_shift			: signed (PRODUKT_SUM_BREDDE-1 downto 0);	
	signal mult_offset_sum_metn			: signed (PRODUKT_SUM_BREDDE-1 downto 0);		
	signal mult_ut								: signed (DA_CONVERTER_WIDTH -1 downto 0);
	
	signal reg_ny								 : std_logic := '0';



	type signalkilde_arraytype					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  integer range NUMBER_OF_SIGNAL_SOURCES-1 downto 0;

	signal signalkilde_array					: signalkilde_arraytype   := (others => 0);
	
	type signal_mux_inn_arraytype				is array (NUMBER_OF_CHANNELS-1 downto 0, NUMBER_OF_SIGNAL_SOURCES-1 downto 0 ) of  signed(WIDTH_IN-1 downto 0);

	signal signal_mux_inn_array						: signal_mux_inn_arraytype := (others => (others => (others => '0')));
	
	type signal_inn_arraytype					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(WIDTH_IN-1 downto 0);
	
	signal signal_inn_array 					: signal_inn_arraytype := (others => (others => '0'));
	
	signal signal_inn_reg						: signal_inn_arraytype := (others => (others => '0'));	
	


	type mul_inn_arraytype					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(DA_BUSSREG_BREDDE-1 downto 0);
	signal da_buss_inn_reg						: mul_inn_arraytype := (others => (others => '0'));	
	
	signal mul_inn_signal_array				: mul_inn_arraytype := (others => (others => '0'));
	
	type signal_in_arraytype					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(DA_CONVERTER_WIDTH-1 downto 0);
		
	signal signal_inn_reg_just					: signal_in_arraytype := (others => (others => '0'));	
	signal offset_array							: signal_in_arraytype := (others => (others => '0'));	


	 signal da_signal_just_array					: signal_in_arraytype := (others => (others => '0'));

	 signal da_signal_just_reg					 : signed(DA_CONVERTER_WIDTH-1 downto 0):= (others => '0');
	 
	type skalafaktor_arraytype					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(DA_SKALAREG_BREDDE-1 downto 0);
	
	signal skalafaktor_array					: skalafaktor_arraytype := (others => (others => '0'));

	signal oppdatere_flagg : std_logic := '0';

	signal signal_in_new_inn					: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');


	signal da_konfig_register				: std_logic_vector(C_SLV_DWIDTH-1 downto 0) := CONFIG_REG_DEFAULT_VALUE; 
	signal da_konfig_register_les			: std_logic_vector(C_SLV_DWIDTH-1 downto 0) := (others => '0');

	signal signalkilde_register			: std_logic_vector(C_SLV_DWIDTH-1 downto 0) :=  (others => '0');
	signal signalkilde_register_les		: std_logic_vector(C_SLV_DWIDTH-1 downto 0) := (others => '0');


	signal reg_ut_ny								: std_logic := '0';
	
	signal csn									   : std_logic := '1';
	signal da_csn								   : std_logic := '1';	

	signal kanal_indeks							: integer range NUMBER_OF_CHANNELS-1 downto 0 := 0;  
	signal kanal_indeks_ut						: integer range NUMBER_OF_CHANNELS-1 downto 0 := 0;  

	type  kanal_indeks_skifteregtype 	is array (STYRESIGNAL_UT_SKIFTEREGBREDDE-1 downto 0) of  integer range NUMBER_OF_CHANNELS-1 downto 0; 
	signal kanal_indeks_skiftereg 		: kanal_indeks_skifteregtype :=  (others =>  0);
	
	
	signal csn_skiftereg 					: unsigned (STYRESIGNAL_UT_SKIFTEREGBREDDE-1 downto 0) := (others => '1');
	signal reg_ut_ny_skiftereg 			: unsigned (STYRESIGNAL_UT_SKIFTEREGBREDDE-1 downto 0) := (others => '1');


	signal da_nr_ut								: std_logic_vector(1 downto 0) := (others => '0');  
	signal nytt_reg_innhold					 : std_logic := '0';
	signal les_eksterne_signaler		  	  : std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);

	signal da_rw_ut								: std_logic := '1';
	signal da_ab_cs_ut							: std_logic := '1';
	signal da_cd_cs_ut							: std_logic := '1';
	signal da_a_b_ut_m							: std_logic := '1';
	signal da_a_b_ut							  : std_logic := '1';

	signal da_d_ut									 : unsigned(DA_CONVERTER_WIDTH-1 downto 0):= (others => '0');	
	signal da_d_ut_m								 : unsigned(DA_CONVERTER_WIDTH-1 downto 0):= (others => '0');	

	signal da_d_ut_u								 : signed(DA_CONVERTER_WIDTH-1 downto 0):= (others => '0');


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
		
		
		type register_array_type is array (P_NUM_REG - 1 downto 0) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);

		signal register_array_read   	: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
		signal register_array_write 	: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
		signal register_array_init 	: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
	

	--====================================================================
	
	
begin

	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
	severity failure;

			
	assert WIDTH_IN <= DA_BUSSREG_BREDDE or USE_SCALING = '0'
	 		report "####  WIDTH_IN er bredere enn inngangen på multiplikatoren"
		severity failure;

	assert NUMBER_OF_SIGNAL_SOURCES < (2**SIGNALVELGER_BREDDE)-1 
	 		report "#### NUMBER_OF_SIGNAL_SOURCES har feil verdi. Må være mindre enn 255."
		severity failure;
		
		
	assert  NUMBER_OF_CHANNELS = 4
		report " NUMBER_OF_CHANNELS har feil verdi. Skal være 4. "
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

	--Signaltilkoblinger.
	

	da_d					<= std_logic_vector(da_d_ut);
	da_a_b				<= da_a_b_ut;
	da_rw					<= da_rw_ut;
	da_ab_cs				<= da_ab_cs_ut;
	da_cd_cs				<= da_cd_cs_ut;
		
	signal_in_new_inn	 <= signal_in_new;

	
	da_nr_ut 	<= std_logic_vector(to_unsigned(kanal_indeks_ut,i_log2(NUMBER_OF_CHANNELS))); 
	
-- Trekker utgangssigalene gjennom et ekstra register på utgangen, slik at det ikke blir noe kombinatorisk logikk mellom registre og utgang. Bedrer timing på utgangssignalene.
	
	da_rw_ut				 <= '0';
	
	utgangsregister_prosess: process(Bus2IP_Clk)
		begin	
			if Bus2IP_Clk 'event and Bus2IP_Clk = '1' then 
				--da_rw_ut				 <= '0';
				da_a_b_ut 			<= da_a_b_ut_m;	
				da_d_ut				<= da_d_ut_m;		
	--		end if;				
	--	end process;
		
	-- --  cs- linene klokkes på synkende flanke, en halv klokkepuls forsinkelse.  Sikrer at data og adresse, som forsinkes en hel klokkepuls holdes en halvperiode etter at cs har skiftet. 		
	--utgangsregister_cs_prosess: process(Bus2IP_Clk) 
	--	begin	
	--		if Bus2IP_Clk 'event and Bus2IP_Clk = '0' then 
				da_ab_cs_ut			<= da_nr_ut(1)		 or da_csn;
				da_cd_cs_ut			<= (not da_nr_ut(1)) or da_csn;
			end if;	
		end process;	
	
-- Koble registre
	register_array_init(KONFIGREG_REGNR) <= CONFIG_REG_DEFAULT_VALUE;	
	
	da_konfig_register <= register_array_write(KONFIGREG_REGNR);	
	
	register_array_read(KONFIGREG_REGNR) <= da_konfig_register_les;


	les_eksterne_signaler <= da_konfig_register(NUMBER_OF_CHANNELS-1 downto 0);
	da_konfig_register_les(NUMBER_OF_CHANNELS-1 downto 0) <= les_eksterne_signaler;

 
	register_array_read(SIGNALKILDEVELGEREG_REGNR) <= signalkilde_register_les;
	signalkilde_register <= register_array_write(SIGNALKILDEVELGEREG_REGNR);
	
	
	-- Signalkildevelgerindeks	
	Signalkildevelger_index_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate
		
		signalkilde_register_les ((n+1)*SIGNALVELGER_BREDDE-1 downto n * SIGNALVELGER_BREDDE)		<=  std_logic_vector(to_unsigned(signalkilde_array(n),SIGNALVELGER_BREDDE));
		
		signalkilde_array(n) <= to_integer(unsigned(signalkilde_register((n+1)*SIGNALVELGER_BREDDE-1 downto n * SIGNALVELGER_BREDDE))) 
				when  to_integer(unsigned(signalkilde_register((n+1)*SIGNALVELGER_BREDDE-1 downto n * SIGNALVELGER_BREDDE)))  <  NUMBER_OF_SIGNAL_SOURCES  else 0;
	end generate;
	
	
  reg_koble_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate
	
	-- Kniper ned bredden av bussregistret til gjeldende antall bit. DA_CONVERTER_WIDTH når skalering ikke brukes, DSP_MUL_A_BREDDE ellers.	
	

  
  da_buss_inn_reg(n) <=  signed(register_array_write(DA_REG_STARTNR + n)(DA_BUSSREG_BREDDE-1 downto 0));	
	
	register_array_read(DA_REG_STARTNR + n) <= 	std_logic_vector(resize(da_signal_just_array(n),C_SLV_DWIDTH)) when  USE_SCALING = '0' else															
																std_logic_vector(resize(mul_inn_signal_array(n),C_SLV_DWIDTH));   

												 
		skala_og_offsetereg_koble_generate : if 	USE_SCALING = '1' generate
		
			register_array_init(SKALA_STARTNR + n) <=  std_logic_vector(to_signed(2**SCALE_SHIFTS,C_SLV_DWIDTH));   -- gir 1 som skalering. 
			
			offset_array(n) <= signed(register_array_write(OFFSET_STARTNR + n)( DA_CONVERTER_WIDTH-1 downto 0));
			skalafaktor_array(n) <= signed(register_array_write(SKALA_STARTNR + n)( DA_SKALAREG_BREDDE-1 downto 0));
			
			register_array_read(OFFSET_STARTNR + n)  <=   std_logic_vector(resize(offset_array(n),C_SLV_DWIDTH));
			register_array_read(SKALA_STARTNR + n)   <=   std_logic_vector(resize(skalafaktor_array(n),C_SLV_DWIDTH));			
		
		end generate;
		
	  
  end generate; 
	
		
	-------------------------------------------------------------------------------------------------
	-- Inngangssignaler. Multiplekser og array. 
	-- Splitting av inngangssignalbuntene i enkeltsignaler i array.
	signalkilde_mux_inn_array_generate : for m in 0 to	NUMBER_OF_SIGNAL_SOURCES-1 generate
		signal_mux_inn_array(0,m) <= 	signed(signal_in_a( (m+1)*WIDTH_IN -1 downto m * WIDTH_IN));
		signal_mux_inn_array(1,m) <= 	signed(signal_in_b( (m+1)*WIDTH_IN -1 downto m * WIDTH_IN));
		signal_mux_inn_array(2,m) <= 	signed(signal_in_c( (m+1)*WIDTH_IN -1 downto m * WIDTH_IN));
		signal_mux_inn_array(3,m) <= 	signed(signal_in_d( (m+1)*WIDTH_IN -1 downto m * WIDTH_IN));
	end generate;
	
	-- Multiplekser, inngangsvelger.
	signalkilde_inn_multiplekser_generate : for k in 0 to	NUMBER_OF_CHANNELS-1 generate
		signal_inn_array(k) <= signal_mux_inn_array(k,signalkilde_array(k));
	end generate;
		
		



	Sekvensprosess :  process (Bus2IP_Clk) 
		variable sekvensteller : integer range 0 to 8 := 0;	
		variable cs_teller : integer range 0 to CLOCK_PULSES_CS_LOW-1  := 0;	
			begin 
				if (Bus2IP_Clk 'event and Bus2IP_Clk = '1') then		 
					if (Bus2IP_Resetn = '0') then
					
						oppdatere_flagg <= '0';
						sekvensteller := 0;				
						cs_teller := 0;
						csn <= '1';
						kanal_indeks <= 0;	
						reg_ut_ny <= '0';
					else					
						
						
						reg_ut_ny <= '0';
						
						if ( reg_ny = '1') then
								oppdatere_flagg <= '1';							
						end if;					
						
						if (sekvensteller = 0) then			
							cs_teller := 0;
							if (oppdatere_flagg = '1') then
								sekvensteller := 1;
								oppdatere_flagg <= '0';				
							end if;								
						else 	
							if cs_teller = 0 then 
								reg_ut_ny <= '1';
							end if;
							
							if (cs_teller < CLOCK_PULSES_CS_LOW-1)	then -- data settes ut et trinn etter CS har blitt satt lavt.						  
								cs_teller := cs_teller +1;
							else		
									cs_teller := 0; 
								sekvensteller := sekvensteller + 1;			
					 
							end if;
							
							if (sekvensteller >= NUMBER_OF_CHANNELS+1) then
								sekvensteller := 0;																		
							end if;	
							
						end if;
							-- Setter ut chip select og adressesignaler. 
							-- Vekselvis skriving. sørger for at cs signalene til hver DA-omformer går høyt etter hver skriving. 
						if ( sekvensteller = 0)	then 
							kanal_indeks <= 0;
							csn <= '1';	
						else 
							kanal_indeks <= KANAL_REKKEFOLGE_TABELL(sekvensteller-1);
							csn <= '0';	
						end if;	
					end if;					
				end if;	
			end process;


 -- skriver eksternt registerinnhold når ny-signalet er satt, 
 -- Flagger nytt innhold  eller når det skrives fra bussen. 		
		Signal_inn_registerprosess :  process(Bus2IP_Clk)
			begin
				if (Bus2IP_Clk 'event and Bus2IP_Clk = '1') then	
					if (Bus2IP_Resetn = '0') then
						signal_inn_reg <= (others => (others => '0')); 
						reg_ny <= '0' ;
					else
							reg_ny <= '0';
						for k in 0 to NUMBER_OF_CHANNELS-1 loop
							if signal_in_new_inn(k) = '1' then 
								signal_inn_reg(k)  <= signal_inn_array(k); 
								if les_eksterne_signaler(k) = '1' then
									reg_ny <= '1';
								end if;
		
							end if;	
						end loop;
						if reg_write_enable = '1' then 		-- Skriving fra databussen				
							reg_ny <= '1';
						end if;
					end if;
				end if;	
			end process;
				

			 

	
	da_signal_ut_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate



		--		signal_inn_reg_just(n) <= resize(shift_right(signal_inn_reg(n),WIDTH_IN - DA_CONVERTER_WIDTH),DA_CONVERTER_WIDTH) when WIDTH_IN >= DA_CONVERTER_WIDTH	else 
		--			shift_left(resize(signal_inn_reg(n),DA_CONVERTER_WIDTH),DA_CONVERTER_WIDTH - WIDTH_IN); 

		signal_inn_reg_just_widen : if WIDTH_IN >= DA_CONVERTER_WIDTH generate
			
				signal_inn_reg_just(n) <= resize(shift_right(signal_inn_reg(n),WIDTH_IN - DA_CONVERTER_WIDTH),DA_CONVERTER_WIDTH);
		end generate;
		
		signal_inn_reg_just_shrink : if WIDTH_IN < DA_CONVERTER_WIDTH generate
			signal_inn_reg_just(n) <=  shift_left(resize(signal_inn_reg(n),DA_CONVERTER_WIDTH),DA_CONVERTER_WIDTH - WIDTH_IN); 
		end generate;
		-- Velger mellom eksterne signaler og bussignaler.  		
	
		da_signal_just_array(n)	 <=  signal_inn_reg_just(n) when  les_eksterne_signaler(n) = '1' else da_buss_inn_reg(n)(DA_CONVERTER_WIDTH-1 downto 0); -- Breddejusterng, skalering når skalering ikke brukes.
		mul_inn_signal_array(n) <= resize(signal_inn_reg(n),DA_BUSSREG_BREDDE) when  les_eksterne_signaler(n) = '1' else 	da_buss_inn_reg(n); -- Breddetilpasning når skalering brukes.
	
	end generate;


m_offset <= shift_left(resize(offset_array(kanal_indeks_skiftereg(STYRESIGNAL_UT_SKIFTEREGBREDDE-1-1)),m_offset 'length),SCALE_SHIFTS);

	-- Data skrives ut. Forsinker signalene med en klokkepuls i forhold til chip select-signalene har blitt skrevet ut. Dette sikrer at data holdes litt etter at cs går høyt. 
	
	data_ut_multiplekser_prosess: process(Bus2IP_Clk)
		begin
		if (Bus2IP_Clk 'event and Bus2IP_Clk = '1') then
			csn_skiftereg <= shift_left(csn_skiftereg,1);
			csn_skiftereg(0) <= csn;

			reg_ut_ny_skiftereg <= shift_left(reg_ut_ny_skiftereg,1);
			reg_ut_ny_skiftereg(0) <= reg_ut_ny;
			
			kanal_indeks_skiftereg <= kanal_indeks_skiftereg(STYRESIGNAL_UT_SKIFTEREGBREDDE-1-1 downto 0) & kanal_indeks;

			
			if reg_ut_ny = '1' then -- Fryser utgang etter at data har blir lest inn. 
		--	if reg_ut_ny_skiftereg(0) = '1' then -- Klokker inn nye data en klokkepuls etter at intern multiplekser har blitt oppdatert. 
				da_signal_just_reg <= da_signal_just_array(kanal_indeks);							-- Signalvelger, uten skalering.	
				mult <= mul_inn_signal_array(kanal_indeks) * skalafaktor_array(kanal_indeks); 	--Signalvelger, med skalering.
			end if;	
			
		-- Skalering og offset. 
	
		mult_s <= resize (mult,mult_s 'length);
		mult_offset_sum <= m_offset  + mult_s;
		
		end if;	
		
	end process;
	
	
		-- --  Metning 
		
--	mult_offset_sum_metn <= shift_right(mult_offset_sum,SCALE_SHIFTS) when  shift_right(mult_offset_sum,SCALE_SHIFTS+DA_CONVERTER_WIDTH) = 0 or shift_right(mult_offset_sum,SCALE_SHIFTS+DA_CONVERTER_WIDTH) =  -1 else 
--									to_signed(0-2** (DA_CONVERTER_WIDTH-1), mult_offset_sum_metn 'length)  when  shift_right(mult_offset_sum,SCALE_SHIFTS+DA_CONVERTER_WIDTH)  < 0 else 
--									to_signed(2** (DA_CONVERTER_WIDTH-1)-1, mult_offset_sum_metn 'length); 
	
	mult_offset_sum_shift <= shift_right(mult_offset_sum,SCALE_SHIFTS);
	
	
	mult_offset_sum_metn <= mult_offset_sum_shift when  shift_right(mult_offset_sum_shift,DA_CONVERTER_WIDTH-1) = 0 or shift_right(mult_offset_sum_shift,DA_CONVERTER_WIDTH-1) =  -1 else 
										to_signed(2** (DA_CONVERTER_WIDTH-1), mult_offset_sum_metn 'length)  when  shift_right(mult_offset_sum_shift,DA_CONVERTER_WIDTH-1)  < 0 else 
										to_signed(2** (DA_CONVERTER_WIDTH-1)-1, mult_offset_sum_metn 'length); 
	
	
	
	mult_ut <= mult_offset_sum_metn(DA_CONVERTER_WIDTH-1 downto 0);
	

	
	kanal_indeks_ut <= kanal_indeks  when USE_SCALING = '0' else kanal_indeks_skiftereg(STYRESIGNAL_UT_SKIFTEREGBREDDE-1) ;		
	

	da_csn <= csn when USE_SCALING = '0' else csn_skiftereg(STYRESIGNAL_UT_SKIFTEREGBREDDE-1);  
		
	da_d_ut_u <= mult_ut when USE_SCALING = '1' else da_signal_just_reg;	
	
	da_d_ut_m <=  unsigned(da_d_ut_u) + 2** (DA_CONVERTER_WIDTH-1); -- Adding 2048/ half scale.
	
	da_a_b_ut_m			<= da_nr_ut(0);  	
	

			
end IMP;






