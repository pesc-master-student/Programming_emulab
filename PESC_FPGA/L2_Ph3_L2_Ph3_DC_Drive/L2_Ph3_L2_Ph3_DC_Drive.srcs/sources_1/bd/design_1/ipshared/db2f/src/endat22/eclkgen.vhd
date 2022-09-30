--*******************************************************************************************
--
--    Gesamtschaltung                                       eclkgen
--                                                          =======
-- Dateiname:        eclkgen.vhd
-- Project:          END_SAFE  
-- Modulname:        ---
-- Autor:            Frank Seiler/ MAZeT GmbH
-- Specification:    ---
--                                                             
-- Synthesis:        Synplify 9.6.1
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V8.21
-- 
-- Erstellungsdatum: 1998-2005 
-- History:          ---
--        F. Seiler  11/2002-7/2003 komplett ueberarbeitet
--                   F.Seiler xx.01.2005 Coverage 
--                   F.Seiler 15.02.2005 u16 -> klgl_24
--                   F.Seiler 01.11.2006 Changes allow_srg_reset, autom_srg_reset
--                   F.Seiler 12.02.2007 set_delay_rg
--                   F.Seiler xx.04.2008 2.Tst (warten bei TVLK-Low), TR verkuerzt
--                   F.Seiler 30.07.2008 Signaleausg. fuer TM Mess.
--                   F.Seiler 25.02.2009 Korrektur F-Type1
--                   F.Seiler 11.03.2009 50 MHz
--                   F.Seiler 17.09.2009 enbl_tm_z25 (LZ wegen Stoerung, TM-Mess.)
--                   F.Seiler 10.11.2010 Tst war teilweise zu kurz -> Z50 (2010.11.09)
--                                       (vgl. Mail v. Hrn. Kobler 2010.09.10)
--*******************************************************************************************

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
USE ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity eclkgen is 
   port(clk, nres: in std_logic; 
--      Time Base
        usc1  :                 in std_logic;
   	mhz_64, mhz_50, mhz_48, mhz_32, mhz_100: in std_logic; -- Select system frequency 
--      Signals from Port
        sel_cfg1 :              in  std_logic;         -- necessary for Delay Register
	write_pulse :           in  std_logic;         -- necessary for Delay Register
--      Signals for Configuration
   	set_ssi,set_endat, fmsb, klgl_24, start_eclk_hw, start_eclk_sw, enbl_dtakt: in std_logic;
        data_in, enbl_alarm2, parit_on, ssi_format, double_word: in std_logic;
        single_turn:            in  std_logic_vector( 4 downto 0);
        tx:                     in  std_logic_vector(29 downto 16);
        cfg_lzk:                in  std_logic_vector( 7 downto 0);
        mode :                  in  std_logic_vector( 2 downto 0);
        n_mode :                in  std_logic_vector( 2 downto 0);
        mode_11_33_44:          in  std_logic;   -- Mode Commands 1-1 ..6-6 
        mode_11_66_tx:          in  std_logic;   -- Mode Commands 1-1 ..6-6 Additional TX-Part
        mode_11_66:             in  std_logic;   -- Mode Commands 1-1 ..6-6
	mode_endat_2_1:         in  std_logic;   -- Mode Commands EnDat 2.1
	mode_kom_2_2:           in  std_logic;   -- Mode Command 2-2
        mode_7_0:               in  std_logic;   -- Mode Command 7-0
        mode_7:                 in  std_logic;   -- Mode Command 7-0
        mode_2:                 in  std_logic;   -- Mode Command 2
        mode_0:                 in  std_logic;   -- Mode Command 0
        cfg_freq:               in  std_logic_vector( 3 downto 0);
        dimp2 :                 in  std_logic_vector(imp_zahl -1 downto 0);
        cfg_time_tst:           in  std_logic_vector( 2 downto 0);
--      Signals for Cable Delay Measurement 
        enbl_lzk:               in  std_logic;
        del_ct:                 out std_logic_vector(7 downto 0);
        del_rg:                 out std_logic_vector(7 downto 0);
        lzm_ready, lzk_activ, enbl_tm_z25:   out std_logic;
--      Watch Dog Signals  
        watch_dog_pulse :       in  std_logic;  -- Breaking signal from watch dog
        watch_dog_soft_reset :  out std_logic;  -- Breaking signal to reset E.Statemachine without LZK
        watch_dog_hard_reset :  out std_logic;  -- Breaking signal to reset E.Statemachine and LZK
--      Output Signals 	
        ec_automat:             out std_logic_vector(5 downto 0);
        imp :                   out std_logic_vector(imp_zahl downto 0);
	dfreq_out:	        out std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
        clk_shift, freq_out, stopbit,Z1415,enspw, enspwcrc, shift_rest, enpsw, data_oe_n, enbl_dig_filt: out std_logic;
        alarm, alarm2, ld_alarm, ld_alarm2: out std_logic; 
        fb_typ_1:               out std_logic;
	dl_high, dui, ready1, ready2, ssi_flag, double_word_flag1, zusatz_flag: out std_logic;
        zibit :                 out std_logic_vector(1 downto 0);
        zict:                   out std_logic_vector(1 downto 0);
        qzict:                  out std_logic_vector(1 downto 0);
        allow_srg_reset:        out std_logic;
        autom_srg_reset:        out std_logic;
        srg_ready:              out std_logic;
        srg_ready_for_strobe:   out std_logic;
--      Signals for Test Mode
--        test_time:              in  std_logic;
--        fr_prog:                in  std_logic;
--        test_freq:              in  std_logic;
        ic_test_mode:           in  std_logic;
        tst_zi_sel:             in  std_logic_vector( 2 downto 0);
        test_max_s_ct:          out std_logic_vector(13 downto 0);
        test_s_ct:              out std_logic_vector(12 downto 0);
	test_qfreq:             out std_logic_vector(freq_widh -1 downto 0);
        test_flag_out:          out std_logic);
end eclkgen;

Architecture behav of eclkgen is

signal issi_flag, stop, enbl, enb2, enb12, enb22, rt, uend, ienpsw, ienspw, ienspwcrc, iready1,iready2: std_logic;
signal data_in1, data_in2, clki_shift, ialarm, ialarm2, q_fb_typ_1, fb_typ_1_flag, lzk, dl_high_i, enbl_qsstop2: std_logic;

signal qautomat:           std_logic_vector(5 downto 0);
signal ddfreq:             std_logic_vector(freq_widh -1 downto 0);
signal dfreq:              std_logic_vector(freq_widh -1 downto 0);
signal qfreq:              std_logic_vector(freq_widh -1 downto 0);
--signal qfreq_set_value:    std_logic_vector(freq_widh -1 downto 0);

signal qimp:                                     std_logic_vector(imp_zahl    downto 0);
signal dlimp, dlimp_i, dimp2_ssi, dimp2_ssi_minus_1:      std_logic_vector(imp_zahl    downto 0);
signal dimp2_ssi_i, dimp2_ssi_minus_1_i:         std_logic_vector(imp_zahl    downto 0);
signal ctq:                                      std_logic_vector(imp_zahl -1 downto 0);
signal dimp2_plus_crc,     dimp2_plus_crc_i:     std_logic_vector(imp_zahl +1 downto 0);
signal dimp2_plus_2zi_crc, dimp2_plus_2zi_crc_i: std_logic_vector(imp_zahl +1 downto 0);
signal dimp2_plus_1zi_crc, dimp2_plus_1zi_crc_i: std_logic_vector(imp_zahl +1 downto 0);

signal alarmbit_mode:  std_logic;                        -- Mode eingestllt, in dem Alarmbit gesendet wird
signal delay_ct:       std_logic_vector(7 downto 0);     -- Delay-CT misst das Wire-Delay
signal delay_rg:       std_logic_vector(7 downto 0);     -- RG fuer Wire-Delay
signal delay_flag:     std_logic;                        -- wird gesetzt, wenn Wire-delay ausgemessen wurde
signal delay_flag1,delay_flag11:    std_logic;           -- wird gebraucht, um bei kurzen Delays (<T/2) noch die H/L-Fl. im Z13 zuzulassen.
signal delay_flag2,delay_flag22:    std_logic;           -- wird gesetzt, wenn Wire-delay ausgemessen wurde und Automat f. neue Uebertragung bereit
signal delay_flag3:    std_logic;                        -- wenn das Flag gesetzt ist und durchlauf. Takt, dann wird Sendetakt dauerhaft generiert
signal delay_flag4:    std_logic;                        -- wenn das Flag gesetzt ist und durchlauf. Takt, dann wird Sendetakt dauerhaft generiert
signal delay_z13:      std_logic;                        -- verz�gert Z_13 um gemessenes Wire-delay
signal set_delay_rg, set_delay_rg1, start_delay_ct, correct_dui, rt1: std_logic;
signal rt_lh_flanke, rt_hl_flanke:  std_logic;
signal stop2:          std_logic;                        -- nur logisch verkn�pft
signal qstop2_i:       std_logic;                        -- nur logisch verkn�pft
signal qsstop2:        std_logic;                        -- aequivalent zu stop2 nur qsfreq-bezogen (stopt u.a. qfreq in Z25)
signal zusatz_flag_i:  std_logic;                        -- wird gesetzt, wenn PW und ZI vor�ber sind und Zusatz kommen kann
signal zusatz_flag2:   std_logic;                        -- wird gesetzt, Zusatz vorbei zur Unterscheidung in Z25 (stoppt qsfreq)

