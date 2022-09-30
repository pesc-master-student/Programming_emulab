--************************************************************************
--        
--                                                         inpff																	              --  Bondinsel                                              =====															 --
--  Input with Flip Flop                                              
--
--  Place Holder for I/O Pad
--
--*************************************************************************
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity inpff is
   port(clk, I : in std_logic;
        O :      out std_logic);
end inpff;

Architecture behav of inpff is

begin
 process(clk)

   begin
     if clk'event and clk='1' then
	O  <= I ;
     end if;
 end process;


end behav;








