--****************************************************************************************
--
--                                                               statreg_8x
--                                                               ========
-- File Name:        statreg_8x.vhd
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
-- Function:         Status Register
--                   Set is ore important than Reset.
--                   It can be configurated as an 8-,16-,24-,32-Bit-
--                   Register by the generic parameter "init_width".
--                                  
--                   Write Coding:
--                   write_pulse(1,0)   Action:
--                       0   0          write Byte 0           
--                       0   1          write Byte 1
--                       1   0          write Byte 2
--                       1   1          write Byte 3
--
-- History: F.Seiler 27.11.2003 Initial Version 
--                   Substitutes statreg_nx8.vhd by using ABP-IF
--                   (D-Input: 32Bit instead of 16Bit, Byte-Demultiplexing deleted)
--          F.Seiler 01.11.2006 nres_srg
-- 
--****************************************************************************************
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_misc.all;

entity statreg_8x is

   generic(
	init_width:      integer:= 4);                                    -- Width (Count of Bytes -> 1,2,3 or 4)
   port(clk:             in  std_logic;
	nres:            in  std_logic;                                   -- synchr. Reset
	nres_srg:        in  std_logic;
        sel:             in  std_logic;                                   -- Select this Register
        write_pulse :    in  std_logic_vector(   init_width -1 downto 0); -- One for every Byte
	d:               in  std_logic_vector((8*init_width)-1 downto 0);
	d_int_stat:      in  std_logic_vector((8*init_width)-1 downto 0);
	int_stat_rq:     out std_logic_vector((8*init_width)-1 downto 0));

end statreg_8x;


architecture behav of statreg_8x is

signal intstatrq:   std_logic_vector((8*init_width) downto 0);
constant initwidth: integer:=init_width-1;

begin


--==========================================================================================
--  Interrupt-Status-RG Byte 0
------------------------------


  INTSTAT0: process(nres, clk)

  begin

     if nres = '0' then
		intstatrq  <= conv_std_logic_vector(0, (8*init_width)+1);

     elsif  clk'event and clk = '1' then

       if nres_srg = '0' then
		intstatrq  <= conv_std_logic_vector(0, (8*init_width)+1);
       else

          for i in 0 to initwidth loop 
	            for k in 0 to 7 loop 	  

  	                 if  d_int_stat(i*8+k) = '1' then
		             intstatrq(i*8+k) <= '1';
	                 elsif sel ='1' and write_pulse(i) ='1' and d(i*8+k) ='1' then
		               intstatrq(i*8+k) <=	'0';
	                 end if;

                    end loop;
	  end loop;      

       end if;
     end if;
  end process INTSTAT0;


int_stat_rq <= intstatrq((8*init_width)-1 downto 0);


end behav;
