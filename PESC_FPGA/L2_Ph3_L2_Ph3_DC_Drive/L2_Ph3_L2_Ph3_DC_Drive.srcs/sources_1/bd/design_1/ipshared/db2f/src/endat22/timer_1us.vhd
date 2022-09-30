--***********************************************************************************
--
--                                                               Timer_1us
--                                                               =========
-- File Name:        timer_1_us.vhd
-- Project:          EnDat6
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
-- 
-- Function:         This circuit delivers clock output pulses of 
--                   0.10us, 0.25us, 1us, 2us, 100us, 200us, 1000us.
--                   These pulses are adjust for the input frequencys
--                   of 32,36,48,64 MHz on input "clk".
-- 
-- History: F.Seiler      04.04.2003 Initial Version
--          F.Seiler      19.06.2003 100us output
--          R.Woyichovski 22.09.2004 added parameter for fsys=100MHz
--          F.Seiler      11.03.2009 50 MHz
--***********************************************************************************
-- 
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity timer_1us is
   port(
	clk, nres:              	 in std_logic; -- system clock , reset
	mhz_100, mhz_64, mhz_50, mhz_48, mhz_32: in std_logic; -- define the system frequency
	test :                           in std_logic; -- select test mode
	Q1:	 out std_logic_vector(6 downto 0);     -- test vector us counter
	Q1000:	 out std_logic_vector(10 downto 0);    -- test vector us counter
	--
	usc010:	 out std_logic;	 -- 0.10 us pulse
	usc025:	 out std_logic;	 -- 0.25 us pulse
	usc1:    out std_logic;	 -- 1    us pulse
	usc2:    out std_logic;	 -- 2    us pulse
	usc100:  out std_logic;	 -- 100  us pulse
	usc200:  out std_logic;	 -- 200  us pulse
	usc500:  out std_logic;	 -- 500  us pulse
	usc1000: out std_logic); -- 1000 us pulse
end timer_1us;

architecture behav of timer_1us is

	-- Signal declaration
	--
	signal CTE1, CTE2, CTE010, CTE025: 	  std_logic;	-- Clock Timer Enable
	signal CTE100, CTE200, CTE500, CTE1000:   std_logic;	-- Clock Timer Enable
	signal Q:		std_logic_vector( 6 downto 0);	-- Q-Ausg. 1us-Counter
	signal QQ:		std_logic_vector(10 downto 0);	-- Q-Ausg. 100us-Counter

	signal value025, value050, value075: integer;		-- 0.25us-,0.50us-,0.75us-value
	signal value010, value020, value030: integer;		-- 0.10us-,0.20us-,0.30us-value
	signal value040, value060, value070: integer;		-- 0.40us-,0.60us-,0.70us-value
	signal value080, value090          : integer;		-- 0.80us-,0.90us-value
	signal value_max                   : integer;		-- range of 1us-counter 
				
	constant BeforeLast:		     integer:= 1;
	constant value0:		     integer:= 0;
	constant value100:		     integer:= 99;
	constant value200:		     integer:= 199;
	constant value300:		     integer:= 299;
	constant value400:		     integer:= 399;
	constant value500:		     integer:= 499;
	constant value600:		     integer:= 599;
	constant value700:		     integer:= 699;
	constant value800:		     integer:= 799;
	constant value900:		     integer:= 899;
	constant value1000:		     integer:= 999;

	
begin


