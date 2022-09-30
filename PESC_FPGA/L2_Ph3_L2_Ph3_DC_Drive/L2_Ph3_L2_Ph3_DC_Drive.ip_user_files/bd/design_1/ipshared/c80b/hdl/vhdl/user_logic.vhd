--*****************************************************************************************
-- Incremental encoder interface
-- Interface for a two phase pulse encoder with zero track 
--
-- Author: Kjell Ljøkelsøy. Sintef Energi. 2009-2017
--

------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------


------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
	 

	EDGE_CLOCK_TIMEOUT_TIME 				: integer := 100; -- ms. -- Time when the edge clock stops, avoiding overflow, so zero speed can be detected properly.
	CONFIG_REG_DEFAULT_VALUE		: std_logic_vector   := X"00000000";   
	FILTER_HYSTERESIS_DEFAULT_VALUE		: std_logic_vector   := X"00000000";   

	 -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
	 C_S_AXI_ACLK_FREQ_HZ  : integer                    ;--   := 100_000_000;  	-- Hz. Clock frequency.  Value is updated automatically. 
	
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
	 
	 -- External signals
	ENCODER										: in std_logic_vector(2 downto 0);	--  bit2: B, bit 1: A, bit 0: Z.
	ENCODER_ERR								: in std_logic_vector(3 downto 0);	-- bit 3: felles, bit2: B, bit 1: A, bit 0: Z.
	LEDS									: out std_logic_vector(3 downto 0); -- bit 3:  Err(rød),  bit2: B, bit 1: A, bit 0: Z.
	
	-- Signals towards the FpgA fabric..
	encoder_counter_value 					: out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
	zero_capture_value						: out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
	edge_time								: out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
	edge_time_valid_flag  					: out std_logic; 		-- 1: zero pulse have been captured Valid data in zero capture signal
	
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
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

  --USER signal declarations added here, as needed for user logic
	
	--constant KLOKKEFREKVENS	: integer  := 100000000 ; --Hz. 
	-- constant pg_EDGE_CLOCK_TIMEOUT_TIME	: integer  := 100 ;-- Milisekunder. 
--	constant ZERO_PULSE_PATTERN : std_logic_vector (2 downto 0) := "111";  -- Signal B,A,Z.


    constant ZERO_PULSE_PATTERN             : std_logic := '1';
	constant pg_FILTERTELLEBREDDE		: integer  := 16 ;-- bit. 
	
	
	constant KLOKKEFREKVENS : integer  := C_S_AXI_ACLK_FREQ_HZ;

	constant NUM_REG 									: integer := 6;
	
	 constant PULSGIVER_STATUS_REGNR				: integer := 0;
	 constant PULSGIVER_OPPSETT_REGNR			: integer := 1;
	 constant PULSGIVER_FILTER_REGNR				: integer := 2;
	 constant PULSGIVER_POSISJON_REGNR			: integer := 3;
	 constant PULSGIVER_NULLREF_REGNR			: integer := 4;
	 constant PULSGIVER_FLANKETID_REGNR			: integer := 5;
	

	constant PULSGIVER_ERR_BREDDE					: integer := 4; 
	constant PULSGIVER_SIGNALER_BREDDE			: integer := 3;
	constant LED_BREDDE								: integer := 4;
	
	-- bit i statusreg
	
	constant PULSGIVER_ERR_START_BITNR			: integer := 16;
	constant PULSGIVER_SIGNALER_START_BITNR	: integer := 8;
	constant FLANKEKLOKKE_HAR_STOPPET_BITNR	: integer := 4;
	constant HAR_FANGET_NULL_FLAGG_BITNR		: integer := 1;
	
	constant FRYSE_BITNR 							: integer := 0;	-- eneste skrivbare bit i statusreg.
	
	-- bit i oppsettreg.
	
	
	constant LED_START_BITNR						: integer := 16;	
	constant LED_FUNKSJON_BITNR					: integer := 9; -- 1: pulsgiversignaler 0:- registerverdier.
	constant DREIERETNING_BITNR					: integer := 8;
	constant RESET_FANGET_NULL_FLAGG_BITNR		: integer := 1;
	constant RESET_TELLERE_BITNR					: integer := 0;


