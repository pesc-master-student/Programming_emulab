--******************************************************************************
--
--                                                          Digfilt_par2
--                                                          ============
-- Dateiname:        digfilt_par2.vhd
-- Projekt:          MMI4832-E4
-- Modulname:        ---
-- Autor:            Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Erstellungsdatum: 29.08.2001
--
-- Spezifikation:    ---
--                                                             
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Funktion:         parameterisierbares, progr. dig. Eing.-Filter                                  
--                   (wie Filter digfilt_par, aber Par.-Uebergabe durch generic)
--                   Vorwaerts-CT: 
--                   - beginnt mit jedem Flankenwechsel an "IN" bis zum 
--                     programmierten Wert D(15:10) zu zaehlen
--                   FF
--                   - wird der progr. Wert erreicht entsteht am Ausg. 
--                     ein Flankenwechsel
-- 
-- History:          ---
--        F.Seiler,  30.08.01  -Ausg.-Mux qout eingefuegt:
--                              Bei ausgeschalteten Filtern geht inpp direkt auf 
--                              qout.
--                             -Spike-Generierung auch nun auch fuer Pulse mit
--                              einer Taktdauer.
--******************************************************************************

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
USE ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity digfilt_par2 is
      generic(
	   filt_width :      integer:= 1); 
      port(clk, nres, inpp : in  std_logic;
           d :               in  std_logic_vector(filt_width - 1 downto 0);
	   qout, spike :     out std_logic);
end digfilt_par2;


Architecture behav of digfilt_par2 is

signal in1, in2, rt: std_logic;
signal rq:           std_logic_vector(filt_width - 1 downto 0);

begin

   process (clk)
   begin
	if clk'event and clk='1' then
		in2 <=in1;
		in1 <=inpp;
    end if;
   end process;




-- Zaehler
----------
   process (nres, clk)
   begin

 	 if nres = '0' then 
		rq  <= CONV_STD_LOGIC_VECTOR(0,filt_width);
		spike <= '0';
	 elsif clk'event and clk='1' then

		if ( rq < d and ((inpp='1' and in1='1' and rt='0') or  (inpp='0' and in1='0'and rt='1'))) then    --Start Filter-CT
			rq <= rq+1;
			spike <= '0';
		elsif rq < d and rq /= CONV_STD_LOGIC_VECTOR(0,filt_width) and((inpp='1' and in1='0') or (inpp='0' and in1='1')) then 
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
			spike <= '1';
		elsif rq < d  and ((inpp='1' and in1='0' and in2='1') or (inpp='0' and in1='1' and in2='0')) then
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
			spike <= '1';			
		elsif rq = d and ((inpp='1' and in1='0') or  (inpp='0' and in1='1')) then    -- Filterwert erreicht
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
		elsif rq > d  then
			rq <= CONV_STD_LOGIC_VECTOR(0,filt_width);
	        elsif rq = CONV_STD_LOGIC_VECTOR(0,filt_width) then
			spike <= '0';
		else 
			Null;
		end if;
	end if;

   end process;


-- Ausgangs-FF, (JK-FF)
-----------------------------
   process (nres, clk)
   begin
	if nres = '0' then
--		 rt  <= inpp;
		 rt  <= '0';  -- Vorschlag v. HT
	elsif clk'event and clk='1' then
		 if d = CONV_STD_LOGIC_VECTOR(0,filt_width)  then 
		 rt  <= inpp;
		 elsif d /= CONV_STD_LOGIC_VECTOR(0,filt_width) and rq = d and in2='1' and in1='1'  then
			rt <= '1';
		 elsif d /= CONV_STD_LOGIC_VECTOR(0,filt_width) and rq = d and in2='0' and in1='0'  then
			rt <= '0';
--		 else
--			rt <= rt;
		 end if;
	end if;
   end process;


qout <= rt when d /= CONV_STD_LOGIC_VECTOR(0,filt_width) else inpp;


end behav;

