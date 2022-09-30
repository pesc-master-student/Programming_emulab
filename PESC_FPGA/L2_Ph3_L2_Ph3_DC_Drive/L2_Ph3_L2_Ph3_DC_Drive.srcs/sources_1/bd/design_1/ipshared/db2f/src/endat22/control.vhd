--****************************************************************************************
--
--                                                          control_e6
--                                                          ==========
-- File Name:        control_e6.vhd
-- Project:          EnDat6
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
-- Function:         Central Controlling Unit
--                   Consists of Configuration Registers, Status Registers and Interrupt
--                   Mask Registers.
--                   Special Functions
--                   ic_test_mode=1 krg(23)=1 : Ueberbrueckung Frequenzteiler
--                   ic_test_mode=0 krg(23)=1 : "normaler" Betriebsmodus mit Delay-Messung
--                   ic_test_mode=0 krg(23)=0 : "normaler" Betriebsmodus Delay-Messung deaktiviert
--
--                   crc_error ausgeblendet, wenn Alarm schon da war.
--                   (Waehrend Z25,26 wird SPW durchgeshiftet, falls vorherige Zeit nicht
--                   ausreichte. Dadurch erfolgt CRC-Prüfung erst dort. Beim Alarm-Abbruch 
--                   beginnt die CRC-Auswertung (Alarmbit). Dies bewirkt den CRC-Error,
--                   der dort nicht hingehört.)
--                                  
-- History: F.Seiler 25.11.2003 Initial Version 
--                   (Substitutes control_e6.vhd by using ABP-IF)
--                   Attation: Set_EnDat, Set_SSI D14,15 -> 30,31  !!!
--          F.Seiler:08.10.2004 Outputs crc_err, crc_err_rg3 for WT of CRC5
--          F.Seiler:02.02.2005 CRC reduced to 5 bit (coverage)
--          F.Seiler:15.02.2005 u16-> klgl_24; gr16, gr24 ... cleared
--          F.Seiler 01.11.2006 Changes allow_srg_reset, autom_srg_reset, nres_srg
--          F.Seiler 09.07.2007 signal crc_err_rg2 
--          F.Seiler 01.02.2008 input_2_srg(29 downto 24) connecting to zero external
--          F.Seiler,08.04.2008 tst_empf_rg1,2,3 with I/O-access
--          F.Seiler xx.09.2008 watch_dog_soft_reset
--****************************************************************************************
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
use IEEE.STD_LOGIC_misc.all;
use ieee.std_logic_arith.all;

