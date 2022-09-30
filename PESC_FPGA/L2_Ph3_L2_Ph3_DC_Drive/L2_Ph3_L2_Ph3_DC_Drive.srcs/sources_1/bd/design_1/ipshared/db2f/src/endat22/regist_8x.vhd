--****************************************************************************************
--
--                                                          regist_8x
--                                                          =======
-- File Name:        regist_8x.vhd
-- Project:          EnDat22-SI
-- Modul Name:       ---
-- Author:           Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Specification:    ---
--                                                             
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Function:         This circuit is a simple register. It can be configurated as an 8-,
--                   16-,24-,32-Bit Register by the generic parameter "init_width".
-- 
--                   Write Coding:
--                   write_pulse(1,0)   Action:
--                       0   0          write Byte 0           
--                       0   1          write Byte 1
--                       1   0          write Byte 2
--                       1   1          write Byte 3

-- History: F.Seiler 28.11.2003 Initial Version 
--                   Substitutes regist_nx8.vhd by using ABP-IF
--                   (D-Input: 32Bit instead of 16Bit, Byte-Demultiplexing deleted)
-- 
--****************************************************************************************
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_misc.all;


entity regist_8x is

   generic(init_width:   integer:= 4;   -- Width (Count of Bytes -> 1,2,3 or 4)
           init_res:     integer:= 0);  -- Reset Value
		
   port(clk, nres:       in  std_logic;
        sel:             in  std_logic;
        write_pulse :    in  std_logic_vector(   init_width -1 downto 0);
        d :              in  std_logic_vector((8*init_width)-1 downto 0);
        q :              out std_logic_vector((8*init_width)-1 downto 0));

end regist_8x;


Architecture behav of regist_8x is

signal rq:          std_logic_vector(8*init_width downto 0);
constant initwidth: integer:=init_width-1;

begin


  process (nres, clk)

     begin
       if nres = '0' then
 	   rq  <= conv_std_logic_vector(init_res, (8*init_width)+1); 

       elsif clk'event and clk = '1' then

          for i in 0 to initwidth loop 
             if sel = '1' and write_pulse(i) = '1'  then
	        rq((8*(i) +7) downto (8*(i)))  <= d((8*(i) +7) downto (8*(i)));
             end if;
          end loop;

       end if;
  end process;

q <= rq((8*init_width)-1 downto 0);

end behav;



