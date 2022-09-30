--****************************************************************************************
--
--                                                             Time_table
--                                                             ==========
-- File Name:        time_table.vhd
-- Project:          END_SAFE
-- Modul Name:       ---
-- Author:           Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Function:         generate different periods and frequencies dependend on
--                   the different system frequencies (32,48,64,100 MHz).
--                                  
-- 
-- History: F.Seiler       10.04.2003 Initial Version
--          F.Seiler       23.06.2003 Pipeline
--          F.Seiler       07.12.2003 Flags an nres
--          R.Woyzichovski 21.09.2004 change time parameters for 100 MHz instead of 36 MHz 
--          F.Seiler       27.04.2008 time_500ns (reduced: without synchr)
--          F.Seiler       11.03.2009 50 MHz
--****************************************************************************************
-- 
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
use ieee.std_logic_arith.all;

entity time_table is
   port(
	clk, nres:              	in std_logic; -- system clock , reset
	mhz_64,mhz_50,mhz_48,mhz_32,mhz_100: in std_logic; -- define the system frequency
	cfg_freq:                       in std_logic_vector(3 downto 0);
	cfg_time_tst:                   in std_logic_vector(2 downto 0);
	--
	dfreq:	                        out std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
	time_tst:                       out std_logic_vector(freq_widh-1 downto 0); -- Recovery time Tst
	time_500ns:                     out std_logic_vector(freq_widh-1 downto 0);
	freq_200khz:                    out std_logic_vector(freq_widh-1 downto 0);
	time_test:                      out std_logic_vector(freq_widh-1 downto 0));
end time_table;


architecture behav of time_table is

-- Signal declaration

signal value_dfreq: integer;
signal dfreq_i:                         std_logic_vector(freq_widh-1 downto 0);
signal time_tst_i:                      std_logic_vector(freq_widh-1 downto 0);
signal time_500ns_i:                    std_logic_vector(freq_widh-1 downto 0);
signal freq_200khz_i:                   std_logic_vector(freq_widh-1 downto 0);
signal time_test_i:                     std_logic_vector(freq_widh-1 downto 0);	
begin


--==========================================================================================
-- TCLK- Frequency Mapping
--------------------------