entity control_e6 is
   port(clk, nres  :                     in  std_logic;                     -- Clock, Reset

--  Signals for Micro Controller Port
-------------------------------------
    d :    	                         in  std_logic_vector(31 downto 0); -- Data from Port to Registers
    d_empf_rg2 :                         in  std_logic_vector(20 downto 16);-- Input of RX2
    d_empf_rg3 :                         in  std_logic_vector(20 downto 16);-- Input of RX3

    sel_rx1  :                           in  std_logic;                     -- Select Receive Register 1
    sel_rx2  :                           in  std_logic;                     -- Select Receive Register 2
    sel_rx3  :                           in  std_logic;                     -- Select Receive Register 3
    sel_cfg1 :                           in  std_logic;                     -- Select Configuration Register 1
    sel_cfg2 :                           in  std_logic;                     -- Select Configuration Register 2
    sel_cfg3 :                           in  std_logic;                     -- Select Configuration Register 3
    sel_stat :                           in  std_logic;                     -- Select Status Register 
    sel_im   :                           in  std_logic;                     -- Select Interrupt Mask Register 
    soft_str :                           in  std_logic;                     -- Software Strobe
    write_pulse:                         in  std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers
    cfg1 :   	                         out std_logic_vector(31 downto 0); -- Configuration Register1
    cfg2 :   	                         out std_logic_vector(31 downto 0); -- Configuration Register2
    cfg3 :   	                         out std_logic_vector(15 downto 0); -- Configuration Register3
    dstat :                              out std_logic_vector(31 downto 0); -- Inputs of Status Register to Output
    stat :                               out std_logic_vector(31 downto 0); -- Status Register
    im  :                                out std_logic_vector(31 downto 0); -- Interrupt Mask Register

    tx :    	                         in  std_logic_vector(29 downto 0); -- Data from TX Register
    qspw :    	                         in  std_logic_vector(47 downto 0); -- Data from Ser.Parallel Converter

    eempf_rg1, eempf_rg2, eempf_rg3 :    out std_logic;   -- Enable RX Registers
    tst_empf_rg:                         in  std_logic;   -- Test Enable RX Registers (For Test Write Modus)
    ic_test_mode:                        in  std_logic;   -- IC Test Mode

-- Necessary for Destination of Data Width
------------------------------------------
    klgl_24 :                            out std_logic;   -- less or equal 24
    
--  Signals of/for the Measurement System
-----------------------------------------    
    start_trans_hw:                      out std_logic;   -- Start Transmission with Hardware Strobe
    start_trans_sw:                      out std_logic;   -- Start Transmission with Software Strobe
    str :                                in  std_logic;   -- Strobe Signal from Pin
    istr:                                in  std_logic;   -- Strobe Signal from internal Timer
    watch_dog_soft_reset :               in  std_logic;   -- Breaking signal to reset E.Statemachine without LZK
    watch_dog_hard_reset :               in  std_logic;   -- Breaking signal to reset E.Statemachine and LZK
    input_2_srg:                         in  std_logic_vector(29 downto 24); -- additional inputs to status register

    mode:	                         out std_logic_vector( 2 downto 0);  -- Coding Mode Command
    n_mode:	                         out std_logic_vector( 2 downto 0);  -- Coding Mode Command
    mode_11_33_44:                       out std_logic;   -- Mode Commands 1-1 ..6-6 
    mode_11_66_tx:                       out std_logic;   -- Mode Commands 1-1 ..6-6 Additional TX-Part
    mode_11_66:                          out std_logic;   -- Mode Command 1-1 .. 6-6
    mode_endat_2_1:                      out std_logic;   -- Mode Commands EnDat 2.1
    mode_kom_2_2:                        out std_logic;   -- Mode Command 2-2
    mode_7_0:                            out std_logic;   -- Mode Command 7-0
    mode_7:                              out std_logic;   -- Mode Command 7-0
    mode_2:                              out std_logic;   -- Mode Command 2
    mode_0:                              out std_logic;   -- Mode Command 0
    ready1 :                             in  std_logic;   -- Data Transmission was done
    ready2 :                             in  std_logic;   -- Data Transmission was done

    alarm, alarm2:                       in  std_logic;   -- Errors of Encoder
    dl_high :                            in  std_logic;   -- Data line (DATA_RC) is high 
    serial_data_spike:                   in  std_logic;   -- Spike on DATA_RC 
    zi_bit:                              in  std_logic_vector( 1 downto 0);  -- Coding for Count of ZI
    zict:	                         in  std_logic_vector( 1 downto 0);  -- Coding for Count of ZI
    zusatz_flag:                         in  std_logic;   -- Zusatzflag
    qcrc:                                in  std_logic_vector( 4 downto 0);  -- From Encoder received CRC Value
    testcrc:                             in  std_logic_vector( 4 downto 0);  -- Self generated CRC Value
    
    lzm_ready:                           in  std_logic;   -- Cable Delay Measurement was done  
    lzk_activ:                           in  std_logic;   -- Cable Delay Compensation is active

    ssi_flag :                           in  std_logic;   -- SSI Mode
    double_word_flag1:                   in  std_logic;   -- SSI-Double Word Processing
    par_err :                            in  std_logic;   -- Parity Error (only in SSI Mode)
    i_int6n, i_int7n :                   in  std_logic;   -- free Interrupt Inputs
    intn:                                out std_logic;   -- Interrupt Request to Micro Controller

--  Configuration Outputs for EnDat and SSI Mode
-------------------------------------------------
--  for EnDat:
    enbl_alarm2    :                     out std_logic;
--    enbl_accept    :                     out std_logic;   -- Enable Data Acception
    enbl_dtakt     :                     out std_logic;   -- Enable "Nonstop TCLK"
    cfg_freq       :                     out std_logic_vector( 3 downto  0);  -- Config. of Transmission Frequency
    cfg_dimp2      :                     out std_logic_vector( 5 downto  0);  -- Config. of Data Word Length
    cfg_lzk        :                     out std_logic_vector( 7 downto  0);  -- Config. Cable Delay Compensation
    enbl_lzk       :                     out std_logic;   -- Enable Cable Delay Compensation
    MHZ_64         :                     out std_logic;   -- Select  64 MHZ (System Frequency)
    MHZ_50         :                     out std_logic;   -- Select  50 MHZ (System Frequency)
    MHZ_48         :                     out std_logic;   -- Select  48 MHZ (System Frequency)
    MHZ_32         :                     out std_logic;   -- Select  32 MHZ (System Frequency)
    MHZ_100        :                     out std_logic;   -- Select 100 MHZ (System Frequency)
    set_endat      :                     out std_logic;   -- Set to EnDat Mode
    allow_srg_reset:                     in  std_logic;
    autom_srg_reset:                     in  std_logic;
    srg_ready:                           in  std_logic;
    srg_ready_for_strobe:                in  std_logic;
    cfg_allow_srg_reset:                 out std_logic;
    cfg_autom_srg_reset:                 out std_logic;

--  for EnDat  + SSI:
    cfg_sample     :                     out std_logic_vector( 7 downto  0); -- Config of Timer for Sampling Rate 
    cfg_watch      :                     out std_logic_vector( 7 downto  0); -- Config of Watch Dog Timer
    cfg_time_tst   :                     out std_logic_vector( 2 downto  0); -- Config of Time Tst
    enbl_dig_filt  :                     in  std_logic;                      -- enbl Filter during Data Receive 
    cfg_filt_data  :                     out std_logic_vector( 5 downto  0); -- Config of Filter for serial Data
    cfg_str_delay  :                     out std_logic_vector( 7 downto  0); -- Config of Strobe Delay

--  for SSI:
    parit_on       :                     out std_logic;   -- Enable Parity Check (SSI, even)
    ssi_format     :                     out std_logic;   -- Select SSI Format (Tree or right)
    gray           :                     out std_logic;   -- Enable Gray Format for Data
    single_turn    :                     out std_logic_vector( 4 downto  0);  -- Singleturn Value of Encoder
    double_word    :                     out std_logic;                       -- Enable Double Word

    parit_ev       :                     out std_logic;   -- Parity even 
    set_ssi        :                     out std_logic;   -- Set to SSI Mode
    ssi            :                     out std_logic;   -- SSI Mode

--  Configuration Outputs for EnDat and SSI Mode
-------------------------------------------------
    tst_zi_bit    :                     out std_logic_vector( 1 downto  0);  -- Control Information about ZI Status
    tst_dl_high   :                     out std_logic;                       --  Control Information about Data_rc Line

--  New Outputs for E6
-------------------------------------------------
    crc_err       :                     out std_logic;                       -- CRC Empf.Reg1 (Pos1)
    crc_err_rg2   :                     out std_logic;                       -- CRC Empf.Reg2
    crc_err_rg3   :                     out std_logic;                       -- CRC Empf.Reg3 (Pos2)
    fb_typ_1      :                     in  std_logic;                       -- F-Typ I  to FRG
    fb_typ_2      :                     out std_logic;                       -- F-Typ II to FRG
    n_rm          :                     out std_logic);                      -- not RM bit

