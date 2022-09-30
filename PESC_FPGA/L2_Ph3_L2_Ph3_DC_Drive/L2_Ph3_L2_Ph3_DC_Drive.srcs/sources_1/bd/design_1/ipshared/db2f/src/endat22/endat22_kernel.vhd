--****************************************************************************************
--
--                                                          endat_kernel
--                                                          ============
-- File Name:        $RCSfile
-- Project:          END_SAFE  
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
-- Function:         Endat2.2-Interface for EnDat V2.2 (DR.J.HEIDENHAIN)
--                   With SYNC_PORT-IF
-- 
-- History: F.Seiler 04.05. 2005 Initial Version
--          F.Seiler    09/ 2005 Changes SPI, SPEED
--          F.Seiler 23.10. 2006 Nur gueltige Mode Commands werden ins TX uebernommen
--                               u. koennen somit eine Uebertragung starten.
--                               (Signale: valid_mode_commands, valid_e22_commands)
--          F.Seiler    11/ 2006 Changes allow_srg_reset, autom_srg_reset
--                               Watch Dog Reset:watch_dog_soft_reset, watch_dog_hard_reset
--          F.Seiler  09.07.2007 signal crc_err_rg2, MHz100 for OEM1 functions
--          F.Seiler xx.11. 2007 New tm measurement, new Pos1-2 compare (divider) 
--          F.Seiler xx.01. 2008 OEM1 functions 
--          F.Seiler 06.03. 2008 tst_mode_divider 
--          F.Seiler 28.03. 2008 TCLK pin solution V1, V2
--          F.Seiler 24.04. 2008 Pipieline start_trans_sw (SW-Strobe)
--          F.Seiler 30.07. 2008 Signaleausg. fuer TM Mess.
--          F.Seiler xx.09. 2008 Senslist tclk_pulse:nres, watch_dog_soft_reset
--          F.Seiler 15.12. 2008 RM-Bit+ dstat vorbreitet
--          F.Seiler 11.03. 2009 50 MHz
--          F.Seiler 17.09. 2009 enbl_tm_z25 (Stoerung, Laufzeit wegen TM-Messung)
--          R.Woyzichovski 09.04.2015 Recovery Time Measurement accordingly to
--                                    specification D1129749-00-A-01:
--                                    "Messung der Recovery Time I (Monozeit) 
--                                     Spezifikation fuer EnDAT2.2 Master(Basic)"
--****************************************************************************************
-- Revision history
--
-- $Log
--
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.endat5_pkg.all;
use endat22.resource_pkg.all;
USE ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity endat22_kernel is 
   generic
       (
        IMPLEMENT_TCLK_V1:    integer:=1;         -- Standard Solution
        IMPLEMENT_TCLK_V2:    integer:=0          -- Customer Solution
       );
   port(clk         :   in  std_logic;
        nres        :   in  std_logic; 
        scan_test   :   in  std_logic; 

        data_rc     :   in  std_logic;
        nstr        :   in  std_logic;
        n_int6      :   in  std_logic;
        n_int7      :   in  std_logic;
        intn        :   out std_logic;

        data_dv     :   out std_logic;
        de          :   out std_logic;
        ntimer      :   out std_logic;
        tclk        :   out std_logic;
        tst_out_pin :   out std_logic;
        dui         :   out std_logic;
        n_si        :   out std_logic;
        datin2moduls:   out std_logic;
        -- Recovery Time Flags
        RTM_START_O :   out   std_logic;
        RTM_STOPP_O :   out   std_logic;

-------------------------------------------------------------------------------------------
-- load pulse for registers
-- map write enable to former select signals
-------------------------------------------------------------------------------------------
        sel_tx      :   in  std_logic;         -- Select Transmission Register
        sel_rx1     :   in  std_logic;         -- Select Receive Register 1
        sel_rx2     :   in  std_logic;         -- Select Receive Register 2
        sel_rx3     :   in  std_logic;         -- Select Receive Register 3
        sel_cfg1    :   in  std_logic;         -- Select Configuration Register 1
        sel_cfg2    :   in  std_logic;         -- Select Configuration Register 2
        sel_cfg3    :   in  std_logic;         -- Select Configuration Register 3
        sel_stat    :   in  std_logic;         -- Select Status Register
        sel_im      :   in  std_logic;         -- Select Interrupt Mask Register
        sel_tst1    :   in  std_logic;         -- Select Test Register 1
        sel_tst2    :   in  std_logic;         -- Select Test Register 2

        soft_str    :   in  std_logic;         -- Soft Strobe

--  Data Stream from the Input Port to the internal registers 
        data_port_to_registers : in std_logic_vector(31 downto 0); -- Inputs from Port


-------------------------------------------------------------------------------------------
-- Signals to/from control_saf
-------------------------------------------------------------------------------------------

--  Registers
---------------

       write_pulse:                   in  std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers

       eempf_rg1  :   	              out std_logic;                     -- enable for RX1
       eempf_rg2  :                   out std_logic;                     -- enable for RX2
       eempf_rg3  :                   out std_logic;                     -- enable for RX3
       d_empf_rg1 :   	              out std_logic_vector(15 downto 0); -- Input of RX1
       d_empf_rg2 :                   out std_logic_vector(23 downto 0); -- Input of RX2
       d_empf_rg3 :   	              out std_logic_vector(31 downto 0); -- Input of RX3

       tx         :   	              out std_logic_vector(29 downto 0); -- Transmission Register
       empf_rg1   :                   out std_logic_vector(55 downto 0); -- RX1
       empf_rg2   :                   out std_logic_vector(31 downto 0); -- RX2
       empf_rg3   :                   out std_logic_vector(31 downto 0); -- RX3
--       empf_rg4   :                   out std_logic_vector(47 downto 0); -- RX4

       cfg1       :                   out std_logic_vector(31 downto 0); -- CFG1
       cfg2       :                   out std_logic_vector(31 downto 0); -- CFG2
       cfg3       :                   out std_logic_vector(15 downto 0); -- CFG3
       dstat      :                   out std_logic_vector(31 downto 0); -- Inputs of Status Register to Output
       stat       :                   out std_logic_vector(31 downto 0); -- Status Register 
       im         :                   out std_logic_vector(31 downto 0); -- Interrupt Mask Register 
       tst1       :                   out std_logic_vector(31 downto 0); -- Test Register 1
       tst2       :                   out std_logic_vector(31 downto 0); -- Test Register 2


       mode_7_0 :                     out std_logic;                     -- Mode Command 7-0
       mode_11_33_44 :                out std_logic;                     -- Mode Commands 1-1 ..6-6
       qspw :                         out std_logic_vector(23 downto 0); -- Data from Ser.Parallel Converter
       set_sende_from_ua1 :           in  std_logic;                     -- Enable for TX for values 42,43,44 when UA1
       d_pretx_mx_from_saf :          in  std_logic_vector(13 downto 0); -- Muxer for the values 942,943,944 for the TX reg
       pretx_mx_sel :                 in  std_logic;                     -- Select for Muxer for TX

--  Enable WT
-------------    

       enbl_for_wt_crc5 :             in  std_logic;                     -- enable for test od CRC5 checker
       data_for_wt_crc5 :             in  std_logic;                     -- serial data out
       rdy_wt_crc5 :                  in  std_logic;                     -- ready signal of WT CRC5 activity test
       pos1_index  :                  in  std_logic;                     -- Index for Pos1 for compare with Pos2

--  Signals of/for the Measurement System
-----------------------------------------    

       input_2_srg:                   in  std_logic_vector(29 downto 24); -- additional inputs to status register

       qcrc :                         out std_logic_vector( 4 downto 0); -- received CRC from encoder
       testcrc :                      out std_logic_vector( 4 downto 0); -- in this IC generated CRC

       crc_err  :                     out std_logic;                     -- CRC Error PW (Pos1)
       crc_err_rg2 :                  out std_logic;                     -- CRC Error ZI2
       crc_err_rg3 :                  out std_logic;                     -- CRC Error ZI1 (Pos2)

       tst_empf_rg:                   out std_logic;                     -- Test Enable RX Registers (For Test Write Modus)
       ic_test_mode:                  out std_logic;                     -- IC Test Mode
       tst_mux2:                      out std_logic_vector( 1 downto 0); -- Testmux2
       tst_mux3:                      out std_logic_vector( 1 downto 0); -- Testmux3
       tst_mode_div:                  out std_logic;                     -- Test Mode of divider 

       alarm   :                      out std_logic;                     -- Fehler1
       alarm2  :                      out std_logic;                     -- /Fehler2
       fb_typ_1:                      out std_logic;                     -- F-TypI   FRG
       fb_typ_2:                      out std_logic;                     -- F-TypII  FRG
       n_rm:                          out std_logic;                     -- not RM bit

       mode_ua1 :                     in  std_logic;                     -- 4-cycle (transmission mode ua1)
       start_trans :                  out std_logic;                     -- Start transmission (Timer, HW, SW)

       dfreq_out:                     out std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
       ec_automat:                    out std_logic_vector(5 downto 0);  -- ECLK state machine
       zi_bit    :                    out std_logic_vector(1 downto 0);  -- Number of ZI from eclk 
       autom_srg_reset:               out std_logic;
       cfg_allow_srg_reset:           out std_logic;
       cfg_autom_srg_reset:           out std_logic;
       enbl_tm_z25:                   out std_logic;                     -- Laufzeit ist eingearbeitet                
--  Signals for tm CNT
----------------------   
       usc010      :                  out std_logic;                     -- 100 ns pulse 
       usc025      :                  out std_logic;                     -- 250 ns pulse
       MHZ48       :                  out std_logic;                     -- Select 48 MHz system frequency
       MHZ50       :                  out std_logic;                     -- Select 50 MHz system frequency
       MHZ64       :                  out std_logic;                     -- Select 64 MHz system frequency
       MHZ100      :                  out std_logic;                     -- Select 100MHz system frequency

-----------------------------------------------------------------------------------------
-- Signals to Watchdog WD
-------------------------------------------------------------------------------------------

       start_wd   :                        out std_logic);