signal qsfreq:         std_logic_vector(9 downto 0);     -- Frequenz-Teiler fuer zu sendenden Takt --29.05.2000
signal srt:            std_logic;                        -- Toggle-FF fuer zu sendenden TCLK (bei Delay)
signal s_ct:           std_logic_vector(19 downto 0);    -- zeahlt die gesendeten Takte
signal sb_ct:          std_logic_vector(19 downto 0);    -- zeahlt die Takte bis das Startbit erscheint
signal max_s_ct, max_s_ct_i:       std_logic_vector(19 downto 0);    -- Anzahl der zu sendenden Takte
signal test_flag:      std_logic_vector(3 downto 0);     -- Testflags fuer Sendetakt und Startbit-Zaehler

signal t40_plus_crc, t24_plus_crc: std_logic_vector(5 downto 0);

signal send_zi1,send_zi2,send_not_zi1,send_not_zi2, send_not_zi12: std_logic; -- Coding to set Register for Count of ZI
signal rq_bit, zi_bit, zi_bit_i: std_logic_vector(1 downto 0);                -- State Machine (Register) for Count of ZI's (0,1,2)
signal zi_ct, zi_ct1:  std_logic_vector(1 downto 0);                          -- Flag fuer 1, 2 ZI's
signal zibit_i :       std_logic_vector(1 downto 0);                          -- for Receive of Empf.RG and Signalisation in TST1
signal mode_com_11_66: std_logic;                                             -- Mode commands 11 ..66
signal clear_zi_ct:    std_logic;                                             -- signals condition to clear zi_ct

signal time_tst:                           std_logic_vector(freq_widh -1 downto 0);    -- pre defined times and frequency
signal freq_200khz, time_500ns, time_test: std_logic_vector(freq_widh -1 downto 0);
signal ct_30us:                            std_logic_vector(4 downto 0); 
signal start_eclk:                         std_logic;
signal iready21, double_word_flag, double_word_flg1, restart_for_double_word: std_logic;
signal mode_zf:                                   std_logic; -- mode 1,3,4,5,6 and zusatz_flag
signal need_tr:                                   std_logic; 
signal watch_dog_soft_reset_i:                    std_logic;
signal wait_for_snd_qsstop2 :                     std_logic;
signal srg_ready_i, srg_ready_for_strobe_i:       std_logic;
signal autom_srg_reset_i:                         std_logic;
signal ready_delay_ct_z25, busy_delay_ct_z25 :                       std_logic;
component time_table
   port(
	clk, nres:              	 in std_logic; -- system clock , reset
	mhz_64, mhz_50, mhz_48, mhz_32, mhz_100: in std_logic; -- define the system frequency
	cfg_freq:                        in std_logic_vector(3 downto 0);
	cfg_time_tst:                    in std_logic_vector(2 downto 0);
	--
	dfreq:	                         out std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
	time_tst:                        out std_logic_vector(freq_widh-1 downto 0); -- Recovery time Tst
	time_500ns:                      out std_logic_vector(freq_widh-1 downto 0);
	freq_200khz:                     out std_logic_vector(freq_widh-1 downto 0);
	time_test:                       out std_logic_vector(freq_widh-1 downto 0));
end component;


begin


Frequ: time_table
   port map(
	clk, nres,                       -- system clock, reset
	mhz_64, mhz_50, mhz_48, mhz_32, mhz_100, -- define the system frequency
	cfg_freq,
	cfg_time_tst,
	--
	dfreq,
	time_tst,
	time_500ns,
	freq_200khz,
	time_test);

restart_for_double_word <= double_word and iready2 and (not iready21) and (not double_word_flag);

zusatz_flag <= zusatz_flag_i;
--mode_all    <= mode & n_mode;

start_eclk  <= ((start_eclk_hw or start_eclk_sw) and stop);   -- Codierung verhindert zu fruehes Starten
enbl        <= start_eclk or restart_for_double_word;

din_flanke:   process (nres,clk)
   begin
      if nres = '0'  then       
            data_in1  <= '1';
      elsif clk'event and clk='1' then
            data_in1  <= data_in;
      end if;
   end process;

 data_in2   <= (not data_in) and data_in1 ;


doub_word:   process (nres,clk)
   begin
      if nres = '0'  then       
            iready21          <= '0';
            double_word_flag  <= '0';
            double_word_flg1  <= '0';
      elsif clk'event and clk='1' then
            iready21  <= iready2;
            double_word_flg1 <= double_word_flag;

         if iready2 = '1' and iready21 ='0' and double_word='1' then 
            if double_word_flag = '0' then
              double_word_flag <= '1';
            else
              double_word_flag <= '0';	    
            end if;

         elsif   start_eclk = '1'   then
            double_word_flag <= '0';

--         elsif iready2 ='1' and iready21 ='0' and double_word_flag ='1' then
--            double_word_flag <= '0';
         end if;
      end if;
   end process;

double_word_flag1 <= double_word_flg1;

-----------------------------------------------------------------------------------------------------------------------------------
-- Ablaufsteuerung (EnDat-Automat)
-----------------------------------------------------------------------------------------------------------------------------------
automat:   process (nres,clk)
   begin
      if nres = '0'  then        --   SW-Reset krg(7) = '1' mit NRES odern
         qautomat      <= "000100";
         issi_flag     <= '0';
         delay_z13     <= '0';
	 zi_ct         <= "00";
	 zusatz_flag_i <= '0';
         enbl_qsstop2  <= '0';
         zusatz_flag2  <= '0';
         enbl_dig_filt <= '0';
         wait_for_snd_qsstop2 <= '0';
      elsif clk'event and clk='1' then
--             qqautomat <= qautomat;
         if  (set_ssi='1') then
             qautomat <= "000101";
             issi_flag     <= '1';
         elsif (set_endat='1' or watch_dog_soft_reset_i='1') then
                  qautomat      <= "000100";
                  issi_flag     <= '0';
         	  delay_z13     <= '0';
	 	  zi_ct         <= "00";
	 	  zusatz_flag_i <= '0';
                  enbl_qsstop2  <= '0';
                  zusatz_flag2  <= '0';
                  wait_for_snd_qsstop2 <= '0';
         else
            case qautomat is

               when "011000" =>                                          -- Z_24
                  if data_in='1' then
                     qautomat <= qautomat+1;                             -- Nach Empfang des letzten Bits geht DL auf h (max. 30us)
                     enbl_qsstop2 <= '1';
                  end if;

               when "011001" =>                                          -- Z_25 Ohne LZK
                  if delay_flag2='0' then
                     if data_in2='1' then
                        qautomat <= "011010";
                     end if;
                  elsif data_in='0' then                                 -- delay_flag2 = '1' and ...
--                     if qsstop2='1' or mode_11_33_44 = '1' then                                 -- Z_25 hier Synch von qsfreq (srt-rt)
                     if qsstop2='1'  then                                 -- Z_25 hier Synch von qsfreq (srt-rt)
                        qautomat <= "011010";                            -- or 
                     elsif  mode_11_33_44 = '1' then                     -- Z_25 hier Synch von qsfreq (srt-rt) 
                        if ready_delay_ct_z25 = '1' then                 -- Laufzeit muss bei 1-1 Befehlen abgewartet werden
                        qautomat <= "011010";                            -- or 
                        end if;
                     end if;                                             -- Z_25 Am Ende der 1-1 .. 6-6 Befehle
                  end if;

               when "011010" =>                                          -- Z_26
                  qautomat <= qautomat+1;

               when "011011" =>                                          -- Z_27
                  if (stop2='1' and data_in='0') then
                     qautomat <= "000100";
                     enbl_qsstop2 <= '0';
                     zusatz_flag2 <= '0';
                  end if;

               when "000100" =>                                          -- Z_4
                  if enb12 = '1' then                                    -- rising edge of enbl
                     qautomat <= qautomat+1;
                  end if;

               when "000101" =>                                          -- Z_5
                  if (issi_flag='0' and stop2='1') then
                     qautomat <= qautomat+1;
                  end if;

               when "000110" =>                                          -- Z_6
                  qautomat <= qautomat+1;

               when "000111" =>                                          -- Z_7
	          if stop2='1' then
                     if mode_11_66_tx = '1' then                         ---> Z_52 Takt f.SBit fuer Zusatz bei 1-1..6-6
                        qautomat <= "110100";                                                             
                     else
                        qautomat <= qautomat+1;                          ---> Z_8  Normalfall
                     end if;
                  end if;

	       when "110100" =>                                          -- Z_52 -> Z_53  Leertakt (Low) vor SBit 
                  qautomat <= "110101";

	       when "110101" =>                                          -- Z_53
                  if stop2='1' then
                     qautomat <= qautomat+1;
                  end if;

               when "110110" =>                                          -- Z_54
                  qautomat <= qautomat+1;                                ---> Z55   Startbit fuer Zusatz

	       when "110111" =>                                          -- Z_55
                  if stop2='1' then                                      ---> Z_8 
                     qautomat <= "001000";	  
                  end if;

               when "001000" =>                                          -- Z_8 
                  qautomat <= qautomat+1;

	       when "001001" =>                                          -- Z_9
                  if stop2='1'then 
                     if zusatz_flag_i ='0' then
                        qautomat <= qautomat+1;                          ---> (alte M.-Befehle)
                     else
                        qautomat <= "110000";                            ---> Z_48 Zusatz bei 1-1,3-3,4-4
                     end if;
                  end if;

               when "001010" =>                                          -- Z_10
                  qautomat <= qautomat+1;

               when "001011"  =>                                         -- Z_11
                  if stop2='1' then
                     qautomat <= "011110";
                  end if;

	       when "110000" =>                                          -- Z_48 -> Z_49 2 Leertakte
                  qautomat <= "110001";
                  zusatz_flag2 <= '1';                                   -- to stop qsfreq counter in Z_25

	       when "110001" =>                                          -- Z_49
                  if stop2='1' then                                      ---> Z_20 fertig
                     qautomat <= "010100";
                     zi_ct    <= "00";
                  end if;

               when "011110" =>                                          -- Z_30
                  if delay_flag2 = '1' then                              --->Z_42 mit Delay kein Warten mehr 18.9.01
                     qautomat <= "101010";                               -- (delay_flag2='1' if lzk='1' only, else '0')
                  else                                                   -- Z_31 -ohne Delay
                     qautomat <= qautomat+1;
                  end if;

               when "011111" =>                                          -- Z_31
                  if stop2='1' and data_in = '0' then                   
                     qautomat <= "001100";
                  end if;

               when "101010" =>                                          -- Z_42
                  qautomat <= qautomat+1;

               when "101011" =>                                          -- Z_43
                  if stop2='1'  then
                     qautomat <= "001100";
                  end if;

