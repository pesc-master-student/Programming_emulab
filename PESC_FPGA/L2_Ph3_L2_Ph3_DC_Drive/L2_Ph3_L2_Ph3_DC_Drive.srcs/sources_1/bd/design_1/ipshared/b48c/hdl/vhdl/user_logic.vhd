--***************************************************************************
-- comparator_limiter_block.
--
-- Skrevet av: Kjell Ljøkelsøy. Sintef Energi. 2009

------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;




--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;



entity user_logic is
  generic
  (
  
	 
	WIDTH_IN 								: integer           					:= 12;	
	WIDTH_OUT 								: integer           					:= 12;	
	
  	NUMBER_OF_CHANNELS						: integer								:= 1;  	
	NUMBER_OF_COMPARATORS					: integer								:= 2; 	-- Number of comparators per channel.
	
	FLIPFLOP_DEFAULT_VALUE					: std_logic								:= '0';	


	COMPARATOR_FUNCTION_GREATER_THAN		: std_logic_vector(31 downto 0)	:= X"00000002";  -- One bit pr comparator. Filler &  k3 & k2 &  k1 % k0  Set flag when condition is present. 
	COMPARATOR_FUNCTION_LESS_THAN			: std_logic_vector(31 downto 0)	:= X"00000001";  -- One bit pr comparator. Filler &  k3 & k2 &  k1 % k0  Set flag when condition is present.  
	COMPARATOR_FUNCTION_EQUAL				: std_logic_vector(31 downto 0)	:= X"00000002";  -- One bit pr comparator. Filler &  k3 & k2 &  k1 % k0  Set flag when condition is present. 

	REGISTER_SET_MASK						: std_logic_vector(31 downto 0)	:= X"00000002";   	-- One bit pr comparator. Filler +  k3,k2,k1,k0  Set flag when condition is present. 
	REGISTER_CLEAR_MASK						: std_logic_vector(31 downto 0)	:= X"00000001"; 	-- One bit pr comparator. Filler +  k3,k2,k1,k0  Set flag when condition is present.   
	
	READ_CLIPPED_SIGNALS					: integer range 1 downto 0			:= 1;		-- 0: Not readable 1: Clipped signals available for read by processor bus
	
	READ_REFERENCES							: integer range 1 downto 0			:= 1;		-- 0: Not readable references (used for external references) 1: Readable references.
   
	REFERENCE_SELECTOR						: integer range 1 downto 0			:= 0; 	-- 0: Internal references from registers. 1: External reference signals.
	SEPARATE_REFERENCES						: integer range 1 downto 0			:= 0; 	-- 0: Common references for all channels.  1: Separate references.
	
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
	C_SLV_DWIDTH                  : integer        				      := 32;
	C_SLV_AWIDTH                 : integer                       	:= 32	
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
	 
	signal_in						      	: in std_logic_vector (NUMBER_OF_CHANNELS * WIDTH_IN -1 downto 0); -- c &b & a 
	reference_in					      		: in std_logic_vector (NUMBER_OF_COMPARATORS * NUMBER_OF_CHANNELS * WIDTH_IN -1 downto 0) := (others => '0'); --  c2 & b2 & a2  
	 						
	comparator_out						      	: out std_logic_vector (NUMBER_OF_COMPARATORS * NUMBER_OF_CHANNELS  -1 downto 0);

	set_flipflop_in				      	: in  std_logic_vector (NUMBER_OF_CHANNELS  -1 downto 0) := (others => '0');
	clear_flipflop_in			      	: in std_logic_vector (NUMBER_OF_CHANNELS  -1 downto 0) := (others => '0');

	flipflop_out						      	: out std_logic_vector (NUMBER_OF_CHANNELS  -1 downto 0);

	signal_out						      	: out std_logic_vector (NUMBER_OF_CHANNELS * WIDTH_OUT -1 downto 0);	

	signal_out_a						   : out std_logic_vector (WIDTH_OUT -1 downto 0);	
	signal_out_b						   : out std_logic_vector (WIDTH_OUT -1 downto 0);	
	signal_out_c						   : out std_logic_vector (WIDTH_OUT -1 downto 0);	
	signal_out_d						   : out std_logic_vector (WIDTH_OUT -1 downto 0);	

	new_in								: in std_logic := '1';			-- Valid signals in. Only used for flipflops, not for comparators or clipping. 
	new_out								: out std_logic := '1';			-- Valid signals out. NB! Flipflop signals are delayed, one clock pulse later than new_out. 
	   
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

--  	-- Inngangssignalkonfigurering.  
	

	constant SEPARAT_REF								: integer := 1;
	
	
	constant ER_LESBAR								: integer := 1;
	
	constant REGISTER_REF							: integer := 0;

  -- Registernummer 

	constant FLIPFLOP_REGNR 						: integer := 0;		-- c, b, a
	constant KOMPARATOR_REGNR 						: integer := 1;		-- c2, b2, a2, c1, b1, a1, c0, b0, a0

	constant REGARRAY_STARTREGNR 					: integer := 2;
	constant REGISTERBLOKKAVSTAND 				: integer := NUMBER_OF_CHANNELS; 	
	constant NUM_REG 								: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * (1 + NUMBER_OF_COMPARATORS);	
	
	constant BEGRENSER_UT_START_REGNR 			: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 0; -- Leser utgangssignal, Skriving hit skriver rett til integratoren. 
	constant REF_REG_START_REGNR 					: integer := REGARRAY_STARTREGNR + REGISTERBLOKKAVSTAND * 1 ; -- Leser utgangssignal, Skriving hit skriver rett til integratoren.

	constant ANTALL_DISKRETE_UT_KANALER			: integer := 4;
	
	-- Bit i konfigreg. Må manuelt passe på at det er tilstrekkelig avstand mellom blokkene her.




	signal klokke 									: std_logic := '0';  
	signal reset 									: std_logic := '1';  

--	type 	registerarraytype 					is array (C_NUM_REG-1 downto 0 ) of  std_logic_vector(C_SLV_DWIDTH-1 downto 0);

	--signal lesereg 									: registerarraytype 	:= (others => (others => '0'));
	-- signal skrivereg 									: registerarraytype 	:= (others => (others => '0'));
	
	type 	signal_array_type 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(WIDTH_IN-1 downto 0);
	signal signal_in_array 					: signal_array_type := (others => (others => '0'));	

	type 	signal_out_array_type 				is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  signed(WIDTH_OUT-1 downto 0);
	type 	signal_out_mellomarray_type 		is array (ANTALL_DISKRETE_UT_KANALER-1 downto 0 ) of  signed(WIDTH_OUT-1 downto 0);
	signal signal_out_mellomarray 				: signal_out_mellomarray_type := (others => (others => '0'));
	signal begrenser_ut_array 					: signal_out_array_type := (others => (others => '0'));
	
	type referanse_kanal_array_type 			is array (NUMBER_OF_COMPARATORS -1 downto 0 ) of  signed(WIDTH_IN-1 downto 0);
	type referanse_array_type 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  referanse_kanal_array_type;
	
	signal referanse_array_inn						: referanse_array_type := (others =>(others => (others => '0'))); --:= (others => (others => '0'));
	signal referanse_array_reg						: referanse_array_type := (others =>(others => (others => '0')));
	signal referanse_array 							: referanse_array_type := (others =>(others => (others => '0')));

	
	type komparator_resultat_array_type			is array(NUMBER_OF_CHANNELS -1 downto 0 ) of  std_logic_vector (NUMBER_OF_COMPARATORS -1  downto 0);	
	signal komparator_resultat_array				: komparator_resultat_array_type := (others => (others => '0')); 

	signal reg_settflagg								: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0 );
	signal reg_resetflagg							: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0 );
 

	signal flipflop									: std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0 ) := (others => FLIPFLOP_DEFAULT_VALUE);
	signal komparator_resultat						: std_logic_vector(NUMBER_OF_COMPARATORS * NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');

	signal ny_komp_ut									: std_logic := '1'; 


	
	
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
	--	signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

	--	signal load 					: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
		

	--====================================================================
		
begin
--   
	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;

	assert ((REFERENCE_SELECTOR /=  REGISTER_REF) or (READ_REFERENCES = ER_LESBAR))
		report "#### READ_REFERENCES must be enabled when REFERENCE_SELECTOR is set to registers."
		severity failure;

-- Dette er helt feil. Rett opp.
 --	assert ( C_SLV_DWIDTH >= NUMBER_OF_CHANNELS * NUMBER_OF_COMPARATORS)
--		report "#### NUMBER_OF_CHANNELS * NUMBER_OF_COMPARATORS greater than C_SLV_DWIDTH"
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
				
					for f in 0 to NUMBER_OF_CHANNELS-1 loop
						if ny_komp_ut = '1' then
							if (reg_settflagg(f) = '1') or (set_flipflop_in(f) = '1') then 
								register_array_write(FLIPFLOP_REGNR)(f) <= '1'; 
							elsif reg_resetflagg(f) = '1' or (clear_flipflop_in(f) = '1') then 						
								register_array_write(FLIPFLOP_REGNR)(f) <= '0'; 							
							end if;						
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
   reset <= '1' when Bus2IP_Resetn = '0' else '0';

	-- Ny-signal prosess.
	-- NB! Registersignalet er forsinket ett trinn mer enn dette. 
	
	new_out <= ny_komp_ut;
	
	ny_signal_prosess: process (klokke)
		begin
			if klokke 'event and klokke = '1' then 
				ny_komp_ut <= new_in;
			end if;
		
		end process;



  ------------------------------------------
	-- Kobler opp registre. 
	
	register_array_init(FLIPFLOP_REGNR)(NUMBER_OF_CHANNELS-1 downto 0) <=  (others => FLIPFLOP_DEFAULT_VALUE); 
	
	flipflop <= register_array_write(FLIPFLOP_REGNR)(NUMBER_OF_CHANNELS-1 downto 0); -- bruker registerarrayet som flipflopper.
	
	register_array_read(FLIPFLOP_REGNR)								<= std_logic_vector(resize(unsigned(flipflop),C_SLV_DWIDTH));
	register_array_read(KOMPARATOR_REGNR)							<= std_logic_vector(resize(unsigned(komparator_resultat),C_SLV_DWIDTH));
	

	Ref_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   	
	
	register_array_read(BEGRENSER_UT_START_REGNR + kanal)		<= std_logic_vector(resize(begrenser_ut_array(kanal),C_SLV_DWIDTH)) when (READ_CLIPPED_SIGNALS = ER_LESBAR);

		-- Oppkobling av referanseregistre.	
		Ref_komp_array_sammenkobling_generate :	for komp in 0 to NUMBER_OF_COMPARATORS-1 generate
		
			referanse_array_reg(kanal)(komp)		<=	signed(register_array_write(REF_REG_START_REGNR + NUMBER_OF_COMPARATORS * kanal + komp)(WIDTH_IN-1 downto 0)) when SEPARATE_REFERENCES = SEPARAT_REF
														else 	signed(register_array_write(REF_REG_START_REGNR + NUMBER_OF_COMPARATORS * 0 + komp)(WIDTH_IN-1 downto 0));
														
			referanse_array_inn(kanal)(komp)		<= signed(reference_in( (kanal * NUMBER_OF_COMPARATORS + komp) * WIDTH_IN + WIDTH_IN-1 downto (kanal * NUMBER_OF_COMPARATORS + komp) * WIDTH_IN));  			
			
			register_array_read(REF_REG_START_REGNR + NUMBER_OF_COMPARATORS * kanal + komp ) <= std_logic_vector(resize( referanse_array(kanal)(komp),C_SLV_DWIDTH)) when ((READ_REFERENCES = ER_LESBAR) and ((SEPARATE_REFERENCES = SEPARAT_REF) or (kanal = 0))) ; 
		
		end generate; 

	
	end generate;		
	
	-- Velger kilde for referansesignalene.	
	
	referanse_array <= referanse_array_reg when (REFERENCE_SELECTOR = REGISTER_REF) else referanse_array_inn;

	---------------------------------------------
	-- Sammenkobling av signaler inn og ut. 
	
	--	
	signal_in_array_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   	
	
		signal_in_array(kanal) <= signed(signal_in (kanal * WIDTH_IN + WIDTH_IN-1 downto kanal * WIDTH_IN));  -- Denne skrives rett i register_array_write. 
		
		komparator_resultat(kanal * NUMBER_OF_COMPARATORS + NUMBER_OF_COMPARATORS-1 downto kanal * NUMBER_OF_COMPARATORS) <= std_logic_vector(komparator_resultat_array(kanal));

	end generate;
	
	------------------------------------------------------
		-- Oppkobling av signaler ut.
	
	signal_out_arraysammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   

		-- Samlesignal ut. 
		signal_out(kanal * WIDTH_OUT + WIDTH_OUT-1 downto kanal * WIDTH_OUT)	<= std_logic_vector(begrenser_ut_array(kanal));	
		
		-- Setter ut verdier på de diskrete utgangene.  Må tas via et mellomtrinn, et array med flere kanaler for å unngå breddekluss. 
		signal_out_mellomarraysammenkobling_generate : if kanal < ANTALL_DISKRETE_UT_KANALER generate
		
			signal_out_mellomarray(kanal) <= begrenser_ut_array(kanal);
			
		end generate;		
	end generate;
	
	-- Kobler opp diskrete signalutganger.

	signal_out_a <= std_logic_vector(signal_out_mellomarray(0));
	signal_out_b <= std_logic_vector(signal_out_mellomarray(1));
	signal_out_c <= std_logic_vector(signal_out_mellomarray(2));
	signal_out_d <= std_logic_vector(signal_out_mellomarray(3));
	
	--- 
	
	Sett_resettflagg_generate :   for kanal in 0 to NUMBER_OF_CHANNELS-1 generate  
		reg_settflagg(kanal) <= '0' when unsigned(komparator_resultat_array(kanal)	 and REGISTER_SET_MASK(NUMBER_OF_COMPARATORS-1 downto 0)) = 0 else '1'; 
		reg_resetflagg(kanal) <= '0' when unsigned(komparator_resultat_array(kanal) and REGISTER_CLEAR_MASK(NUMBER_OF_COMPARATORS-1 downto 0)) = 0 else '1'; 


	end generate;
	
	flipflop_out <= flipflop; 
	comparator_out <= komparator_resultat;
	--------------------------------------------------------------------------
	
	
	-- Komparatorene.
	
	Komparatorarray_generate : for kanal in NUMBER_OF_CHANNELS-1 downto 0 generate   
	

			komparatorprosess: process (klokke)
			begin
				if klokke 'event and klokke = '1' then 
					
					komparator_resultat_array(kanal)	<= (others =>'0'); 
					if WIDTH_OUT <= WIDTH_IN then 
						begrenser_ut_array(kanal) <= signal_in_array(kanal)(WIDTH_OUT-1 downto 0);
					else
						begrenser_ut_array(kanal) <= resize(signal_in_array(kanal),WIDTH_OUT);
					end if;
					Komparatorarray_pr_kanal_loop : for komp in 0 to NUMBER_OF_COMPARATORS-1 loop   
						
						if ( (((COMPARATOR_FUNCTION_GREATER_THAN(komp) = '1') and (COMPARATOR_FUNCTION_LESS_THAN(komp) = '1')) and (signal_in_array(kanal) /= referanse_array(kanal)(komp)))
							or ((COMPARATOR_FUNCTION_GREATER_THAN(komp) = '1') and  (signal_in_array(kanal) > referanse_array(kanal)(komp)))   
							or ((COMPARATOR_FUNCTION_LESS_THAN(komp) = '1') and  (signal_in_array(kanal) < referanse_array(kanal)(komp))) 
							or ((COMPARATOR_FUNCTION_EQUAL(komp) = '1') and (signal_in_array(kanal) = referanse_array(kanal)(komp)))) then  
								if WIDTH_OUT <= WIDTH_IN then 
									begrenser_ut_array(kanal) <= referanse_array(kanal)(komp)(WIDTH_OUT-1 downto 0);
								else
									begrenser_ut_array(kanal) <= resize(referanse_array(kanal)(komp),WIDTH_OUT);
								end if;	
								komparator_resultat_array(kanal)(komp) <= '1';
								
							end if;
									
					end loop;		
					end if;	
				end process;

	end generate;
	---------------------		
	
	
	
	

	---------------------------------------------------------------------------	
end IMP;