end endat22_kernel;




architecture behav of endat22_kernel is

--==========================================================================================
--  Signal Declaration
--==========================================================================================
    signal qsoft_str                : std_logic;                     -- Select Software Strobe
--  Data Stream from the internal registers to the Output Port
    signal pretx                    : std_logic_vector(31 downto 0); -- Transmission Pre-Register
    signal tx_i                     : std_logic_vector(29 downto 0); -- Transmission Register
    signal d_empfrg, q_empfrg       : std_logic_vector(47 downto 0); -- Receive Register 1
    signal i_empf_rg1               : std_logic_vector( 7 downto 0); -- 
    signal d_empfrg1_h              : std_logic_vector( 7 downto 0); 
    signal d_empf_rg2_i             : std_logic_vector(31 downto 0); -- Receive Register 2
    signal d_empf_rg3_i             : std_logic_vector(31 downto 0); -- Receive Register 3

    signal qspw_i                   : std_logic_vector(47 downto 0); -- Data from Ser.Parallel Converter
    signal qcrc_i                   : std_logic_vector( 4 downto 0); -- received CRC from encoder
    signal cfg                      : std_logic_vector(31 downto 0); -- Configuration Register 1
    signal dsrg                     : std_logic_vector(31 downto 0); -- Inputs of Status Register to Output 
    signal srg                      : std_logic_vector(31 downto 0); -- Status Register 
    signal tst2_i                   : std_logic_vector(31 downto 0); -- Test Register 2

   
    signal usc025_i, usc1, usc2, usc100, usc200, usc500, usc1000 :                std_logic;
    signal clk_shift, dui_i:                                                      std_logic;
    signal MHZ_100, MHZ_64, MHZ_50, MHZ_48, MHZ_32:                               std_logic;
    signal de_i, nsrb_i:                                                          std_logic;
--    signal nc:                                                                    std_logic;
    signal data_rc_i:                                                             std_logic;

    signal nstr1, nstr_i, nstr1_delay, str, timer_str, timer_strobe:              std_logic;
    signal watch_dog_soft_reset, watch_dog_hard_reset:                            std_logic;
    signal watch_dog_pulse, enbl_watch_dog, enbl_sample:                          std_logic;
    signal n_int6_i, n_int7_i, i_int6n, i_int7n:                                  std_logic;

    signal klgl_24:                                                               std_logic;

    signal set_endat, enbl_lzk, enbl_dig_filt:                                    std_logic;
    signal enbl_dtakt, enbl_alarm2, data_in, ready1, ready2:                      std_logic;
    signal stopbit, Z1415, enspw, enspwcrc, shift_rest, fmsb, enpsw, data_oe_n:   std_logic;
    signal alarm_i, alarm2_i, ld_alarm, ld_alarm2, fb_typ_1_i, dl_high:           std_logic;
    signal data_out, ssi_flag, freq_out, double_word, double_word_flag1:          std_logic;
    signal set_ssi, ssi, par_err, gray, parit_on, parit_ev, ssi_format:           std_logic;
    signal single_turn :                          std_logic_vector(4 downto 0);

    signal start_trans_hw, start_trans_sw, q_start_trans_sw:                      std_logic;
    signal sende_flag, setpsw,set_sende:                                          std_logic;

    signal dat_in, serial_data_spike :                                            std_logic;  
    signal eempf_rg1_i, eempf_rg2_i, eempf_rg3_i, zusatz_flag:                    std_logic;
    signal zi_bit_i :                             std_logic_vector( 1 downto 0); 

    signal mode, n_mode :                         std_logic_vector(2 downto 0);
    signal mode_11_33_44_i, mode_11_66_tx, mode_11_66:                            std_logic;
    signal mode_endat_2_1, mode_kom_2_2, mode_7_0_i, mode_7, mode_2, mode_0:      std_logic;
    signal valid_mode_commands, valid_e22_commands :                              std_logic;
    signal test_qfreq :                           std_logic_vector(freq_widh -1 downto 0);
    signal cfg_dimp2 :                            std_logic_vector(imp_zahl  -1 downto 0);
    signal cfg_sample, cfg_watch :                std_logic_vector( 7 downto 0);
    signal testcrc_i:                             std_logic_vector( 4 downto 0);
    signal ec_automat_i :                         std_logic_vector( 5 downto 0);

    signal qpsw:                                  std_logic_vector(15 downto 0);
    signal lzm_ready, lzk_activ  :                std_logic;
    signal del_ct :                               std_logic_vector( 7 downto 0);
    signal del_rg :                               std_logic_vector( 7 downto 0);
    signal imp :                                  std_logic_vector(imp_zahl downto 0);

    signal cfg_freq :                             std_logic_vector( 4 downto 0);
    signal cfg_lzk :                              std_logic_vector( 7 downto 0);
    signal cfg_time_tst:                          std_logic_vector( 2 downto 0);
    signal cfg_filt_data:                         std_logic_vector( 5 downto 0);
    signal cfg_str_delay:                         std_logic_vector( 7 downto 0);

    signal allow_srg_reset:                       std_logic;
    signal autom_srg_reset_i:                     std_logic;
    signal srg_ready, srg_ready_for_strobe:       std_logic;

    signal qzict:                                 std_logic_vector( 1 downto 0);
    signal zict:                                  std_logic_vector( 1 downto 0);
    signal Q_1US:                                 std_logic_vector( 6 downto 0);
    signal Q_1000US:                              std_logic_vector(10 downto 0);
    signal timer_rq, watch_rq :                   std_logic_vector( 6 downto 0);

