--***************************************************************************
-- Vekselretter drivergrensesnitt og pulse_width_modulator.
--
-- Author: Kjell Ljøkelsøy. Sintef Energi. 2007 - 2014


------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;

----------------------------------------------------------------------------

entity user_logic is
  generic
  (

	WIDTH_IN	 							: integer              	:= 16;	-- Reference input signal width.
	
	NUMBER_OF_SIGNAL_SOURCES					: integer 					:= 1; -- Number of discrete input signals to the multiplexer.
	

	HYSTERESIS_DEFAULT_VALUE 				: integer 					:= 10; --  bit.
	
	CARRIER_COUNTER_FRACTIONAL_BITS 				: integer           		:= 10;	-- Number of bits output signal carrier counter is shifted down.  
	
	CARRIER_INCREMENT_DEFAULT_VALUE 				: integer 					:= 512; --  bit.

	AMPLITUDE_DEFAULT_VALUE 				: integer 					:= 2000; --  Peak to peak amplitude of carrier. Full scale input is half of this..

  	NUMBER_OF_CHANNELS							: integer					:= 3;  	
	
	NUMBER_OF_CARRIERS						: integer					:= 1; -- Less or equal to NUMBER_OF_CHANNELS.	

	INTERRUPT_DIVISOR_WIDTH			: integer					:= 8;  -- Size of the interrupt divisor counter..  
	
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
    --USER ports added here


	ref_in_new							: in 	std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others=> '1');	 			-- 1 New, valid reference signals. Must be tied  high if not used.. 

	ref_in								: in  std_logic_vector(NUMBER_OF_SIGNAL_SOURCES * NUMBER_OF_CHANNELS * WIDTH_IN-1 downto 0):= (others => '0'); 
	-- ref_xx && ref_2c & ref_2b & ref 2a && ref_1c & ref_1b & ref 1a;

	
	ref_synch_in						: in	std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others=> '1');			--  External synch signal for loading references into registers.  0: keep old value 1: load referanse.			

	ref_out								: out  std_logic_vector(NUMBER_OF_CHANNELS * WIDTH_IN-1 downto 0):= (others => '0'); -- Actual reference, after multiplexer and synchronisation.--  ref_c & ref_b & ref a;

	ref_out_a								: out std_logic_vector(WIDTH_IN-1 downto 0); 
	ref_out_b								: out std_logic_vector(WIDTH_IN-1 downto 0);
	ref_out_c								: out std_logic_vector(WIDTH_IN-1 downto 0);
	
	synch_in								: in	std_logic := '0';			-- 1: Base counter reset. The slave base counter will be one clock pulse after the master.. 			

	synch_out								: out std_logic_vector(1 + 2 * NUMBER_OF_CARRIERS-1 downto 0); 		  
		--  base counter reset & carrier_tops & carrier bottoms, 
		-- tc: number of carriers
		-- bit tc-1 -0 int _mask  carrier bottom c,b,a 	1: pulse 0: no pulse.
		-- bit 2*tc-1  - tc  int _mask  carrier top c,b,a 	1: pulse 0: no pulse.
		-- bit 2*tc . int mask base counter reset  1: pulse 0: no pulse	
		
	base_counter_out						: out std_logic_vector(WIDTH_IN+1-1 downto 0):= (others => '0'); -- Base counter, shifted down. Reference PWM phase. 
	
 	carrier_out							: out std_logic_vector(NUMBER_OF_CARRIERS * WIDTH_IN-1 downto 0):= (others => '0');		-- Bundle of carriers: tc_c & tc_b & tc a
	
	carrier_out_a						: out std_logic_vector(WIDTH_IN-1 downto 0); -- 
	carrier_out_b						: out std_logic_vector(WIDTH_IN-1 downto 0);
	carrier_out_c						: out std_logic_vector(WIDTH_IN-1 downto 0);

	pwm_out								: out std_logic_vector(NUMBER_OF_CHANNELS -1 downto 0):= (others => '0'); 	
	
	phase_shift_out						: out std_logic_vector(NUMBER_OF_CHANNELS -1 downto 0):= (others => '0'); 	
		
	intr								: out std_logic := '0'; -- 1:Interrupt pulse to processor 


	
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
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

