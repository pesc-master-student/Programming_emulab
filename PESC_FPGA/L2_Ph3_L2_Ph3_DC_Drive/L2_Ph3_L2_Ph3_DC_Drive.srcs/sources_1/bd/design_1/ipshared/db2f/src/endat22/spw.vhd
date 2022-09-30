----------------------------------------------------------------------------------
--
-- File Name:        spw.vhd	
--
-- Project:          EnDat6
--
-- Modul Name:       spw
--
-- Specification:    ---
--                                                             
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Function:         Seriell-Parallel-Wandler 
--                         2 Seriell-Parallel-Wandler (fuer CRC, Daten)
--                         enspw, enspwcrc: enbl fuer Daten-, CRC-Empfang
--

-- History: 	     F.Seiler Original from EnDat4
--                   F.Seiler 30.04.2003 Initial Version for EnDat5
--                   F.Seiler       2004 CRC8 entfernt wegen Expr. Coverage
--                   F.Seiler 05.10.2004 activity test for EnDat6
--                   F.Seiler 15.02.2005 klgl_24 -> klgl_24 
--                   F.Seiler 07.11.2006 res2 eingefuegt
----------------------------------------------------------------------------------

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity spw is
   port(clk, nres, res2, ssi, fmsb, gray, clk_shift, Z1415, enspw, enspwcrc: in std_logic;
        shift_rest, ind, set_endat, parit_on, parit_ev, ready2, klgl_24 :  in std_logic;
        qspw :    out std_logic_vector(47 downto 0);
        qcrc :    out std_logic_vector( 4 downto 0);
        testcrc:  out std_logic_vector( 4 downto 0);
	par_fehl: out std_logic;
	
	enbl_for_wt_crc5 :  in  std_logic;             -- enable for test od CRC5 checker
        data_for_wt_crc5 :  in  std_logic;             -- serial data out
        rdy_wt_crc5      :  in  std_logic);            -- ready signal of WT CRC5 activity test
end spw;


Architecture behav of spw is
signal ind01, ind1, par_test,ready22,pf,pf1,LTF,itestcrc_0,enspw1,enspw1_wt : std_logic;
signal rq:                                    std_logic_vector(47 downto 0);
signal rqcrc:                                 std_logic_vector( 4 downto 0);
signal rqtestcrc:                             std_logic_vector( 4 downto 0);
signal ctcrc:                                 std_logic_vector( 3 downto 0);


begin

ind01      <= ind;

--Leertakt-Flag
---------------
   process(nres, clk)
   begin
     if (nres = '0') then 
			LTF <= '0';
     elsif clk'event and clk='1' then
 	    if LTF='0' and clk_shift='1' and enspw='1' then
			LTF <= '1';
 	    elsif ready2='1' then
			LTF <= '0';
        end if;
     end if;
   end process;



-- Datenempfaenger
------------------
ind1 <= (gray and (ind01 xor rq(0))) or ((not gray) and ind01);

   process(clk,nres)
   begin

      if nres = '0'  then
        rq      <= (others=>'0');
        ready22   <= '0'; 

      elsif clk'event and clk='1' then
              ready22 <= ready2;

             if (ready22 ='1' or set_endat ='1' or res2 ='1') then        -- fuer ssi ready22
	              rq  <= (others=>'0');

-- shift to right (LSB first; Werte > 24 Bit) 
             elsif fmsb='0' then
 		       if clk_shift='1' and enspw='1' then
			   if klgl_24 ='0' then 
		              rq    <=  ind1 & rq(47 downto 1);
                           else -- klgl_24 = 1
-- shift to right (LSB first; Werte <= 24 Bit) 
-- 		              rq(15 downto  0)  <=  ind1 & rq(15 downto 1);
--		              rq(47 downto 16)  <=  (others=>'0');
 		              rq(23 downto  0)  <=  ind1 & rq(23 downto 1);
		              rq(47 downto 24)  <=  (others=>'0');
                           end if;  -- klgl_24 
 
 		       elsif shift_rest='1' then   -- schieben bis rechts buendig
		           rq    <=  '0' & rq(47 downto 1);
                       end if;     --clk_shift, enspw