--  Signal for Test
    signal test_s_ct :                            std_logic_vector(12 downto 0); 
    signal test_max_s_ct :                        std_logic_vector(13 downto 0); 
--    signal test_i:                                std_logic_vector(19 downto 0);
    signal ic_test_mode_i,test_flag,tst_empf_rg_i:std_logic;
    signal tst_out_pin_i, tst_out_pin_sel:        std_logic;
    signal tst_mux:                               std_logic_vector( 1 downto 0);
    signal tst_zi_sel:                            std_logic_vector( 2 downto 0);
    signal tst_data:                              std_logic_vector(47 downto 0);
    signal tst_zi_bit:                            std_logic_vector( 1 downto 0);
    signal tst_dl_high:                           std_logic;
    signal start_pulse_ct:                        std_logic_vector( 3 downto 0);
    signal n_si_i, tclk_i, tclk_start, enbl_tclk_start_i, enbl_tclk_start :  std_logic;

    signal no_tst_empf_rg_and_no_ssi:             std_logic;
    signal no_tst_empf_rg_and_ssi:                std_logic;
--========================================================================================
-- New Signals 

    signal load_alarm   :                std_logic_vector( 1 downto 0); -- Load Alarm into ERG1
    signal d_empf_rg1_in_alarm:          std_logic_vector( 1 downto 0); -- D-Input Alarm into ERG1
    signal q_empfrg1_al2 :               std_logic;                     -- Alarm2-Bits + SSI im ERG1  
    signal q_empfrg1_al :                std_logic_vector( 1 downto 0); -- Alarm1,2-Bits im ERG1
    signal pretx_mx :                    std_logic_vector(29 downto 0); -- Input TX Register


--  Signals of/for the Measurement System
-----------------------------------------    

--  signal start_cycle_234 :             std_logic;                     -- SW-Start of cycles 1,2,3 while UA1
    signal start_trans_sw_mux:           std_logic;                     -- SW-Start 

--========================================================================================

    -- constant signals
    --------------------------------
    signal hi, lo: std_logic; -- hi, lo driven signals