end control_e6;

Architecture behav of control_e6 is

component regist_8x
   generic(init_width:   integer:= 4;   -- Width (Count of Bytes -> 1,2,3 or 4)
           init_res:     integer:= 0);  -- Reset Value
		
   port(clk, nres:       in std_logic;
        sel:             in std_logic;
        write_pulse :    in  std_logic_vector(   init_width -1 downto 0);
        d :              in  std_logic_vector((8*init_width)-1 downto 0);
        q :              out std_logic_vector((8*init_width)-1 downto 0));
end component;

component statreg_8x
   generic(
	init_width:      integer:= 4);         -- Width (Count of Bytes -> 1,2,3 or 4)
   port(clk:             in  std_logic;
	nres:            in  std_logic;
	nres_srg:        in  std_logic;
        sel:             in  std_logic;                                   -- Select this Register
        write_pulse :    in  std_logic_vector(   init_width -1 downto 0); -- One for every Byte
	d:               in  std_logic_vector((8*init_width)-1 downto 0);
	d_int_stat:      in  std_logic_vector((8*init_width)-1 downto 0);
	int_stat_rq:     out std_logic_vector((8*init_width)-1 downto 0));
end component;


signal  eempf_rg2_i, eempf_rg3_i, enbl_accept:                std_logic;
signal  ocfg3130, ssi_i, set_ssi_i, set_ssi_ii, set_endat_i:  std_logic;
signal  sel_stat_i, cfg_allow_srg_reset_i:                    std_logic; -- For Reset Controlling of SRG,FRG
signal  nres_srg,   cfg_autom_srg_reset_i:                    std_logic; -- For Reset Controlling of SRG,FRG
signal  adr_mrs_err, fb_typ_2_i, fb_typ_3_i:      std_logic;
signal  sw_str2, sw_str1, sw_str, hw_str, hw_str2, hw_str1 :  std_logic;
signal  crc_err_i, crc_err_rg2_i, crc_err_rg3_i:              std_logic;
signal  par_err1, i_int61n, ready11, ready21, ready22:        std_logic;

