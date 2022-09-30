------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;


Library UNISIM;
use UNISIM.vcomponents.all;



entity signal_operasjon_blokk is
  generic
  (
	FUNKSJON								: integer range 0 to 2 := 0; -- 0: Sum/differanse. 1:Sum/differanse via register. 2: Multiplikasjon.
	FORTEGN								: integer range 0 to 1 := 0; 	-- 0: ikke fortegn 1: fortegn
	ANTALL_INN							   : integer := 2;					-- Må være 2 signaler inn ved multiplikasjon.
	BREDDE_INN               	: integer := 16;
	BREDDE_UT                	: integer := 16					-- BREDDE_UT bør være såpass mye større enn BREDDE_INN at en ikke får overflyt.	
  );
  port
	(
	pluss_minus							: in std_logic_vector(ANTALL_INN-1 downto 0) :=(others => '0'); --  Signalet skal: 0: Adderes.  1: Subtraheres. Syntaks: "0" & "0"
	inn 									: in std_logic_vector (ANTALL_INN * BREDDE_INN -1 downto 0) := (others =>'0');  -- "inn_b & inn_a"  Array av inngangssignaler
	ut 									: out std_logic_vector (BREDDE_UT -1 downto 0) := (others =>'0');
	inn_ny								: in  std_logic := '1';	
	ut_ny									: out std_logic := '0';
	klokke								: in  std_logic := '0';
	reset_h								: in  std_logic := '0'
  );


	attribute SIGIS : string;
	attribute SIGIS of klokke    : signal is "CLK";
	attribute SIGIS of reset_h  : signal is "RST";

end entity signal_operasjon_blokk;

architecture IMP of signal_operasjon_blokk is

	constant  SUM_DIFFERANSE_FUNKSJON						: integer := 0;
	constant  SUM_DIFFERANSE_FUNKSJON_MED_REGISTER		: integer := 1;
	constant  GANGE_FUNKSJON									: integer := 2;

	constant  NY_SKIFTEREGISTER_LENGDE :	integer := 2;

	constant DSP48E_A_BREDDE						: integer := 30;
	constant DSP48E_B_BREDDE						: integer := 18;
	constant DSP48E_PRODUKT_BREDDE				: integer := 48;

	signal dsp48e_A_inn 						: std_logic_vector (DSP48E_A_BREDDE-1 downto 0) := (others => '0');
	signal dsp48e_B_inn 						: std_logic_vector (DSP48E_B_BREDDE-1 downto 0) := (others => '0');
	signal dsp48e_produkt					: std_logic_vector (DSP48E_PRODUKT_BREDDE-1 downto 0) := (others => '0');

	signal reset 					: std_logic := '0';
	signal ny_skifterergister 	: std_logic_vector( NY_SKIFTEREGISTER_LENGDE-1 downto 0) := (others => '0');

	type inn_array_type is array( ANTALL_INN -1 downto 0)  of  std_logic_vector (BREDDE_INN -1 downto 0);

	signal inn_array 				:  inn_array_type := (others=> (others=> '0'));
	
	signal sum 						: std_logic_vector (BREDDE_UT-1 downto 0) := (others => '0');
	signal sum_reg 				: std_logic_vector (BREDDE_UT-1 downto 0) := (others => '0');
	signal produkt 				: std_logic_vector (BREDDE_UT-1 downto 0) := (others => '0');