---------------------------------------------------------------------------------------------------------------------------------
--          Warten auf Startbit (1. Uebertragung - noch kein Wire-Delay gemessen)

               when "001100" =>                                          -- Z_12
                  qautomat <= qautomat+1;

               when "001101" =>                                          -- Z_13
                  if delay_flag2='0' then
	             if stop2 ='1' then
	                if data_in='0' then                              -- Warten auf Startbit
	                   if delay_z13='0' then                      
                              qautomat <= "001100";
                              enbl_dig_filt <= '1';                      -- to diskriminate Spikes while Switch RX/TX
                           end if;
---------------------------------------------------------------------------------------------------------------------------------
--          Startbit erkannt  - Messen Wire-Delay
                        else                                             -- data_in='1'    
                           enbl_dig_filt <= '1';                         -- to diskriminate Spikes while Switch RX/TX
                           if alarmbit_mode = '1' then                   ---> Z_14  Mode m. Alarmbit (DL=H, da else-Zweig)
                              qautomat  <= "001110";
                           else                                          -- alarmbit_mode = '0'
                              qautomat  <= "010000";                     ---> Z_16  Mode o. Alarmbit (DL=H, da else-Zweig)
                           end if;
                        end if;
                     end if;                                             -- stop2 ='1'
                  else                                                   -- delay_flag2='1'
---------------------------------------------------------------------------------------------------------------------------------
--          Warten auf Startbit und Erkennen (2,3,...n-te Uebertragung - Wire-Delay bereits bei 1. Uebertragung gemessen)
                     if  delay_z13 ='0' then
                        if qfreq = ddfreq  then                          -- Z_13 Start Delay auf TCLK-HL
	                   qautomat <= qautomat;
                           delay_z13 <= '1';
                        end if;
                     else                                                -- delay_z13 ='1'
                        if  delay_ct = delay_rg  then                    -- Z_13 Ende Delay
                           delay_z13 <= '0';
                           qautomat <= "100010";
                        end if;
                     end if;
                  end if; -- delay_flag2

               when "100010" =>                                          -- Z_34  Z_34/_35 2 ausgeblendete TCLK-Flanken 
                  qautomat <= "100011";
                  enbl_dig_filt <= '1';                                  -- to diskriminate Spikes while Switch RX/TX


               when "100011" =>                                          -- Z_35
	          if data_in = '0' then                                  -- Startbitpruefung  (kein Startbit)
                     qautomat <= "100100";                               ---> Z_36
                  else                                                   -- data_in='1'  
                     if alarmbit_mode = '1' then                         -- Startbit erkannt - Mode mit Alarmbit
                        qautomat <= "001110";                            --->Z14
                     else                                                -- alarmbit_mode = '0' --> Mode ohne Alarmbit
                        qautomat <= "010000";                            --->Z16
                     end if; 
                  end if;

               when "100100" =>                                          -- Z_36
                  qautomat <= "100101";                                  ---> Z_37

               when "100101" =>                                          -- Z_37
                  if stop2='1'  then                                      
                     if data_in='0' then                                 -- Startbitpruefung (kein Startbit) stop2
                        qautomat <= "100100";
                     else                                                                             
                        if alarmbit_mode = '1' then                      -- Startbit erkannt  - Mode mit Alarmbit stop2    
                           qautomat <= "001110";                         --->Z_14
                        else                                             -- alarmbit_mode = '0' Mode ohne Alarmbit
                           qautomat <= "010000";                         --->Z_16
                        end if; 
                     end if; 
                  end if;

---------------------------------------------------------------------------------------------------------------------------------
--          Warten auf Alarmbit und Erkennen 
               when "001110" =>                                          -- Z_14
                  qautomat <= qautomat+1;

               when "001111" =>                                          -- Z_15
                  if stop2='1' then                                      -- kein Abbruch mehr
   		     if enbl_alarm2= '0' then
                       qautomat <= qautomat+1;				 ---> Z_16 (Es wird nur ein Alarmbit uebertragen)  25.09.02
		     else 
                       qautomat <= "111110";				 ---> Z_62 (Es werden 2 Alarmbits uebertragen)
		     end if;
                  end if;

               when "111110"  =>                                         -- Z_62 Alarmbit 2
                  qautomat <= qautomat+1;

               when "111111" =>                                          -- Z_63
                  if stop2='1' then                                      -- kein Abbruch mehr
                     qautomat <= "010000";
                  end if;

---------------------------------------------------------------------------------------------------------------------------------
--          Daten- und CRC-Empfang
               when "010000" =>                                          -- Z_16
                  qautomat <= qautomat+1;

               when "010001" =>                                          -- Z_17
                  if stop2='1' then                                      -- Daten
                     qautomat <= qautomat+1;
                  end if;

               when "010010" =>                                          -- Z_18
                  qautomat <= qautomat+1;

               when "010011" =>                                          -- Z_19
                  if stop2='1' then
                     if (mode_endat_2_1 = '1'  or                        -- 2.1-Befehle
                         mode_kom_2_2   = '1') then                      -- 2-2 Kommun
                          qautomat <= qautomat+1;                          ---> Z_20
                          zi_ct    <= "00";
                     end if;
                     if clear_zi_ct ='1' then                            -- clear of counter zi_ct
	                 if mode_7_0 = '1' then                          -- 7-0 Befehl
                            qautomat <= qautomat+1;                      ---> Z_20
                            zi_ct    <= "00";
                         end if;

                -- Nach Empfang der ZI kann Automat zum Parameter-Empf. uebergehen (Z_50/51)
                         if mode_11_66 = '1'  then                      -- 1-1..6-6  
                            qautomat <= "110010";                        ---> Z_50
                            zi_ct    <= "00";
                         end if;

                     else
                         if (mode_7_0 or mode_11_66) = '1' then
                            qautomat <= "101100";                           ---> Z_44
                            zi_ct    <= zi_ct + '1';
                         end if;
                     end if;
                  end if;

               when "101100" =>                                          -- Z_44
                  qautomat <= qautomat+1;

               when "110010" =>                                          -- Z_50
                  if q_fb_typ_1 = '1' then
                     qautomat <= "011000";                      ---> Z_24 Stop when F-Typ1 Error
                  else
                     qautomat <= qautomat+1;
                  end if;
                     enbl_qsstop2 <= '1';                                   -- to stop qfreq in Z_51

               when "101101" =>                                          -- Z_45
                  if stop2='1' then                                      ---> Z16 Leertakt vor ZI
                     qautomat <= "010000";
                  end if;

               when "110011" =>                                          -- Z_51
                  if delay_flag2='0' then
                     if stop2='1' then                                   ---> Z_46 Leertakt vor Zusatz (1-1..6-6)
                        qautomat <= "101110";		                 -- ohne LZK
		        zusatz_flag_i  <= '1';                           -- tst war zu kurz 2010.11.09  		  
                     end if;
                  else                                                   -- delay_flag2='1'
                     if qsstop2='1' then	                         ---> Z_46 Leertakt vor Zusatz (1-1..6-6)
                        if wait_for_snd_qsstop2 = '1' then               -- tst war zu kurz 2010.11.09 -> 1/2 TCLK laenger
                          qautomat <= "101110";		                 -- mit LZK Synchr. mit qsstop, damit letzer Takt
		          zusatz_flag_i  <= '1';                         -- vollstaendig ist
                        else
                          wait_for_snd_qsstop2 <= '1';
                        end if;
                     end if;
                  end if;

               when "101110" =>                                          -- Z_46
                  qautomat <= "000101";                                  ---> Z_5
		  enbl_qsstop2 <= '0';
                  enbl_dig_filt <= '0';
                  wait_for_snd_qsstop2 <= '0';

---------------------------------------------------------------------------------------------------------------------------------
--          Ende + Uebergang zur naechsten Uebertragung
               when "010100"  =>                                         -- Z_20
	          if enbl_dtakt = '1' then                               -- Verzweigung: durchlauf. /unterbr. Takt
                     qautomat <= "010110";                               ---> Z_22
		     zusatz_flag_i  <= '0';      
                  else                                                   -- enbl_dtakt = '0'
                     qautomat <= "011000";                               ---> Z_24 (unterbr. Takt)
		     zusatz_flag_i  <= '0';      
                     enbl_dig_filt  <= '0';
                  end if;

               when "010110" =>                                          -- Z_22  (durchl. Takt)
                  qautomat <= qautomat+1;

               when "010111"  =>
                  if uend='1' and data_in='0' then
                     if delay_flag4 = '0' then                           -- Z23 -> Z12   28.08.01 Delay einarbeiten in dT
                        qautomat <= "001100";
                     else                                                -- Z23 -> Z36   Delay ist bereits eingearb. 
                        qautomat <= "100100";
                     end if;
                  end if;