--==========================================================================================
-- Frequency definition for 0,25us pulse    and 1us-counter range (value_max)
--------------------------------------------------------------------------------------------
FREQ_MAP_025:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32)
variable addr: std_logic_vector( 4 downto 0);

   begin
    addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32;
		case addr is

		when "01000" => value025  <= 17;  -- 16+1   -- fuer fsys = 64 MHz
			        value050  <= 33;  -- 32+1
			        value075  <= 49;  -- 48+1
			        value_max <= 63;  -- 64-1
		
		when "00100" => value025  <= 13;  -- 12+1 (12,5) fuer fsys = 50 MHz
			        value050  <= 25;  -- 25+1
			        value075  <= 38;  -- 37+1 (37,5)
			        value_max <= 49;  -- 50-1
		
		when "00010" => value025  <= 13;  -- 12+1   -- fuer fsys = 48 MHz
			        value050  <= 25;  -- 24+1
			        value075  <= 37;  -- 36+1
			        value_max <= 47;  -- 48-1
		
		when "00001" => value025  <= 9;   --  8+1   -- fuer fsys = 32 MHz
			        value050  <= 17;  -- 16+1
			        value075  <= 25;  -- 24+1
			        value_max <= 31;  -- 32-1

		when others => value025  <= 26;  --  25+1  -- fuer fsys =100 MHz
		               value050  <= 51;  --  50+1
			       value075  <= 76;  --  75+1
			       value_max <= 99;  -- 100-1

  		end case;

    end process;
--==========================================================================================



--==========================================================================================
-- Frequency definition for 0,10us pulse
--------------------------------------------------------------------------------------------
FREQ_MAP_010:    process(mhz_100, mhz_64, mhz_50, mhz_48, mhz_32)
variable addr: std_logic_vector( 4 downto 0);

   begin
    addr := mhz_100 & mhz_64 & mhz_50 & mhz_48 & mhz_32;
		case addr is

		when "01000" => value010 <=  7;  --  6+1   -- fuer fsys = 64 MHz
			        value020 <= 14;  -- 13+1
			        value030 <= 20;  -- 19+1
			        value040 <= 27;  -- 26+1
--			        value050 <= 33;  -- 32+1
			        value060 <= 39;  -- 38+1
			        value070 <= 46;  -- 45+1
			        value080 <= 52;  -- 51+1
			        value090 <= 59;  -- 58+1
			       			       		
		when "00100" => value010 <=  6;  --  5+1   -- fuer fsys = 50 MHz
			        value020 <= 11;  -- 10+1
			        value030 <= 16;  -- 15+1
			        value040 <= 21;  -- 20+1
--			        value050 <= 26;  -- 25+1
			        value060 <= 31;  -- 30+1
			        value070 <= 36;  -- 35+1
			        value080 <= 41;  -- 40+1
			        value090 <= 46;  -- 45+1
		
		when "00010" => value010 <=  6;  --  5+1   -- fuer fsys = 48 MHz
			        value020 <= 10;  -- 10+1
			        value030 <= 15;  -- 14+1
			        value040 <= 20;  -- 19+1
--			        value050 <= 25;  -- 24+1
			        value060 <= 30;  -- 29+1
			        value070 <= 35;  -- 34+1
			        value080 <= 39;  -- 38+1
			        value090 <= 43;  -- 43+1
		
		when "00001" => value010 <=  4;  --  3+1   -- fuer fsys = 32 MHz
			        value020 <=  7;  --  6+1
			        value030 <= 11;  -- 10+1
			        value040 <= 14;  -- 13+1
--			        value050 <= 17;  -- 16+1
			        value060 <= 20;  -- 19+1
			        value070 <= 23;  -- 22+1
			        value080 <= 27;  -- 26+1
			        value090 <= 30;  -- 29+1

		when others  => value010 <= 11;  -- 10+1   -- fuer fsys =100 MHz
			        value020 <= 21;  -- 20+1
			        value030 <= 31;  -- 30+1
			        value040 <= 41;  -- 40+1
--			        value050 <= 51;  -- 50+1
			        value060 <= 61;  -- 60+1
			        value070 <= 71;  -- 70+1
			        value080 <= 81;  -- 80+1
			        value090 <= 91;  -- 90+1

  		end case;
    end process;
--==========================================================================================



--==========================================================================================
-- 1us-Counter
--------------------------------------------------------------------------------------------
P1US: process(nres,clk)
begin
	if nres = '0' then
		Q      <= conv_std_logic_vector(63,7);
		CTE1   <=	 '0' ;
		CTE010 <=	 '0' ;
		CTE025 <=	 '0' ;
		elsif clk'event and clk = '1' then