--  	-- inngangssignalkonfigurering. 
 
	constant MAKS_NUMBER_OF_SIGNAL_SOURCES 			: integer := 15; -- Fire bit.	
	
  -- Registernummer 

  	constant SIGNALKILDE_REGNR 					: integer := 0; -- -- -1 velger prosessorbuss. 
  
	constant REF_SYNK_KILDE_REGNR 				: integer := 1;
	
	constant INTERRUPTKONFIG_REGNR 				: integer := 2;
	constant INTERRUPT_DIVISOR_REGNR 			: integer := 3;

	

	constant TREKANTSIGNAL_AMPLITUDE_REGNR		: integer := 4;   
	constant TREKANTSIGNAL_INKREMENT_REGNR		: integer := 5;  
	
	constant HYSTERESE_REGNR						: integer := 6;   

	constant REGARRAY_STARTREGNR 					: integer := 8;
	

	constant REGISTERBLOKKAVSTAND 				: integer := NUMBER_OF_CHANNELS; 	
	constant NUM_REG 								: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 3;	

	
	constant REF_REG_START_REGNR 					: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 0; -- Leser utgangssignal, Skriving hit skriver rett til integratoren. 
	constant TREKANT_REG_START_REGNR 			: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 1; -- Referansessignal. Skrives til et register, leser gjeldende verdi.
 	constant FASESKIFT_REG_START_REGNR 			: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 2; -- Referansessignal. Skrives til et register, leser gjeldende verdi.
	