FREQ_MAP:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32, cfg_freq)
variable addr: std_logic_vector(8 downto 0);

   begin
    addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32 & cfg_freq(3 downto 0);
		case addr is

		when "100000000" => 	value_dfreq   <= 3;    -- 100 MHz
		when "100000001" => 	value_dfreq   <= 3;    ----------
		when "100000010" => 	value_dfreq   <= 3;
		when "100000011" => 	value_dfreq   <= 3;
		when "100000100" =>	value_dfreq   <= 4;
		when "100000101" =>	value_dfreq   <= 5;
		when "100000110" =>	value_dfreq   <= 6;
		when "100000111" =>	value_dfreq   <= 7;
		when "100001000" =>	value_dfreq   <= 8;
		when "100001001" =>	value_dfreq   <= 9;
		when "100001010" =>	value_dfreq   <= 10;
		when "100001011" => 	value_dfreq   <= 12;
		when "100001100" =>	value_dfreq   <= 25;
		when "100001101" =>	value_dfreq   <= 50;
		when "100001110" =>	value_dfreq   <= 250;
		when "100001111" =>	value_dfreq   <= 500;

		when "010000000" => 	value_dfreq   <= 3;    -- 64 MHz
		when "010000001" => 	value_dfreq   <= 3;    ---------
		when "010000010" => 	value_dfreq   <= 3;
		when "010000011" => 	value_dfreq   <= 3;
		when "010000100" =>	value_dfreq   <= 4;
		when "010000101" =>	value_dfreq   <= 5;
		when "010000110" =>	value_dfreq   <= 6;
		when "010000111" =>	value_dfreq   <= 7;
		when "010001000" =>	value_dfreq   <= 8;
		when "010001001" =>	value_dfreq   <= 9;
		when "010001010" =>	value_dfreq   <= 10;
		when "010001011" => 	value_dfreq   <= 12;
		when "010001100" =>	value_dfreq   <= 16;   -- 10/h  16/d
		when "010001101" =>	value_dfreq   <= 32;   -- 20/h  32/d
		when "010001110" =>	value_dfreq   <= 160;  -- A0/h 160/d
		when "010001111" =>	value_dfreq   <= 320;  --140/h 320/d

		when "001000000" => 	value_dfreq   <= 3;    -- 50 MHz
		when "001000001" => 	value_dfreq   <= 3;    ---------
		when "001000010" => 	value_dfreq   <= 3;
		when "001000011" => 	value_dfreq   <= 3;
		when "001000100" =>	value_dfreq   <= 4;
		when "001000101" =>	value_dfreq   <= 5;
		when "001000110" =>	value_dfreq   <= 6;
		when "001000111" =>	value_dfreq   <= 7;
		when "001001000" =>	value_dfreq   <= 8;
		when "001001001" =>	value_dfreq   <= 9;
		when "001001010" =>	value_dfreq   <= 10;
		when "001001011" => 	value_dfreq   <= 12;
		when "001001100" =>	value_dfreq   <= 12;   --  C/h  12/d (12,5)
		when "001001101" =>	value_dfreq   <= 25;   -- 19/h  25/d
		when "001001110" =>	value_dfreq   <= 125;  -- 7D/h 125/d
		when "001001111" =>	value_dfreq   <= 250;  -- FA/h 250/d

		when "000100000" => 	value_dfreq   <= 3;    -- 48 MHz
		when "000100001" => 	value_dfreq   <= 3;    ---------
		when "000100010" => 	value_dfreq   <= 3;
		when "000100011" => 	value_dfreq   <= 3;
		when "000100100" =>	value_dfreq   <= 4;
		when "000100101" =>	value_dfreq   <= 5;
		when "000100110" =>	value_dfreq   <= 6;
		when "000100111" =>	value_dfreq   <= 7;
		when "000101000" =>	value_dfreq   <= 8;
		when "000101001" =>	value_dfreq   <= 9;
		when "000101010" =>	value_dfreq   <= 10;
		when "000101011" => 	value_dfreq   <= 12;
		when "000101100" =>	value_dfreq   <= 12;   --  C/h  12/d
		when "000101101" =>	value_dfreq   <= 24;   -- 18/h  24/d
		when "000101110" =>	value_dfreq   <= 120;  -- 78/h 120/d
		when "000101111" =>	value_dfreq   <= 240;  -- F0/h 240/d

		when "000010000" => 	value_dfreq   <= 3;    -- 32 MHz
		when "000010001" => 	value_dfreq   <= 3;    ---------
		when "000010010" => 	value_dfreq   <= 3;
		when "000010011" => 	value_dfreq   <= 3;
		when "000010100" =>	value_dfreq   <= 4;
		when "000010101" =>	value_dfreq   <= 5;
		when "000010110" =>	value_dfreq   <= 6;
		when "000010111" =>	value_dfreq   <= 7;
		when "000011000" =>	value_dfreq   <= 8;
		when "000011001" =>	value_dfreq   <= 9;
		when "000011010" =>	value_dfreq   <= 10;
		when "000011011" => 	value_dfreq   <= 12;
		when "000011100" =>	value_dfreq   <= 8;
		when "000011101" =>	value_dfreq   <= 16;
		when "000011110" =>	value_dfreq   <= 80;
		when "000011111" =>	value_dfreq   <= 160;

		when others   => 	value_dfreq   <= 242;  
  		end case;
    end process;

dfreq_i <= CONV_STD_LOGIC_VECTOR(value_dfreq,freq_widh);          
--dfreq   <= dfreq_i;
--==========================================================================================
-- Recovery Time definition (Time Tst)
--------------------------------------

Wait_Time_tst:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32, cfg_time_tst, dfreq_i)
variable addr: std_logic_vector(7 downto 0);

begin
   addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32 & cfg_time_tst(2 downto 0);
     case addr is
											-- fuer fsys = 100 MHz
	when "10000000" => time_tst_i  <= dfreq_i;					-- defined frequency
	when "10000001" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(  50,freq_widh);  	-- 0,5 us
	when "10000010" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 100,freq_widh);  	-- 1   us
	when "10000011" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 150,freq_widh);  	-- 1,5 us
	when "10000100" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 200,freq_widh);  	-- 2   us
	when "10000101" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 400,freq_widh);  	-- 4   us
	when "10000110" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 800,freq_widh);  	-- 8   us
	when "10000111" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(1000,freq_widh);  	--10   us

											-- fuer fsys = 64 MHz
	when "01000000" => time_tst_i  <= dfreq_i;					-- defined frequency
	when "01000001" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 32,freq_widh);  	-- 0,5 us
	when "01000010" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 64,freq_widh);  	-- 1   us
	when "01000011" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 96,freq_widh);  	-- 1,5 us
	when "01000100" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(128,freq_widh);  	-- 2   us
	when "01000101" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(256,freq_widh);  	-- 4   us
	when "01000110" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(512,freq_widh);  	-- 8   us
	when "01000111" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(640,freq_widh);  	--10   us

											-- fuer fsys = 50 MHz
	when "00100000" => time_tst_i  <= dfreq_i;					-- defined frequency
	when "00100001" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 25,freq_widh);  	-- 0,5 us
	when "00100010" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 50,freq_widh);  	-- 1   us
	when "00100011" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 75,freq_widh);  	-- 1,5 us
	when "00100100" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(100,freq_widh);  	-- 2   us
	when "00100101" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(200,freq_widh);  	-- 4   us
	when "00100110" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(400,freq_widh);  	-- 8   us
	when "00100111" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(500,freq_widh);  	--10   us

											-- fuer fsys = 48 MHz
	when "00010000" => time_tst_i  <= dfreq_i;					-- defined frequency
	when "00010001" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 24,freq_widh);  	-- 0,5 us
	when "00010010" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 48,freq_widh);  	-- 1   us
	when "00010011" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 72,freq_widh);  	-- 1,5 us
	when "00010100" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 96,freq_widh);  	-- 2   us
	when "00010101" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(192,freq_widh);  	-- 4   us
	when "00010110" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(384,freq_widh);  	-- 8   us
	when "00010111" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(480,freq_widh);  	--10   us
		
											-- fuer fsys = 32 MHz
	when "00001000" => time_tst_i  <= dfreq_i;					-- defined frequency
	when "00001001" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 16,freq_widh);  	-- 0,5 us
	when "00001010" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 32,freq_widh);  	-- 1   us
	when "00001011" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 48,freq_widh);  	-- 1,5 us
	when "00001100" => time_tst_i  <= CONV_STD_LOGIC_VECTOR( 64,freq_widh);  	-- 2   us
	when "00001101" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(128,freq_widh);  	-- 4   us
	when "00001110" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(256,freq_widh);  	-- 8   us
	when "00001111" => time_tst_i  <= CONV_STD_LOGIC_VECTOR(320,freq_widh);  	--10   us
		
	when others    => time_tst_i  <= dfreq_i;
     end case;
