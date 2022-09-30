--***********************************************************************************
--
--                                                          Timer_50ms
--                                                          ==========
-- File Name:        timer_50ms.vhd
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
-- Function:         This is a 7-Bit-Divider to use as Sampling-Rate-Timer or
--                   Watch Dog. It needs pre-divided clock pulses.
--                   There are two inputs for pre-devided clock pulses: 
--                   usc2 = 2 us, usc200 = 200us.
--                   The d_conf_rg(7) choose between these two inputs:
--                   d_conf_rg(7)=1 : usc200 is activ  (range up to 50.8 ms) 
--                   d_conf_rg(7)=0 : usc2   is activ  (range up to 254 us)
--                   An external coniguration register is necessary.
--
-- History: F.Seiler 07.04.2003 Initial Version
--          F.Seiler 15.05.2003 Signal pulse_out
--          F.Seiler Change because of coverage
--***********************************************************************************

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer is
   port(clk, nres:    in  std_logic;                    -- system clock, reset
        ic_test_mode: in  std_logic;                    -- select test mode
	usc2, usc200: in  std_logic;                    -- clock pulse input
        enbl_timer:   in  std_logic;                    -- Enable Timer
        d_conf_rg :   in  std_logic_vector(7 downto 0); -- Data from configuration register
        timer_rq :    out std_logic_vector(6 downto 0); -- 7-bit-Timer
	clock_out :   out std_logic;                    -- Output Frequency (1:1)
	pulse_out :   out std_logic);                   -- Output Pulse Signal
end timer;

Architecture behav of timer is

signal rt, usc: std_logic;
signal rq:      std_logic_vector(6 downto  0);
signal prq:     std_logic_vector(6 downto  0);


begin

--  Auswahl Zeiltbasis (1us, 0,5ms)

usc <= usc2   when d_conf_rg(7) ='0' else usc200;
prq <= d_conf_rg(6 downto 0);


--===================================================================================
--  Divider 

tim:   process (nres,clk)

 begin
   if (nres = '0') then 
			rq          <=  "0000000";
			rt          <= '0';
			
   elsif clk'event and clk='1' then


      if ic_test_mode='1' then                                   -- IC-Test-Mode active
             if rq = "0000000" then 
                          rq        <= rq - '1';
			  rt        <=  not rt ;
             else 
                          rq        <= rq - '1';
             end if;

	     
      elsif enbl_timer ='1'                   then 

           if  usc='1' then
	      
	      if  rq(6 downto  1) /="000000"  then               -- Timer active when rq /= 1,2
                          rq        <= rq  - '1';
              
	      else      -- rq = 1,2

	         if   prq /= "0000000"  then                     -- Start when prq and rq = 1,2
			  rq        <=  prq;
			  rt        <=  not rt ;
	         end if;

              end if;

	   elsif  prq = "0000000"  then                          -- Stop Timer
			  rq        <=  "0000000";
			  rt        <=  '0';

	   end if;

      else 
			  rq        <=  "0000000";
			  rt        <=  '0';

      end if;	
   end if;
 end process;
--===================================================================================

pulse_out    <= '1' when usc ='1' and rq = "0000001" else '0';
clock_out    <= rt;
timer_rq     <= rq;

end behav;