signal  enbl_dsrg0_i_ssi:                                     std_logic;
signal  enbl_dsrg0_i_endat, enbl_dsrg0_endat:                 std_logic;
signal  enbl_dsrg8_i, enbl_dsrg9_i, enbl_dsrg8,  enbl_dsrg9:  std_logic;
signal  sw_krg_0, sw_krg_00, mode7, mode_11_33_44_i:          std_logic;
signal  mode_11_66_tx_i, mode_endat_2_1_i, mode_kom_2_2_i:    std_logic;
signal  mode_11_66_i, mode_7_0_i, mode7_i, mode2_i, mode0_i : std_logic;

signal  mode_all :                                     std_logic_vector( 5 downto 0);
signal  icfg, icfg2 :                                  std_logic_vector(31 downto 0);
signal  icfg3:                                         std_logic_vector(15 downto 0);
signal  dsrg, qsrg, qim:                               std_logic_vector(31 downto 0);
signal  ntestcrc:                                      std_logic_vector( 4 downto 0);
signal  mode_i, n_mode_i, mode_ii, n_mode_ii:	       std_logic_vector( 2 downto 0);
signal  cfg_dimp2_i:                                   std_logic_vector( 5 downto 0);
signal  cfg_str_delay_i:                               std_logic_vector( 7 downto  0); -- Config of Strobe Delay
signal  cfg_filt_data_i:                               std_logic_vector( 5 downto  0); -- Config of Filter for serial Data

signal  tst_empf_rg1, tst_empf_rg2, tst_empf_rg3 :     std_logic;

BEGIN 


IMR :  regist_8x  generic map(init_width	=> 4,         	-- 32 Bit
               		       init_res   	=> 0)	  	-- reset value 
   		   port    map(clk, nres, sel_im, write_pulse, d, qim);
		

KDO1 : regist_8x  generic map(init_width 	=> 4,         	-- 32 Bit
             	               init_res   	=> 3568)	-- reset value  (0000 0DF0 /h) -> 13 Bit, 100 KHz
   		   port    map(clk, nres, sel_cfg1, write_pulse, d, icfg);


KDO2 : regist_8x  generic map(init_width 	=> 4,         	-- 32 Bit
             	  	       init_res   	=> 262144)	-- reset value  (4 0000 /h)    -> 2us
   		   port    map(clk, nres, sel_cfg2, write_pulse, d, icfg2); 


KDO3 : regist_8x  generic map(init_width 	=> 2,         	-- 16 Bit
             		       init_res   	=> 108)	-- reset value  (006C /h)      -> Tree, Gray
   		   port    map(clk, nres, sel_cfg3, write_pulse(1 downto 0) , d(15 downto 0), icfg3);


STA :  statreg_8x generic map(init_width  	=> 4)        	-- 32 Bit
                   port    map(clk, nres, nres_srg, sel_stat_i, write_pulse, d, dsrg, qsrg);

		


process (nres, clk)
   begin
    if nres = '0'  then 
	   	sw_str2   <= '0';
	   	hw_str2   <= '0';
	  	par_err1  <= '0';
        	i_int61n  <= '1';
           	ready22   <= '0';
           	ready21   <= '0';
           	ready11   <= '0';

    elsif clk'event and clk='1' then

	   	sw_str2   <= sw_str1;
	   	hw_str2   <= hw_str1;
	   	par_err1  <= par_err;
          	i_int61n  <= i_int6n;
          	ready22   <= ready21;
           	ready21   <= ready2;
           	ready11   <= ready1;
    end if;
end process;


-- Strobeimpulsbildung
-----------------------
-- Das HW-Strobe-Signal wird zum Start der Taktgenerierung genutzt.
-- -> Das Strobe-Bit bedeutet hier, dass das Datenwort (Parallelwert gueltig ist)

--sw_str  <= soft_str and (not sw_str2);
--hw_str  <= hw_str1  and (not hw_str2) and icfg(0);
--hw_str1 <= str or istr;

sw_str  <= sw_str1 and (not sw_str2);
hw_str  <= hw_str1  and (not hw_str2) and icfg(0);
hw_str1 <= str;
sw_str1 <= soft_str or istr;

start_trans_hw <= (icfg(0) and hw_str);
start_trans_sw <= sw_str;

   process (nres, clk)
   begin
	if nres = '0' then
		   sw_krg_00  <= '0';
		   sw_krg_0   <= '0';
	elsif clk'event and clk='1' then
		   sw_krg_00  <= sw_krg_0;
		 if (ready1='1' and ready11='0') then 
		   sw_krg_0   <= '0';
		 elsif sw_str ='1' then
		   sw_krg_0   <= '1';
		 end if;
	end if;
   end process;