--	constant REF_SIGNALS_DIRECTLY_IN						: integer					:= 0; -- 0: Referansesignaler via buffer. 1: Referansesignaler tas rett inn, utenom registrene. Kan i så fall ikke skrives fra prosessorbussen.
	
	
	-- Bit i konfigreg. Må manuelt passe på at det er tilstrekkelig avstand mellom blokkene her.

	-- Diverse 
	
	constant SYNKKILDEREG_BREDDE				: integer := 5;
		--bit 0:			-- Fast på. Kontinuerlig oppdatering.
		-- bit 1:		-- synch_in signal
		-- bit 2:		-- Trekant bunn,	
		-- bit 3:		-- Trekant topp,.
		-- bit 4:		--  Baseteller start.  

	constant REF_SYNK_KILDE_DEFAULTVERDI	: integer := 1;
	constant REF_DEFAULTVERDI					: integer := 0;
	
	constant INT_KONFIGREG_BREDDE				: integer := 1 + 2 * NUMBER_OF_CARRIERS; 
	
	constant ANTALL_DISKRETE_UTGANGER		: integer := 3;
	
	constant TREKANTBREDDE						:  integer := WIDTH_IN + 2; -- En bit ekstra gir plass for basetelleren til å nå opp til 2x trekant amplitude, enda en bit ekstra må til for å unngå overflyt og synkglipp ved maksverder nær fullskala og store inkrement.
	constant TREKANTTELLER_BREDDE  				: integer := CARRIER_COUNTER_FRACTIONAL_BITS + TREKANTBREDDE;
	
	signal klokke 										: std_logic := '0';  
	signal reset 										: std_logic := '1';  

	
	signal statusreg									: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal konfigreg	 								: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	
	signal konfigreg_lese							: std_logic_vector(C_SLV_DWIDTH-1 downto 0 ):= (others => '0');	

	--signal ref_velger									: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');

	signal baseteller				   				: unsigned(TREKANTTELLER_BREDDE -1 downto 0) := (others => '0');
	signal baseteller_synkflagg					: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	signal baseteller_forrige_synkflagg			: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	signal baseteller_synkpuls				  		: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');

	signal baseteller_nullflagg	  				: std_logic :=  '0';
	signal synch_in_flagg	  						: std_logic :=  '0';
	signal synch_out_flagg	  							: std_logic :=  '0';
	
	
	signal trekant_toppverdi_2x			  		: unsigned(TREKANTBREDDE-1 downto 0); 
	signal baseteller_heltall			  		 	: unsigned(TREKANTBREDDE-1 downto 0); 
	
	signal trekant_retningsflagg				  	: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	signal forrige_trekant_retningsflagg	  	: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	signal trekant_topp_synkpuls				  	: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	signal trekant_bunn_synkpuls				  	: std_logic_vector(NUMBER_OF_CARRIERS -1 downto 0) := (others => '0');
	
	
	signal synkpulser 								: std_logic_vector(INT_KONFIGREG_BREDDE-1 downto 0)  := (others => '0'); 
 


	
	signal int_kildesignal							: std_logic := '0'; 
	signal int_kildesignal_g						: std_logic := '0'; 
	
	signal intsignal									: std_logic := '0'; 
	
	signal int_konfig_reg							: std_logic_vector(INT_KONFIGREG_BREDDE-1 downto 0) := (others=> '0');
	
	signal int_divisor_reg							: unsigned(INTERRUPT_DIVISOR_WIDTH-1 downto 0) := (others => '0'); 
	
	signal int_divisor_teller						: unsigned(INTERRUPT_DIVISOR_WIDTH-1 downto 0) := (others => '0'); 
	
	signal trekant_amplitude 						: unsigned(TREKANTBREDDE-1 downto 0 ):= (others => '0'); 
	
	signal trekant_topp		 						: signed(TREKANTBREDDE-1 downto 0 );

	signal trekant_bunn								: signed(TREKANTBREDDE-1 downto 0 );
	
	signal inkrement 									: signed(TREKANTTELLER_BREDDE-1 downto 0 );
	
	type trekantteller_arraytype 					is array (NUMBER_OF_CARRIERS-1 downto 0 ) of  signed(TREKANTTELLER_BREDDE-1 downto 0);
	
	signal trekantteller_array						: trekantteller_arraytype := (others => (others => '0'));
	
	type trekant_arraytype 							is array (NUMBER_OF_CARRIERS-1 downto 0 ) of  signed(TREKANTBREDDE-1 downto 0);

	signal trekant_faseskift_array				: trekant_arraytype := (others => (others => '0'));
	
	signal trekant_array 							: trekant_arraytype := (others => (others => '0'));

	
	signal trekant_pluss_hysterese_array 		: trekant_arraytype	:= (others => (others => '0'));
	signal trekant_minus_hysterese_array 		: trekant_arraytype	:= (others => (others => '0'));
	
	signal trekant_negativ_array 					: trekant_arraytype := (others => (others => '0'));
	
	type diskret_ut_mellomarraytype 				is array (ANTALL_DISKRETE_UTGANGER-1 downto 0 ) of  std_logic_vector(WIDTH_IN-1 downto 0);

	signal carrier_out_mellomarray					: diskret_ut_mellomarraytype := (others => (others => '0'));
	
	signal ref_out_mellomarray					: diskret_ut_mellomarraytype := (others => (others => '0'));

	
	signal signalkildereg							: std_logic_vector(C_SLV_DWIDTH-1 downto 0);
	
	signal signalkildereg_lese						: std_logic_vector(C_SLV_DWIDTH-1 downto 0) := (others=> '0');

	
	type signalkildevelger_arraytype			is array (NUMBER_OF_CHANNELS-1 downto 0) of  unsigned(4-1 downto 0);
	
	
	signal signalkildevelger_array				: signalkildevelger_arraytype := (others => (others => '0'));
			
	type signalkildevelger_verdi_arraytype		is array (NUMBER_OF_CHANNELS-1 downto 0) of  integer range 16 -1 downto 0;

	signal signalkildevelger_verdi_array	: signalkildevelger_verdi_arraytype  := (others => 0);
	
	type signalkilde_nr_arraytype				is array (NUMBER_OF_CHANNELS-1 downto 0) of  integer range NUMBER_OF_SIGNAL_SOURCES-1 downto 0;
	
	signal signalkilde_nr_array				: signalkilde_nr_arraytype := (others => 0);
		
	type ref_in_signal_arraytype 			is array (NUMBER_OF_SIGNAL_SOURCES+1-1 downto 0, NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(WIDTH_IN-1 downto 0 );

	--	type baseteller_arraytype 						is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  std_logic_vector(BASETELLERBREDDE-1 downto 0 );

	signal ref_in_array 							: ref_in_signal_arraytype	:= (others => (others => (others => '0')));
	
	type ref_signal_arraytype 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(WIDTH_IN-1 downto 0 );
	signal ref_buffer_array 						: ref_signal_arraytype	:= (others => (others => '0'));
	signal ref_reg_array 							: ref_signal_arraytype	:= (others => (others => '0'));
	signal ref_array 									: ref_signal_arraytype	:= (others => (others => '0'));

	
		
	signal ref_synk_kilde_reg							: std_logic_vector(SYNKKILDEREG_BREDDE-1 downto 0) := (others => '0');

	signal ref_synk 									: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');

	signal hysterese									: signed(TREKANTBREDDE-1 downto 0 ) := to_signed(HYSTERESIS_DEFAULT_VALUE,TREKANTBREDDE); 

	signal halv_hysterese							: signed(TREKANTBREDDE-1 downto 0 );
	

	
	signal pwm											: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
	
	signal faseskift									: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
	
	signal faseskift_sett_h_komp					: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
	signal faseskift_sett_l_komp					: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');	
	signal faseskift_sett_h							: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
	signal faseskift_sett_l							: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');	
	
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
		signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

		signal load 					: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
		

	--====================================================================
	
begin

	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;

	assert (REG_ADDR_SHIFT =	2)
		report "#### REG_ADDR_SHIFT <> 2, => C_SLV_DWIDTH <> 32  "
		severity note;


	assert (NUMBER_OF_SIGNAL_SOURCES <	MAKS_NUMBER_OF_SIGNAL_SOURCES)
		report "#### NUMBER_OF_SIGNAL_SOURCES er større enn MAKS_NUMBER_OF_SIGNAL_SOURCES"
		severity error;
		
		
	assert (NUMBER_OF_CHANNELS >= NUMBER_OF_CARRIERS)
		report "#### NUMBER_OF_CHANNELS må være større enn eller lik NUMBER_OF_CARRIERS"
		severity error;
	
		
	assert (REGISTERBLOKKAVSTAND >= NUMBER_OF_CARRIERS)
		report "#### REGISTERBLOKKAVSTAND må være større enn eller lik  NUMBER_OF_CARRIERS"
		severity error;
	

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
					for reg in 0 to NUM_REG -1 loop
						if load(reg) = '1' then	
							register_array_write(reg) <= register_array_load(reg);
						end if;
					end loop;				
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
	
	klokke <= Bus2IP_Clk;
	reset <= not Bus2IP_Resetn;
	
	-- Initialverdier i registre.
	
	register_array_init(SIGNALKILDE_REGNR) 					<=	std_logic_vector(to_unsigned(0,C_SLV_DWIDTH));  
	register_array_init(REF_SYNK_KILDE_REGNR) 				<=	std_logic_vector(to_unsigned(1,C_SLV_DWIDTH));  	 -- kontstant på.
	register_array_init(INTERRUPTKONFIG_REGNR) 			   <=	std_logic_vector(to_unsigned(0,C_SLV_DWIDTH));  	
	
	register_array_init(TREKANTSIGNAL_INKREMENT_REGNR) <= std_logic_vector(to_unsigned(CARRIER_INCREMENT_DEFAULT_VALUE,C_SLV_DWIDTH));  
	register_array_init(TREKANTSIGNAL_AMPLITUDE_REGNR) <= std_logic_vector(to_unsigned(AMPLITUDE_DEFAULT_VALUE,C_SLV_DWIDTH));		

		
			
	-- Skriving av External signals direkte i registrene.
	-- Skriver over referanseregistrene med eksterne verdier. 

	ref_in_load_array_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate 
			load(REF_REG_START_REGNR + n) <= ref_in_new(n) when (signalkildevelger_verdi_array(n) < NUMBER_OF_SIGNAL_SOURCES) else '0'; -- 1111 blokkerer oppdatering.	
			register_array_load(REF_REG_START_REGNR + n) <= std_logic_vector(resize(ref_in_array(signalkilde_nr_array(n),n),C_SLV_DWIDTH)); 

	end generate; 
	
	
	
  ------------------------------------------
	-- Kobler opp registre. 

	-- Skriving

	
	signalkildereg					<=	register_array_write(SIGNALKILDE_REGNR);	

	int_konfig_reg					<= register_array_write(INTERRUPTKONFIG_REGNR)(int_konfig_reg 'length -1 downto 0 );	
	
	
	
	int_divisor_reg		<= unsigned(register_array_write(INTERRUPT_DIVISOR_REGNR)(int_divisor_reg 'length -1 downto 0 ));

	


	ref_synk_kilde_reg			<=	register_array_write(REF_SYNK_KILDE_REGNR)(ref_synk_kilde_reg 'length -1 downto 0);
	
	hysterese 						<= signed(register_array_write(HYSTERESE_REGNR)(hysterese 'length -1 downto 0)); 
	
	
	inkrement 						<= resize(signed(register_array_write(TREKANTSIGNAL_INKREMENT_REGNR)),inkrement 'length);  

	trekant_amplitude				<= resize(unsigned(register_array_write(TREKANTSIGNAL_AMPLITUDE_REGNR)(WIDTH_IN-1 downto 0)),trekant_amplitude 'length); 	
	
	Skrivereg_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   		

	--	xxxref_reg_array(kanal)			<=	register_array_write(REF_REG_START_REGNR + kanal)(WIDTH_IN-1 downto 0); -- brukes ikke, register_array_write brukes som register direkte istedet.
		
		
		ref_buffer_array(kanal) <= signed(register_array_write(REF_REG_START_REGNR + kanal)(ref_buffer_array(kanal) 'length -1 downto 0));
	
	end generate;		
	
	Trekantreg_array_sammenkobling_generate : for t in 0 to NUMBER_OF_CARRIERS-1 generate 
		
		trekant_faseskift_array(t) 	<= signed(register_array_write(FASESKIFT_REG_START_REGNR + t)(trekant_faseskift_array(t) 'length -1 downto 0));
		
	end generate;		

		
		
	-- Lesing
	
	

	register_array_read(SIGNALKILDE_REGNR) 								<= signalkildereg_lese; 


--	register_array_read(REF_SYNK_KILDE_REGNR)(ref_synk_kilde_reg 'length -1 downto 0) 			<= ref_synk_kilde_reg when REF_SIGNALS_DIRECTLY_IN /= 1 else 
	--																						std_logic_vector(to_unsigned((1),ref_synk_kilde_reg 'length )); 

	register_array_read(REF_SYNK_KILDE_REGNR)(ref_synk_kilde_reg 'length -1 downto 0) 			<= ref_synk_kilde_reg; 
	
	register_array_read(INTERRUPTKONFIG_REGNR) 							<= std_logic_vector(resize(unsigned(int_konfig_reg),C_SLV_DWIDTH)); 
		
	register_array_read(INTERRUPT_DIVISOR_REGNR) 							<= std_logic_vector(resize(int_divisor_reg,C_SLV_DWIDTH)); 
	
	register_array_read(HYSTERESE_REGNR)									<= std_logic_vector(resize(hysterese,C_SLV_DWIDTH));

	register_array_read(TREKANTSIGNAL_AMPLITUDE_REGNR) 				<= std_logic_vector(resize(trekant_amplitude,C_SLV_DWIDTH));
	
	
	register_array_read(TREKANTSIGNAL_INKREMENT_REGNR) 				<= std_logic_vector(resize(inkrement,C_SLV_DWIDTH));




	
	Lesereg_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   	
	
		register_array_read(REF_REG_START_REGNR + kanal) 					<= std_logic_vector(resize(ref_array(kanal),C_SLV_DWIDTH)); 
		

		
   end generate;
	
	
	Lesereg_trekant_array_sammenkobling_generate : for trekant in 0 to NUMBER_OF_CARRIERS-1 generate   	

		register_array_read(TREKANT_REG_START_REGNR + trekant)			<= std_logic_vector(resize(trekant_array(trekant),C_SLV_DWIDTH)); -- Kun lesing.

		register_array_read(FASESKIFT_REG_START_REGNR + trekant)			<= std_logic_vector(resize(trekant_faseskift_array(trekant),C_SLV_DWIDTH));


	end generate;
	---------------------------------------------------------------


	-------------------------------------------------------------------
	-- Trekantsignalgenerator

	trekant_toppverdi_2x <= shift_left(trekant_amplitude(TREKANTBREDDE-1 downto 0),1); -- ganger med to. 

	synch_in_flagg <= synch_in;
	
	baseteller_heltall <= baseteller(TREKANTTELLER_BREDDE-1 downto CARRIER_COUNTER_FRACTIONAL_BITS) ;
	
	base_counter_out <=  std_logic_vector(baseteller(WIDTH_IN +1 + CARRIER_COUNTER_FRACTIONAL_BITS-1 downto CARRIER_COUNTER_FRACTIONAL_BITS)) ;
	
	Trekantsignal_baseteller_synk_prosess: process ( klokke) is
		begin
			if klokke 'event and klokke = '1' then
				if reset = '1' then
					baseteller  <= (others => '0');	
					baseteller_synkflagg  <= (others => '0');
					baseteller_nullflagg	<= '1';	
					baseteller_synkpuls  <= (others => '0');		
					synch_out_flagg <= '0';					
				else 
					synch_out_flagg <= '0';
					baseteller_nullflagg	<= '0';
					baseteller_synkflagg  <= (others => '0');
				
					baseteller <= baseteller + unsigned(inkrement);	-- frittløpende teller. 
					
					-- Synkflaggene settes høye når basetelleren er over faseskiftverdien for her kanal.
					for n in NUMBER_OF_CARRIERS-1 downto 0 loop
					
						if (baseteller_heltall >= unsigned (trekant_faseskift_array(n))) then
							baseteller_synkflagg(n) <= '1';					
						end if;
						
            	end loop;
					
				   -- Nullstiller baseteller.  
			
					if  baseteller_heltall  >= trekant_toppverdi_2x - shift_right(unsigned(hysterese),TREKANTBREDDE) 
						or (synch_in_flagg = '1') then 
						baseteller  <= (others => '0') ;		
						synch_out_flagg <= '1';
						baseteller_nullflagg	<= '1';
						baseteller_synkflagg  <= (others => '1');-- Tvangssetter fasesynksignalene til '1'. Sikrer dermed at det alltid kommer en flanke på synkflaggene til slutt selv om faseskiftet er for høyt.
					end if;
					
		         --Tvangssetter fasesynksignalene til'0' ved første klokkepuls etter nullstilling av baseteller. Sikrer dermed at det kommer en flanke på fasesynkpuls til slutt selv om faseskiftet er for lavt.  
					if baseteller_nullflagg = '1' then 
						baseteller_synkflagg  <= (others => '0');
					end if;	
					
					-- Genererer synkpulser.
					baseteller_synkpuls <= baseteller_synkflagg and not  baseteller_forrige_synkflagg; 
					baseteller_forrige_synkflagg <= baseteller_synkflagg;



				end if;
			end if;	
		end process;
														
		Trekantsgnaler_generate : for n in 0 to NUMBER_OF_CARRIERS-1 generate		
		
		trekant_array(n) <= resize(shift_right(trekantteller_array(n),CARRIER_COUNTER_FRACTIONAL_BITS),TREKANTBREDDE);  

		trekant_topp <=  shift_right(signed(trekant_amplitude),1);		
		trekant_bunn <= trekant_topp - signed(trekant_amplitude); -- Går bra, øverse bit i trekant_amplitude er alltid null.

		
		Trekantsignal_teller_prosess: process (klokke) is
			
			variable neste_teller : signed (TREKANTTELLER_BREDDE -1  downto 0);  			
			begin
				if klokke 'event and klokke = '1' then
					if reset = '1' then
						trekantteller_array(n) <= (others=>'0');
				--		trekant_topp_synkpuls(n)  <= '0';
				--		trekant_bunn_synkpuls(n) <= '0';
						trekant_retningsflagg(n)  <= '1';
					else
					
					--	trekant_topp_synkpuls(n) <= '0';
						
						neste_teller :=  trekantteller_array(n);
						
						if trekant_retningsflagg(n) = '1' then 
							neste_teller :=neste_teller + inkrement;
						else 
							neste_teller := neste_teller - inkrement;
						end if;						
						
						if shift_right(neste_teller,CARRIER_COUNTER_FRACTIONAL_BITS) >= trekant_topp then 
							trekant_retningsflagg(n) <= '0';	
						end if; 
						
						if shift_right(neste_teller,CARRIER_COUNTER_FRACTIONAL_BITS) > trekant_topp then 
							neste_teller := shift_left(resize(trekant_topp,TREKANTTELLER_BREDDE),CARRIER_COUNTER_FRACTIONAL_BITS);
						elsif shift_right(neste_teller, CARRIER_COUNTER_FRACTIONAL_BITS) < trekant_bunn then 				
							neste_teller := shift_left(resize(trekant_bunn,TREKANTTELLER_BREDDE),CARRIER_COUNTER_FRACTIONAL_BITS);							
						end if;
						
						if baseteller_synkpuls(n) = '1' then 
							neste_teller := shift_left(resize(trekant_bunn,TREKANTTELLER_BREDDE),CARRIER_COUNTER_FRACTIONAL_BITS);
							
							trekant_retningsflagg(n) <= '1';	
						end if;
						trekantteller_array(n) <= neste_teller;			
						
						forrige_trekant_retningsflagg(n) <= trekant_retningsflagg(n);
															
					end if;
				end if;
			end process;

			trekant_topp_synkpuls(n) <= not trekant_retningsflagg(n) and forrige_trekant_retningsflagg(n);	
			trekant_bunn_synkpuls(n) <= trekant_retningsflagg(n) and not forrige_trekant_retningsflagg(n);
	end generate;

	
		------------------------------------------------------
		-- Oppkobling av trekantsignaler ut.
	
	carrier_out_arraysammenkobling_generate : for kanal in 0 to NUMBER_OF_CARRIERS-1 generate   

		carrier_out(kanal * WIDTH_IN + WIDTH_IN-1 downto kanal * WIDTH_IN)	<= std_logic_vector(resize(trekant_array(kanal),WIDTH_IN));	
		
	end generate;
	
	-- Kobler opp diskrete signalutganger.
		
	
	carrier_outgangssignal_sammenkobling_generate_1 : for trekant in 0 to NUMBER_OF_CARRIERS-1 generate   	
	
		carrier_outgangssignal_sammenkobling_generate_2 : if  trekant < ANTALL_DISKRETE_UTGANGER generate		
		
			-- Setter ut verdier på de diskrete utgangene.  Må tas via et mellomtrinn, et array med flere kanaler for å unngå breddekluss. 
	
			carrier_out_mellomarray(trekant) <= std_logic_vector(resize(trekant_array(trekant),WIDTH_IN));
		
		end generate;

	

	
		
	end generate;	

	carrier_out_a <= carrier_out_mellomarray(0);
	carrier_out_b <= carrier_out_mellomarray(1);
	carrier_out_c <= carrier_out_mellomarray(2);

	
		
	----------------------------------------------------------
	-- Synkpulser og interruptsignal. 

	synkpulser <= baseteller_nullflagg & trekant_topp_synkpuls & trekant_bunn_synkpuls;		
			
	synch_out <= synkpulser;
	
	int_kildesignal <= '1' when  unsigned(synkpulser and int_konfig_reg) /= 0   else '0';	
	-- Interrupt divisor prosess, int signal ut frekvens er en brøkdel av int signal.
	intsignal_prosess : process(klokke) is		
		begin
			if (klokke 'event and klokke = '1') then
			
			int_kildesignal_g <= int_kildesignal;
				intsignal <= '0';
				if ( int_kildesignal = '1') and (int_kildesignal_g = '0') then -- flanke
					
					if int_divisor_teller < int_divisor_reg then 
						int_divisor_teller <= int_divisor_teller + 1;
					else 	
						int_divisor_teller	<= to_unsigned(1,int_divisor_teller 'length);
						intsignal <= '1';
					end if;
				end if;
			end if;
		end process;
		
	intr	<= intsignal;				

	

--------------------------------------------------------------	
	
	-- Sammenkobling av ref inn signaler. 
	ref_in_signalkilde_array_generate : for s in 0 to NUMBER_OF_SIGNAL_SOURCES-1 generate   
		ref_in_kanal_array_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate 
		
			ref_in_array(s,n) <= signed(ref_in( (s * NUMBER_OF_CHANNELS + n) * WIDTH_IN + WIDTH_IN -1 downto (s * NUMBER_OF_CHANNELS + n) * WIDTH_IN));
			
		end generate;
	end generate;
	
	--- inngangsmultiplekseren.
	
	ref_in_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   	
				
			
				
		signalkildevelger_array(kanal) <=  unsigned(signalkildereg(kanal * 4 + 3 downto kanal * 4)) when kanal < 8 else unsigned(signalkildereg(7 * 4 + 3 downto 7 * 4));   


		
		Signalkildereg_lese_generate : if kanal <  8 generate 			
		 	signalkildereg_lese(kanal * 4 + 3 downto kanal * 4) 	<= std_logic_vector(signalkildevelger_array(kanal));			
		end generate;

												end generate;
												ref_in_array_sammenkobling_generate_teste6 : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate  
	
	-- Her er det noe grufs. 
	
		signalkildevelger_verdi_array(kanal) <= to_integer( '0' & signalkildevelger_array(kanal)); -- Tvinger til unsigned.
												end generate;
												ref_in_array_sammenkobling_generate_teste : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   
		
		signalkilde_nr_array(kanal) <= signalkildevelger_verdi_array(kanal) when signalkildevelger_verdi_array(kanal) < NUMBER_OF_SIGNAL_SOURCES else 0;
--		signalkilde_nr_array(kanal) <= CONV_INTEGER(signalkildevelger_array(kanal)) when ( (CONV_INTEGER(signalkildevelger_array(kanal)) < NUMBER_OF_SIGNAL_SOURCES) or (CONV_INTEGER(signalkildevelger_array(kanal)) >= 0 )) else 0;


	end generate;

-- ref_in_array skrives til skrivereg.

	
-- Innlesing av referanse fra bufferregister.



	Ref_synk_buffer_register_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate 	
		

	
		ref_synk(kanal)  <= '1' when ((baseteller_nullflagg 
											& trekant_topp_synkpuls((NUMBER_OF_CARRIERS * kanal)/ NUMBER_OF_CHANNELS)
											& trekant_bunn_synkpuls((NUMBER_OF_CARRIERS * kanal )/ NUMBER_OF_CHANNELS)
											& ref_synch_in(kanal) 
											& '1')
												and unsigned(ref_synk_kilde_reg)) /= 0  else '0';

	
		Ref_synk_buffer_register_prosess : process(klokke) is		
			begin				
				if (klokke 'event and klokke = '1') then	
					if reset = '1' then
						ref_reg_array(kanal) <= (others => '0');
					else
												
						if ref_synk(kanal) = '1' then  
							ref_reg_array(kanal) <= ref_buffer_array(kanal);				
						end if;				
					end if;	
				end if;
			end process;			
			
	--	ref_array(kanal) <= ref_in_array(signalkilde_nr_array(kanal),kanal) when REF_SIGNALS_DIRECTLY_IN = 1	else   ref_reg_array(kanal); 
	ref_array(kanal) <=   ref_reg_array(kanal); 

			
		ref_out(kanal * WIDTH_IN + WIDTH_IN-1 downto kanal * WIDTH_IN)	<= std_logic_vector(resize(ref_array(kanal),WIDTH_IN));	
		
		mellomarraygenerate : if kanal < ANTALL_DISKRETE_UTGANGER generate
				ref_out_mellomarray(kanal) <= std_logic_vector(ref_array(kanal));
				
		end generate;
		
	end generate;	

	ref_out_a <= ref_out_mellomarray(0);
	ref_out_b <= ref_out_mellomarray(1);
	ref_out_c <= ref_out_mellomarray(2);	

	--------------------------------------------------------------------------
	
	-- pulse_width_modulatoren
	
	halv_hysterese <= shift_right(hysterese,1); 

	trekant_hysterese_generate : for t in 0 to NUMBER_OF_CARRIERS-1 generate 	
	
	-- Her fordeles trekantene til kanalene. 
		trekant_pluss_hysterese_array(t) <= trekant_array(t) + halv_hysterese;
		trekant_minus_hysterese_array(t) <= trekant_array(t) + halv_hysterese  - hysterese;
		
	end generate;
	
	Modulator_generate : for n in 0 to NUMBER_OF_CHANNELS-1 generate 	
		pulse_width_modulator_prosess : process(klokke) is
			begin
				if (klokke 'event and klokke = '1') then	
					if reset = '1' then
						pwm(n) <= '0';
					else 
						if resize(ref_array(n),TREKANTBREDDE) >  trekant_pluss_hysterese_array((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) then
							pwm(n) <= '1';
						end if;
						if resize(ref_array(n),TREKANTBREDDE) <= trekant_minus_hysterese_array((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) then
							pwm(n) <= '0';
						end if;
					end if;
				
				end if;
				
		end process;		
		
	--------------------------------

	trekant_negativ_generate : for t in 0 to NUMBER_OF_CARRIERS-1 generate 	
	
		trekant_negativ_array(t) <= 0 - trekant_array(t);
	end generate;
	
	faseskift_sett_h_komp(n)	<= '1' when 	(resize(ref_array(n),TREKANTBREDDE) <  trekant_array((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) ) else '0';
	faseskift_sett_l_komp(n)	<= '1' when 	(resize(ref_array(n),TREKANTBREDDE) <  trekant_negativ_array((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) ) else '0';

	faseskift_sett_h(n) 	<= '1' when (trekant_topp_synkpuls((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) = '1') or (faseskift_sett_h_komp(n) = '1' and 	trekant_retningsflagg((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) = '1') else '0';
	faseskift_sett_l(n) 	<= '1' when (trekant_bunn_synkpuls((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) = '1') or (faseskift_sett_l_komp(n) = '1' and 	trekant_retningsflagg((NUMBER_OF_CARRIERS * n )/ NUMBER_OF_CHANNELS) = '0') else '0';


	
	Faseskiftmodulator_flipflop_prosess : process(klokke) is
		begin
			if (klokke 'event and klokke = '1') then	
				if reset = '1' then
					faseskift(n) <= '0';
				else 
					if faseskift_sett_h(n)  = '1' then 
						faseskift(n) <= '1';
					end if;
					if faseskift_sett_l(n)  = '1' then		
						faseskift(n) <= '0';
					end if;
				end if;
				
			end if;
				
		end process;		
		
				
		
	end generate;
	

	---------------------		
	


	-- Oppkobling av PWM signaler ut. 	

	phase_shift_out <= faseskift;
	pwm_out 	<= pwm;
	

	
	---------------------------------------------------------------------------	
end IMP;