-- shift to left (MSB first)
             else    -- fmsb='1'
 		       if clk_shift='1' and enspw='1' and (ssi='0' or (ssi='1' and LTF='1')) then
		          rq    <= rq(46 downto 0) & ind1;
                       end if;
	     end if;
     end if;
   end process;



-- CRC-Empfaenger
------------------
   process(clk,nres)
   begin

      if nres = '0'  then
        rqcrc   <= (others=>'0');

      elsif clk'event and clk='1' then

           if (ready2 ='1' or set_endat ='1' or res2 ='1') then
              rqcrc  <= (others=>'0');

-- shift to left (LSB oder MSB first)        5-Bit CRC
 	   elsif clk_shift='1' and enspwcrc='1'  then  
	      rqcrc(4 downto 0) <= rqcrc(3 downto 0) & ind1;
	      
	   end if; 
      end if;
   end process;



--CRC-Test-Counter zum Ausblenden der Adressbits
------------------------------------------------
   process(nres, clk)
   begin
     if (nres = '0') then 
			ctcrc <= "1000";
     elsif clk'event and clk='1' then
 	    if (ready2='1' or set_endat ='1' or res2 ='1') then
			ctcrc <= "1000";
 	    elsif clk_shift='1' and (enspw='1' or Z1415='1') and ctcrc /="0000" then
			ctcrc <= ctcrc -'1';
        end if;
     end if;
   end process;


--CRC-Test 
----------
enspw1    <= enspw or Z1415;
enspw1_wt <= enspw or Z1415 or enbl_for_wt_crc5;

itestcrc_0  <=   ((enbl_for_wt_crc5 and rqtestcrc(4)) xor data_for_wt_crc5) when enbl_for_wt_crc5 ='1' else  -- WT_CRC5
                 ((enspw1           and rqtestcrc(4)) xor ind01);                                            -- working 

   process(nres, clk)
   begin
     if (nres = '0') then 
			rqtestcrc <= "11111";
     elsif clk'event and clk='1' then
 	    if (ready2='1' or set_endat ='1'  or res2 ='1'                   -- working mode
	                                      or rdy_wt_crc5= '1') then      -- after activity test
			rqtestcrc <= "11111";

 	    elsif 
	         (clk_shift='1' and (enspw='1' or Z1415='1'))                               -- workind mode
		                                              or enbl_for_wt_crc5 ='1' then -- activity test
			rqtestcrc(4) <= rqtestcrc(3);
			rqtestcrc(3) <= ((itestcrc_0 and enspw1_wt) xor rqtestcrc(2));
			rqtestcrc(2) <= rqtestcrc(1);
			rqtestcrc(1) <= ((itestcrc_0 and enspw1_wt) xor rqtestcrc(0));
			rqtestcrc(0) <= itestcrc_0;
        end if;
     end if;
   end process;





-- Paritaetspruefung bei SSI
----------------------------

test_par: process (nres, clk)
begin
        if nres = '0' then
                        par_test<='0';
                        pf1 <= '0';
        elsif clk'event and clk='1' then
                if  ready2='0' and ready22='1' then
                        par_test<='0';
                        pf1 <= '0';
                elsif (ind01='1' and clk_shift='1' and ssi='1' and LTF='1') then
                        par_test<= not par_test;
                elsif (ready2='1' and ssi='1' ) then 
                        pf1 <= pf;
		else 
		        Null;
                end if;
        end if;
end process;


pf        <=  (par_test xor parit_ev) and parit_on and ready2;
qcrc      <= rqcrc;
testcrc   <= rqtestcrc;
qspw      <= rq;
par_fehl  <=  pf1;

end behav;