--========================================================================================
--Coding of the Configuration Registers 
---------------------------------------

   -- Set to EnDat Mode:
-----------------------

process(nres, clk)
  begin
    if (nres = '0') then 
			ocfg3130 <= '0';
    elsif clk'event and clk='1' then
			ocfg3130 <= (icfg(31) or icfg(30));
    end if;
end process;

   
   -- for EnDat:
----------------
enbl_alarm2    <= '1' when mode_i(2 downto 0) = "111"  else '0';  --For EnDat2.2 Mode Commands 

enbl_accept    <= icfg(1);
enbl_dtakt     <= icfg(2);

cfg_freq       <= icfg( 7 downto  4);
cfg_dimp2      <= icfg(13 downto  8);
cfg_dimp2_i    <= icfg(13 downto  8);
cfg_allow_srg_reset_i <= icfg(14);
cfg_autom_srg_reset_i <= icfg(15);
cfg_lzk        <= icfg(23 downto  16);
enbl_lzk       <= icfg(24)            and (not ic_test_mode);

-- decode the system frequency defined in CFG1
MHZ_64         <= '1' when icfg(28 downto 27)= "00"  else '0';
MHZ_48         <= '1' when icfg(28 downto 27)= "01"  else '0';
MHZ_32         <= '1' when icfg(28 downto 26)= "100" else '0';
MHZ_50         <= '1' when icfg(28 downto 26)= "101" else '0';
MHZ_100        <= '1' when icfg(28 downto 27)= "11"  else '0';

--set_endat_i      <= (icfg(31) and (not ocfg3130))            -- Set to EnDat Mode
--                  or 
--		  (icfg(31) and watch_dog_hard_reset);         -- Watchdog sets to EnDat Mode

set_endat_i    <= (sel_cfg1 and  write_pulse(3) and d(31) and (not d(30)))     -- Set to EnDat Mode
                  or 
		  (icfg(31) and watch_dog_hard_reset);         -- Watchdog sets to EnDat Mode

sel_stat_i     <= sel_stat when cfg_allow_srg_reset_i = '0' else
                  sel_stat when allow_srg_reset       = '1' else
                  '0';

nres_srg       <= '0' when cfg_autom_srg_reset_i = '1' and autom_srg_reset = '1' else
                  '1';

   -- for EnDat + SSI:
--------------
cfg_sample     <= icfg2( 7 downto  0);
cfg_watch      <= icfg2(15 downto  8);
cfg_time_tst   <= icfg2(18 downto 16);
--cfg_filt_data  <= icfg2(21 downto 19);
cfg_str_delay_i  <= icfg2(31 downto 24) when icfg2(31 downto 24) /="00000001" and 
                                             icfg2(31 downto 24) /="00000010" else "00000000";


Data_Filt:    process(icfg2)                                         -- Coding for Data Filter
variable addr: std_logic_vector(2 downto 0);

begin
   addr := icfg2(21 downto 19);
     case addr is                                                    -- Mindestnutzsignaldauer in clocks
	when "001"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 2,6); -- 3
	when "010"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 3,6); -- 4
	when "011"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 4,6); -- 5
	when "100"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 5,6); -- 6
	when "101"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 9,6); -- 10
	when "110"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR(19,6); -- 20
	when "111"  => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR(39,6); -- 40
	when others => cfg_filt_data_i <= CONV_STD_LOGIC_VECTOR( 0,6); -- 1 (Off)
     end case;
end process;




   -- for SSI:
--------------
parit_on       <= icfg3(0)            and ssi_flag;
ssi_format     <= icfg3(1)            and ssi_flag;
gray           <= icfg3(2)            and ssi_flag;
single_turn    <= icfg3( 7 downto  3);
double_word    <= icfg3(8)            and ssi_flag;

parit_ev       <= '0';
ssi_i          <= ssi_flag or set_ssi_ii;
--set_ssi_i      <= ((not icfg(31)) and icfg(30) and (not ocfg3130))       -- Set to SSI Mode
--                  or 
--		  (icfg(30) and watch_dog_hard_reset);                     -- Watchdog sets to SSI Mode

set_ssi_i      <= (sel_cfg1 and  write_pulse(3) and d(30) and (not d(31))) -- Set to SSI Mode
                  or 
		  (icfg(30) and watch_dog_hard_reset);                     -- Watchdog sets to SSI Mode