end process;


--==========================================================================================
-- Time 500ns
-------------

Wait_Time_500ns:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32)
variable addr: std_logic_vector(4 downto 0);

begin
   addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32;
     case addr is
					                                       -- * -2 Takte Eing.Synchr.
	when "01000" => time_500ns_i <= CONV_STD_LOGIC_VECTOR(30,freq_widh);   -- 32-2: fsys =  64 MHz
	when "00100" => time_500ns_i <= CONV_STD_LOGIC_VECTOR(23,freq_widh);   -- 25-2: fsys =  50 MHz
	when "00010" => time_500ns_i <= CONV_STD_LOGIC_VECTOR(22,freq_widh);   -- 24-2: fsys =  48 MHz
	when "00001" => time_500ns_i <= CONV_STD_LOGIC_VECTOR(14,freq_widh);   -- 16-2: fsys =  32 MHz
	when others  => time_500ns_i <= CONV_STD_LOGIC_VECTOR(48,freq_widh);   -- 50-2: fsys = 100 MHz
     end case;
end process;


--==========================================================================================
-- Frequency 200 KHz   (Time 2.5us for a half period) 
-----------------------------------------------------

Time_for_200khz:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32)
variable addr: std_logic_vector(4 downto 0);

begin
   addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32;
     case addr is
					
	when "01000" => freq_200khz_i <= CONV_STD_LOGIC_VECTOR(160,freq_widh);  -- fsys =  64 MHz
	when "00100" => freq_200khz_i <= CONV_STD_LOGIC_VECTOR(125,freq_widh);  -- fsys =  50 MHz
	when "00010" => freq_200khz_i <= CONV_STD_LOGIC_VECTOR(120,freq_widh);  -- fsys =  48 MHz
	when "00001" => freq_200khz_i <= CONV_STD_LOGIC_VECTOR( 80,freq_widh);  -- fsys =  32 MHz
	when others  => freq_200khz_i <= CONV_STD_LOGIC_VECTOR(250,freq_widh);  -- fsys = 100 MHz
     end case;
end process;


--==========================================================================================
-- Time for Testmode   (Time 1us) 
-----------------------------------------------------

Time_for_test:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32)
variable addr: std_logic_vector(4 downto 0);

begin
   addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32;
     case addr is
					
	when "01000" => time_test_i <= CONV_STD_LOGIC_VECTOR( 64,freq_widh);  -- fuer fsys =  64 MHz
	when "00100" => time_test_i <= CONV_STD_LOGIC_VECTOR( 50,freq_widh);  -- fuer fsys =  50 MHz
	when "00010" => time_test_i <= CONV_STD_LOGIC_VECTOR( 48,freq_widh);  -- fuer fsys =  48 MHz
	when "00001" => time_test_i <= CONV_STD_LOGIC_VECTOR( 32,freq_widh);  -- fuer fsys =  32 MHz
	when others  => time_test_i <= CONV_STD_LOGIC_VECTOR(100,freq_widh);  -- fuer fsys = 100 MHz
     end case;
end process;

pipe: process (nres, clk)
begin
if nres = '0' then
  time_tst <= (others=>'0');
  dfreq    <= (others=>'0');
elsif clk'event and clk='1' then
  time_tst    <= time_tst_i;
  dfreq       <= dfreq_i;
end if;
end process;

time_test   <= time_test_i;
time_500ns  <= time_500ns_i;
freq_200khz <= freq_200khz_i;

end behav;
