--****************************************************************************************
--
--                                                                    psw
--                                                                    === 
-- File Name:        psw.vhd
-- Project:          EnDat6
-- Modul Name:       psw
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
-- Function:         Parallel to Serial Converter
--                   30-Bit-Parallel-Serial-Converter for Transmission Operation
--                   width of rq = 31 Bit, because the MSB arrives at data_out with enpsw. 
--                   enpsw: shift enable (for transmission)
--                   MSB first
--                   clk_shift: Clock-Pulses for shifting
--                   data_out: Data Output Parallel-Serial-Converter
-- 
-- History: 	     F.Seiler Original from EnDat4
--                   F.Seiler 30.04.2003 Initial Version for EnDat5
--                   F.Seiler 24.01.2005 Improve Coverage
--****************************************************************************************
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use endat22.endat5_pkg.all;

entity psw is
   port(clk, nres, load, clk_shift, enpsw: in std_logic;       -- Signals for Shifter
        d :           in  std_logic_vector(29 downto 0);
        q :           out std_logic_vector(15 downto 0);
                                                               -- Configuration Signals for Mux
        ec_automat:   in  std_logic_vector( 5 downto 0);
        imp:          in  std_logic_vector(imp_zahl downto 0);
        zusatz_flag:  in  std_logic;
                                                               -- Serial Data Out
        data_out: out std_logic);

end psw;


Architecture behav of psw is

signal rq:          std_logic_vector(30 downto 0);
signal data_out_i : std_logic;
begin


-- Shifter for Transmission
---------------------------

process(clk, nres)
 begin

      if nres = '0'  then
               rq    <= (others=>'0');

      elsif clk'event and clk='1' then

           if enpsw='0' then

 		if load ='1'   then                             -- laden
		      rq    <= '0' & d;
                end if;
           else

 		if clk_shift ='1'  then  -- shift to left
		      rq    <=  rq(29 downto 0) & '0';
	        end if;

           end if;
      end if;
 end process;



data_out_i <= rq(30);
q          <= rq(15 downto 0);



-- Multiplexer for Data_Out Signal
----------------------------------
-- (Signal must be '0' or '1' sometimes)

data_out 
  <= '1'        when (ec_automat = "110111" and imp  = CONV_STD_LOGIC_VECTOR(2,imp_zahl+1)) else                    -- Z55 1.Teil SB
     '1'        when (ec_automat = "001000"                                                and zusatz_flag ='1') else --Z8 2.Teil SB
     '1'        when (ec_automat = "001001" and imp  = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1) and zusatz_flag ='1') else --Z9 2.Teil SB

     data_out_i when (ec_automat = "001001" and imp /= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1) and zusatz_flag ='1') else --Z9 letztes Bit 
                                                                                                                       -- Zusatz
     data_out_i when ((ec_automat = "001000" or ec_automat = "001001")                     and zusatz_flag ='0') else  --Z8,9 normal
     data_out_i when (ec_automat = "001010")                          else                           --Z10
     data_out_i when (ec_automat = "001011" and imp = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1)) else      --Z11
     data_out_i when (ec_automat = "110000")                          else
     data_out_i when (ec_automat = "110001" and imp = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1)) else '0';
end behav;