--------------------------------------------------------------------------------------------
			if Q = BeforeLast then                                                    -- 1 us  Pulse
				CTE1 <=	 '1' ;
			else
				CTE1 <=	 '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if ((Q = BeforeLast) or (Q=value010) or (Q=value020) or (Q=value030)
			                     or (Q=value040) or (Q=value050) or (Q=value060)
					     or (Q=value070) or (Q=value080) or (Q=value090)) then -- 0.10 us Pulse
				CTE010 <=	 '1' ;
			else
				CTE010 <=	 '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if ((Q = BeforeLast) or (Q=value025) or (Q=value050) or (Q=value075)) then -- 0.25 us Pulse
				CTE025 <=	 '1' ;
			else
				CTE025 <=	 '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if CTE1 = '1' then                                                        -- 1 us Counter 
        			Q <= conv_std_logic_vector(value_max,7);
			else
				Q <= Q - '1';
			end if;
--------------------------------------------------------------------------------------------
		end if;
	end process P1US;
--==========================================================================================	



--==========================================================================================
-- 1ms-Counter
--------------------------------------------------------------------------------------------
P1000us:process(nres,clk)
begin
	if nres = '0' then
          	QQ      <= conv_std_logic_vector(value1000,11) ;
		CTE100  <=	 '0' ;
		CTE200  <=	 '0' ;
		CTE500  <=	 '0' ;
		CTE1000 <=	 '0' ;
		elsif clk'event and clk = '1' then
--------------------------------------------------------------------------------------------
			if Q = BeforeLast and QQ = value0 then		     -- 1000 us pulse 
				CTE1000 <= '1' ;
			else
				CTE1000 <= '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if Q = BeforeLast and (QQ = value0 or QQ=value500) then	 -- 500 us pulse 
				CTE500 <= '1' ;
			else
				CTE500 <= '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if (Q = BeforeLast and			             -- 200 us pulse
			    (QQ=value200 or QQ=value400 or QQ=value600 or QQ=value800 or QQ=value0)) then 
				CTE200 <=	 '1' ;
			else
				CTE200 <=	 '0' ;
			end if;
--------------------------------------------------------------------------------------------			if (Q = BeforeLast and			             -- 200 us pulse
			if (Q = BeforeLast and			             -- 100 us pulse
			    (QQ=value100 or QQ=value300 or QQ=value500 or QQ=value700 or QQ=value900)) then 
				CTE100 <=	 '1' ;
			else
				CTE100 <=	 '0' ;
			end if;
--------------------------------------------------------------------------------------------
			if CTE1000 = '1' then                                -- 1000 us Counter normal mode
       				QQ <= conv_std_logic_vector(value1000,11) ;
			elsif CTE1 = '1' or test ='1' then                   -- 1000 us Counter test mode
				QQ <= QQ - '1' ;
			end if;
--------------------------------------------------------------------------------------------
		end if;
	end process P1000us;
--==========================================================================================

-- FlipFlop for 2 us
---------------------
P_USC2:process(nres,clk)   
begin
     if nres = '0' then
        CTE2    <= '0';
     elsif clk'event and clk = '1' then
       if CTE1= '1' then 
        CTE2    <= not CTE2;
       end if;
     end if;
end process P_USC2;

usc2    <= CTE1 and (not CTE2);

--==========================================================================================
-- Pipeline (no logical function)
P_FF:process(nres,clk)   
begin
     if nres = '0' then
        usc010  <= '0';
        usc025  <= '0';
        usc1    <= '0';
	usc100  <= '0';
	usc200  <= '0';
	usc500  <= '0';
	usc1000 <= '0';
     elsif clk'event and clk = '1' then
	usc010  <= CTE010;
	usc025  <= CTE025;
	usc1    <= CTE1;
	usc100  <= CTE100 or CTE200;
	usc200  <= CTE200;
	usc500  <= CTE500;
	usc1000 <= CTE1000;
     end if;
end process P_FF;
--==========================================================================================


		
--==========================================================================================
-- Outputs for Test

PQ1:     Q1       <= Q;         -- Q-Ausg. des Teilers (CT) fuer 1us
PQ1000:  Q1000    <= QQ;        -- Q-Ausg. des Teilers (CT) fuer 1000us

end behav;
	