--   bit i pulssignal
	constant P_NULL						  : integer := 0;	
	constant P_A						  : integer := 1;	
	constant P_B						  : integer := 2;	
	
	signal klokke  : std_logic := '0';
	signal reset_h : std_logic := '1';


	signal pg_led_s 						: std_logic_vector(3 downto 0) := (others=> '0');

	signal pg_s_inn							: std_logic_vector(2 downto 0):= (others=> '0');
	signal pg_m								: std_logic_vector(2 downto 0):= (others=> '0');
	signal pg_m2								: std_logic_vector(2 downto 0):= (others=> '0');
	signal pg_s 								: std_logic_vector(2 downto 0):= (others=> '0');
	signal ENCODER_ERR_s 							: std_logic_vector(3 downto 0):= (others=> '0');
	signal pg_filt 							: std_logic_vector(2 downto 0):= (others=> '0');
	signal forrige_pg_filt 					: std_logic_vector(2 downto 0):= (others=> '0');

	
	signal pg_filter_topp					: unsigned(pg_FILTERTELLEBREDDE-1 downto 0):= (others=> '0');
	
	type 	filtertellerarraytype 		is array (3-1 downto 0 ) of  unsigned(pg_FILTERTELLEBREDDE-1 downto 0);
	
	signal filtertellerarray 				: filtertellerarraytype := (others => (others=> '0'));
	
	


	signal pg_pos_teller 					: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_pos_null						: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_flankeklokke					: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_flanketid_diff				: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_flanketid						: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_pos_teller_reg 				: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_pos_null_reg					: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_flanketid_reg					: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');

	signal pg_telle							: std_logic := '0';
	signal pg_telle_retning					: std_logic := '0';
	signal pg_forrige_telle_retning		: std_logic := '0';
	signal pg_fange_null						: std_logic := '0';
	signal pg_fryse							: std_logic := '0';
	signal pg_dreieretning					: std_logic := '0';
	signal pg_har_fanget_null_flagg		: std_logic := '0';
	signal pg_flankeklokke_stoppet_flagg : std_logic := '0';

	signal pg_reset_fanget_null_flagg	: std_logic := '0';
	signal pg_reset_flagg					: std_logic := '0';

	signal pg_led_funksjon					: std_logic := '0';    
	signal pg_led_skriveverdi				: std_logic_vector(3 downto 0) := (others=> '0');    

	signal pg_nullverdi_reg					: unsigned(C_SLV_DWIDTH-1 downto 0):= (others=> '0');

	signal pg_oppsett							: std_logic_vector(C_SLV_DWIDTH-1 downto 0):= (others=> '0');
	signal pg_oppsett_les					: std_logic_vector(C_SLV_DWIDTH-1 downto 0):= (others=> '0');

	signal pg_status							: std_logic_vector(C_SLV_DWIDTH-1 downto 0):= (others=> '0');

		
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
  		
--	assert ( ANTALL_DRIVERE_PR_FASE = 2)
--		report "#### ANTALL_DRIVERE_PR_FASE er forskjellig fra 2"
--		severity failure;

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
	 