---------------------------------------------------------------------------------------------------------------------------------
               when others => null;
                   
            end case;
        end if;
      end if;
   end process;
---------------------------------------------------------------------------------------------------------------------------------

-- Clear condition for zi_ct (used at Z_19 of FSM)
--------------------------------------------------
clear_zi_ct <= '1' when  (zi_bit="00" or                             -- 0 ZI sel.
                         (zi_bit="01" and zi_ct="01") or             -- 1 ZI sel.
                         (zi_bit="10" and zi_ct="10")) else          -- 2 ZI sel.
               '0';


-----------------------------------------------------------------------------------------------------------------------------------
-- Festlegen der Anzahl der TCLK-Takte
-----------------------------------------------------------------------------------------------------------------------------------
dimp2_ssi_i  <= (("0" & dimp2) + '1') when parit_on ='0' else -- 1 Clock more, because the 1.Bit will be accept withe the 2.LH-TCLK-Edge
                (("0" & dimp2) + '1'+ '1');                   -- 2 Clocks more, becaus additional to this parity_bit

dimp2_ssi_minus_1_i  <= (("0" & dimp2) + '1');

d_impuls: process (qautomat, issi_flag, dimp2, dimp2_ssi, mode_0, mode_2, mode_7, mode_11_66_tx, zi_ct)
begin
case qautomat is
   when "010110"|"010111" =>                                         -- Z22, Z23
         dlimp_i  <= "0000100";
   when "011000"|"011001" =>                                         -- Z24, Z25
         dlimp_i  <= "0000001";
   when "011010"|"011011" =>                                         -- Z26, Z27
         dlimp_i  <= "0000001";
   when "000100" =>                                                  -- Z4
         dlimp_i  <= "0000010";
   when "000101" =>                                                  -- Z5
         if issi_flag='1' then
            dlimp_i  <= (dimp2_ssi(imp_zahl- 1 downto 0) &'0');
         else
            dlimp_i  <= "0000001";
         end if;
   when "000110"|"000111" =>                                         -- Z6, Z7
         dlimp_i  <= "0000010";
   when "001000"|"001001" =>                                         -- Z16, Z17
         dlimp_i  <= "0111100";                                          --> 30 Takte
         if (mode_0='1' or mode_2='1' or mode_7='1') then
            dlimp_i  <= "0001100";                                       -->  6 Takte
         end if;
         if mode_11_66_tx='1' then
            dlimp_i  <= "0110000";                                       --> 24 Takte bei Zusatz
         end if;
   when "001010"|"001011" =>                                         -- Z10, Z11
         dlimp_i  <= "0000101";
   when "011110"|"011111" =>                                         -- Z30, Z31
         dlimp_i  <= "0000001";
   when "101010"|"101011" =>                                         -- Z42, Z43
         dlimp_i  <= "0000001";
   when "001100"|"001101" =>                                         -- Z12, Z13
         dlimp_i  <= "0000010";
   when "100010"|"100011" =>                                         -- Z34, Z35
         dlimp_i  <= "0000001";
   when "100100"|"100101" =>                                         -- Z36, Z37
         dlimp_i  <= "0000010";
   when "101100"|"101101" =>                                         -- Z44, Z45 (ZI)
         dlimp_i  <= "0000010";
   when "101110" =>                                                  -- Z46
         dlimp_i  <= "0000001";
   when "110000"|"110001" =>                                         -- Z48, Z49 (Zusatz 3 (2,5) Leertakte)
         dlimp_i  <= "0000110";
   when "110010"|"110011" =>                                         -- Z50, Z51 (Zusatz 1-1,3-3,4-4,5-5,6-6 Leer-Takt)
         dlimp_i  <= "0000011";
   when "110100"|"110101" =>                                         -- Z52, Z53 (Zusatz 1-1,3-3,4-4,5-5,6-6 Low-Takt)
         dlimp_i  <= "0000010";
   when "110110"|"110111" =>                                         -- Z54, Z55 (Zusatz 1-1,3-3,4-4,5-5,6-6 High-Takt (Startbit))
         dlimp_i  <= "0000010";
   when "001110"|"001111" =>                                         -- Z14, Z15
         dlimp_i  <= "0000010";
   when "111110"|"111111" =>                                         -- Z62, Z63
         dlimp_i  <= "0000010";
   when "010000"|"010001" =>
         dlimp_i  <= "0110000";                                      -- 24 Takte fuer Zusatz-Info
         if (mode_0 ='1') or (mode_7 ='1' and zi_ct = "00") then     -- Empfange POS
            dlimp_i  <= dimp2 &'0';
         end if;
         if mode_2='1' then
            dlimp_i  <= "1010000";                                   -- 40 Takte fuer Testwerte
         end if;
   when "010010"|"010011" =>                                         -- Z18, Z19 (CRC5)
         dlimp_i  <= "0001010";
   when  others  =>
         dlimp_i  <= (others =>'0');
end case;
end process;

--==========================================================================================
-- Define Times of TCLK
-----------------------
need_tr <= '1' when delay_flag2 ='1' and (delay_rg < time_500ns(7 downto 0)) else '0';

ddfreq <=
          time_tst                               when qautomat ="000101" and issi_flag = '0'                        -- EnDat
	                                                                 and (
									      (not(delay_flag2 ='0' and lzk='1'))
									      and 
									      (zusatz_flag_i = '0')                 -- only first tst
									     )                                 else -- Recovery Time "Tst" 

          time_tst                               when qautomat ="000101" and issi_flag = '1' and double_word_flag ='0'
	                                                                 and qimp = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1) -- SSI
									 and iready2='0' else                       -- Recovery Time "Tst" 

          time_500ns                             when qautomat ="011010" else  -- Delay 500 ns 
          time_500ns                             when qautomat ="011011" and need_tr = '1'else
          "0000000010"                           when qautomat ="011011" else

          CONV_STD_LOGIC_VECTOR(1,freq_widh)     when qautomat ="000100" else  -- Z_4

          CONV_STD_LOGIC_VECTOR(1,freq_widh)     when qautomat ="100010" else  -- Z_34
          CONV_STD_LOGIC_VECTOR(1,freq_widh)     when qautomat ="100011" else  -- Z_35  dfreq

          freq_200khz                            when delay_flag2 ='0' and lzk='1' else -- 200KHz for Wire-Delay-Measurement.
	                                                                                 dfreq;


enb22 <=
--        '1'       when qautomat ="000000" else   -- Z0
--        '1'       when qautomat ="000010" else   -- Z2
          '1'       when qautomat ="000110" else   -- Z6
          '1'       when qautomat ="001000" else   -- Z8
          '1'       when qautomat ="001010" else   -- Z10
          '1'       when qautomat ="011110" else   -- Z30
--          '1'       when qautomat ="101000" else   -- Z40  -- tbd
          '1'       when qautomat ="101010" else   -- Z42
          '1'       when qautomat ="101100" else   -- Z44
          '1'       when qautomat ="101110" else   -- Z46
          '1'       when qautomat ="110000" else   -- Z48
          '1'       when qautomat ="110010" else   -- Z50
          '1'       when qautomat ="110100" else   -- Z52
          '1'       when qautomat ="110110" else   -- Z54
          '1'       when qautomat ="001100" else
          '1'       when qautomat ="001110" else   -- Z14 
          '1'       when qautomat ="111110" else   -- Z62 
--        '1'       when qautomat ="100000" else 
          '1'       when qautomat ="100010" else 
          '1'       when qautomat ="100100" else 
          '1'       when qautomat ="010000" else
          '1'       when qautomat ="010010" else
          not lzk   when qautomat ="010110" else -- Urspruenglich wirkte enb22 mit Z22. Mit dfreq=3 (4MHz TCLK) muss dies 
          lzk       when qautomat ="010100" else -- schon mit Z20 wirken. Diese Unterscheidung ist da, damit die alten Sim.nicht geaendert werden muessen.
          '1'       when qautomat ="011000" else   -- Z24 Ausblenden geht hier nicht, da qfreq aktiv sein muss.
          '1'       when qautomat ="011010" else   -- Z26 
--          '1'       when qautomat ="011100" else 
          enb12     when qautomat ="000100" else   -- nur in den Zustaenden (4,5) wird externes Strobe zugelassen. 
          enb12     when issi_flag='1' else '0';   -- if issi_flag=1 then Z5 !!


ienpsw <=    '0'    when issi_flag='1'      else 
             uend   when qautomat ="001000" else
             '1'    when qautomat ="001001" else
             '1'    when qautomat ="001010" else '0';

gen_enspw: process (qautomat,issi_flag,parit_on,ssi_format,qimp,dimp2_ssi_minus_1,single_turn)
begin
if issi_flag='1' then
   if ssi_format='1' then
      if parit_on='0' then
         ienspw <= '1'; 
      elsif qimp < (dimp2_ssi_minus_1(imp_zahl- 1 downto 0) &'0') then
         ienspw <= '1'; 
      else
         ienspw <= '0';
      end if;
   else
      if qimp < (("001101" + single_turn) &'0') then
         ienspw <= '1';
      else
         ienspw <= '0';
      end if;
   end if;