--==========================================================================================
-- Coding for Status Register 
-------------------------------
enbl_dsrg0_i_endat <= (icfg(0) or sw_krg_0) and (icfg(1) or (not qsrg(0)));
enbl_dsrg0_i_ssi   <= (icfg(0) or sw_krg_00) and (icfg(1) or (not qsrg(0)));

dsrg(0)  <= (enbl_dsrg0_i_ssi and ssi_i and ready21 and (not ready22) and (not double_word_flag1))  -- SSI  -- 13.01.04
                                                                                                    -- sonst wird bei DU ERG1
												    -- ueberschrieben
            or

            (enbl_dsrg0_endat and (not ssi_i) and ready2 and (not ready21)    -- EnDat 
             and (not zict(1)) and (not zict(0))                              -- only for PW 
		 );

dsrg(1)  <= alarm;

dsrg(2)  <= ( crc_err_i and (not ssi_i)  and (not ready21) )
           or
          (par_err and (not par_err1) and ssi_i and (not double_word_flag1));

dsrg(3)  <= fb_typ_1;
dsrg(4)  <= fb_typ_2_i;

dsrg(5)  <= adr_mrs_err and (not ssi_i) and ready2 and (not ready21);

dsrg(6) <= (not i_int6n) and i_int61n;
dsrg(7) <=  not i_int7n;