-- Setter initialverdier i registre.
			register_array_init(PULSGIVER_OPPSETT_REGNR)  <= CONFIG_REG_DEFAULT_VALUE;
			register_array_init(PULSGIVER_FILTER_REGNR)  <= FILTER_HYSTERESIS_DEFAULT_VALUE;
			
	
	
		
	klokke <= Bus2IP_Clk;
   reset_h <= '1' when Bus2IP_Resetn = '0' else '0';

	
	-- Kobler opp registre. 

	-- Skriving

	pg_fryse 							<= register_array_write(PULSGIVER_STATUS_REGNR)(FRYSE_BITNR);	--  Eneste skrivbare bit i statusreg. Kan dermed sette frysbittet uten å lese resten av bittene først. 
	
	pg_oppsett 							<= register_array_write(PULSGIVER_OPPSETT_REGNR);	
	pg_filter_topp						<= unsigned(register_array_write(PULSGIVER_FILTER_REGNR)(pg_FILTERTELLEBREDDE-1 downto 0));	   

	
	-- Lesing
		
	register_array_read(PULSGIVER_STATUS_REGNR) 					<= pg_status;
	register_array_read(PULSGIVER_OPPSETT_REGNR) 				<= pg_oppsett_les;
	register_array_read(PULSGIVER_FILTER_REGNR) 					<= std_logic_vector(resize(pg_filter_topp,C_SLV_DWIDTH));
	register_array_read(PULSGIVER_POSISJON_REGNR) 				<= std_logic_vector(pg_pos_teller_reg);
	register_array_read(PULSGIVER_NULLREF_REGNR) 				<= std_logic_vector(pg_pos_null_reg);
	register_array_read(PULSGIVER_FLANKETID_REGNR) 				<= std_logic_vector(pg_flanketid_reg);	
	

	
	---------------------------------------------------------------



	pg_status(FRYSE_BITNR) 									<= pg_fryse;
	pg_status(PULSGIVER_ERR_BREDDE + PULSGIVER_ERR_START_BITNR-1 downto PULSGIVER_ERR_START_BITNR)		<= ENCODER_ERR_s;
	pg_status(PULSGIVER_SIGNALER_BREDDE + PULSGIVER_SIGNALER_START_BITNR -1 downto PULSGIVER_SIGNALER_START_BITNR) 		<= pg_s; 
	pg_status(FLANKEKLOKKE_HAR_STOPPET_BITNR)					<= pg_flankeklokke_stoppet_flagg;
	pg_status(HAR_FANGET_NULL_FLAGG_BITNR) 					<= pg_har_fanget_null_flagg;

	


	
	pg_led_skriveverdi 			<= pg_oppsett(LED_BREDDE + LED_START_BITNR-1 downto LED_START_BITNR);
	pg_led_funksjon 	 			<= pg_oppsett(LED_FUNKSJON_BITNR);
	pg_dreieretning				<=	pg_oppsett(DREIERETNING_BITNR);
	pg_reset_fanget_null_flagg <=	pg_oppsett(RESET_FANGET_NULL_FLAGG_BITNR);
	pg_reset_flagg 				<=	pg_oppsett(RESET_TELLERE_BITNR);
	



	pg_oppsett_les(LED_BREDDE + LED_START_BITNR-1 downto LED_START_BITNR)	<= pg_led_skriveverdi;
	pg_oppsett_les(LED_FUNKSJON_BITNR)				<= pg_led_funksjon;	
	pg_oppsett_les(DREIERETNING_BITNR)				<= pg_dreieretning;
	pg_oppsett_les(RESET_FANGET_NULL_FLAGG_BITNR)	<= pg_reset_fanget_null_flagg;
	pg_oppsett_les(RESET_TELLERE_BITNR)				<= pg_reset_flagg;



	encoder_counter_value 					<= std_logic_vector(pg_pos_teller);
	zero_capture_value						<= std_logic_vector(pg_pos_null);
	edge_time					<=	std_logic_vector(pg_flanketid);
	edge_time_valid_flag 	<= pg_har_fanget_null_flagg; 
	
	pg_s_inn <= ENCODER;
	ENCODER_ERR_s <= ENCODER_ERR;
	LEDS <=	pg_led_s;

	--pg_led_s <= ENCODER_ERR_s(3) & pg_s  when (pg_led_funksjon = '1') else 	pg_led_skriveverdi;
	pg_led_s <= ENCODER_ERR_s(3) & pg_filt  when (pg_led_funksjon = '1') else 	pg_led_skriveverdi;


	
	-- Lavpassfiltrerer pulsene ved hjelp av tellere.