else
   case qautomat is
      when "010000"|"010001" => ienspw <= '1';
      when others            => ienspw <= '0'; 
   end case;
end if;
end process;
	     

ienspwcrc <= '1'    when qautomat ="010010" else
             '1'    when qautomat ="010011" else '0';



sh_rest: process (qautomat, ctq)
begin
if ctq /= "000000" then
  case qautomat is
    when "010010"|"010011"|"010100"|"010110" =>                       -- Z_18,Z_19,Z_20,Z_22
        shift_rest <='1';
    when others =>
        shift_rest <='0';
  end case;
else
  shift_rest <='0';
end if;
end process;


data_oe_n <= '0'  when (qautomat ="110100" or qautomat ="110101") else                               -- Z52, Z53 Leertakt
             '0'  when (qautomat ="110110" or qautomat ="110111") else                               -- Z54, Z55 Startbit
             '0'  when (qautomat ="001000" or qautomat ="001001") else                               -- Z8,Z9
             '0'  when qautomat  ="001010" else                                                      -- Z10,Z11: Rest +1/2 Takt 
             '0'  when qautomat  ="001011" and qimp = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1) else
             '0'  when qautomat  ="001011" and qimp = CONV_STD_LOGIC_VECTOR(2,imp_zahl+1) else 
             '0'  when qautomat  ="110000" else                                                      -- Z48,Z49: Rest +1/2 Takt
             '0'  when qautomat  ="110001" and qimp = CONV_STD_LOGIC_VECTOR(1,imp_zahl+1) else 
             '0'  when qautomat  ="110001" and qimp = CONV_STD_LOGIC_VECTOR(2,imp_zahl+1) else '1';
	     	     	     
ialarm    <= '1'  when qautomat  ="001111" and data_in='1' and stop2='1' else '0';
ialarm2   <= '1'  when qautomat  ="111111" and data_in='0' and stop2='1' else '0';
ld_alarm  <= '1'  when qautomat  ="001111"                 and stop2='1' else '0';
ld_alarm2 <= '1'  when qautomat  ="111111"                 and stop2='1' else '0';

iready1   <= '1'  when qautomat ="000100" or (issi_flag='1' and  stop='1') else '0'; -- tbd

iready2   <= '1'  when qautomat ="110010" else                           -- Z_50
	     '1'  when qautomat ="101100" else                           -- Z44
             '1'  when (qautomat ="010100" and zusatz_flag_i ='0') else  -- Z20
             uend  when issi_flag='1' else '0';                          -- SSI

Z1415     <= '1'  when  qautomat ="001111" else         --15,62,63 
	     '1'  when  qautomat ="111110" else
	     '1'  when  qautomat ="111111" else '0';


alarmbit_mode <= '1' when (mode_0 ='1' or mode_2 ='1' or  mode_7 ='1') else '0'; -- '1', wenn Mode, in dem Alarmbit gesendet wird

process(nres, clk)
  begin
    if (nres = '0') then 
          q_fb_typ_1  <= '0';
    elsif clk'event and clk='1' then
        if set_endat = '1' or set_ssi = '1'  then
          q_fb_typ_1  <= '0';
        elsif qautomat = "001101" or qautomat = "100011" or qautomat = "100101" then   -- Z_13, Z_35, Z_37
	  q_fb_typ_1  <= '1';
        elsif clki_shift='1' and data_in = '0'  then
	  q_fb_typ_1  <= '0';
        elsif qautomat = "000100"  then
	  q_fb_typ_1  <= '0';
        end if;
    end if;
end process;
fb_typ_1  <= '1' when qautomat = "010100" and q_fb_typ_1  = '1' else
             '1' when qautomat = "110010" and q_fb_typ_1  = '1' else '0';

--========================================================================================
-- Pipeline
-----------

zi_ff:   process (nres,clk)
   begin
      if nres = '0'  then       
            zi_ct1  <= "00";
      elsif clk'event and clk='1' then
            zi_ct1  <= zi_ct;
      end if;
   end process;
	
zict      <= zi_ct;
qzict     <= zi_ct1;

--========================================================================================
-- Selection of ZI
--================

-- State Machine for Count of ZI's
----------------------------------

send_zi1      <= '1' when tx(29 downto 24) = "001001" and tx(23 downto 20) = "0100" and tx(19 downto 16) /= "1111"else '0';
send_zi2      <= '1' when tx(29 downto 24) = "001001" and tx(23 downto 20) = "0101" and tx(19 downto 16) /= "1111"else '0';
send_not_zi1  <= '1' when tx(29 downto 24) = "001001" and tx(23 downto 16) = "01001111" else '0'; -- 4F
send_not_zi2  <= '1' when tx(29 downto 24) = "001001" and tx(23 downto 16) = "01011111" else '0'; -- 5F
send_not_zi12 <= '1' when tx(29 downto 24) = "101010"                                   else '0'; -- Mode 5 --(MS receive RESET)

zi_state:   process (nres,clk)
   begin
      if nres = '0'  then       
             rq_bit  <= "00";
      elsif clk'event and clk='1' then

        if qautomat = "010100" then                        -- Still when Z20

          if send_not_zi12 = '1'                     then  -- MS receive RESET
             rq_bit  <= "00";
          end if;

        elsif qautomat = "110000" then                        -- Still when Z48

          case rq_bit is
             when "00" =>
                if send_zi1 = '1' then
                   rq_bit  <= "01";                  -- Select ZI1 (only one ZI)
                end if;
                if send_zi2 = '1' then
                   rq_bit  <= "10";                  -- Select ZI2 (only one ZI)
                end if;
             when "01" =>
                if send_zi2 = '1' then
                   rq_bit  <= "11";                  -- Select ZI2 in a second step after ZI1 (now two ZI)
                end if;
                if send_not_zi1 = '1' then
                   rq_bit  <= "00";                  -- After selecting ZI1 -> deselect ZI1
                end if;
             when "10" =>
                if send_zi1 = '1' then
                   rq_bit  <= "11";                  -- Select ZI1 in a second step after ZI2 (now two ZI)
                end if;
                if send_not_zi2 = '1' then
                   rq_bit  <= "00";                  -- After selecting ZI2 -> deselect ZI2
                end if;
             when others =>
                if send_not_zi1 = '1' then
                   rq_bit  <= "10";                  -- After selecting two ZI -> deselect ZI1
                end if;
                if send_not_zi2 = '1' then
                   rq_bit  <= "01";                  -- After selecting two ZI -> deselect ZI2
                end if;
           end case;
        end if;
      end if;
   end process;


-- Mux for manuell ZI-Setting or ZI-State Machine
-------------------------------------------------

bit_mux:  process(tst_zi_sel, rq_bit)

    variable addr: std_logic_vector(4 downto 0);

    begin
    addr := tst_zi_sel(2 downto 0) & rq_bit(1 downto 0);
        case addr is
           when "00000"   => zi_bit_i <= "00"; -- Automatic Mode for ZI
           when "00001"   => zi_bit_i <= "01";
           when "00010"   => zi_bit_i <= "01";
           when "00011"   => zi_bit_i <= "10";

           when "00100"   => zi_bit_i <= "01"; -- Set Z1 by TST2 (Only 1 ZI)
           when "00101"   => zi_bit_i <= "01"; 
           when "00110"   => zi_bit_i <= "01";
           when "00111"   => zi_bit_i <= "01";

           when "01000"   => zi_bit_i <= "01"; -- Set Z2 by TST2 (Only 1 ZI)
           when "01001"   => zi_bit_i <= "01"; 
           when "01010"   => zi_bit_i <= "01";
           when "01011"   => zi_bit_i <= "01";

           when "01100"   => zi_bit_i <= "10"; -- Set Z2+ZI1 by TST2
           when "01101"   => zi_bit_i <= "10"; 
           when "01110"   => zi_bit_i <= "10";
           when "01111"   => zi_bit_i <= "10";
	   
           when others    => zi_bit_i <= (others=>'0');
       end case;
   end process;


zibit_i   <= rq_bit when tst_zi_sel = "000"  else 
             "00"   when tst_zi_sel(2) = '1' else tst_zi_sel(1 downto 0); 
	     

--========================================================================================
-- prozess zum rechts-buendig schieben

   process (nres,clk)    -- Korrektur 16.01.2005 16->24 @ klgl_24 active
   begin
       if (nres = '0') then 
			ctq  <= "000000";
       elsif clk'event and clk='1' then
         if (set_ssi='1' or set_endat='1' or watch_dog_soft_reset_i='1') then 
               ctq  <= "000000";
         elsif qautomat ="010010" and fmsb='0' then

	    if  klgl_24='0' then
               ctq <= "110000" - dimp2;
            else
               ctq <= "011000" - dimp2;
            end if;
	    
	 elsif ctq /= "000000" then
               ctq <= ctq - '1';
	 end if;
       end if;
   end process;


-- Impuls-CT, Frequenzteiler

   process (clk,nres)
   begin

   if (nres = '0') then    -- Korrektur 31.05.2000                                       

            qfreq   <= CONV_STD_LOGIC_VECTOR(1,freq_widh);
            qimp    <= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1);

   elsif clk'event and clk='1' then