--dsrg(8)    <= ((icfg(0) or sw_krg_0) and (icfg(1) or (not qsrg(8)))
enbl_dsrg8_i <=  (icfg(0) or sw_krg_0) and (icfg(1) or (not qsrg(8)));         -- EnDat-Mode

dsrg(8) <= (enbl_dsrg8                                                         -- Empf-RG2
            and ready2 and (not ready21) and mode7) 

	    when ((zict = "01" and zi_bit= "11") or (zict = "01" and zi_bit= "10")) and ssi_i ='0'  else 	
	          
	   (double_word_flag1 and ready21 and (not ready22)
	    and (icfg(1) or (not qsrg(8)))  ) when ssi_i ='1' 	     else '0';

--dsrg(9)    <= ((icfg(0) or sw_krg_0) and (icfg(1) or (not qsrg(9)))
enbl_dsrg9_i <=  (icfg(0) or sw_krg_0) and (icfg(1) or (not qsrg(9)));         -- EnDat-Mode

dsrg(9) <= (enbl_dsrg9                                                         -- Empf-RG3
            and (not ssi_i) and ready2 and (not ready21) and mode7 

            )
	    when ((zict = "10" and zi_bit= "11") or (zict = "01" and zi_bit= "01")) else '0';		  

dsrg(10) <= alarm2;

dsrg(11) <= crc_err_rg3_i;
dsrg(12) <= crc_err_rg2_i;

dsrg(15 downto 13) <= qspw(23 downto 21) when mode7 = '1' and (eempf_rg2_i = '1' or 
					                       eempf_rg3_i = '1'   )     else "000";
n_rm     <= (not qspw(22))               when mode7 = '1' and (eempf_rg2_i = '1' or 
					                       eempf_rg3_i = '1'   )     else '0';						
dsrg(16) <= serial_data_spike and enbl_dig_filt;
dsrg(17) <= watch_dog_hard_reset or watch_dog_soft_reset;
dsrg(18) <= fb_typ_3_i;

dsrg(23 downto 19) <= (others => '0');
dsrg(29 downto 24) <= input_2_srg(29 downto 24);
dsrg(30)           <= '0';
dsrg(31)           <= srg_ready;
dstat              <= dsrg;
--========================================================================================
-- Masking of Interrupt Request
-------------------------------
intn  <=  not  (or_reduce (qsrg  and qim)); 


--========================================================================================
-- CRC Error Generation
-----------------------
ntestcrc      <= not(testcrc);
crc_err_i     <= '1' when ready2='1' and (qcrc /= ntestcrc) and zict  = "00" else '0';
crc_err_rg2_i <= '1' when ready2='1' and (qcrc /= ntestcrc) and zict /= "00" and dsrg(8) ='1' else '0'; -- RG2
crc_err_rg3_i <= '1' when ready2='1' and (qcrc /= ntestcrc) and zict /= "00" and dsrg(9) ='1' else '0'; -- RG3 (RG2 voll)

crc_err       <= crc_err_i and (not ssi_i) and (not ready21);
crc_err_rg2   <= crc_err_rg2_i;
crc_err_rg3   <= crc_err_rg3_i;

--========================================================================================
-- Generation of Adress-Error, MRS-Error
----------------------------------------
adr_mrs_err <= '1' when ready2='1' and (tx(23 downto 16) /= qspw(23 downto 16)) and 
                   (mode_all = "001110" or  --1   E2.1
		    mode_all = "011100" or  --3   E2.1
		    mode_all = "100011" or  --4   E2.1
		    mode_all = "101010" or  --5   E2.1
		    mode_all = "110001" or  --6   E2.1
		    mode_all = "010010")    --2-2 E2.2 - Communication Command	    
		    else '0';

--========================================================================================
-- Error Typ1 (DATA_RC = high)
------------------------------
--fb_typ_1    <= fb_typ_1_i;
--fb_typ_1_i  <= '1' when ready2='1' and (qspw(23 downto 0) = "111111111111111111111111" )   
--                                   and (qcrc = "11111")
--                                   and
--                   (mode_all = "001110" or  --1   E2.1
--		    mode_all = "011100" or  --3   E2.1
--		    mode_all = "100011" or  --4   E2.1
--		    mode_all = "101010" or  --5   E2.1
--		    mode_all = "110001" or  --6   E2.1
--		    mode_all = "010010")    --2-2 E2.2 - Communication Command	    
--		    else '0';

fb_typ_2    <= fb_typ_2_i;
fb_typ_2_i  <= '1' when ready2='1' and  (and_reduce (qspw(23 downto 0)  xor tx(23 downto 0)) ='1') 
                                   and
                   (mode_all = "001110" or  --1   E2.1
		    mode_all = "011100" or  --3   E2.1
		    mode_all = "100011" or  --4   E2.1
		    mode_all = "101010" or  --5   E2.1
		    mode_all = "110001" or  --6   E2.1
		    mode_all = "010010")    --2-2 E2.2 - Communication Command	    
		    else '0';

fb_typ_3_i  <= '1' when eempf_rg3_i ='1' and (d_empf_rg3(20 downto 16) = "01111") else --15/dec ZI1
               '1' when eempf_rg2_i ='1' and (d_empf_rg2(20 downto 16) = "11111") else --31/dec ZI2
               '0';

--========================================================================================
-- Complete Mode Command
------------------------
mode_all <= mode_ii & n_mode_ii;



--========================================================================================
-- Mode Command 0
-----------------
mode0_i <= '1' when mode_i = "000" else '0';


--========================================================================================
-- Mode Command 2
-----------------
mode2_i <= '1' when mode_i = "010" and n_mode_i = "101" else '0';


--========================================================================================
-- Mode Command 7
-----------------
mode7_i <= '1' when mode_i = "111" else '0';
mode_7  <= mode7;

--========================================================================================
-- Mode Command 7-0
-------------------
mode_7_0_i <= '1' when mode_i ="111" and n_mode_i = "000" else '0';


--========================================================================================
-- Mode Commands 1-1,3-3,4-4,5-5,6-6 (Zusatz)
---------------------------------------------
mode_11_33_44_i <= '1' when mode_ii = "111" and (n_mode_ii/="000" and n_mode_ii/="010" and n_mode_ii/="111" ) else '0'; 


--========================================================================================
-- Mode Commands 1-1,6-6
------------------------
mode_11_66_i  <= '1' when mode_i ="111" and n_mode_i /= "000" else '0';


--========================================================================================
-- Mode Commands EnDat 2.1
---------------------------------------------
mode_endat_2_1_i <= '1' when mode_i /="111" and   mode_i = (not n_mode_i) else '0';  -- 2.1-Befehle


--========================================================================================
-- Mode Command 2-2 (Kommunication Command)
---------------------------------------------
mode_kom_2_2_i <= '1' when (mode_i & n_mode_i) = "010010" else '0';  -- Mode 2-2 Kommunication


--========================================================================================
-- Coding of Mode Commands
--------------------------
n_mode_i(2 downto 0) <= tx(26 downto 24);

mode_ctrl: process (tx, zusatz_flag)
begin
if zusatz_flag='0' then
   if tx(29 downto 27) = tx(26 downto 24) and tx(29 downto 27)/="010" then
      -- Mode Com.1-1..6-6 (PW
      mode_i(2 downto 0) <= "111";
   else
      -- Die alten M.-B. (2.1), (2.2.:7-0 mit ZI)
      mode_i(2 downto 0) <= tx(29 downto 27);
   end if;
else
   case tx(29 downto 24) is
      when "001001" => mode_i(2 downto 0) <= "001";            -- Mode Command 1-1 (Rest)
      when "011011" => mode_i(2 downto 0) <= "011";            -- Mode Command 3-3 (Rest)
      when "100100" => mode_i(2 downto 0) <= "100";            -- Mode Command 4-4 (Rest)
      when "101101" => mode_i(2 downto 0) <= "101";            -- Mode Command 5-5 (Rest)
      when "110110" => mode_i(2 downto 0) <= "110";            -- Mode Command 6-6 (Rest)
      when others   => mode_i(2 downto 0) <= tx(29 downto 27); -- Die alten M.-B. (2.1), (2.2.:7-0 mit ZI)
   end case;
end if;
end process;


-- Zusatz-Sende_info
with tx(29 downto 24) select
  mode_11_66_tx_i <= zusatz_flag when "001001"|"011011"|"100100"|"101101"|"110110",  -- Mode Commands i-i except 2-2
                     '0'         when others;


--========================================================================================
-- Necessary for Destination of Data Width
------------------------------------------

klgl_24   <= '1' when (((mode_ii ="000" or mode_ii ="111") and ssi_i='0') or ssi_i='1') 
                 and cfg_dimp2_i < "011001" else '0';

--========================================================================================
-- Pipeline Register (no function)
----------------------------------
   process(nres, clk)
   begin
     if (nres = '0') then 
		mode_ii         <= "000";
		n_mode_ii       <= "000";
                mode_11_66_tx   <= '0';
		mode_endat_2_1  <= '0';
		mode_kom_2_2    <= '0';
		mode_7_0        <= '0';
		mode_11_66      <= '0';
		mode7           <= '0';
		mode_2          <= '0';
		mode_0          <= '0';
		mode_11_33_44   <= '0';
                cfg_str_delay   <= (others => '0');
                cfg_filt_data   <= (others => '0');
                set_endat       <= '0';
                set_ssi_ii      <= '0';
                enbl_dsrg0_endat<= '0';
                enbl_dsrg8      <= '0';
                enbl_dsrg9      <= '0';
	 elsif clk'event and clk='1' then
		mode_ii         <= mode_i;
		n_mode_ii       <= n_mode_i;
                mode_11_66_tx   <= mode_11_66_tx_i;
		mode_endat_2_1  <= mode_endat_2_1_i;
		mode_kom_2_2    <= mode_kom_2_2_i;
		mode_7_0        <= mode_7_0_i;
		mode_11_66      <= mode_11_66_i;
		mode7           <= mode7_i;
		mode_2          <= mode2_i;
		mode_0          <= mode0_i;
		mode_11_33_44   <= mode_11_33_44_i;
                cfg_str_delay   <= cfg_str_delay_i;
                cfg_filt_data   <= cfg_filt_data_i;
                set_endat       <= set_endat_i;
                set_ssi_ii      <= set_ssi_i;
                enbl_dsrg0_endat<= enbl_dsrg0_i_endat;
                enbl_dsrg8      <= enbl_dsrg8_i;
                enbl_dsrg9      <= enbl_dsrg9_i;
     end if;
   end process;
   
--========================================================================================
-- Allocation of Outpus
-----------------------
tst_empf_rg1 <= tst_empf_rg and sel_rx1 and write_pulse(0);
tst_empf_rg2 <= tst_empf_rg and sel_rx2 and write_pulse(0);
tst_empf_rg3 <= tst_empf_rg and sel_rx3 and write_pulse(0);

eempf_rg1   <= tst_empf_rg1 or dsrg(0);  -- pulse Coding with ready2
eempf_rg2_i <= tst_empf_rg2 or dsrg(8);
eempf_rg3_i <= tst_empf_rg3 or dsrg(9);

eempf_rg2   <= eempf_rg2_i;
eempf_rg3   <= eempf_rg3_i;

cfg1        <= icfg;
cfg2        <= icfg2;
cfg3        <= icfg3;
stat        <= qsrg(31) & srg_ready_for_strobe & qsrg(29 downto 24) & lzm_ready & lzk_activ & qsrg(21 downto 0); -- Bit(23:22) are active signals
im          <= qim;

ssi         <= ssi_i;
set_ssi     <= set_ssi_ii;

mode        <= mode_ii;
n_mode      <= n_mode_ii;

tst_zi_bit  <= zi_bit;   --Zur Signalisierung ins Test-RG
tst_dl_high <= dl_high;  --Zur Signalisierung ins Test-RG

cfg_allow_srg_reset  <= cfg_allow_srg_reset_i;
cfg_autom_srg_reset  <= cfg_autom_srg_reset_i;

end behav;

