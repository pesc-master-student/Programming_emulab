--******************************************************************************
--
--                                                          Regist
--                                                          ======
-- Dateiname:        regist.vhd
-- Projekt:          MMI4832-E4
-- Modulname:        ---
-- Autor:            Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Erstellungsdatum: 24.09.2001
--
-- Spezifikation:    ---
--                                                             
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Funktion:         parametrisierbares Register
-- 
-- History:          ---
--        F.Seiler,  ---
-- 
--******************************************************************************
-- 
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity regist is

   generic(init_width:    integer:= 1;   -- Width
           init_res:      integer:= 0);  -- Reset Value
		
   port(clk, nres, enbl: in std_logic;
        d :              in  std_logic_vector(init_width-1 downto 0);
        q :              out std_logic_vector(init_width-1 downto 0));

end regist;


Architecture behav of regist is

signal rq:    std_logic_vector(init_width downto 0);

begin
   process (nres, clk)

   begin
     if nres = '0' then
 	   rq  <= conv_std_logic_vector(init_res,init_width +1); 

     elsif clk'event and clk = '1' then

       if enbl = '1'  then
	   rq(init_width-1 downto 0)  <= d;
       end if;
       
     end if;
   end process;

q <= rq(init_width-1 downto 0);

end behav;