--      if ic_test_mode='1' and   test_freq ='0' then                                           -- Testmode
      if ic_test_mode='1'  then                                                                 -- Testmode
	    qfreq   <= qfreq + '1' ;
			
      elsif (set_ssi='1' or set_endat='1' or watch_dog_soft_reset_i='1' or qautomat ="011010" or (enbl_qsstop2='1' and qsstop2='1')) then -- Soft-Set or Synchron. von qsfreq
            qfreq   <= CONV_STD_LOGIC_VECTOR(1,freq_widh);
            qimp    <= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1);


      else
		if ( (stop = '0') and (qfreq = ddfreq)  ) then                                 -- 2007.04.03 Coverage
                   if (qimp < dlimp)  then                                                     -- 2007.04.03 Coverage
		      qimp <= qimp + '1' ;
		   else                                                                        -- 2007.04.03 Coverage
                      qimp  <= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1);
		   end if;                                                                     -- 2007.04.03 Coverage
		end if;
--------------------------------------------------------------------------------------------------------------------------------------------------
--            12.07.01 Fuer alle anderen (ohne zentralen Vorteiler):
		if (qfreq < ddfreq) and not((qautomat  = "000101" and issi_flag ='1' and stop = '1')) then -- not 5 im SSI-Mode am Anfang (Codierung auch ueber dfreq mgl.)
					       
			   qfreq <= qfreq + '1' ;			
----------------------------------------------------------------------------------------------------------------------------------------------------	    
	    	elsif   (qautomat  = "100010" or qautomat = "100011") 	then    --Z 34,34 immer 1 Uebergang von Z13 kann unvollstandig sein

                       qfreq <= CONV_STD_LOGIC_VECTOR(1,freq_widh);
		       qimp    <= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1);
----------------------------------------------------------------------------------------------------------------------------------------------------	    
	    	elsif  stop = '0' and qfreq = ddfreq 	then

                       qfreq <= CONV_STD_LOGIC_VECTOR(1,freq_widh);
	    	    
		elsif ( stop = '1' )    		then                                     -- evtl. hier stop2

                       qfreq <= CONV_STD_LOGIC_VECTOR(1,freq_widh);
                       qimp  <= CONV_STD_LOGIC_VECTOR(1,imp_zahl+1);
		end if;
	  end if;
	end if;
   end process;




-- Ausgangs-FF, (Toggle-FF)
-----------------------------

   process (nres,clk)
   begin
     if (nres = '0' ) then 
			rt      <= '0';
	 elsif clk'event and clk='1' then   
	        if ( set_ssi='1' or set_endat='1' or watch_dog_soft_reset_i='1' ) then
			rt      <= '0';		
	        elsif ((qautomat="000100" or issi_flag='1') and enb12 ='1') then
			rt      <= '1';
			elsif qsstop2='1' and delay_flag2='1' and qautomat="110011" then   -- Restart bei Zusatz
			rt      <= '1';
			elsif ((qfreq=ddfreq)  and stop='0'                              -- 12.07.01
                             and not(   (stop2='1' and issi_flag='1')            -- kein TCLK bei SSI-Ende qimp=A/h (sonst 11 Flanken)
			             or (qautomat="001111" and data_in='1'  and uend='1')  -- kein TCLK bei 15,
				     or (qautomat="011000") or (qautomat="011001")         -- kein TCLK bei 24,25
                                     or (qautomat="011010") or (qautomat="011011")         -- kein TCLK bei 26,27 
				     
				     or (qautomat="011111" and data_in='1' and delay_flag2='0')  -- DL=1 darf 11.TCLK-Flanke noch nicht kommen
		                     or (qautomat="001101" and delay_z13='1' and qimp ="0000010" and delay_flag2='1') )) then   -- Wiederholungsmessung

			rt  <=  not rt;

			elsif (qautomat="100011") then 
			rt  <=  not rt;			
			elsif (qfreq=ddfreq and qautomat="011111" and data_in='0') then   -- Falls DL spaet auf L geht !!!
			rt  <=  not rt;			
						
			elsif ((qfreq=ddfreq) and stop='0' and (qautomat(5 downto 1) ="00010"  )) then
			rt  <=  rt;

			elsif stop = '1' then
			rt <= rt;
			end if;

	 end if;
   end process;


-- Startautomat, mit enb1-(0/1)-Flanke wird stop=0 gebildet
------------------------------------------------------------
enb12    <= enbl and not enb2;

  process (clk, nres)
   begin
     if (nres = '0' ) then 
			  stop  <= '1';
                          uend  <= '0';
                          enb2  <= '0';

     elsif clk'event and clk='1' then
			enb2 <= enbl;

              if (set_ssi='1' or set_endat='1' or watch_dog_soft_reset_i='1') then 
			  stop  <= '1';
                          uend  <= '0';
	      else
			if ( qimp = 1 and enb22='1') then
                          stop <= '0';
                          uend <= '0';
			elsif (qimp = dlimp_i) and (qfreq = ddfreq) and (qimp /= 1) then
			  stop <= '1';
                          uend <= '1';
			elsif (qimp = dlimp_i) and (qfreq = ddfreq) then
			  stop <= '1';
			elsif (qimp > dlimp_i) or (qfreq > ddfreq) then
			  stop <= '1';
			end if;
	      end if;
	 end if;
   end process;



qstop2_i <= '1' when (qimp = dlimp) and (qfreq = (ddfreq -'1'))  else '0';

-- Wire-delay-Counter
---------------------
-- Misst Wire Delay, wenn Delay-Flag nicht gesetzt ist!

lzk       <= enbl_lzk;

  process (clk, nres)
   begin
     if nres = '0'  then
                        delay_ct     <= (others =>'0');
                        delay_rg     <= (others =>'0');
                        delay_flag   <= '0';
                        delay_flag2  <= '0';
                        delay_flag1  <= '0';
                        delay_flag4  <= '0';
                        set_delay_rg <= '0';
                        set_delay_rg1 <= '0';
                        ready_delay_ct_z25 <= '0';
                        busy_delay_ct_z25  <= '0';
                        rt1          <= '0';
     elsif clk'event and clk='1' then
                        rt1 <= rt;

        if sel_cfg1 ='1' and write_pulse='1' then
                        set_delay_rg <= '1';
        else
                        set_delay_rg <= '0';
        end if;

        if set_delay_rg = '1'  and enbl_lzk='1' then  -- 1 Colck Delay
                        set_delay_rg1 <= '1';
        else
                        set_delay_rg1 <= '0';
        end if;

        if  set_ssi='1' or set_endat='1' or lzk ='0' then
                        delay_ct    <= (others =>'0');
                        delay_rg    <= (others =>'0');
                        delay_flag  <= '0';
                        delay_flag2 <= '0';
                        delay_flag1 <= '0';
                        delay_flag4 <= '0';
                        ready_delay_ct_z25 <= '0';
                        busy_delay_ct_z25  <= '0';

         elsif  set_delay_rg1='1' and qautomat = "000100" then

             if cfg_lzk(7 downto 1) ="0000000" then   -- Value: 0,1
                        delay_ct    <= (others =>'0');
                        delay_rg    <= (others =>'0');
                        delay_flag  <= '0';
                        delay_flag2 <= '0';
                        delay_flag1 <= '0';
                        delay_flag4 <= '0';
                        ready_delay_ct_z25 <= '0';
                        busy_delay_ct_z25  <= '0';

             else  -- manuelle Korrektur Delaywert
                        delay_rg    <= cfg_lzk(7 downto 0);
                        delay_flag  <= '1';
                        delay_flag2 <= '1';
                        delay_flag1 <= '1';
             end if;

         elsif  watch_dog_soft_reset_i='1'  then
                        delay_ct    <= (others =>'0');
                        delay_flag4 <= '0';

         elsif  start_delay_ct='1'  then
                        delay_ct    <= (others =>'0');

         elsif  correct_dui='1'  then
                        delay_ct    <= "00000010";

         elsif   qautomat = "010000"  then                   -- Z16
                        delay_ct    <= "00000001";
                        ready_delay_ct_z25 <= '0';
                        busy_delay_ct_z25  <= '0';

        elsif (qautomat = "011000" )  then                                         -- Z24 Restart Laufzeit muss bei 1-1 Befehlen eingearbeitet werden
                if delay_flag2='1' then
                   if busy_delay_ct_z25 = '0' then
                        delay_ct    <= delay_rg;
                        busy_delay_ct_z25 <= '1';
                   elsif delay_ct > "00000001" then
                        delay_ct    <= delay_ct-1;
                   end if;
                end if;
        elsif (qautomat = "011001" )  then                                         -- Z25 Laufzeit muss bei 1-1 Befehlen eingearbeitet werden
                if delay_flag2='1' then
                   if delay_ct > "00000001" then
                        delay_ct           <= delay_ct-1;
                   else
                        ready_delay_ct_z25 <= '1';
                        busy_delay_ct_z25  <= '0';
                   end if;
                end if;
        elsif (qautomat = "001100" or  qautomat = "001101")  then                  -- Z12,13
                if delay_flag='0' then
                   if data_in='0'   then                                            -- Delay messen
                        delay_ct    <= delay_ct+1;

                   else   -- data_in='1'
                      if  delay_ct(7 downto 1) /= "0000000" then
                        delay_flag  <= '1';
                        delay_rg    <= delay_ct;
                        delay_ct    <= "00000001";
                      end if;
                   end if;

                else  -- delay_flag='1' then
                    if qautomat(0) = '1' then                                       -- Z13
                       if rt_lh_flanke ='1' then
                          delay_flag1 <= '1';
                       end if;
                    end if;

                    if delay_z13='1' then
                       if  delay_ct /= (delay_rg) then                                 -- Delay einarbeiten
                           delay_ct    <= delay_ct+1;
                       end if;
                    end if;
                end if;

         elsif delay_flag='1' and (qautomat = "000100" or qautomat = "010110") then -- Z4,22
                        delay_flag2 <= '1';
                        ready_delay_ct_z25 <= '0';
                        busy_delay_ct_z25  <= '0';

         end if;

         if delay_flag2='1' and (qautomat = "010110") then                          -- Z22
                        delay_flag4 <= '1';
         end if;
     end if;
   end process;
