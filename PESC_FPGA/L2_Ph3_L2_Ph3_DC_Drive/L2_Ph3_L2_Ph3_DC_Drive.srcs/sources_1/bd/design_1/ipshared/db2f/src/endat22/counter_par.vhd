--******************************************************************************
--
--                                                          counter_par
--                                                          ============
-- Dateiname:        counter_par.vhd
-- Projekt:          EnDat5
-- Modulname:        ---
-- Autor:            Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Erstellungsdatum: 19.06.2003
--
-- Spezifikation:    ---
--                                                             
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Funktion:         Counter for Delay
-- 
-- History:          ---
--        F.Seiler,  ---
--******************************************************************************

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
USE ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity counter_par is
      generic(
	   filt_width :      integer:= 1); 
      port(clk, nres, inpp : in  std_logic;
           d :               in  std_logic_vector(filt_width - 1 downto 0);
	   qout :            out std_logic);
end counter_par;


Architecture behav of counter_par is

signal rt:               std_logic;
signal rq, dd:           std_logic_vector(filt_width - 1 downto 0);

begin

--Ausgleich fuer voranstehende und folgende Synchronisations-FF.
dd <= CONV_STD_LOGIC_VECTOR(0,filt_width) when d= CONV_STD_LOGIC_VECTOR(0,filt_width) else
--    CONV_STD_LOGIC_VECTOR(0,filt_width) when d= CONV_STD_LOGIC_VECTOR(1,filt_width) else  -- 1 Ebene hoeher codiert
--    CONV_STD_LOGIC_VECTOR(0,filt_width) when d= CONV_STD_LOGIC_VECTOR(2,filt_width) else
      d - (CONV_STD_LOGIC_VECTOR(3,filt_width)); 

-- Zaehler
----------
   process (nres, clk)
   begin

 	if (nres = '0') then 
		rq  <= CONV_STD_LOGIC_VECTOR(0,filt_width);
                rt <= '1';
        elsif clk'event and clk='1' then
		if    ( rq = CONV_STD_LOGIC_VECTOR(0,filt_width) and inpp='0' 
		        and d= CONV_STD_LOGIC_VECTOR(3,filt_width)) then              -- Start Filter-CT wenn d=3
                        rt <= '0';
		elsif ( rq = CONV_STD_LOGIC_VECTOR(0,filt_width) and inpp='0' ) then  -- Start Filter-CT wenn d>3
			rq <= rq+1;
		elsif ( rq /= CONV_STD_LOGIC_VECTOR(0,filt_width) and rq < dd ) then  -- Weiter zaehlen
			rq <= rq+1;
		elsif rq = dd and d /= CONV_STD_LOGIC_VECTOR(0,filt_width) 
		              and d /= CONV_STD_LOGIC_VECTOR(3,filt_width) then 
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
                        rt <= '0';
		elsif (rq > dd) or  inpp='1' then
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
                        rt <= '1';
		end if;
	end if;

   end process;


qout <= rt when d /= CONV_STD_LOGIC_VECTOR(0,filt_width) else inpp;


end behav;

