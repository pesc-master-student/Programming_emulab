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
--                   enble for every bit
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


entity regist2 is

   generic(init_width:    integer:= 1;   -- Width
           init_res:      integer:= 0);  -- Reset Value
		
   port(clk, nres : in std_logic;
        enbl :      in  std_logic_vector(init_width-1 downto 0);
        d :         in  std_logic_vector(init_width-1 downto 0);
        q :         out std_logic_vector(init_width-1 downto 0));

end regist2;


Architecture behav of regist2 is

signal rq:    std_logic_vector(init_width downto 0);
constant initwidth: integer:=init_width-1;

begin
   process (nres, clk)

   begin
     if nres = '0' then
 	   rq  <= conv_std_logic_vector(init_res,init_width +1); 

     elsif clk'event and clk = '1' then

       for i in 0 to initwidth loop 

          if enbl(i) = '1'  then
	    rq(i)  <= d(i);
          end if;

       end loop;      
       
     end if;
   end process;

q <= rq(init_width-1 downto 0);

end behav;