enbl_tm_z25 <= '1' when delay_ct(7 downto 1) /= "0000000" and qautomat(5 downto 1) = "01100" else '0';  --Z24,25
--  and delay_flag='0' , damit der CT beim Einarbeiten des Delays nicht mit Null beginnt -> somit DUI 1 Takt eher 
start_delay_ct <= rt_hl_flanke  when (qautomat = "001100"  ) and delay_flag='0' else '0';
correct_dui    <= rt_hl_flanke  when (qautomat = "001100"  ) and delay_flag='1' else '0';

rt_lh_flanke   <=     rt and not rt1;
rt_hl_flanke   <= not rt and     rt1;

--Flags for Status of Cable Delay Measurement
---------------------------------------------
lzk_activ <= delay_flag2;

  process (clk, nres)
   begin
     if nres = '0'  then 
		lzm_ready    <= '0';
                delay_flag11 <= '0';
                delay_flag22 <= '0';
     elsif clk'event and clk='1' then
                delay_flag11 <= delay_flag1;
                delay_flag22 <= delay_flag2;
	 if set_delay_rg='1'  or  set_delay_rg1='1' or set_endat='1' then 
		lzm_ready    <= '0';
	 elsif delay_flag2 ='1' and delay_flag22 ='0' and not  -- both Edges are only at the same Time by
	      (delay_flag1 ='1' and delay_flag11 ='0') then    -- Manual Setting
		lzm_ready    <= '1';
	 end if;
     end if;
   end process;
   
--------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Sendetakt (Frequenzteiler)
--
   process (nres,clk)
   begin
	if nres = '0' then
                    qsfreq <= CONV_STD_LOGIC_VECTOR(1,10);
	elsif clk'event and clk='1' then
                if (set_ssi='1' or set_endat='1' or qautomat ="011010" or watch_dog_soft_reset_i='1') then 

                    qsfreq <= CONV_STD_LOGIC_VECTOR(1,10);
		end if;

		if (("000000000000000" & qsfreq) < dfreq) and delay_flag2='1' and
		                       (qautomat  = "100101" or  qautomat = "100100" or                        -- Z37,36
				      ((qautomat  = "001101" and delay_z13='1' ) or                            -- Z13
		                        qautomat  = "100011" or  qautomat = "100010" or                        -- Z35,Z34
                                        qautomat  = "001110" or  qautomat = "001111" or                        -- Z14,15
                                        qautomat  = "111110" or  qautomat = "111111" or                        -- Z62,63
		                        qautomat  = "010000" or  qautomat = "010001" or                        -- Z16,17
		                      ((qautomat  = "011000" or  qautomat = "011001") and zusatz_flag2='0') or -- Z24,25            
		                        qautomat  = "101100" or  qautomat = "101101" or                        -- Z44,45
		                        qautomat  = "110010" or  qautomat = "110011" or                        -- Z50,51
				        qautomat  = "010010" or  qautomat = "010011" or qautomat = "010111" or -- Z18,19,23,20,22
					qautomat  = "010100" or  qautomat = "010110")  ) then

			qsfreq <= qsfreq + '1' ;

		elsif ( stop = '0' and (("000000000000000" & qsfreq) = dfreq)) then
                      qsfreq <= CONV_STD_LOGIC_VECTOR(1,10); -- 29.05.2000

		elsif ( stop = '1' ) then
                       qsfreq <= CONV_STD_LOGIC_VECTOR(1,10); -- 29.05.2000

		end if;
	end if;
   end process;

qsstop2 <= '1' when (s_ct = max_s_ct) and (qsfreq = ddfreq)  else '0';


-- Sende-Ausgangs-FF, (Toggle-FF)
---------------------------------

   process (nres,clk)                       -- Toggled bis Anzahl der zu sendenden Takte erreicht und bei Z20,22,23
   begin                                   
     if (nres = '0' ) then 
			srt      <= '0';
	 elsif clk'event and clk='1' then   
         if  set_ssi='1' or set_endat='1' or lzk ='0' or watch_dog_soft_reset_i='1' then
			srt      <= '0';
--       elsif ((qautomat="000100" or issi_flag='1') and enb12 ='1') then
         elsif (qautomat="000100" and enb12 ='1') then
			srt      <= '1';
         elsif (qautomat="010100" and zusatz_flag_i ='1' and mode_com_11_66 ='1') then  -- Setzen Ruhe-Zustand nach Zusatz, da sonst auf '1' wegen 2.tst
			srt      <= '0';
         elsif (qautomat="110010" and  q_fb_typ_1  ='1'  and mode_com_11_66 ='1') then  -- Setzen Ruhe-Zustand nach F-Typ1
			srt      <= '0';
--			           bedeutet: (s_ct < max_s_ct) 
	 elsif qsfreq= dfreq and ((s_ct /= max_s_ct_i) or (enbl_dtakt='1' and delay_flag3='1')) then  -- 19.09.2001
			srt  <=  not srt;
	 end if;
     end if;
   end process;



-- Sende-Impuls-CT
------------------
-- 
   process(nres, clk)                      -- zaehlt die Zahl der gesendeten Takte, waehrend die eigentliche State Machine
   begin                                   -- um das Wire-Delay verzoegert wird. Dies ist notwendig, da die Zahl der zu 
     if (nres = '0') then                  -- sendenden Takte bestimmt werden muss.
			s_ct <= (others=>'0');
     elsif clk'event and clk='1' then
       if ic_test_mode ='1' then           -- 30.05.2000 Testmode eingebaut
			s_ct <= s_ct +'1';                --

       elsif  set_ssi='1' or set_endat='1' or lzk ='0' or qautomat="000100" or qautomat="010110" or watch_dog_soft_reset_i='1' then
			s_ct <= (others=>'0');

       elsif qsfreq = dfreq then                -- 2008.04.10 
          if    mode_com_11_66 ='1' then 
	       if srt='0' then                  -- neue Loesung fuer alle MC ohne Zusatz  (wegen Pause bei 2.TST-low)
                    if not (qautomat(5 downto 2) = "0110" and  q_fb_typ_1  ='1') then   -- nicht bei Z_24,25,26,27 wenn Abbruch wegen F-Typ1-Fehler
       			s_ct <= s_ct +'1';
                    end if;
               end if;
          else                                  -- alte Loesung fuer alle MC ohne Zusatz
	       if srt='1' then  -- 190901 
       			s_ct <= s_ct +'1';
               end if;
          end if;
       end if;
     end if;
   end process;