--	 pg_filt <= pg_s;

	pg_signalsynkprosess : process(klokke)	--  Bufing i et par ekstra registertrinn. Fjerner evt. metastabilitet. 
		begin
			if (klokke 'event and klokke = '1') then		
				pg_m <= pg_s_inn; 
				pg_m2 <= pg_m;
				pg_s <= pg_m2;					
			end if;
		end process;	
			
	pg_filterprosess : process(klokke)
		begin
			if (klokke 'event and klokke = '1') then	
				if	(reset_h = '1') then
				filtertellerarray <= (others => (others=> '0'));
		
					pg_filt <= (others => '0');				
				else

	
					filtertellerarray_generate : for n	in 2 downto 0 loop 
					
						if (pg_s(n) = '0') then
							if (filtertellerarray(n) = 0) then
								pg_filt(n) <= '0';
							else 
								filtertellerarray(n) <= filtertellerarray(n) - 1;
							end if;
						else 
							if (filtertellerarray(n) >= pg_filter_topp) then
								pg_filt(n) <= '1';
							else 
								filtertellerarray(n) <= filtertellerarray(n) + 1;
							end if;						
						end if;	
						
					end loop;
				end if;		
			 end if;		
		end process;



	-- Flankedetektering.
	
	pg_flankeprosess	: process(klokke)
		begin
			if (klokke 'event and klokke = '1') then
				if	(reset_h = '1') then
					pg_telle <= '0';
					pg_telle_retning <= '0';
					pg_fange_null <= '0';
					forrige_pg_filt <= pg_filt;
				else
					pg_telle <= '0';
					pg_telle_retning <= '0';				
					pg_fange_null <= '0';
					forrige_pg_filt <= pg_filt;
					
				--	if ((pg_filt = ZERO_PULSE_PATTERN) and (not (forrige_pg_filt = ZERO_PULSE_PATTERN)))  then
					if ((pg_filt(P_NULL) = ZERO_PULSE_PATTERN) and (not (forrige_pg_filt(P_NULL) = ZERO_PULSE_PATTERN)))  then			 				
							pg_fange_null <= '1'; -- Denne slingrer en bit når dreieretiningen skifter. Burde vært låst til en av flankene.					
					end if;					
					
					-- flankedetektering. flanke skifter. Ser om det er samme eller forskjellig verdi på de to fasene etter skifting. 
					--if (((pg_filt(1) = (not  forrige_pg_filt(1))) and ( pg_filt(1) = (not pg_filt(2)))) or ((pg_filt(2) = (not  forrige_pg_filt(2))) and ( pg_filt(1) = (    pg_filt(2))))) then
					if (((pg_filt(P_A) = (not  forrige_pg_filt(P_A))) and ( pg_filt(P_A) = (not pg_filt(P_B)))) or ((pg_filt(P_B) = (not  forrige_pg_filt(P_B))) and ( pg_filt(P_A) = (    pg_filt(P_B))))) then

							pg_telle <= '1';						
							if (pg_dreieretning = '0')  then
								pg_telle_retning <= '1';	
							else 
								pg_telle_retning <= '0';				
							end if;
					end if;
					if (((pg_filt(1) = (not  forrige_pg_filt(1))) and ( pg_filt(1) = ( pg_filt(2)))) or ((pg_filt(2) = (not  forrige_pg_filt(2))) and ( pg_filt(1) = (not pg_filt(2)))))	then			
						pg_telle <= '1';
						if (pg_dreieretning = '0')  then
							pg_telle_retning <= '0';	
						else 
							pg_telle_retning <= '1';				
						end if;
					end if;	
				end if;
			end if;	
		end process;
		
		
	pg_flanketid_diff <=  pg_flankeklokke - pg_flanketid;

	-- Tellere. 	
	pg_pulstelleprosess	: process(klokke)
		begin
			if (klokke 'event and klokke = '1') then		
				if	(reset_h = '1') then
					pg_pos_teller 						<= (others => '0');
					pg_pos_null 						<= (others => '0');
					pg_flankeklokke					<= to_unsigned ( (EDGE_CLOCK_TIMEOUT_TIME * (KLOKKEFREKVENS/1000)),pg_flankeklokke 'length );	-- Starter meed stoppverdien, som indiker lang tid. når føste pulsen kommer. 
					pg_flanketid						<= (others => '1');	
					pg_pos_teller_reg 				<= (others => '0');
					pg_pos_null_reg 					<= (others => '0');
					pg_flanketid_reg					<= (others => '1');	
					pg_har_fanget_null_flagg 		<= '0';
					pg_flankeklokke_stoppet_flagg <= '1';
					pg_forrige_telle_retning <= '0';
				else
				
					if ( pg_flanketid_diff < to_unsigned ( (EDGE_CLOCK_TIMEOUT_TIME * (KLOKKEFREKVENS/1000) ),pg_flanketid_diff 'length )) then 
						-- Ikke lenge siden siste puls. Flankeklokka stoppes når det har gått lang tid.
						pg_flankeklokke <= pg_flankeklokke +1; 
						pg_flankeklokke_stoppet_flagg <= '0';
					else 
						pg_flankeklokke_stoppet_flagg <= '1';
					end if;				
					
					if (pg_telle = '1') then 
						if pg_telle_retning	= '1' then 					
							pg_pos_teller <= pg_pos_teller + 1;					
						else 
							pg_pos_teller 		<= pg_pos_teller -1 ;
						end if;
						
						-- Leser av flankeklokke kun når teller ikke endrer retning. Undertrykker dermed feil turtallsmåling når pulsgiveren vakler mellom to posisjoner.
						pg_forrige_telle_retning <= pg_telle_retning;
						if pg_telle_retning = pg_forrige_telle_retning then
							pg_flanketid 		<= pg_flankeklokke;
						end if;
					end if;


					 
					if (pg_fange_null = '1') then
						pg_pos_null			<= pg_pos_teller;
						pg_har_fanget_null_flagg <= '1';

						
					end if;

						-- nullstilling av tellere i drift. 
					if (pg_reset_fanget_null_flagg = '1') then				
						pg_pos_null 		<= (others => '0');
						pg_har_fanget_null_flagg <= '0';

					end if; 
					
					if (pg_reset_flagg = '1') then
						pg_pos_teller 		<= (others => '0');
						pg_pos_null 		<= (others => '0');
						pg_flankeklokke	<= to_unsigned ( (EDGE_CLOCK_TIMEOUT_TIME * (KLOKKEFREKVENS/1000)),pg_flankeklokke 'length );
						pg_flanketid		<= (others => '1');
						pg_har_fanget_null_flagg <= '0';

					end if;
					
						
					-- kopierer til leseregistrene.
					if (pg_fryse = '0') then
						pg_pos_teller_reg <= pg_pos_teller;
						pg_pos_null_reg 	<= pg_pos_null;
						pg_flanketid_reg 	<= pg_flanketid; 
					end if;
				end if;
			end if;		
		end process;	
					
 


end IMP;