-- adding signals to implement the recovery time measurement (tm) acc. D1129749-00-A-01
-- -------------------------------------------------------------------------------
    signal rt_data_s:                   std_logic_vector(WORD-1 downto 0);  -- tm measurement value
    signal rt_start_s:                  std_logic;                          -- start event of tm measurement
    signal rt_stopp_s:                  std_logic;                          -- stopp event of tm measurement
    signal status_map_s:                std_logic_vector(input_2_srg'range);-- input_2_srg + start/stopp events
    signal cfg2_s:                      std_logic_vector(cfg2'range);       -- cfg2 interconnect

--========================================================================================
-- component declaration
--========================================================================================

component control_e6
   port(clk, nres  :                     in  std_logic;                     -- clk, Reset
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
    klgl_24  :                               out std_logic;   -- less than    25
    
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
--  enbl_accept    :                     out std_logic;   -- Enable Data Acception
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
    tst_dl_high   :                     out std_logic;                       -- Control Information about Data_rc Line

--  New Outputs for E6
-------------------------------------------------
    crc_err       :                     out std_logic;                       -- CRC Empf.Reg1 (Pos1)
    crc_err_rg2   :                     out std_logic;                       -- CRC Empf.Reg2
    crc_err_rg3   :                     out std_logic;                       -- CRC Empf.Reg3 (Pos2)
    fb_typ_1      :                     in  std_logic;                       -- F-Typ I  to FRG
    fb_typ_2      :                     out std_logic;                       -- F-Typ II to FRG
    n_rm          :                     out std_logic);                      -- not RM bit
end component;


component eclkgen
   port(clk, nres: in std_logic; 
--      Time Base
        usc1 :                  in std_logic;
   	mhz_64, mhz_50, mhz_48, mhz_32, mhz_100: in std_logic; -- Select system frequency 
--      Signals from Port
        sel_cfg1 :              in  std_logic;         -- necessary for Delay Register
	write_pulse :           in  std_logic;         -- necessary for Delay Register
--      Signals for Configuration
   	set_ssi,set_endat, fmsb, klgl_24, start_eclk_hw, start_eclk_sw, enbl_dtakt: in std_logic;
        data_in, enbl_alarm2, parit_on, ssi_format, double_word: in std_logic;
	single_turn:            in  std_logic_vector(4 downto 0);
        tx:                     in  std_logic_vector(29 downto 16);
        cfg_lzk:                in  std_logic_vector( 7 downto 0);
        mode :                  in  std_logic_vector(2 downto 0);
        n_mode :                in  std_logic_vector(2 downto 0);
        mode_11_33_44:          in  std_logic;   -- Mode Commands 1-1 ..6-6 
        mode_11_66_tx:          in  std_logic;   -- Mode Commands 1-1 ..6-6 Additional TX-Part
        mode_11_66:             in  std_logic;   -- Mode Commands 1-1 ..6-6
	mode_endat_2_1:         in  std_logic;   -- Mode Commands EnDat 2.1
	mode_kom_2_2:           in  std_logic;   -- Mode Command 2-2
        mode_7_0:               in  std_logic;   -- Mode Command 7-0
        mode_7:                 in  std_logic;   -- Mode Command 7-0
        mode_2:                 in  std_logic;   -- Mode Command 2
        mode_0:                 in  std_logic;   -- Mode Command 0
        cfg_freq:               in  std_logic_vector(3 downto 0);
        dimp2 :                 in  std_logic_vector(imp_zahl -1 downto 0);
        cfg_time_tst:           in  std_logic_vector(2 downto 0);
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
        clk_shift, freq_out, stopbit,Z1415,enspw, enspwcrc, shift_rest, enpsw, data_oe_n,enbl_dig_filt: out std_logic;
        alarm, alarm2, ld_alarm, ld_alarm2: out std_logic; 
        fb_typ_1:               out std_logic;
	dl_high, dui, ready1, ready2, ssi_flag, double_word_flag1, zusatz_flag: out std_logic;
        zibit:                  out std_logic_vector(1 downto 0);
        zict:                   out std_logic_vector(1 downto 0);
        qzict:                  out std_logic_vector(1 downto 0);
        allow_srg_reset:        out std_logic;
        autom_srg_reset:        out std_logic;
        srg_ready:              out std_logic;
        srg_ready_for_strobe:   out std_logic;
--      Signals for Test Mode
        ic_test_mode:           in  std_logic;
        tst_zi_sel:             in  std_logic_vector(2 downto 0);
        test_max_s_ct:          out std_logic_vector(13 downto 0);
        test_s_ct:              out std_logic_vector(12 downto 0);
	test_qfreq:             out std_logic_vector(freq_widh -1 downto 0);
        test_flag_out:          out std_logic);
end component;

component regist
   generic(init_width:    integer:= 1;   -- Width
           init_res:      integer:= 0);  -- Reset Value
   port(clk, nres, enbl : in std_logic;
        d : in  std_logic_vector(init_width -1 downto 0);
        q : out std_logic_vector(init_width -1 downto 0));
end component;

component regist2

   generic(init_width:    integer:= 1;   -- Width
           init_res:      integer:= 0);  -- Reset Value
		
   port(clk, nres : in std_logic;
        enbl :      in  std_logic_vector(init_width-1 downto 0);
        d :         in  std_logic_vector(init_width-1 downto 0);
        q :         out std_logic_vector(init_width-1 downto 0));
end component;

component regist_8x
   generic(init_width:   integer:= 4;   -- Width (Count of Bytes -> 1,2,3 or 4)
           init_res:     integer:= 0);  -- Reset Value
		
   port(clk, nres:       in std_logic;
        sel:             in std_logic;
        write_pulse :    in  std_logic_vector(   init_width -1 downto 0);
        d :              in  std_logic_vector((8*init_width)-1 downto 0);
        q :              out std_logic_vector((8*init_width)-1 downto 0));
end component;

component digfilt_par2
   generic(
	filt_width :     integer:= 1); 
   port(clk, nres, inpp: in  std_logic;
        d :              in  std_logic_vector(filt_width - 1 downto 0);
	qout, spike :    out std_logic);
end component;

component counter_par
      generic(
	   filt_width :      integer:= 1); 
      port(clk, nres, inpp : in  std_logic;
           d :               in  std_logic_vector(filt_width - 1 downto 0);
	   qout :            out std_logic);
end component;

component psw
   port(clk, nres, load, clk_shift, enpsw: in std_logic;       -- Signals for Shifter
        d :           in  std_logic_vector(29 downto 0);
        q :           out std_logic_vector(15 downto 0);
                                                               -- Configuration Signals for Mux
        ec_automat:   in  std_logic_vector( 5 downto 0);
        imp:          in  std_logic_vector(imp_zahl downto 0);
        zusatz_flag:  in  std_logic;
                                                               -- Serial Data Out
        data_out:     out std_logic);
end component;

component spw
   port(clk, nres, res2, ssi, fmsb, gray, clk_shift, Z1415, enspw, enspwcrc: in  std_logic; 
        shift_rest, ind, set_endat, parit_on, parit_ev, ready2, klgl_24 :  in  std_logic;
        qspw :        out std_logic_vector(47 downto 0);
        qcrc :        out std_logic_vector( 4 downto 0);
        testcrc :     out std_logic_vector( 4 downto 0);
        par_fehl:     out std_logic;

        enbl_for_wt_crc5 :  in  std_logic;              -- enable for test od CRC5 checker
        data_for_wt_crc5 :  in  std_logic;              -- serial data out
        rdy_wt_crc5      :  in  std_logic               -- ready signal of WT CRC5 activity test
       );
end component;


component timer
   port(clk, nres:    in  std_logic;                    -- system clk, reset
        ic_test_mode: in  std_logic;                    -- select test mode
	usc2, usc200: in  std_logic;                    -- clk pulse input
        enbl_timer:   in  std_logic;                    -- Enable Timer
        d_conf_rg :   in  std_logic_vector(7 downto 0); -- Data from configuration register
        timer_rq :    out std_logic_vector(6 downto 0); -- 7-bit-Timer
	clock_out :   out std_logic;                    -- Continuous clk Signal (1:1)
	pulse_out :   out std_logic);                   -- Output Pulse Signal
end component;
    
    
component timer_1us
   port	(clk, nres:                      in std_logic; -- system clk , reset
	mhz_100, mhz_64, mhz_50, mhz_48, mhz_32: in std_logic; -- define the system frequency
	test :                           in std_logic; -- select test mode
	Q1:	 out std_logic_vector( 6 downto 0);    -- test vector us counter
	Q1000:	 out std_logic_vector(10 downto 0);    -- test vector us counter
	--
	usc010:	 out std_logic;	 -- 0.10 us pulse
	usc025:	 out std_logic;	 -- 0.25 us pulse
	usc1:    out std_logic;	 -- 1    us pulse
	usc2:    out std_logic;	 -- 2    us pulse
	usc100:  out std_logic;	 -- 100  us pulse
	usc200:  out std_logic;	 -- 200  us pulse
	usc500:  out std_logic;	 -- 500  us pulse
	usc1000: out std_logic); -- 1000 us pulse
end component;


component inpff
   port(clk, I : in  std_logic;
        O :      out std_logic);   
end component;

-- component to implement measurement of recovery time tm
component RT_COUNTER
    generic (
        IMPLEMENT_G : integer;
        DATA_WIDTH_G : integer;
        PORT_WIDTH_G : integer
    );
    port (
        CLK:        in std_logic;
        RES_IX:     in std_logic;
        RX_I:       in std_logic;
        RT_ON_I:    in std_logic;
        INIT_I:     in std_logic;
        BE_I :      in std_logic_vector ( DATA_WIDTH_G/BYTE-1 downto 0 );
        RT_INIT_I:  in std_logic_vector ( PORT_WIDTH_G-1 downto 0 );
        DEL_CT_I:   in std_logic_vector ( 7 downto 0 );
        EC_STATE_I: in std_logic_vector ( 5 downto 0 );
        MODE_I:     in std_logic_vector ( 5 downto 0 );
        MRS_I:      in std_logic_vector ( 7 downto 0 );
        RT_DATA_O:  out std_logic_vector ( PORT_WIDTH_G-1 downto 0 );
        RT_START_O: out std_logic;
        RT_STOPP_O: out std_logic
    );
end component;


begin

-- constant level signals
hi <= '1';
lo <= '0';

--========================================================================================
-- VHDL-Place Holder for Pads
-----------------------------

-- Measurement System
U_DRC    :  inpff port map(clk, data_rc,   data_rc_i);
U_DRC_2  :  inpff port map(clk, data_rc_i, dat_in);
U_NSTR   :  inpff port map(clk, nstr,      nstr_i);  
U_NSTR_2 :  inpff port map(clk, nstr_i,    nstr1);  
U_IR6    :  inpff port map(clk, n_int6,    n_int6_i);
U_IR6_2  :  inpff port map(clk, n_int6_i,  i_int6n);
U_IR7    :  inpff port map(clk, n_int7,    n_int7_i);
U_IR7_2  :  inpff port map(clk, n_int7_i,  i_int7n);

	  
-- Outputs	  
U_DV  :  inpff port map(clk, data_out, data_dv);   -- Output
U_NSRB:  ntimer   <= nsrb_i;
U_DE  :  inpff port map(clk, de_i, de);   -- Output

U_TCLK : tclk     <= tclk_i;

datin2moduls   <= dat_in;

U_TST_D_RC : inpff port map(clk, tst_out_pin_i, tst_out_pin); -- Output
U_DUI :      inpff port map(clk, dui_i,         dui);         -- Output
U_SI :       n_si        <= n_si_i;



-- Pipeline Register - for functional identity to endat22
---------------------------------------------------------
   process(nres, clk)
   begin
     if (nres = '0') then
                qsoft_str <= '0';
         elsif clk'event and clk='1' then
                qsoft_str <= soft_str; -- Select Software Strobe
     end if;
   end process;

-----------------------------------------------------------------------------

    cfg1 <= cfg    when cfg(24) ='0' else cfg(31 downto 24) & del_rg & cfg(15 downto 0);  -- Bei LZK Delay-RG
    stat(31 downto 11) <= srg(31 downto 11);
    stat(10)           <= not srg(10);
    stat( 9 downto  0) <= srg( 9 downto  0);


--========================================================================================
-- Measurement Controlling Unit
-------------------------------
ctrl: control_e6
   port map(
    clk  	      => clk,                 -- System clk
    nres  	      => nres,                -- Reset

    d     	      => data_port_to_registers,
    d_empf_rg2        => d_empf_rg2_i(20 downto 16), -- Input of RX2
    d_empf_rg3        => d_empf_rg3_i(20 downto 16), -- Input of RX3

    sel_rx1           => sel_rx1,             -- Select Receive Register 1
    sel_rx2           => sel_rx2,             -- Select Receive Register 2
    sel_rx3           => sel_rx3,             -- Select Receive Register 3
    sel_cfg1          => sel_cfg1,            -- Select Configuration Register 1
    sel_cfg2          => sel_cfg2,            -- Select Configuration Register 2
    sel_cfg3          => sel_cfg3,            -- Select Configuration Register 3
    sel_stat          => sel_stat,            -- Select Status Register 
    sel_im            => sel_im,              -- Select Interrupt Mask Register 
    soft_str          => qsoft_str,            -- Select Software Strobe
    write_pulse       => write_pulse,         -- Write Pulse for Bytes of Registers
    cfg1     	      => cfg,                 -- Configuration Register 1
    cfg2    	      => cfg2_s,                -- Configuration Register 2
    cfg3    	      => cfg3,                -- Configuration Register 3
    dstat             => dsrg,                -- inputs of Status Register to Output
    stat              => srg,                 -- Status Register
    im                => im,                  -- Interrupt Mask Register

    tx                => tx_i,                -- Data from TX Register
    qspw              => qspw_i,              -- Data from Ser.Parallel Converter

    eempf_rg1         => eempf_rg1_i,         -- Enable RX Register1
    eempf_rg2         => eempf_rg2_i,         -- Enable RX Register2
    eempf_rg3         => eempf_rg3_i,         -- Enable RX Register3
    tst_empf_rg       => tst_empf_rg_i,       -- Test Enable RX Registers (For Test Write Modus)
    ic_test_mode      => ic_test_mode_i,      -- IC Test Mode

-- Necessary for Destination of Data Width
------------------------------------------
    klgl_24               => klgl_24,               -- less than 25
    
--  Signals of/for the Measurement System
-----------------------------------------    

    start_trans_hw    => start_trans_hw,      -- Start Transmission with Hardware Strobe
    start_trans_sw    => start_trans_sw,      -- Start Transmission with Software Strobe
    str               => str,                 -- Strobe Signal from Pin
    istr              => timer_strobe,        -- Strobe Signal from internal Timer
    watch_dog_soft_reset => watch_dog_soft_reset, -- Breaking signal to reset E.Statemachine without LZK
    watch_dog_hard_reset => watch_dog_hard_reset, -- Breaking signal to reset E.Statemachine and LZK
    input_2_srg       => status_map_s,        -- additional inputs to status register

    mode              => mode,                -- Coding Mode Command
    n_mode            => n_mode,              -- Coding Mode Command
    mode_11_33_44     => mode_11_33_44_i,
    mode_11_66_tx     => mode_11_66_tx,       -- Mode Commands 1-1 ..5-5 Additional TX-Part
    mode_11_66        => mode_11_66,          -- Mode Commands 1-1 ..6-6
    mode_endat_2_1    => mode_endat_2_1,      -- Mode Commands EnDat 2.1
    mode_kom_2_2      => mode_kom_2_2,        -- Mode Command 2-2
    mode_7_0          => mode_7_0_i,          -- Mode Command 7-0
    mode_7            => mode_7,              -- Mode Command 7-0
    mode_2            => mode_2,              -- Mode Command 2
    mode_0            => mode_0,              -- Mode Command 0
    ready1            => ready1,              -- Data Transmission was done
    ready2            => ready2,              -- Data Transmission was done    

    alarm             => alarm_i,             -- Error1 of Encoder
    alarm2            => alarm2_i,            -- Error2 of Encoder
    dl_high           => dl_high,             -- Data line (DATA_RC) is high 

    serial_data_spike => serial_data_spike,   -- Spike on DATA_RC 
    zi_bit            => zi_bit_i,            -- Coding for Count of ZI
    zict              => qzict,               -- Coding for Count of ZI
    zusatz_flag       => zusatz_flag,         -- Zusatzflag
    qcrc              => qcrc_i( 4 downto 0), -- From Encoder received CRC Value
    testcrc           => testcrc_i(4 downto 0),-- Self generated CRC Value

    lzm_ready         => lzm_ready,         -- Cable Delay Measurement was done  
    lzk_activ         => lzk_activ,         -- Cable Delay Compensation is active

    ssi_flag          => ssi_flag,          -- SSI Mode
    double_word_flag1 => double_word_flag1, -- SSI-Double Word Processing
    par_err           => par_err,           -- Parity Error (only in SSI Mode)

    i_int6n           => i_int6n,           -- free Interrupt Input
    i_int7n           => i_int7n,           -- free Interrupt Input
    intn              => intn,              -- Interrupt Request to Micro Controller

--  Configuration Outputs for EnDat and SSI Mode
-------------------------------------------------
--  for EnDat:
    enbl_alarm2       => enbl_alarm2,               -- Enable of Alarmbit 2
--  enbl_accept       => enbl_accept,               -- Enable Data Acception
    enbl_dtakt        => enbl_dtakt,                -- Enable "Nonstop TCLK"
    cfg_freq          => cfg_freq( 3 downto 0),     -- Config. of Transmission Frequency
    cfg_dimp2         => cfg_dimp2(5 downto 0),     -- Config. of Data Word Length
    cfg_lzk           => cfg_lzk(  7 downto 0),     -- Config. Cable Delay Compensation
    enbl_lzk          => enbl_lzk,                  -- Enable Cable Delay Compensation
    MHZ_64            => MHZ_64,                    -- Select  64 MHZ (System Frequency)
    MHZ_50            => MHZ_50,                    -- Select  50 MHZ (System Frequency)
    MHZ_48            => MHZ_48,                    -- Select  48 MHZ (System Frequency)
    MHZ_32            => MHZ_32,                    -- Select  32 MHZ (System Frequency)
    MHZ_100           => MHZ_100,                   -- Select 100 MHZ (System Frequency)
    set_endat         => set_endat,                 -- Set to EnDat Mode
    allow_srg_reset   => allow_srg_reset,
    autom_srg_reset   => autom_srg_reset_i,
    srg_ready           => srg_ready,
    srg_ready_for_strobe => srg_ready_for_strobe,
    cfg_allow_srg_reset => cfg_allow_srg_reset,
    cfg_autom_srg_reset => cfg_autom_srg_reset,

--  for EnDat  + SSI:
    cfg_sample        => cfg_sample(7 downto 0),    -- Config of Timer for Sampling Rate 
    cfg_watch         => cfg_watch(7 downto 0),     -- Config of Watch Dog Timer
    cfg_time_tst      => cfg_time_tst(2 downto 0),  -- Config of Time Tst
    enbl_dig_filt     => enbl_dig_filt,             -- enbl Filter during Data Receive 
    cfg_filt_data     => cfg_filt_data(5 downto 0), -- Config of Filter for serial Data
    cfg_str_delay     => cfg_str_delay(7 downto 0), -- Config of Strobe Delay

--  for SSI:
    parit_on          => parit_on,                  -- Enable Parity Check (SSI, even)
    ssi_format        => ssi_format,                -- Select SSI Format (Tree or right)
    gray              => gray,                      -- Enable Gray Format for Data
    single_turn       => single_turn(4 downto 0),   -- Singleturn Value of Encoder
    double_word       => double_word,               -- Enable Double Word

    parit_ev          => parit_ev,                  -- Parity even 
    set_ssi           => set_ssi,                   -- Set to SSI Mode
    ssi               => ssi,                       -- SSI Mode
--  Configuration Outputs for EnDat and SSI Mode
-------------------------------------------------
    tst_zi_bit        => tst_zi_bit,                -- Control Information about ZI Status
    tst_dl_high       => tst_dl_high,               -- Control Information about Data_rc Line

--  New Outputs for E6
-------------------------------------------------
    crc_err           => crc_err,                   -- CRC Empf.Reg1 (Pos1)
    crc_err_rg2       => crc_err_rg2,               -- CRC Empf.Reg2
    crc_err_rg3       => crc_err_rg3,               -- CRC Empf.Reg3 (Pos2)
    fb_typ_1          => fb_typ_1_i,                -- F-TypI   to FRG
    fb_typ_2          => fb_typ_2,                  -- F-TypII  to FRG
    n_rm              => n_rm                       -- not RM bit
   );

--========================================================================================
-- EnDat Kernal
---------------
eclk: eclkgen
   port map(clk, nres, 
                                             -- Time Base
        usc1,
        mhz_64, mhz_50, mhz_48, mhz_32, mhz_100,
                                             -- Signals from Port
        sel_cfg1,
	write_pulse(2),
                                             -- Signals for Configuration
	set_ssi,set_endat, fmsb, klgl_24, 
	start_trans_hw, start_trans_sw_mux, enbl_dtakt, 
        data_in, enbl_alarm2, parit_on, ssi_format, double_word, 
	single_turn(4 downto 0),
        tx_i(29 downto 16),
        cfg_lzk(7 downto 0),
        mode(2 downto 0),
        n_mode(2 downto 0),
	mode_11_33_44_i,
        mode_11_66_tx,     -- Mode Commands 1-1 ..5-5 Additional TX-Part
        mode_11_66,        -- Mode Commands 1-1 ..6-6
        mode_endat_2_1,    -- Mode Commands EnDat 2.1
        mode_kom_2_2,      -- Mode Command 2-2
        mode_7_0_i,        -- Mode Command 7-0
        mode_7,            -- Mode Command 7-0
        mode_2,            -- Mode Command 2
        mode_0,            -- Mode Command 0
        cfg_freq(3 downto 0),
        cfg_dimp2(imp_zahl -1 downto 0),
        cfg_time_tst(2 downto 0),
                                             -- Signals for Cable Delay Measurement 
        enbl_lzk            => enbl_lzk,
        del_ct              => del_ct, 
	del_rg              => del_rg,
        lzm_ready           => lzm_ready,
	lzk_activ           => lzk_activ,
	enbl_tm_z25         => enbl_tm_z25,
                                             --      Watch Dog Signals  
        watch_dog_pulse     => watch_dog_pulse,       -- Breaking Pre-Signal from watch dog
        watch_dog_soft_reset => watch_dog_soft_reset, -- Breaking signal to reset E.Statemachine without LZK
        watch_dog_hard_reset => watch_dog_hard_reset, -- Breaking signal to reset E.Statemachine and LZK
	                                     -- Output Signals
        ec_automat          => ec_automat_i,
        imp                 => imp(imp_zahl downto 0),
	dfreq_out           => dfreq_out(freq_widh-1 downto 0), -- TCLK-frequency
	clk_shift           => clk_shift, 
	freq_out            => freq_out, 
	stopbit             => stopbit, 
	Z1415               => Z1415,
	enspw               => enspw, 
	enspwcrc            => enspwcrc, 
	shift_rest          => shift_rest, 
	enpsw               => enpsw, 
	data_oe_n           => data_oe_n, 
	enbl_dig_filt       => enbl_dig_filt,
	alarm               => alarm_i, 
	alarm2              => alarm2_i, 
	ld_alarm            => ld_alarm, 
	ld_alarm2           => ld_alarm2, 
        fb_typ_1            => fb_typ_1_i,
	dl_high             => dl_high, 
	dui                 => dui_i,
	ready1              => ready1, 
	ready2              => ready2, 
	ssi_flag            => ssi_flag, 
        double_word_flag1   => double_word_flag1,
	zusatz_flag         => zusatz_flag, 
        zibit               => zi_bit_i(1 downto 0),
	zict                => zict(1 downto 0), 
	qzict               => qzict(1 downto 0), 
        allow_srg_reset     => allow_srg_reset,
        autom_srg_reset     => autom_srg_reset_i,
        srg_ready           => srg_ready,
        srg_ready_for_strobe => srg_ready_for_strobe,
                                             -- Signals for Test Mode
        ic_test_mode        => ic_test_mode_i,
        tst_zi_sel          => tst_zi_sel,
	test_max_s_ct       => test_max_s_ct,
	test_s_ct           => test_s_ct,
	test_qfreq          => test_qfreq,
	test_flag_out       => test_flag);


--========================================================================================
-- Internal Registers (TX, RX, Parallel-to-Serial-Converter, Serial-to-Parallel-Converter)
------------------------------------------------------------------------------------------

pres  : regist_8x  generic map(init_width => 4,          -- 32 Bit
             	               init_res   => 117440512)	 -- reset value (07000000/h) -> Transmission of Position Value
   		   port    map(clk, nres, sel_tx, write_pulse, data_port_to_registers, pretx);

pretx_mx(29 downto 0) <=  d_pretx_mx_from_saf & pretx(15 downto 0) when pretx_mx_sel = '1'                               else  -- 942, 943, 944
--                          "11100000000000"    & pretx(15 downto 0) when mode_ua1     = '1' and valid_e22_commands  = '0' else  -- Mode Command 38 
--                          "00011100000000"    & pretx(15 downto 0) when                        valid_mode_commands = '0' else  -- Mode Command 0 
                          pretx(29 downto 0);

valid_e22_commands  <= '1' when pretx(29 downto 27) =      pretx(26 downto 24)  and pretx(29 downto 24) /= "000000" 
                                                                                and pretx(29 downto 24) /= "111111"  
                                                                                and pretx(29 downto 24) /= "010010" else
                       '1' when pretx(29 downto 24) = "111000"                  else

		       '0';
valid_mode_commands <= '1' when pretx(29 downto 27) =      pretx(26 downto 24)  and pretx(29 downto 24) /= "000000" and pretx(29 downto 24) /= "111111" else
                       '1' when pretx(29 downto 27) = not (pretx(26 downto 24)) else
		       '0';
		       
sende : regist     generic map(init_width => 30,    -- width
                               init_res   => 117440512)	 -- reset value (07000000/h) -> Transmission of Position Value
                   port    map(clk, nres, set_sende,
                               pretx_mx(29 downto 0),
			          tx_i(29 downto 0));

ps_w :  psw        port    map(clk, nres, setpsw, clk_shift, enpsw, 
                               tx_i(29 downto 0), 
			       qpsw(15 downto 0),
			       ec_automat_i,
			       imp,
			       zusatz_flag,
                               data_out);


sp_w : spw  port map(clk, nres, watch_dog_soft_reset, ssi, fmsb, gray, clk_shift, Z1415,enspw, enspwcrc,
                     shift_rest, data_in, set_endat, parit_on, parit_ev, ready2, klgl_24,
                     qspw_i(47 downto 0),
                     qcrc_i(4 downto 0),
                     testcrc_i(4 downto 0),
                     par_err, enbl_for_wt_crc5, data_for_wt_crc5, rdy_wt_crc5);

no_tst_empf_rg_and_no_ssi <= '1' when tst_empf_rg_i= '0' and ssi ='0' else '0';
no_tst_empf_rg_and_ssi    <= '1' when tst_empf_rg_i= '0' and ssi ='1' else '0';

d_empfrg     <=                                qspw_i(47 downto 0)  when tst_empf_rg_i= '0'              else tst_data;
d_empf_rg2_i <= ("000" & qcrc_i( 4 downto 0) & qspw_i(23 downto 0)) when no_tst_empf_rg_and_no_ssi = '1' else 
                                               qspw_i(31 downto 0)  when no_tst_empf_rg_and_ssi    = '1' else tst_data(31 downto 0);

d_empf_rg3_i <= ("000" & qcrc_i( 4 downto 0) & qspw_i(23 downto 0)) when tst_empf_rg_i= '0'              else tst_data(31 downto 0);


E_RG1 : regist generic map(init_width => 48,    -- width
                           init_res   => 0)     -- reset value  
               port    map(clk, nres, eempf_rg1_i,
                           q_empfrg(47 downto 0),
			   empf_rg1(47 downto 0));

E_RG1H : regist generic map(init_width => 8,    -- width
                            init_res   => 0)     -- reset value  
                port    map(clk, nres, eempf_rg1_i,
                            d_empfrg1_h(7 downto 0),
		 	    i_empf_rg1 (7 downto 0));

E_RG1AL : regist2 generic map(init_width => 2,    -- width
                            init_res   => 0)     -- reset value  
                port    map(clk, nres, load_alarm,
                            d_empf_rg1_in_alarm,
		 	    q_empfrg1_al);

load_alarm                 <= ld_alarm2 & ld_alarm;
d_empf_rg1_in_alarm        <= alarm2_i  &    alarm_i;

d_empfrg1_h( 7 downto  0)  <= pos1_index & q_empfrg1_al(1 downto 0) & qcrc_i(4 downto 0);

q_empfrg1_al2              <= (not q_empfrg1_al(1)) and (not ssi);

empf_rg1   (55 downto 48)  <= i_empf_rg1 (7) &  q_empfrg1_al2  & i_empf_rg1 (5 downto 0);

  	      
E_RG2 : regist generic map(init_width => 32,    -- width
                           init_res   => 0)	-- reset value  
               port    map(clk, nres, eempf_rg2_i,
                           d_empf_rg2_i(31 downto 0),
			   empf_rg2(31 downto 0));

E_RG3 : regist generic map(init_width => 32,    -- width
                           init_res   => 0)	    -- reset value  
               port    map(clk, nres, eempf_rg3_i,
                           d_empf_rg3_i(31 downto 0),
                           empf_rg3 (31 downto 0));

d_empf_rg2 <= d_empf_rg2_i(23 downto 0);
d_empf_rg3 <= d_empf_rg3_i;
eempf_rg1  <= eempf_rg1_i;
eempf_rg2  <= eempf_rg2_i;
eempf_rg3  <= eempf_rg3_i;
--========================================================================================
--  Pre Divider 1us
-------------------
tim_1us: timer_1us
   port map(
	clk      => clk,
	nres     => nres,
	MHZ_64   => MHZ_64,		-- define the system frequency
	MHZ_50   => MHZ_50,		-- define the system frequency
	MHZ_48   => MHZ_48,		-- define the system frequency
	MHZ_32   => MHZ_32,		-- define the system frequency
	MHZ_100  => MHZ_100,		-- define the system frequency
	test     => ic_test_mode_i,	-- select test mode
	Q1       => Q_1US,		-- Test Output
	Q1000    => Q_1000US,
--	--
	usc010   => usc010,		-- 0.10 us  clk Time Base (Pulse)
	usc025   => usc025_i,		-- 0.25 us  clk Time Base (Pulse)
	usc1     => usc1,		-- 1    us  clk Time Base (Pulse)
	usc2     => usc2,		-- 2    us  clk Time Base (Pulse)
	usc100   => usc100,		-- 100  us  clk Time Base (Pulse)
	usc200   => usc200,		-- 200  us  clk Time Base (Pulse)
	usc500   => usc500,		-- 500  us  clk Time Base (Pulse)
	usc1000  => usc1000);		-- 1000 us  clk Time Base (Pulse)


--========================================================================================
--  Sampling Rate
------------------ 
sample: timer 
   port map(
	clk          => clk,
	nres         => nres,
	ic_test_mode => ic_test_mode_i,
	enbl_timer   => enbl_sample,     -- Enable Timer: Not activ when UA1
	usc2 	     => usc1,            -- 2 us  clk Time Base (Pulse)
	usc200 	     => usc100,		 -- 200 us  clk Time Base (Pulse)
        d_conf_rg    => cfg_sample,      -- Data from Configuration Register
        timer_rq     => timer_rq,	 -- Test Output  (6 downto 0)
	clock_out    => timer_str,       -- Output Frequency (1:1)
	pulse_out    => open);           -- Output Pulse Signal
	

--========================================================================================
--  Watch Dog
------------- 
watch: timer 
   port map(
	clk          => clk,
	nres         => nres,
	ic_test_mode => ic_test_mode_i,
	enbl_timer   => enbl_watch_dog,   -- Enable Timer
	usc2 	     => usc2, 		  -- 2 us  clk Time Base (Pulse)
	usc200 	     => usc200,		  -- 200 us  clk Time Base (Pulse)
        d_conf_rg    => cfg_watch,        -- Data from Configuration Register
        timer_rq     => watch_rq,	  -- Test Output  (6 downto 0)
	clock_out    => open,             -- Output Frequency (1:1)
	pulse_out    => watch_dog_pulse); -- Output Pulse Signal


enbl_watch_dog <= '1' when ready1 = '0' and enbl_dtakt = '0'
                                        and tx_i(29 downto 24) /= "101010"
	                                and tx_i(29 downto 24) /= "011100"
		                        and tx_i(29 downto 24) /= "100011" else '0';
				      
--========================================================================================
--  Strobe-Signal Delay   (/STR)
--------------------------------
STR_SYNC: counter_par
      generic map (filt_width => 8) 
      port map    (clk, nres, nstr1, cfg_str_delay, nstr1_delay );



--========================================================================================
--  Filter in the serial data input path      (DATA_RC)
-------------------------------------------------------
data_filt: digfilt_par2
      generic map (filt_width => 6) 
      port map    (clk, nres, dat_in, cfg_filt_data, data_in, serial_data_spike );



--========================================================================================

-- Das Senderegister wird nur beschrieben, wenn ein Schreibbefehl auf Adresse 
-- erfolgt und die Uebertragung zum /vom Geber beendet ist:
-- Der Inhalt des Sende-RG's wird immer dann in den PSW uebernommen, wenn keine 
-- Uebertragung aktiv ist.
-- 
   process (nres,clk)
   begin
     if (nres = '0') then 
		sende_flag <= '0';
	 elsif clk'event and clk='1' then
		if sel_tx='1' and write_pulse(3)='1' then
		sende_flag <= '1';
		elsif ready1='1' then
		sende_flag <= '0';
		else
		Null;
		end if;
	 end if;
   end process;
set_sende <= (sende_flag         and ready1  and  (not set_sende_from_ua1) and  valid_mode_commands)                 or  -- transmission method 0
             (                       ready1  and       set_sende_from_ua1  and (valid_e22_commands or pretx_mx_sel));    -- while using transmission method 1
setpsw    <= ready1;



fmsb      <= '1'   when cfg(31)='0' and cfg(30)='1' else
             '1'   when not (mode ="000" or  mode_2 = '1' or  (mode ="111" and qzict = "00")) and ssi_flag='0'   else 
             '1'   when ssi_flag='1' else '0';


enbl_sample    <=  '1';
str            <=  not nstr1_delay;
timer_strobe   <= timer_str when cfg_str_delay = "00000000" and mode_ua1 = '0' else '0';

nsrb_i         <=  not timer_str;
de_i           <=  not data_oe_n;



--========================================================================================

--========================================================================================
-- Pipeline Register (no function)
----------------------------------
   process(nres, clk)
   begin
     if (nres = '0') then 
		q_empfrg <= (others => '0');
	 elsif clk'event and clk='1' then
		q_empfrg <= d_empfrg;
     end if;
   end process;
   
         
--========================================================================================
-- Test Register 1+2
--------------------

tst1 <= "0" & Q_1000US & "0" & Q_1US & "00" & test_qfreq         when ic_test_mode_i='1' and tst_mux= "01" else
        "00" & test_max_s_ct & "00" & test_flag &  test_s_ct     when ic_test_mode_i='1' and tst_mux= "10" else

        del_ct&del_rg & "000000" & ec_automat_i & '0' & tst_zi_bit & tst_dl_high; --(u.a. ic_test_mode='0' od tst_mux=0 )

TEST2 : regist_8x generic map(init_width 	=> 4,    -- 32 Bit
             	               init_res   	=> 0)	 -- reset value
   		   port    map(clk, nres, sel_tst2, write_pulse, data_port_to_registers, tst2_i);

tst_out_pin_sel <= tst2_i(2);
tst_empf_rg_i   <= tst2_i(3);
tst_mux         <= tst2_i(5 downto 4);
ic_test_mode_i  <= tst2_i(7);
tst_zi_sel      <= tst2_i(10 downto 8);
tst_mode_div    <= tst2_i(11);
tst_mux2        <= tst2_i(13 downto 12);  -- Testmux2
tst_mux3        <= tst2_i(15 downto 14);  -- Testmux3

tst_data        <= tst2_i(31 downto 16) & tst2_i(31 downto 16) & tst2_i(31 downto 16);  -- for Testing empf-RG 1,2,3

-- changes due to implementation of recovery time measurement
-- (to get acces to cfg2 control data thes internal net cfg2_s is introduced
--  allowing to enable/disable output of rt measurement data via tst2 port
--  furthermore the cfg2_s signal has to assigned to port cfg2)
tst2(1*WORD-1 downto 0*WORD)  <= tst2_i(1*WORD-1 downto 0*WORD);
tst2(2*WORD-1 downto 1*WORD)  <= tst2_i(2*WORD-1 downto 1*WORD) when cfg2_s(22)='0'
                                 else rt_data_s;
cfg2 <= cfg2_s;                                 

--========================================================================================

-- Testsignale


-- Start Pulse Counter for SI-Signal and Quick-TCLK
cnt_start_pulse:   process(nres, clk) 
   begin 
     if (nres = '0') then                
	      start_pulse_ct <= "0000";
              enbl_tclk_start <= '0';
     elsif clk'event and clk='1' then
              enbl_tclk_start <= enbl_tclk_start_i;
         if ready1 = '0' then 
	    if start_pulse_ct  = "0000"           then 
	       if ec_automat_i(5 downto 1) = "00010" then      -- Start bei Z4,Z5
	         start_pulse_ct <= start_pulse_ct + '1';
               end if;
            elsif  start_pulse_ct /= "1111" then               -- Weiter zaehlen
	       start_pulse_ct <= start_pulse_ct + '1';
            end if;
         elsif nstr1 ='1'  then
	      start_pulse_ct <= "0000";
         end if;
     end if;
   end process;

n_si_i     <= '0' when tclk_i = '0' and start_pulse_ct  = "0000" else       -- Pulse kommt sofort mit TCLK
              '0' when start_pulse_ct /= "0000" and start_pulse_ct /= "1111" else '1';

-----------------------------------------------------------------------------------------------------------------------------
G_TCLK_V1: if (IMPLEMENT_TCLK_V1 = 1) generate

     tclk_start        <= '0' when nstr = '0'              and enbl_tclk_start = '1'      else '1';  -- Signal muss spikefrei sein 
     enbl_tclk_start_i <= '1' when start_pulse_ct = "0000" and cfg_str_delay = "00000000" and cfg(0)='1' else '0';


     -- Damit TCLK mit str gleich nach Low geht
     tclk_pulse:   process(tclk_start, clk) 
        begin 
     --     if (nres = '0') then                wegen Problem Ment. Compiler  19.01.04
     --              tclk_i         <= '1';
          if (tclk_start = '0') then                
                   tclk_i         <= '0';
          elsif clk'event and clk='1' then
                   tclk_i  <= freq_out;
          end if;
        end process;
end generate;  -- IMPLEMENT_TCLK_V1 = 1

G_TCLK_V2: if (IMPLEMENT_TCLK_V2 = 1) generate
                                                                                                         -- Signal muss spikefrei sein -> Disabled during scan test 
     tclk_start        <= '0' when (scan_test = '0' and nstr = '0' and enbl_tclk_start = '1') else '1';  -- (Hinweis von Kobler, Hrn. 27.3.2008)
     enbl_tclk_start_i <= '1' when start_pulse_ct = "0000" and cfg_str_delay = "00000000" and cfg(0)='1' else '0';


     -- Damit TCLK mit str gleich nach Low geht
     tclk_pulse:   process(tclk_start, clk, nres) 
        begin 
          if (nres = '0') then
                   tclk_i         <= '1';
          elsif (tclk_start = '0') then                
                   tclk_i         <= '0';
          elsif clk'event and clk='1' then
                   tclk_i  <= freq_out;
          end if;
        end process;
end generate;  -- IMPLEMENT_TCLK_V2 = 1
-----------------------------------------------------------------------------------------------------------------------------


tst_out_pin_i <= data_in;                                       --  Watch Dog Pulse

-- Platzhalter
--test_i(15 downto 0)  <= PRDATA_i(15 downto 0);
--test_i(19 downto 16) <= PRDATA_i( 3 downto 0);


--========================================================================================
--========================================================================================
-- Monitoring Unit
------------------

--start_trans_sw_mux <= start_trans_sw or start_cycle_234; -- for internal automatical start
start_trans_sw_mux <= q_start_trans_sw;

start_wd     <= eempf_rg1_i;
dstat        <= dsrg;
alarm        <= alarm_i;
alarm2       <= alarm2_i;
fb_typ_1     <= fb_typ_1_i;
autom_srg_reset <= autom_srg_reset_i;

tx           <= tx_i;
qcrc         <= qcrc_i;
testcrc      <= testcrc_i;
qspw         <= qspw_i(23 downto 0);
ec_automat   <= ec_automat_i;
zi_bit       <= zi_bit_i;
mode_7_0     <= mode_7_0_i;
ic_test_mode <= ic_test_mode_i;
tst_empf_rg  <= tst_empf_rg_i;
d_empf_rg1   <= q_empfrg(15 downto 0);
usc025       <= usc025_i;

MHZ48       <= MHZ_48;
MHZ50       <= MHZ_50;
MHZ64       <= MHZ_64;
MHZ100      <= MHZ_100;
mode_11_33_44 <= mode_11_33_44_i;

start_trans  <= start_trans_hw or q_start_trans_sw; -- Start transmission (Timer, HW, SW) 

process(nres, clk) -- Pipeline
   begin 
     if (nres = '0') then
          q_start_trans_sw  <= '0';
     elsif clk'event and clk='1' then
          q_start_trans_sw  <= start_trans_sw;
          end if;
        end process;


--=======================================================================================
-- Recovery Time Measurement accordingly to specification D1129749-00-A-01
-- "Messung der Recovery Time I (Monozeit) Spezifikation fuer EnDAT2.2 Master(Basic)"
-- added 09.04.2015, RWO 
--=======================================================================================
-- the init data   on port RT_INIT_I is get from  higher WORD of write data (data_port_to_registers)
-- the result data on port RT_DATA_O is mapped to higher WORD of test2 register

I_RTM: RT_COUNTER
generic map(
    IMPLEMENT_G  => 1,
    DATA_WIDTH_G => WORD,
    PORT_WIDTH_G => WORD
)
port map(
    CLK          => clk,
    RES_IX       => nres,
    RX_I         => data_in,
    RT_ON_I      => cfg2_s(22),
    INIT_I       => sel_tst2,
    BE_I         => write_pulse(3 downto 2), -- map to the higher word of data_port...
    RT_INIT_I    => data_port_to_registers(DWORD-1 downto WORD),
    DEL_CT_I     => del_ct,
    EC_STATE_I   => ec_automat_i,
    MODE_I       => tx_i(MODE_MSB downto MODE_LSB),
    MRS_I        => tx_i(MRS_MSB downto MRS_LSB),
    RT_DATA_O    => rt_data_s,
    RT_START_O   => rt_start_s,
    RT_STOPP_O   => rt_stopp_s
);

-- map the rt_start and rt_stopp events into the status vector
stat_map: process(input_2_srg, rt_start_s, rt_stopp_s)
constant START_RTM_c: integer:=27;
constant STOPP_RTM_c: integer:=28;
begin
    status_map_s <= input_2_srg;
    status_map_s(START_RTM_c) <= rt_start_s;    
    status_map_s(STOPP_RTM_c) <= rt_stopp_s;    
end process stat_map;

RTM_START_O <= rt_start_s;
RTM_STOPP_O <= rt_stopp_s;

--============ End of Recovery Time Measurment ==========================================


end behav;