test_s_ct <= s_ct(test_s_ct'range);             


-- Zaehler fuer verzoegerte Takt-Pulse beim Warten auf Startbit 
---------------------------------------------------------------
--
   process(nres, clk)
   begin
     if (nres = '0') then
			sb_ct <= (others=>'0');
     elsif clk'event and clk='1' then
       if ic_test_mode ='1' then           -- 30.05.2000 Testmode eingebaut
			sb_ct <= s_ct +'1';               --
 	    elsif set_ssi='1' or set_endat='1' or lzk ='0' or qautomat="000100" or qautomat="010110" or watch_dog_soft_reset_i='1' then
			sb_ct <= (others=>'0');
 	    elsif  rt_hl_flanke ='1' and (qautomat(5 downto 1) = "10010"              or               -- Z_37,Z_37 1. Messung
				       (((qautomat  = "001101" and delay_z13='1')     or
		                          qautomat  = "100011" or qautomat = "100010" or               -- Z_34,Z_35
                                          qautomat  = "111110" or                                      -- 2. Fehlerbit
				          qautomat  = "001110" or (qautomat = "010000" and zi_ct="00")) and delay_flag2='1')) then
	                             
			sb_ct <= sb_ct +'1';
        end if;
     end if;
   end process;


-----------------------------------------------------------------------------------------------------------------------------------
-- Festlegen der Anzahl der TCLK Impulse
----------------------------------------

   process(mode_0, mode_2, mode_7, zi_bit, sb_ct, dimp2_plus_crc, dimp2_plus_1zi_crc, dimp2_plus_2zi_crc, t24_plus_crc, t40_plus_crc)
   begin
     if mode_0 = '1' then
                             max_s_ct_i <= ( sb_ct + dimp2_plus_crc );     -- krg + 5/8 Takte
     elsif mode_7='1' then

        case zi_bit is
           when "00"   =>    max_s_ct_i <= ( sb_ct + dimp2_plus_crc );     -- krg + 5/8 Takte bei Zusatz
           when "01"   =>    max_s_ct_i <= ( sb_ct + dimp2_plus_1zi_crc);  -- krg + 5/8 + 1+29/32  Takte
           when others =>    max_s_ct_i <= ( sb_ct + dimp2_plus_2zi_crc);  -- krg + 5/8 + 1+29/32 + 1+29/32 Takte
        end case;

     elsif mode_2='1' then
                             max_s_ct_i <= ( sb_ct + t40_plus_crc    );    -- 40+5/8 =45/48 Takte
     else
                             max_s_ct_i <= ( sb_ct + t24_plus_crc    );    -- 24+5/8 =29/32 Takte
                                                                                  -- when not (mode="000" or mode="010")
     end if;
   end process;


                                                          -- for Mode Commands 1-1 ..6-6 Clock more  then LZK is activ (for Z51)
dimp2_plus_crc_i     <= (("00" & dimp2) + "0000101") when (mode_11_33_44 ='0' or q_fb_typ_1 = '1') else (("00" & dimp2) + "0000110"); --  5, 6
dimp2_plus_2zi_crc_i <= (("00" & dimp2) + "1000001") when (mode_11_33_44 ='0' or q_fb_typ_1 = '1') else (("00" & dimp2) + "1000010"); -- 65,66
dimp2_plus_1zi_crc_i <= (("00" & dimp2) + "0100011") when (mode_11_33_44 ='0' or q_fb_typ_1 = '1') else (("00" & dimp2) + "0100100"); -- 35,36
t40_plus_crc         <= "101101"; -- 45
t24_plus_crc         <= "011101"; -- 29

-----------------------------------------------------------------------------------------------------------------------------------

-- Delay-Flag fuer durchlaufenden Takt
--------------------------------------
-- 
   process(nres, clk)                      -- Mit delay_z13 (Verzoegerung ist eingearbeitet) wird Sendetakt generiert
   begin                                   -- Im Unterschied zum unterbrochenen Takt ist dieser ab hier dauerhaft aktiv
     if (nres = '0') then                  -- 
			delay_flag3 <= '0';
     elsif clk'event and clk='1' then
       if set_ssi='1' or set_endat='1' or lzk ='0' or watch_dog_soft_reset_i='1' then
			delay_flag3 <= '0';
-- 	    elsif delay_z13   = '1' and delay_flag ='1' then
 	    elsif delay_z13   = '1' then                      -- delay_z13 wird nur 1, wenn delay_flag ='1',
			delay_flag3 <= '1';
 	    elsif                        qautomat = "011010" then
			delay_flag3 <= '0';
        end if;
     end if;
   end process;



-----------------------------------------------------------------------------------------------------------------------------------
-- Test-Flag fuer fuer s_ct, sb_ct
-----------------------------------------------------------------------------------------------------------------------------------
--
   process(nres, clk) 
   begin 
     if (nres = '0') then                
			test_flag(3 downto 0) <= "0000";
     elsif clk'event and clk='1' then
       if ic_test_mode ='0'  then
			test_flag(3 downto 0) <= "0000";
       end if;
       if ic_test_mode ='1' and s_ct = 2**s_ct'length-1 then
			test_flag(0) <= '1';
       end if;
       if ic_test_mode ='1' and sb_ct = 2**sb_ct'length-1 then
			test_flag(1) <= '1';
       end if;
       if ic_test_mode ='1' and test_flag(0) ='1' and s_ct = 0 then
			test_flag(2) <= '1';
       end if;
       if ic_test_mode ='1' and test_flag(1) ='1' and sb_ct = 0 then
			test_flag(3) <= '1';
       end if;
     end if;
   end process;

test_flag_out <= '1' when test_flag(3 downto 0) = "1111" else '0';


-----------------------------------------------------------------------------------------------------------------------------------
-- diverse Signalzuweisungen
-----------------------------------------------------------------------------------------------------------------------------------
--
stopbit    <= uend;


-- Clock-Pulse for SPW, PSW, CRC
--------------------------------
clki_shift <= '1' when (qfreq=ddfreq)  and rt='0' and ienpsw ='1' else 
              '1' when (qfreq=ddfreq)  and rt='1' and ienpsw ='0' else '0';

clk_shift  <= clki_shift;


-- Data Acceptance Controll Signal
----------------------------------
dui       <= clki_shift when (qautomat  = "001110" or  --Z14 AL1
                              qautomat  = "001111" or  --Z15 AL1
                              qautomat  = "111110" or  --Z62 AL2
                              qautomat  = "111111" or  --Z63 AL2
                              qautomat  = "010000" or  --Z16 Data
                              qautomat  = "010001" or  --Z17 Data
                              qautomat  = "010010" or  --Z18 CRC
                              qautomat  = "010011" )   --Z19 CRC
	                     else '0';




frq_o: process (rt, srt, delay_flag2, delay_flag3, delay_z13, mode_zf)
begin
   if delay_flag2='0' then
      freq_out <= not rt; 
   else
      if delay_flag3 ='0' then
         if delay_z13 = '0' then
            freq_out <= not rt; 
         else
            freq_out <= not srt;
         end if;
      else
         if mode_zf = '1' then
            freq_out <= not rt;
         else
            freq_out <= not srt;
         end if;
      end if;
   end if;
end process;

with mode select
mode_zf <= zusatz_flag_i when "001"|"011"|"100"|"101"|"110",
           '0'           when others;         


-- Counter for Test of 30 us Status Bit DL_High
-----------------------------------------------
   process(nres, clk) 
   begin 
     if (nres = '0') then                
	      ct_30us   <= "00000";
              dl_high_i <= '0';
     elsif clk'event and clk='1' then
         if qautomat = "011010" or qautomat = "000100" then
	      ct_30us   <= "00000";
              dl_high_i <= '0';
         elsif usc1 ='1'  and qautomat = "011001" then
	   if ct_30us = "11111" then
	      ct_30us   <= "00000";	
              dl_high_i <= '1';
           elsif  dl_high_i = '0' then
	      ct_30us <= ct_30us + '1';	
	   end if;
         end if;
     end if;
   end process;

dl_high <= dl_high_i;


-- Pipeline
-----------
   process(nres, clk) 
   begin 
     if (nres = '0') then                
	      test_max_s_ct        <= (others =>'0');
              zi_bit               <= (others =>'0');
              dimp2_ssi            <= (others =>'0');
              dimp2_ssi_minus_1    <= (others =>'0');
              dimp2_plus_crc       <= (others =>'0');
              dimp2_plus_2zi_crc   <= (others =>'0');
              dimp2_plus_1zi_crc   <= (others =>'0');
              max_s_ct             <= (others =>'0');
              dlimp                <= (others =>'0');
              zibit                <= (others =>'0');
              stop2                <= '0';
              enspw                <= '0';
     elsif clk'event and clk='1' then
              test_max_s_ct        <= max_s_ct(test_max_s_ct'range);
              zi_bit               <= zi_bit_i;
              dimp2_ssi            <= dimp2_ssi_i;
              dimp2_ssi_minus_1    <= dimp2_ssi_minus_1_i;
              dimp2_plus_crc       <= dimp2_plus_crc_i;
              dimp2_plus_2zi_crc   <= dimp2_plus_2zi_crc_i;
              dimp2_plus_1zi_crc   <= dimp2_plus_1zi_crc_i;
              max_s_ct             <= max_s_ct_i;
              dlimp                <= dlimp_i;
              zibit                <= zibit_i;
              stop2                <= qstop2_i;
              enspw                <= ienspw;
     end if;
   end process;


-- Watch Dog Coding
-------------------
watch_dog_soft_reset   <= watch_dog_soft_reset_i;
watch_dog_soft_reset_i <= '1' when delay_flag2 = '1' and watch_dog_pulse ='1' else
                          '0';
watch_dog_hard_reset   <= '1' when delay_flag2 = '0' and watch_dog_pulse ='1' else
                          '0';


srg_ready_for_strobe   <= srg_ready_for_strobe_i;
srg_ready_for_strobe_i <= '1' when qautomat = "000100"  else   -- Z4
		          '0';
srg_ready              <= srg_ready_i;
srg_ready_i            <= '1' when qautomat = "010110"                        else   -- Z22
                          '1' when qautomat = "011000" and zusatz_flag2 = '0' else   -- Z24
                          '1' when qautomat = "101110"                        else   -- Z46   -- verzoegertes 50 auch moeglich
		          '0';
autom_srg_reset        <= autom_srg_reset_i;
autom_srg_reset_i      <= '1' when qautomat = "011110" else    -- Z30
		          '0';

-- Signals for Reset of SRG
---------------------------
-- Flag to allow reset of srg (reset window)
-- Z_4,Z_22,Z_24,Z_46 set -> Z_30 reset 

   process(nres, clk) 
   begin 
     if (nres = '0') then                
	  allow_srg_reset      <= '0';
     elsif clk'event and clk='1' then
        if autom_srg_reset_i = '1' then                      -- autom. Reset ist letzter Zeitpunkt fuer Reset
	  allow_srg_reset      <= '0';
        elsif srg_ready_i = '1' or srg_ready_for_strobe_i = '1' then  -- srg_ready or Z_4
	  allow_srg_reset      <= '1';
        end if;
     end if;
   end process;


-- Coding Mode commands
-----------------------
MC_1166: process (tx)
begin
   case tx(29 downto 24) is
      when "001001" => mode_com_11_66 <= '1';            -- Mode Command 1-1
      when "011011" => mode_com_11_66 <= '1';            -- Mode Command 3-3
      when "100100" => mode_com_11_66 <= '1';            -- Mode Command 4-4
      when "101101" => mode_com_11_66 <= '1';            -- Mode Command 5-5
      when "110110" => mode_com_11_66 <= '1';            -- Mode Command 6-6
      when others   => mode_com_11_66 <= '0';            -- 
   end case;
end process;


-- Signal Allocation to Outputs
-------------------------------
alarm         <= ialarm;
alarm2        <= ialarm2;
enpsw         <= ienpsw;
enspwcrc      <= ienspwcrc;
ready1        <= iready1;
ready2        <= iready2;
ssi_flag      <= issi_flag;
ec_automat    <= qautomat;
imp           <= qimp;
del_ct        <= delay_ct;
del_rg        <= delay_rg;
dfreq_out     <= dfreq;

test_qfreq      <= qfreq;

end behav;