begin

		
	assert (FUNKSJON /= GANGE_FUNKSJON) or (ANTALL_INN = 2)	
		report "#### ANTALL_INN må være 2 ved multiplikasjon"	
		severity failure;	
	
	assert (FUNKSJON /= GANGE_FUNKSJON) or (BREDDE_INN < 18)
		report "#### BREDDE_INN må være mindre enn 18 ved multiplikasjon"	
		severity failure;	
		
	assert (FUNKSJON /= GANGE_FUNKSJON) or (BREDDE_UT = 2 * BREDDE_INN)
		report "#### BREDDE_UT bør være 2 * BREDDE_INN ved multiplikasjon"	
		severity warning;	
	
		
	reset <= reset_h;
	
	
	-- Utgangssignaler. 
		
		-- ny- signaler. 
	ut_ny <= ny_skifterergister(NY_SKIFTEREGISTER_LENGDE-1) when FUNKSJON = GANGE_FUNKSJON
		else 	ny_skifterergister(0) when FUNKSJON = SUM_DIFFERANSE_FUNKSJON_MED_REGISTER 
		else 	inn_ny;
	
	ny_skifteregister_prosess : process(klokke)
		begin
			if klokke 'event and klokke = '1' then
				if reset = '1' then 
					ny_skifterergister <= (others=> '0');
				else 
					ny_skifterergister <= ny_skifterergister(NY_SKIFTEREGISTER_LENGDE-1-1 downto 0) & inn_ny;
				end if;
			end if;
		end process;

	-- Splitte opp inngangssignalet i arrayelementer
	
	inn_array_generate : for nr in ANTALL_INN-1 downto 0 generate 
		inn_array(nr) <= inn( (nr+1) * BREDDE_INN -1 downto nr * BREDDE_INN);
	end generate;		

	-- Addisjon, subtraksjon.
	summeprosess : process (inn_array)
			variable mellomsum : std_logic_vector(BREDDE_UT -1 downto 0) := (others =>'0');
			variable inn_ekst :  std_logic_vector(BREDDE_UT -1 downto 0) := (others =>'0');
		begin		
			mellomsum	:= (others =>'0');		
			
			for nr in 0 to ANTALL_INN-1 loop 				
				
				if FORTEGN = 1 then 				
					inn_ekst := SXT(inn_array(nr),BREDDE_UT);		
				else 
					inn_ekst := EXT(inn_array(nr),BREDDE_UT);		
				end if;
				
				if pluss_minus(nr) = '0' then 				
					mellomsum := mellomsum + inn_ekst;
				else 
					mellomsum := mellomsum - inn_ekst;		
			
					
				end if;
				
			end loop;			
			
			sum <= mellomsum;
		end process;

	summe_registerprosess : process (klokke)
		begin
		if klokke 'event and klokke = '1' then
			sum_reg <= sum;			
		end if;
		end process;
		
	ut <= produkt when (FUNKSJON = GANGE_FUNKSJON)
		else sum_reg when (FUNKSJON = SUM_DIFFERANSE_FUNKSJON_MED_REGISTER) 
		else 	sum;
		
	----------------------------------------------	
	
	
	gange_generate : if 	FUNKSJON = GANGE_FUNKSJON generate
	
	
		dsp48e_A_inn <= SXT(inn_array(0),DSP48E_A_BREDDE) when FORTEGN = 1 else EXT(inn_array(0),DSP48E_A_BREDDE);
		dsp48e_B_inn <= SXT(inn_array(1),DSP48E_B_BREDDE) when FORTEGN = 1 else EXT(inn_array(1),DSP48E_B_BREDDE);
		produkt <= dsp48e_produkt(BREDDE_UT-1 downto 0);


	
							DSP48E_inst : DSP48E
									
									generic map (
									
										ACASCREG => 0,       -- Number of pipeline registers between 
	--																-- A/ACIN input and ACOUT output, 0, 1, or 2
	--									ALUMODEREG => 1,     -- Number of pipeline registers on ALUMODE input, 0 or 1
										AREG => 0,           -- Number of pipeline registers on the A input, 0, 1 or 2
	--									AUTORESET_PATTERN_DETECT => FALSE, -- Auto-reset upon pattern detect, TRUE or FALSE
	--									AUTORESET_PATTERN_DETECT_OPTINV => "MATCH", -- Reset if "MATCH" or "NOMATCH" 
										A_INPUT => "DIRECT", -- Selects A input used, "DIRECT" (A port) or "CASCADE" (ACIN port)
										BCASCREG => 0,       -- Number of pipeline registers between B/BCIN input and BCOUT output, 0, 1, or 2
										BREG => 0,           -- Number of pipeline registers on the B input, 0, 1 or 2
										B_INPUT => "DIRECT", -- Selects B input used, "DIRECT" (B port) or "CASCADE" (BCIN port)
	--									CARRYINREG => 1,     -- Number of pipeline registers for the CARRYIN input, 0 or 1
	--									CARRYINSELREG => 1,  -- Number of pipeline registers for the CARRYINSEL input, 0 or 1
	--									CREG => 1,           -- Number of pipeline registers on the C input, 0 or 1
	--									MASK => X"3FFFFFFFFFFF", -- 48-bit Mask value for pattern detect
										MREG => 1,           -- Number of multiplier pipeline registers, 0 or 1
	--									MULTCARRYINREG => 1, -- Number of pipeline registers for multiplier carry in bit, 0 or 1
										OPMODEREG => 0,      -- Number of pipeline registers on OPMODE input, 0 or 1
	--									PATTERN => X"000000000000", -- 48-bit Pattern match for pattern detect
	--									PREG => 1,           -- Number of pipeline registers on the P output, 0 or 1
										SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
	--															  -- Design Guide" for details
	--									SEL_MASK => "MASK",  -- Select mask value between the "MASK" value or the value on the "C" port
	--									SEL_PATTERN => "PATTERN", -- Select pattern value between the "PATTERN" value or the value on the "C" port
	--									SEL_ROUNDING_MASK => "SEL_MASK", -- "SEL_MASK", "MODE1", "MODE2" 
	--									USE_MULT => "MULT_S", -- Select multiplier usage, "MULT" (MREG => 0), 
	--																 -- "MULT_S" (MREG => 1), "NONE" (not using multiplier)
	--									USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect, "PATDET", "NO_PATDET" 
										USE_SIMD => "ONE48") -- SIMD selection, "ONE48", "TWO24", "FOUR12" 
									port map (
	--									ACOUT => ACOUT,  -- 30-bit A port cascade output 
	--									BCOUT => BCOUT,  -- 18-bit B port cascade output
	--									CARRYCASCOUT => CARRYCASCOUT, -- 1-bit cascade carry output
	--									CARRYOUT => CARRYOUT, -- 4-bit carry output
	--									MULTSIGNOUT => MULTSIGNOUT, -- 1-bit multiplier sign cascade output
	--									OVERFLOW => OVERFLOW, -- 1-bit overflow in add/acc output
										P => dsp48e_produkt,          -- 48-bit output
	--									PATTERNBDETECT => PATTERNBDETECT, -- 1-bit active high pattern bar detect output
	--									PATTERNDETECT => PATTERNDETECT, --  1-bit active high pattern detect output
	--									PCOUT => PCOUT,  -- 48-bit cascade output
	--									UNDERFLOW => UNDERFLOW, -- 1-bit active high underflow in add/acc output
										A 					=> dsp48e_A_inn,	-- 30-bit A data input
										ACIN 				=> "00" & X"0000000",   -- 30-bit A cascade data input
										ALUMODE 			=> "0000", 					-- 4-bit ALU control input
										B 					=> dsp48e_B_inn,	 -- 18-bit B data input
										BCIN 				=> "00" & X"0000",    	-- 18-bit B cascade input
										C  				=> X"000000000000", 		-- 48-bit C data input
										CARRYCASCIN 	=> '0', 			-- 1-bit cascade carry input
										CARRYIN 			=>	'0', 			-- 1-bit carry input signal
										CARRYINSEL 		=> "000", 		-- 3-bit carry select input
										CEA1 				=> '1',      	-- 1-bit active high clock enable input for 1st stage A registers
										CEA2 				=> '1',      	-- 1-bit active high clock enable input for 2nd stage A registers
										CEALUMODE 		=> '1',			-- 1-bit active high clock enable input for ALUMODE registers
										CEB1 				=> '1',      	-- 1-bit active high clock enable input for 1st stage B registers
										CEB2 				=> '1',      	-- 1-bit active high clock enable input for 2nd stage B registers
										CEC 				=> '1',      	-- 1-bit active high clock enable input for C registers
										CECARRYIN 		=> '1', 			-- 1-bit active high clock enable input for CARRYIN register
										CECTRL 			=> '1', 			-- 1-bit active high clock enable input for OPMODE and carry registers
										CEM 				=> '1',       	-- 1-bit active high clock enable input for multiplier registers
										CEMULTCARRYIN 	=> '1',			-- 1-bit active high clock enable for multiplier carry in register
										CEP 				=> '1',       	-- 1-bit active high clock enable input for P registers
										CLK 				=> klokke,		-- Clock input
										MULTSIGNIN 		=> CONV_STD_LOGIC_VECTOR(FORTEGN,1)(0), --   '1', 			-- 1-bit multiplier sign input
										OPMODE 			=> "0000101", -- 7-bit operation mode input
										PCIN 				=> X"000000000000",      -- 48-bit P cascade input 
										RSTA 				=> reset,   	-- 1-bit reset input for A pipeline registers
										RSTALLCARRYIN 	=> reset, 		-- 1-bit reset input for carry pipeline registers
										RSTALUMODE 		=> reset, 		-- 1-bit reset input for ALUMODE pipeline registers
										RSTB 				=> reset,   	-- 1-bit reset input for B pipeline registers
										RSTC 				=> reset,   	-- 1-bit reset input for C pipeline registers
										RSTCTRL 			=> reset, 		-- 1-bit reset input for OPMODE pipeline registers
										RSTM 				=> reset, 		-- 1-bit reset input for multiplier registers
										RSTP 				=> reset  		-- 1-bit reset input for P pipeline registers
								);
		
		
	
	end generate;
		
		
		
end IMP;
