--****************************************************************************************
--
--                                                          ENDAT22_INTREG
--                                                          ==============
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
-- Synthesis:        Synplify 9.6.1
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V8.21
-- 
-- Function:         Endat2.2-Interface for EnDat V2.2 (DR.J.HEIDENHAIN)
--                   No Port -> Register Outputs
-- 
-- History: F.Seiler 02.04. 2009 Initial Version
--          F.Seiler 17.09.2009 enbl_tm_z25 (Stoerung, Laufzeit wegen TM-Messung)
--          F.Seiler 12.10. 2010 OEM1 Aenderungen (gemaess VHDL von JH)
--****************************************************************************************
-- Revision history
--
-- $Log
--
-------------------------------------------------------------------------------------------
library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;
use endat22.endat5_pkg.all;
use endat22.resource_pkg.all;


entity ENDAT22_INTREG is
   generic (

        IMPLEMENT_MONIT_FUNC:   integer:= 1;
        IMPLEMENT_SPEED_FUNC:   integer:= 0;
        IMPLEMENT_INKR_FUNC:    integer:= 0;
        IMPLEMENT_OEM1:         integer:= 0;        -- Special Function
        IMPLEMENT_OEM2:         integer:= 0;        -- Special Function
        IMPLEMENT_TCLK_V1:      integer:= 0;        -- Select V1 or V2 
        IMPLEMENT_TCLK_V2:      integer:= 1         -- Select V1 or V2
           );
   port(clk        :         in    std_logic;
        CLK_WD     :         in    std_logic;
        nres       :         in    std_logic;                     -- Reset for modules
        nreset     :         in    std_logic;                     -- Reset for WD

        CEN_WD_CLK :         in    std_logic;                     -- enable of for CLK_WD (No further synchronisation in EnDat Master !!!!!)

        -- 2nd read only APB port for OEM1
        PSEL2    :           in    std_logic;                     -- PSEL (APB,Decoder)
        PENABLE2 :           in    std_logic;                     -- PENABLE (APB)

-------------------------------------------------------------------------------------------
-- load pulse for registers
-- map write enable to former select signals
-------------------------------------------------------------------------------------------
        sel_tx          :    in  std_logic;         -- Select Transmission Register
        sel_rx1         :    in  std_logic;         -- Select Receive Register 1
        sel_rx2         :    in  std_logic;         -- Select Receive Register 2
        sel_rx3         :    in  std_logic;         -- Select Receive Register 3
        sel_cfg1        :    in  std_logic;         -- Select Configuration Register 1
        sel_cfg2        :    in  std_logic;         -- Select Configuration Register 2
        sel_cfg3        :    in  std_logic;         -- Select Configuration Register 3
        sel_stat        :    in  std_logic;         -- Select Status Register
        sel_im          :    in  std_logic;         -- Select Interrupt Mask Register
        sel_tst1        :    in  std_logic;         -- Select Test Register 1
        sel_tst2        :    in  std_logic;         -- Select Test Register 2
 
        soft_str        :    in  std_logic;         -- Soft Strobe

        sel_rx4         :    in  std_logic;         -- Select Receive Register 4
        sel_cfg4        :    in  std_logic;         -- Select Configuration Register 4
        sel_cfg5        :    in  std_logic;         -- Select Configuration Register 5
        sel_npv         :    in  std_logic;         -- Select Register for "Npv"  value (low part)
        sel_npvh        :    in  std_logic;         -- Select Register for "Npv"  value (high part)
        sel_tst3        :    in  std_logic;         -- Select Test Register3
        sel_off2        :    in  std_logic;         -- Select Register for "Off2" value (low part)
        sel_off2h       :    in  std_logic;         -- Select Register for "Off2" value (high part)
        sel_frg         :    in  std_logic;         -- Select Error/Status Register 
        sel_fim         :    in  std_logic;         -- Select Error Interrupt Mask Register 

        sel_srm         :    in  std_logic;         -- Select Register for "srM" 
        sel_srmh        :    in  std_logic;         -- Select Register for "srM" (high) 
        sel_nsrpos1     :    in  std_logic;         -- Select Register for "nsrPOS1" 
        sel_nsrpos2     :    in  std_logic;         -- Select Register for "nsrPOS2"  

        SEL_OEM1_CTRL   :    in  std_logic;         -- Select OEM1 Control Register
        SEL_OEM1_IRQSTAT:    in  std_logic;         -- Select OEM1 Interrupt Status Register
        SEL_OEM1_IM     :    in  std_logic;         -- Select OEM1 Interrupt Mask
        SEL_OEM1_CFG1   :    in  std_logic;         -- Select OEM1 Configuration Register1
        SEL_OEM1_CFG2   :    in  std_logic;         -- Select OEM1 Configuration Register2
        SEL_OEM1_CFG3   :    in std_logic;          -- Select OEM1 Configuration Register3
        SEL_OEM1_CFG4   :    in std_logic;          -- Select OEM1 Configuration Register4
        SEL_OEM1_CFG5_L :    in std_logic;          -- Select OEM1 Configuration Register5 (lower part)
        SEL_OEM1_CFG5_H :    in std_logic;          -- Select OEM1 Configuration Register5 (higher part)
        SEL_OEM1_CFG6   :    in std_logic;          -- Select OEM1 Configuration Register6
        SEL_OEM1_STAT   :    in  std_logic;         -- Select OEM1 Status

        sel_mult_fact   :    in  std_logic;         -- Select Register for multiplier factor

        --  Data Stream from the Input Port to the internal registers 
        data_port_to_registers   : in std_logic_vector(31 downto 0); -- Inputs from Port
        write_pulse:         in  std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers

        D_SEND:              out   std_logic_vector(SENDE_WIDTH-1 downto 0);
        D_EMPF1:             out   std_logic_vector(EMPF1_WIDTH-1 downto 0);
        D_EMPF2:             out   std_logic_vector(EMPF2_WIDTH-1 downto 0);
        D_EMPF3:             out   std_logic_vector(EMPF3_WIDTH-1 downto 0);
        D_EMPF4:             out   std_logic_vector(EMPF4_WIDTH-1 downto 0);
        D_EMPF1S:            out   std_logic_vector(EMPF1S_WIDTH-1 downto 0);
        D_EMPF3S:            out   std_logic_vector(EMPF3S_WIDTH-1 downto 0);
        D_KONF1:             out   std_logic_vector(KONF1_WIDTH-1 downto 0);
        D_KONF2:             out   std_logic_vector(KONF2_WIDTH-1 downto 0);
        D_KONF3:             out   std_logic_vector(KONF3_WIDTH-1 downto 0);
        D_KONF4:             out   std_logic_vector(KONF4_WIDTH-1 downto 0);
        D_KONF5:             out   std_logic_vector(KONF5_WIDTH-1 downto 0);
        D_NPV:               out   std_logic_vector(NPV_WIDTH-1 downto 0);
        D_OFFSET2:           out   std_logic_vector(OFFSET2_WIDTH-1 downto 0);
        D_STATUS:            out   std_logic_vector(STATUS_WIDTH-1 downto 0);
        D_S_INT_EN:          out   std_logic_vector(STATUS_WIDTH-1 downto 0);
        D_FEHLER:            out   std_logic_vector(FEHLER_WIDTH-1 downto 0);
        D_F_INT_EN:          out   std_logic_vector(FEHLER_WIDTH-1 downto 0);
        D_DS1_RG:            out   std_logic_vector(DS_WIDTH-1 downto 0);
        D_DS2_RG:            out   std_logic_vector(DS_WIDTH-1 downto 0);
        D_DS3_RG:            out   std_logic_vector(DS_WIDTH-1 downto 0);
        D_DS4_RG:            out   std_logic_vector(DS_WIDTH-1 downto 0);
        D_TEST1:             out   std_logic_vector(TEST1_WIDTH-1 downto 0);
        D_TEST2:             out   std_logic_vector(TEST2_WIDTH-1 downto 0);
        D_TEST3:             out   std_logic_vector(TEST3_WIDTH-1 downto 0);
        D_TEST4:             out   std_logic_vector(TEST4_WIDTH-1 downto 0);

        D_SRM:               out   std_logic_vector(SRM_WIDTH-1 downto 0);
        D_NSRPOS1:           out   std_logic_vector(NSRPOS_WIDTH-1 downto 0);
        D_NSRPOS2:           out   std_logic_vector(NSRPOS_WIDTH-1 downto 0);

        D_MULTIPL:           out   std_logic_vector(MULTIPL_WIDTH-1 downto 0);
        D_SPEED:             out   std_logic_vector(SPEED_WIDTH-1 downto 0);
                                                                                   -- 2007.06
        D_OEM1_CTRL :        out   std_logic_vector(OEM1_CNTRL_WIDTH-1 downto 0);   -- OEM1 Control Register
        D_OEM1_IRQSTAT :     out   std_logic_vector(OEM1_INTSTAT_WIDTH-1 downto 0); -- OEM1 Interrupt Status Register
        D_OEM1_IM :          out   std_logic_vector(OEM1_I_INT_EN_WIDTH-1 downto 0);-- OEM1 Interrupt Mask
        D_OEM1_KONF1 :       out   std_logic_vector(OEM1_KONF1_WIDTH-1 downto 0);   -- OEM1 Configuration Register1
        D_OEM1_KONF2 :       out   std_logic_vector(OEM1_KONF2_WIDTH-1 downto 0);   -- OEM1 Configuration Register2
        D_OEM1_KONF3 :       out   std_logic_vector(OEM1_KONF3_WIDTH-1 DOWNTO 0);  -- OEM1 Configuration Register3
        D_OEM1_KONF4 :       out   std_logic_vector(OEM1_KONF4_WIDTH-1 DOWNTO 0);  -- OEM1 Configuration Register4
        D_OEM1_KONF5 :       out   std_logic_vector(OEM1_KONF5_WIDTH-1 DOWNTO 0);  -- OEM1 Configuration Register5
        D_OEM1_KONF6 :       out   std_logic_vector(OEM1_KONF6_WIDTH-1 DOWNTO 0);  -- OEM1 Configuration Register6
        D_OEM1_STORE :       out   std_logic_vector(OEM1_STOR_WIDTH-1  downto 0);   -- OEM1 Store
        D_OEM1_ST :          out   std_logic_vector(OEM1_STURN_WIDTH-1 downto 0);   -- OEM1 Singleturn
        D_OEM1_MT :          out   std_logic_vector(OEM1_MTURN_WIDTH-1 downto 0);   -- OEM1 Multiturn
        D_OEM1_POS2 :        out   std_logic_vector(OEM1_POSI2_WIDTH-1 downto 0);   -- OEM1 Position2
        D_OEM1_SOL :         out   std_logic_vector(OEM1_SOLCT_WIDTH-1 downto 0);   -- OEM1 Sign of Life (Lebenszeichen) 
        D_OEM1_STATUS :      out   std_logic_vector(OEM1_STATUS_WIDTH-1 downto 0);  -- OEM1 Status

        -- Interrupt Request Micro Controller
        n_int1   :           out   std_logic;                     -- Interrupt Request1 to Micro Controller
        n_int2   :           out   std_logic;                     -- Interrupt Request2 to Micro Controller
        n_int3   :           out   std_logic;                     -- Interrupt Request3 to Micro Controller
        n_int1_oem1:          out   std_logic;                     -- Interrupt Request OEM1 to Micro Controller
        n_int2_oem1:          out   std_logic;                     -- Interrupt Request OEM1 to Micro Controller

        -- Mess System
        data_rc :            in    std_logic;
        data_dv :            out   std_logic;
        tclk :               out   std_logic;
        de :                 out   std_logic;

        nstr :               in    std_logic;
        ntimer :             out   std_logic;

        n_int6, n_int7 :     in    std_logic;
        dui    :             out   std_logic;
        tst_out_pin :        out   std_logic;
        n_si   :             out   std_logic;
        -- Recovery Time Flags
        RTM_START_O:         out   std_logic;
        RTM_STOPP_O:         out   std_logic;

        --Scan
        scan_mode:           in    std_logic;                     -- Reset Umschaltg. fuer Scan Modus
--        scin:                in    std_logic;                     -- Scan Modus
--        scen:                in    std_logic;                     -- Scan Modus
--        scout:               out   std_logic;                     -- Scan Modus
        SCIN_WD:             in    std_logic;                     -- input of scan chain of watchdog
        SCOUT_WD:            out   std_logic;                     -- output of scan chain of watchdog

        axis_adr:            in    std_logic_vector( 4 downto 0)  -- Address Line of the encoder axis    
       );

-- synopsys translate_off
attribute PORT_TYP of ENDAT22_INTREG: ENTITY is "APB";
-- synopsys translate_on

-----------------------------------------------------------------------------------------
-- placeholder port signals -> assure error free compile
-----------------------------------------------------------------------------------------

end ENDAT22_INTREG;

architecture behav of ENDAT22_INTREG is

--========================================================================================
    -- constant signals
    --------------------------------
    signal hi, lo:  std_logic; -- hi, lo driven signals

--==========================================================================================
--  Signal Declaration
--==========================================================================================

    signal usc010, usc025, MHZ48, MHZ50, MHz64, MHZ100:  std_logic;
    signal pos1_index:                            std_logic;

    signal intn, intn2, intn3, OEM1_INTN1, OEM1_INTN2: std_logic;

    signal alarm, alarm2 :                        std_logic;

    signal eempf_rg1, eempf_rg2, eempf_rg3:       std_logic;
    signal zi_bit :                               std_logic_vector( 1 downto 0); 
    signal autom_srg_reset :                      std_logic;                     -- from eclk
    signal cfg_allow_srg_reset :                  std_logic;                     -- CFG1
    signal cfg_autom_srg_reset :                  std_logic;                     -- CFG1

--    signal mode :                                 std_logic_vector(2 downto 0);
    signal mode_7_0, mode_11_33_44:               std_logic;
    signal qspw:                                  std_logic_vector(23 downto 0);
    signal qcrc:                                  std_logic_vector( 4 downto 0);
    signal testcrc:                               std_logic_vector( 4 downto 0);
    signal ec_automat :                           std_logic_vector( 5 downto 0);
    signal enbl_tm_z25:                           std_logic;
    signal dfreq :                                std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
    signal datin2moduls :                         std_logic;

--  Signal for Test
    signal ic_test_mode,  tst_empf_rg:            std_logic;
    signal tst_mode_div :                         std_logic;                     -- Testmode of divider
 
    
--========================================================================================
-- New Signals 

    signal tx                       : std_logic_vector(29 downto 0); -- Transmission Register
    signal d_empf_rg1               : std_logic_vector(15 downto 0); -- Receive Register 1
    signal d_empf_rg2               : std_logic_vector(23 downto 0); -- Receive Register 2
    signal d_empf_rg3               : std_logic_vector(31 downto 0); -- Receive Register 3
    signal empf_rg1                 : std_logic_vector(55 downto 0); -- Receive Register 1
    signal empf_rg2, empf_rg3       : std_logic_vector(31 downto 0); -- Receive Register 2, 3

    signal cfg1                     : std_logic_vector(31 downto 0); -- Configuration Register 1
    signal cfg2                     : std_logic_vector(31 downto 0); -- Configuration Register 2
    signal cfg3                     : std_logic_vector(15 downto 0); -- Configuration Register 3
    signal dstat, stat              : std_logic_vector(31 downto 0); -- Status Register 
    signal im                       : std_logic_vector(31 downto 0); -- Interrupt Mask Register 
    signal tst1                     : std_logic_vector(31 downto 0); -- Test Register 1
    signal tst2                     : std_logic_vector(31 downto 0); -- Test Register 2

    signal empf_rg4                 : std_logic_vector(47 downto 0); -- Receive Register 4
    signal empf_rg1s                : std_logic_vector(47 downto 0); -- Receive Register 1S
    signal empf_rg3s                : std_logic_vector(31 downto 0); -- Receive Register 3S

    signal ds1_rg                   : std_logic_vector(31 downto 0); -- Data-Save Register 1 outputs
    signal ds2_rg                   : std_logic_vector(31 downto 0); -- Data-Save Register 2 outputs
    signal ds3_rg                   : std_logic_vector(31 downto 0); -- Data-Save Register 3 outputs
    signal ds4_rg                   : std_logic_vector(31 downto 0); -- Data-Save Register 4 outputs
    signal cfg4                     : std_logic_vector(31 downto 0); -- Configuration Register 4
    signal cfg5                     : std_logic_vector(31 downto 0); -- Configuration Register 5
    signal npv                      : std_logic_vector(47 downto 0); -- Register for "Npv"   -- must 48 bit width !!
    signal tst3                     : std_logic_vector(31 downto 0); -- Test Register3
    signal off2                     : std_logic_vector(47 downto 0); -- Register for "Off2"  -- must 48 bit width !!
    signal frg                      : std_logic_vector(31 downto 0); -- Error/Status Register
    signal fim                      : std_logic_vector(31 downto 0); -- Error Interrupt Mask Register

    signal SRM                      : std_logic_vector(SRM_WIDTH-1    downto 0); -- Register for "srM" (sicherheitsrel. Messschritte)
    signal NSRPOS1                  : std_logic_vector(NSRPOS_WIDTH-1 downto 0); -- Register for "nsrPOS1" (nicht sicherheitsrel. Unterteilung Pos1)
    signal NSRPOS2                  : std_logic_vector(NSRPOS_WIDTH-1 downto 0); -- Register for "nsrPOS2" (nicht sicherheitsrel. Unterteilung Pos2)
    signal tst4                     : std_logic_vector(TEST4_WIDTH-1  downto 0); -- Test Register4

    signal speed                    : std_logic_vector(63 downto 0); -- Register for speed value
    signal mult_fact                : std_logic_vector(15 downto 0); -- Register for multiplier factor

    signal OEM1_CTRL :        std_logic_vector(OEM1_CNTRL_WIDTH-1 downto 0);     -- OEM1 Control Register
    signal OEM1_IRQSTAT :     std_logic_vector(OEM1_INTSTAT_WIDTH-1 downto 0);   -- OEM1 Interrupt Status Register
    signal OEM1_IM :          std_logic_vector(OEM1_I_INT_EN_WIDTH-1 downto 0);  -- OEM1 Interrupt Mask
    signal OEM1_CFG1 :        std_logic_vector(OEM1_KONF1_WIDTH-1 downto 0);     -- OEM1 Configuration Register1
    signal OEM1_CFG2 :        std_logic_vector(OEM1_KONF2_WIDTH-1 downto 0);     -- OEM1 Configuration Register2
    signal OEM1_CFG3 :        std_logic_vector(OEM1_KONF3_WIDTH-1 downto 0);     -- OEM1 Configuration Register3
    signal OEM1_CFG4 :        std_logic_vector(OEM1_KONF4_WIDTH-1 downto 0);     -- OEM1 Configuration Register4
    signal OEM1_CFG5 :        std_logic_vector(OEM1_KONF5_WIDTH-1 downto 0);     -- OEM1 Configuration Register5
    signal OEM1_CFG6 :        std_logic_vector(OEM1_KONF6_WIDTH-1 downto 0);     -- OEM1 Configuration Register6
    signal OEM1_STORE :       std_logic_vector(OEM1_STOR_WIDTH-1  downto 0);     -- OEM1 TM (time value)
    signal OEM1_ST :          std_logic_vector(OEM1_STURN_WIDTH-1 downto 0);     -- OEM1 Singleturn
    signal OEM1_MT :          std_logic_vector(OEM1_MTURN_WIDTH-1 downto 0);     -- OEM1 Multiturn
    signal OEM1_POS2 :        std_logic_vector(OEM1_POSI2_WIDTH-1 downto 0);     -- OEM1 Position2
    signal OEM1_SOL :         std_logic_vector(OEM1_SOLCT_WIDTH-1 downto 0);     -- OEM1 Sign of Life (Lebenszeichen) 
    signal OEM1_STAT :        std_logic_vector(OEM1_STATUS_WIDTH-1 downto 0);    -- OEM1 Status

    signal pretx_mx_sel :                std_logic;                     -- select for Mux TX Register

    signal dir :                         std_logic;                     -- indication of direction of motion

    signal set_sende_from_ua1 :          std_logic;                     -- Enable for TX for values 42,43,44 when UA1
    signal d_pretx_mx_from_saf :         std_logic_vector(13 downto 0); -- Muxer for the values 42,43,44 for the TX reg

    signal enbl_for_wt_crc5 :            std_logic;                     -- enable for test od CRC5 checker
    signal data_for_wt_crc5 :            std_logic;                     -- serial data out
    signal rdy_wt_crc5 :                 std_logic;                     -- ready signal of WT CRC5 activity test
    signal crc_err:                      std_logic;                     -- CRC Error of E-Reg1 (Pos1)
    signal crc_err_rg2, crc_err_rg3:     std_logic;                     -- CRC Error of E-Reg2,  CRC Error of E-Reg3 (Pos2)
    signal n_rm:                         std_logic;                     -- no RM bit

--  Signals of/for the Measurement System
-----------------------------------------    

    signal fb_typ_1, fb_typ_2:           std_logic;                     -- F-TypI,II FRG
    signal tst_mux2, tst_mux3:           std_logic_vector( 1 downto 0); -- Testmux2, 3

    signal start_trans :                 std_logic;                     -- Start Transmission (Timer, HW, SW) 

--========================================================================================
    signal input_2_srg:    std_logic_vector(29 downto 24); -- additional inputs to status register
    signal speed_ready:    std_logic;                      -- calculation of speed is ready

--========================================================================================
--  Signals to/from WD
----------------------    
    signal start_wd    :   std_logic;                 -- Retrigger WD (start)
    signal cfg_wt_wd   :   std_logic;                 -- Select WT WD
    signal wd_time_out :   std_logic;                 -- to WD Bits (FRG)
    signal wd_wt_out   :   std_logic;                 -- to WD Bits (FRG)
    signal wm_idx      :   std_logic;                 -- to WD Bits (FRG)

--========================================================================================
-- Component Declaration
--========================================================================================

component endat22_kernel 
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

-- Signals to/from control_saf
-------------------------------

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
       MHz64       :                  out std_logic;                     -- Select 64 MHz system frequency
       MHZ100      :                  out std_logic;                     -- Select 100MHz system frequency

-----------------------------------------------------------------------------------------
-- Signals to Watchdog WD
-----------------------------------------------------------------------------------------
       start_wd   :                   out std_logic);

end component;


component control_saf
   generic (
      IMPLEMENT_OEM1:    integer:= 0;                                       -- Special Function
      IMPLEMENT_OEM2:    integer:= 0                                        -- Special Function
           );
   port(clk  :                           in  std_logic;                     -- System Clock
    nres     :                           in  std_logic;                     -- Reset

--  Signals for Micro Controller Port
-------------------------------------
    PSEL2 :                              in  std_logic;                     -- PSEL (SYNC_PORT2,Decoder)
    PENABLE2 :                           in  std_logic;                     -- PENABLE (SYNC_PORT2)
    d :    	                         in  std_logic_vector(31 downto 0); -- Data from Port to Registers
    sel_rx4  :                           in  std_logic;                     -- Select Receive Register 4
    sel_cfg4 :                           in  std_logic;                     -- Select Configuration Register 4
    sel_cfg5 :                           in  std_logic;                     -- Select Configuration Register 5
    sel_npv  :                           in  std_logic;                     -- Select Register for "Npv"  value (low part)
    sel_npvh :                           in  std_logic;                     -- Select Register for "Npv"  value (high part)
    sel_tst3 :                           in  std_logic;                     -- Select Test Register3
    sel_off2 :                           in  std_logic;                     -- Select Register for "Off2" value (low part)
    sel_off2h:                           in  std_logic;                     -- Select Register for "Off2" value (high part)
    sel_frg  :                           in  std_logic;                     -- Select Error/Status Register 
    sel_fim :                            in  std_logic;                     -- Select Error Interrupt Mask Register 

    sel_srm :                            in  std_logic;                     -- Select Register for "srM" 
    sel_srmh :                           in  std_logic;                     -- Select Register for "srM" (high) 
    sel_nsrpos1 :                        in  std_logic;                     -- Select Register for "nsrPOS1" 
    sel_nsrpos2 :                        in  std_logic;                     -- Select Register for "nsrPOS2"  

    write_pulse:                         in  std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers
    autom_srg_reset :                    in  std_logic;                     -- from eclk
    cfg_allow_srg_reset :                in  std_logic;                     -- CFG1
    cfg_autom_srg_reset :                in  std_logic;                     -- CFG1

    tx :                                 in  std_logic_vector(29 downto 24); -- Transmission Register
    dfreq :                              in  std_logic_vector(freq_widh-1 downto 0); -- TCLK-frequency
    dat_in :                             in  std_logic;                     -- DATA_RC
    eempf_rg1 :   	                 in  std_logic;                     -- enable for RX1
    eempf_rg2 :                          in  std_logic;                     -- enable for RX2
    eempf_rg3 :                          in  std_logic;                     -- enable for RX3
    d_empf_rg2 :                         in  std_logic_vector(23 downto 0); -- Input of RX2
    d_empf_rg3 :   	                 in  std_logic_vector(31 downto 0); -- Input of RX3
    empf_rg1 :                           in  std_logic_vector(47 downto 0); -- RX1
    empf_rg3 :                           in  std_logic_vector(31 downto 0); -- RX3
    dstat :                              in  std_logic_vector(31 downto 0); -- Inputs of Status Register
    stat :                               in  std_logic_vector(31 downto 0); -- Status Register

    rx4 :   	                         out std_logic_vector(47 downto 0); -- Receive Register4
    rx1s :                               out std_logic_vector(47 downto 0); -- Receive Register1S
    rx3s :                               out std_logic_vector(31 downto 0); -- Receive Register3S
    ds1 :   	                         out std_logic_vector(31 downto 0); -- Data-Save Register 1
    ds2 :   	                         out std_logic_vector(31 downto 0); -- Data-Save Register 2
    ds3 :   	                         out std_logic_vector(31 downto 0); -- Data-Save Register 3
    ds4 :                                out std_logic_vector(31 downto 0); -- Data-Save Register 4
    cfg4 :   	                         out std_logic_vector(31 downto 0); -- Configuration Register 4
    cfg5 :   	                         out std_logic_vector(31 downto 0); -- Configuration Register 5
    npv :   	                         out std_logic_vector(47 downto 0); -- Register for "Npv"
    tst3 :   	                         out std_logic_vector(31 downto 0); -- Test Register3
    off2 :   	                         out std_logic_vector(47 downto 0); -- Register for "Off2"
    frg  :                               out std_logic_vector(31 downto 0); -- Error/Status Register
    fim :                                out std_logic_vector(31 downto 0); -- Error Interrupt Mask Register

    SRM:                                 out std_logic_vector(SRM_WIDTH-1    downto 0); -- Register for "srM" (sicherheitsrel. Messschritte)
    NSRPOS1:                             out std_logic_vector(NSRPOS_WIDTH-1 downto 0); -- Register for "nsrPOS1" (nicht sicherheitsrel. Unterteilung Pos1)
    NSRPOS2:                             out std_logic_vector(NSRPOS_WIDTH-1 downto 0); -- Register for "nsrPOS2" (nicht sicherheitsrel. Unterteilung Pos2)
    tst4 :                               out std_logic_vector(TEST4_WIDTH-1  downto 0); -- Test Register4 (divider) 

    qspw :                               in  std_logic_vector(23 downto 0); -- Data from Ser.Parallel Converter
    set_sende_from_ua1 :                 out std_logic;                     -- Enable for TX for values 42,43,44 when UA1
    d_pretx_mx :                         out std_logic_vector(13 downto 0); -- Muxer for the values 942,943,944 for the TX reg
    pretx_mx_sel :                       out std_logic;                     -- Select for Muxer for TX

--  Enable WT
-------------    

    enbl_for_wt_crc5 :                   out std_logic;                     -- enable for test od CRC5 checker
    data_for_wt_crc5 :                   out std_logic;                     -- serial data out
    rdy_wt_crc5 :                        out std_logic;                     -- ready signal of WT CRC5 activity test
    pos1_index  :                        out std_logic;                     -- Index for Pos1 for compare with Pos2

--  Signals of/for the Measurement System
-----------------------------------------    

    rx_crc5 :                            in  std_logic_vector( 4 downto 0); -- received CRC from encoder
    tst_crc5 :                           in  std_logic_vector( 4 downto 0); -- in this IC generated CRC

    crc_err  :                           in  std_logic;                     -- CRC Error PW (Pos1)
    crc_err_rg2 :                        in  std_logic;                     -- CRC Error ZI2
    crc_err_rg3 :                        in  std_logic;                     -- CRC Error ZI1 (Pos2)

    tst_empf_rg:                         in  std_logic;                     -- Test Enable RX Registers (For Test Write Modus)
    ic_test_mode:                        in  std_logic;                     -- IC Test Mode
    tst_mux2:                            in  std_logic_vector( 1 downto 0); -- Testmux2
    tst_mux3:                            in  std_logic_vector( 1 downto 0); -- Testmux3
    tst_mode_div :                       in  std_logic;                     -- Testmode of divider

    start_trans :                        in  std_logic;                     -- Start transmission (Timer, HW, SW)
    mode_11_33_44:                       in  std_logic;                     -- Mode Commands 1-1 ..6-6
    alarm   :                            in  std_logic;                     -- Fehler1
    alarm2  :                            in  std_logic;                     -- /Fehler2
    fb_typ_1:                            in  std_logic;                     -- F-TypI   FRG
    fb_typ_2:                            in  std_logic;                     -- F-TypII  FRG
    n_rm:                                in  std_logic;                     -- not RM bit

    ec_automat:                          in  std_logic_vector(5 downto 0);  -- ECLK state machine
    zi_bit    :                          in  std_logic_vector(1 downto 0);  -- Number of ZI from eclk 
    del_rg :                             in  std_logic_vector( 7 downto 0); -- Delay-Reg
    enbl_tm_z25 :                        in  std_logic;                     -- Laufzeit ist eingearbeitet                

    axis_adr :  	                 in  std_logic_vector( 4 downto 0); -- Address Line of the encoder axis    

    intn2 :                              out std_logic;                     -- Interrupt Request2 to Micro Controller
    intn3 :                              out std_logic;                     -- Interrupt Request3 to Micro Controller

--  Signals of/for WD
---------------------    
    cfg_wt_wd   :                        out std_logic;                     -- Select WT WD
    wd_time_out :                        in  std_logic;                     -- to WD Bits (FRG)
    wd_wt_out   :                        in  std_logic;                     -- to WD Bits (FRG)
    wm_idx      :                        in  std_logic;                     -- to WD Bits (FRG)

--  Signals for tm CNT
----------------------   
    usc010      :                    in  std_logic;                     -- 100 ns pulse 
    usc025      :                    in  std_logic;                     -- 250 ns pulse
    MHZ48       :                    in  std_logic;                     -- Select 48 MHz system frequency
    MHZ50       :                    in  std_logic;                     -- Select 50 MHz system frequency
    MHZ64       :                    in  std_logic;                     -- Select 64 MHz system frequency
    MHZ100      :                    in  std_logic;                     -- Select 100MHz system frequency

--  Signals for OEM OEM1 Functions
---------------------------------   
    SEL_OEM1_CTRL :                   in  std_logic;                     -- Select OEM1 Control Register
    SEL_OEM1_IRQSTAT :                in  std_logic;                     -- Select OEM1 Interrupt Status Register
    SEL_OEM1_IM :                     in  std_logic;                     -- Select OEM1 Interrupt Mask
    SEL_OEM1_CFG1 :                   in  std_logic;                     -- Select OEM1 Configuration Register1
    SEL_OEM1_CFG2 :                   in  std_logic;                     -- Select OEM1 Configuration Register2
    SEL_OEM1_CFG3 :                   in  std_logic;                     -- Select OEM1 Configuration Register3
    SEL_OEM1_CFG4 :                   in  std_logic;                     -- Select OEM1 Configuration Register4
    SEL_OEM1_CFG5_L :                 in  std_logic;                     -- Select OEM1 Configuration Register5
    SEL_OEM1_CFG5_H :                 in  std_logic;                     -- Select OEM1 Configuration Register5
    SEL_OEM1_CFG6 :                   in  std_logic;                     -- Select OEM1 Configuration Register6
    SEL_OEM1_STAT :                   in  std_logic;                     -- Select OEM1 Status

    OEM1_CTRL :                       out std_logic_vector(OEM1_CNTRL_WIDTH-1    downto 0);    -- OEM1 Control Register
    OEM1_IRQSTAT :                    out std_logic_vector(OEM1_INTSTAT_WIDTH-1  downto 0);    -- OEM1 Interrupt Status Register
    OEM1_IM :                         out std_logic_vector(OEM1_I_INT_EN_WIDTH-1 downto 0);    -- OEM1 Interrupt Mask
    OEM1_CFG1 :                       out std_logic_vector(OEM1_KONF1_WIDTH-1    downto 0);    -- OEM1 Configuration Register1
    OEM1_CFG2 :                       out std_logic_vector(OEM1_KONF2_WIDTH-1    downto 0);    -- OEM1 Configuration Register2
    OEM1_CFG3 :                       out std_logic_vector(OEM1_KONF3_WIDTH-1    downto 0);    -- OEM1 Configuration Register3
    OEM1_CFG4 :                       out std_logic_vector(OEM1_KONF4_WIDTH-1    downto 0);    -- OEM1 Configuration Register4
    OEM1_CFG5 :                       out std_logic_vector(OEM1_KONF5_WIDTH-1    downto 0);    -- OEM1 Configuration Register5
    OEM1_CFG6 :                       out std_logic_vector(OEM1_KONF6_WIDTH-1    downto 0);    -- OEM1 Configuration Register6
    OEM1_STORE :                      out std_logic_vector(OEM1_STOR_WIDTH-1     downto 0);    -- OEM1 Store
    OEM1_ST :                         out std_logic_vector(OEM1_STURN_WIDTH-1    downto 0);    -- OEM1 Singleturn
    OEM1_MT :                         out std_logic_vector(OEM1_MTURN_WIDTH-1    downto 0);    -- OEM1 Multiturn
    OEM1_POS2 :                       out std_logic_vector(OEM1_POSI2_WIDTH-1    downto 0);    -- OEM1 Position2
    OEM1_SOL :                        out std_logic_vector(OEM1_SOLCT_WIDTH-1    downto 0);    -- OEM1 Sign of Life (Lebenszeichen) 
    OEM1_STAT :                       out std_logic_vector(OEM1_STATUS_WIDTH-1   downto 0);    -- OEM1 Status

    OEM1_INTN1 :                       out std_logic;                                          -- Interrupt Request to Micro Controller
    OEM1_INTN2 :                       out STD_LOGIC                                           -- Interrupt Request to Micro Controller
    );
end component;


component WATCHDOG
 generic (
          WATCH_TIME:        integer     -- us !! 
         );
    port (
          CLK_WD:            in    std_logic; -- watchdog clock domain 
          CEN_WD_CLK:        in    std_logic; -- enable of for CLK_WD 
          RESX:              in    std_logic; -- asynchronous Power On Reset (lo activ)
          SCAN_MODE:         in    std_logic; -- avoid DFT design rule violation
          SCIN_WD:           in    std_logic; -- scan chain input
          SCOUT_WD:          out   std_logic; -- scan chain output

          CLK:               in    std_logic; -- application clock domain
          RES_APP:           in    std_logic; -- global reset of application clock domain

          -- control ports (synchronous to CLK)
          ---------------------------------------------------------------
          TRIG:              in    std_logic; -- async trigger from application
          TEST_EN:           in    std_logic; -- check of watchdog timeout

          -- status ports (synchronous to CLK)
          ---------------------------------------------------------------
          WD_IDX:            out   std_logic; -- '0': WD_0 activ
                                               -- '1': WD_1 activ 
          TIME_OUT:          out   std_logic; -- timeout occurs
          TEST_OUT:          out   std_logic  -- watchdog under test expires

         );
end component;


component speed_ctrl
    port (
          clk :              in    std_logic;                     -- Clock
          nres :             in    std_logic;                     -- Reset

          d :    	     in    std_logic_vector(15 downto 0); -- Data from Port to Registers
          sel_mult_fact :    in    std_logic;                     -- Select Register for multiplication factor

          write_pulse:       in    std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers

          cfg_dimp2 :        in    std_logic_vector( 5 downto 0); -- Data word length (Width of position value)
          cfg_speed :        in    std_logic;                     -- configurate speed value output (32, 64 bit)
          eempf_rg1 :        in    std_logic;                     -- enable for RX1
          empf_rg1  :        in    std_logic_vector(47 downto 0); -- RX1

          mult_fact :        out   std_logic_vector(15 downto 0); -- Register for multiplier factor
          speed     :        out   std_logic_vector(63 downto 0); -- Speed Register (speed value)
          dir       :        out   std_logic;                     -- Output for indication of direction
          ready     :        out   std_logic                      -- Ready signal
         );
end component;


    
begin

--========================================================================================
-- constant level signals
hi <= '1';
lo <= '0';
 
--========================================================================================
--========================================================================================
-- EnDat22 Kernel
------------------

KERNEL : endat22_kernel generic map (
        IMPLEMENT_TCLK_V1  => IMPLEMENT_TCLK_V1,        -- Standard Solution
        IMPLEMENT_TCLK_V2  => IMPLEMENT_TCLK_V2)        -- Customer Solution

   port map
       (clk                => clk,
        nres               => nres, 
        scan_test          => scan_mode, 

        data_rc            => data_rc,
        nstr               => nstr,
        n_int6             => n_int6,
        n_int7             => n_int7,
        intn               => intn,

        data_dv            => data_dv,
        de                 => de,
        ntimer             => ntimer,
        tclk               => tclk,
        tst_out_pin        => tst_out_pin,
        dui                => dui,
        n_si               => n_si,
        datin2moduls       => datin2moduls,
        -- Recovery Time Flags
        RTM_START_O        => RTM_START_O,
        RTM_STOPP_O        => RTM_STOPP_O,

-------------------------------------------------------------------------------------------
-- load pulse for registers
-- map write enable to former select signals
-------------------------------------------------------------------------------------------
        sel_tx             => sel_tx,                  -- Select Transmission Register
        sel_rx1            => sel_rx1,                 -- Select Receive Register 1
        sel_rx2            => sel_rx2,                 -- Select Receive Register 2
        sel_rx3            => sel_rx3,                 -- Select Receive Register 3
        sel_cfg1           => sel_cfg1,                -- Select Configuration Register 1
        sel_cfg2           => sel_cfg2,                -- Select Configuration Register 2
        sel_cfg3           => sel_cfg3,                -- Select Configuration Register 3
        sel_stat           => sel_stat,                -- Select Status Register
        sel_im             => sel_im,                  -- Select Interrupt Mask Register
        sel_tst1           => sel_tst1,                -- Select Test Register 1
        sel_tst2           => sel_tst2,                -- Select Test Register 2

        soft_str           => soft_str,                -- Soft Strobe

        data_port_to_registers => data_port_to_registers,


-------------------------------------------------------------------------------------------
-- Signals to/from control_saf
-------------------------------------------------------------------------------------------

--  Registers
---------------

       write_pulse        => write_pulse,             -- Write Pulse for internal Registers

       eempf_rg1          => eempf_rg1,               -- enable for RX1
       eempf_rg2          => eempf_rg2,               -- enable for RX2
       eempf_rg3          => eempf_rg3,               -- enable for RX3
       d_empf_rg1         => d_empf_rg1(15 downto 0), -- Input of RX1 
       d_empf_rg2         => d_empf_rg2(23 downto 0), -- Input of RX2
       d_empf_rg3         => d_empf_rg3,              -- Input of RX3


       tx                 => tx(SENDE_WIDTH-1 downto 0),
       empf_rg1           => empf_rg1,                -- RX1
       empf_rg2           => empf_rg2,                -- RX2
       empf_rg3           => empf_rg3,                -- RX3
--       empf_rg4           => empf_rg4,                -- RX4
       cfg1               => cfg1,
       cfg2               => cfg2,
       cfg3               => cfg3,
       dstat              => dstat,
       stat               => stat,
       im                 => im,
       tst1               => tst1,
       tst2               => tst2,


       mode_7_0           => mode_7_0,                -- Mode Command 7-0
       mode_11_33_44      => mode_11_33_44,           -- Mode Commands 1-1 ..6-6
       qspw               => qspw(23 downto 0),       -- Data from Ser.Parallel Converter
       set_sende_from_ua1 => set_sende_from_ua1,      -- Enable for TX for values 42,43,44 when UA1
      d_pretx_mx_from_saf => d_pretx_mx_from_saf,     -- Muxer for the values 942,943,944 for the TX reg
       pretx_mx_sel       => pretx_mx_sel,            -- Select for Muxer for TX

--  Enable WT
-------------    

       enbl_for_wt_crc5   => enbl_for_wt_crc5,        -- enable for test od CRC5 checker
       data_for_wt_crc5   => data_for_wt_crc5,        -- serial data out
       rdy_wt_crc5        => rdy_wt_crc5,             -- ready signal of WT CRC5 activity test
       pos1_index         => pos1_index,              -- Index for Pos1 for compare with Pos2

--  Signals of/for the Measurement System
-----------------------------------------    

       input_2_srg        => input_2_srg,             -- additional inputs to status register

       qcrc               => qcrc,                    -- received CRC from encoder
       testcrc            => testcrc,                 -- in this IC generated CRC

       crc_err            => crc_err,                 -- CRC Error PW (Pos1)
       crc_err_rg2        => crc_err_rg2,             -- CRC Error ZI2 
       crc_err_rg3        => crc_err_rg3,             -- CRC Error ZI1 (Pos2)

       tst_empf_rg        => tst_empf_rg,             -- Test Enable RX Registers (For Test Write Modus)
       ic_test_mode       => ic_test_mode,                     -- IC Test Mode
       tst_mux2           => tst_mux2,                -- Testmux2
       tst_mux3           => tst_mux3,                -- Testmux3
       tst_mode_div       => tst_mode_div,            -- Testmode of divider

       alarm              => alarm,                   -- Fehler1
       alarm2             => alarm2,                  -- /Fehler2
       fb_typ_1           => fb_typ_1,                -- F-TypI   FRG
       fb_typ_2           => fb_typ_2,                -- F-TypII  FRG
       n_rm               => n_rm,                    -- not RM bit

       mode_ua1           => cfg4(0),                 -- 4-cycle (transmission mode ua1)
       start_trans        => start_trans,             -- Start transmission (Timer, HW, SW)

       dfreq_out          => dfreq,                   -- TCLK-frequency
       ec_automat         => ec_automat,              -- ECLK state machine
       zi_bit             => zi_bit,                  -- Number of ZI from eclk 
       autom_srg_reset    => autom_srg_reset,
       cfg_allow_srg_reset => cfg_allow_srg_reset,
       cfg_autom_srg_reset => cfg_autom_srg_reset,
       enbl_tm_z25        => enbl_tm_z25,             -- Laufzeit ist eingearbeitet                

--  Signals for tm CNT
----------------------   
       usc010             => usc010,                  -- 100 ns pulse 
       usc025             => usc025,                  -- 250 ns pulse
       MHZ48              => MHZ48,                   -- Select 48 MHz system frequency
       MHZ50              => MHZ50,                   -- Select 50 MHz system frequency
       MHz64              => MHZ64,                   -- Select 64 MHz system frequency
       MHZ100             => MHZ100,                  -- Select 100MHz system frequency

-----------------------------------------------------------------------------------------
-- Signals to Watchdog WD
-------------------------------------------------------------------------------------------

       start_wd           => start_wd);




--========================================================================================
--========================================================================================
-- Monitoring Functions
--=====================

-- Monitoring Unit
------------------

MONIT_FUNC: if (IMPLEMENT_MONIT_FUNC = 1) generate

MONIT: control_saf
   generic map (
    IMPLEMENT_OEM1        => IMPLEMENT_OEM1,          -- Special OEM Function
    IMPLEMENT_OEM2        => IMPLEMENT_OEM2)          -- Special OEM Function
   port map (
    clk                   => clk,                     -- Clock
    nres                  => nres,                    -- Reset

--  Signals for Micro Controller Port
-------------------------------------
    PSEL2                 => PSEL2,                   -- PSEL (SYNC_PORT2,Decoder)
    PENABLE2              => PENABLE2,                -- PENABLE (SYNC_PORT2)
    d     	          => data_port_to_registers,  -- Data from Port to Registers
    sel_rx4               => sel_rx4,                 -- Select Receive Register 4
    sel_cfg4              => sel_cfg4,                -- Select Configuration Register 4
    sel_cfg5              => sel_cfg5,                -- Select Configuration Register 5
    sel_npv               => sel_npv,                 -- Select Register for "Npv"  value (low part)
    sel_npvh              => sel_npvh,                -- Select Register for "Npv"  value (high part)
    sel_tst3              => sel_tst3,                -- Select Test Register3
    sel_off2              => sel_off2,                -- Select Register for "Off2" value (low part)
    sel_off2h             => sel_off2h,               -- Select Register for "Off2" value (high part)
    sel_frg               => sel_frg,                 -- Select Error/Status Register 
    sel_fim               => sel_fim,                 -- Select Error Interrupt Mask Register 

    sel_srm               => sel_srm,                 -- Select Register for "srM" 
    sel_srmh              => sel_srmh,                -- Select Register for "srM" (high) 
    sel_nsrpos1           => sel_nsrpos1,             -- Select Register for "nsrPOS1" 
    sel_nsrpos2           => sel_nsrpos2 ,            -- Select Register for "nsrPOS2"  

    write_pulse           => write_pulse(3 downto 0), -- Write Pulse for internal Registers
    autom_srg_reset       => autom_srg_reset,         -- from eclk
    cfg_allow_srg_reset   => cfg_allow_srg_reset,     -- CFG1
    cfg_autom_srg_reset   => cfg_autom_srg_reset,     -- CFG1

    tx                    => tx(29 downto 24),        -- Transmission Register
    dfreq                 => dfreq,                   -- TCLK-frequency
    dat_in                => datin2moduls,            -- DATA_RC
    eempf_rg1             => eempf_rg1,               -- enable for RX1
    eempf_rg2             => eempf_rg2,               -- enable for RX2
    eempf_rg3             => eempf_rg3,               -- enable for RX3
    d_empf_rg2            => d_empf_rg2(23 downto 0), -- Input of RX2
    d_empf_rg3            => d_empf_rg3(31 downto 0), -- Input of RX3
    empf_rg1              => empf_rg1(47 downto 0),   -- RX1
    empf_rg3              => empf_rg3(31 downto 0),   -- RX3
    dstat                 => dstat,                   -- Status Register
    stat                  => stat,                    -- Status Register

    rx4                   => empf_rg4,                -- Receive Register4
    rx1s                  => empf_rg1s,               -- Receive Register1S
    rx3s                  => empf_rg3s,               -- Receive Register3S
    ds1                   => ds1_rg,                -- Data-Save Register 1
    ds2                   => ds2_rg,                -- Data-Save Register 2
    ds3                   => ds3_rg,                -- Data-Save Register 3
    ds4                   => ds4_rg,                -- Data-Save Register 4
    cfg4                  => cfg4,                  -- Configuration Register 4
    cfg5                  => cfg5,                    -- Configuration Register 5
    npv                   => npv,                     -- Register for "Npv"
    tst3                  => tst3,                    -- Test Register3
    off2                  => off2,                    -- Register for "Off2"
    frg                   => frg,                     -- Error/Status Register
    fim                   => fim,                     -- Error Interrupt Mask Register

    SRM                   => SRM,                     -- Register for "srM" (sicherheitsrel. Messschritte)
    NSRPOS1               => NSRPOS1,                 -- Register for "nsrPOS1" (nicht sicherheitsrel. Unterteilung Pos1)
    NSRPOS2               => NSRPOS2,                 -- Register for "nsrPOS2" (nicht sicherheitsrel. Unterteilung Pos2)
    tst4                  => tst4,                    -- Test Register4 (divider) 

    qspw                  => qspw(23 downto 0),       -- Data from Ser.Parallel Converter
    set_sende_from_ua1    => set_sende_from_ua1,      -- Enable for TX for values 42,43,44 when UA1
    d_pretx_mx            => d_pretx_mx_from_saf,     -- Muxer for the values 42,43,44 for the TX reg
    pretx_mx_sel          => pretx_mx_sel,            -- Select for Muxer for TX

--  Enable WT
-------------    

    enbl_for_wt_crc5      => enbl_for_wt_crc5,        -- enable for test od CRC5 checker
    data_for_wt_crc5      => data_for_wt_crc5,        -- serial data out
    rdy_wt_crc5           => rdy_wt_crc5,             -- ready signal of WT CRC5 activity test
    pos1_index            => pos1_index,              -- Index for Pos1 for compare with Pos2

--  Signals of/for the Measurement System
-----------------------------------------    

    rx_crc5               => qcrc( 4 downto 0),       -- received CRC from encoder
    tst_crc5              => testcrc( 4 downto 0),    -- in this IC generated CRC
--
    crc_err               => crc_err,                 -- CRC Error PW (Pos1)
    crc_err_rg2           => crc_err_rg2,             -- CRC Error ZI2 
    crc_err_rg3           => crc_err_rg3,             -- CRC Error ZI1 (Pos2)

    tst_empf_rg           => tst_empf_rg,             -- Test Enable RX Registers (For Test Write Modus)
    ic_test_mode          => ic_test_mode,            -- IC Test Mode
    tst_mux2              => tst_mux2,                -- Testmux2
    tst_mux3              => tst_mux3,                -- Testmux3
    tst_mode_div          => tst_mode_div,            -- Testmode of divider

    start_trans           => start_trans,             -- Start transmission (Timer, HW, SW)
    mode_11_33_44         => mode_11_33_44,           -- Mode Commands 1-1 ..6-6
    alarm                 => alarm,                   -- Fehler1   to FRG (from SRG)
    alarm2                => alarm2,                  -- /Fehler2  to FRG (from SRG)
    fb_typ_1              => fb_typ_1,                -- F-TypI    to FRG
    fb_typ_2              => fb_typ_2,                -- F-TypII   to FRG
    n_rm                  => n_rm,                    -- not RM bit
    
    ec_automat            => ec_automat,              -- ECLK state machine
    zi_bit                => zi_bit,                  -- Number of ZI from eclk 
    del_rg                => cfg1(23 downto 16),      -- Delay-Reg
    enbl_tm_z25           => enbl_tm_z25,             -- Laufzeit ist eingearbeitet                

    axis_adr              => axis_adr,                -- Address Line of the encoder axis    

    intn2                 => intn2,                   -- Interrupt Request2 to Micro Controller
    intn3                 => intn3,                   -- Interrupt Request3 to Micro Controller

--  Signals of/for WD
---------------------    
    cfg_wt_wd             => cfg_wt_wd,               -- Select WT WD
    wd_time_out           => wd_time_out,             -- to WD Bits (FRG)
    wd_wt_out             => wd_wt_out,               -- to WD Bits (FRG)
    wm_idx                => wm_idx,                  -- to WD Bits (FRG)

--  Signals for tm CNT
----------------------   
    usc010                => usc010,                  -- 100 ns pulse 
    usc025                => usc025,                  -- 250 ns pulse
    MHZ48                 => MHZ48,                   -- Select 48 MHz system frequency
    MHZ50                 => MHZ50,                   -- Select 50 MHz system frequency
    MHz64                 => MHZ64,                   -- Select 64 MHz system frequency
    MHZ100                => MHZ100,                  -- Select 100MHz system frequency

    SEL_OEM1_CTRL          => SEL_OEM1_CTRL,           -- Select OEM1 Control Register
    SEL_OEM1_IRQSTAT       => SEL_OEM1_IRQSTAT,        -- Select OEM1 Interrupt Status Register
    SEL_OEM1_IM            => SEL_OEM1_IM,             -- Select OEM1 Interrupt Mask
    SEL_OEM1_CFG1          => SEL_OEM1_CFG1,           -- Select OEM1 Configuration Register1
    SEL_OEM1_CFG2          => SEL_OEM1_CFG2,           -- Select OEM1 Configuration Register2
    SEL_OEM1_CFG3          => SEL_OEM1_CFG3,           -- Select OEM1 Configuration Register3
    SEL_OEM1_CFG4          => SEL_OEM1_CFG4,           -- Select OEM1 Configuration Register4
    SEL_OEM1_CFG5_L        => SEL_OEM1_CFG5_L,         -- Select OEM1 Configuration Register5 (lower part)
    SEL_OEM1_CFG5_H        => SEL_OEM1_CFG5_H,         -- Select OEM1 Configuration Register5 (higher part)
    SEL_OEM1_CFG6          => SEL_OEM1_CFG6,           -- Select OEM1 Configuration Register6
    SEL_OEM1_STAT          => SEL_OEM1_STAT,           -- Select OEM1 Status

    OEM1_CTRL              => OEM1_CTRL,                -- OEM1 Control Register
    OEM1_IRQSTAT           => OEM1_IRQSTAT,             -- OEM1 Interrupt Status Register
    OEM1_IM                => OEM1_IM,                  -- OEM1 Interrupt Mask
    OEM1_CFG1              => OEM1_CFG1,                -- OEM1 Configuration Register1
    OEM1_CFG2              => OEM1_CFG2,                -- OEM1 Configuration Register2
    OEM1_CFG3              => OEM1_CFG3,                -- OEM1 Configuration Register3
    OEM1_CFG4              => OEM1_CFG4,                -- OEM1 Configuration Register4
    OEM1_CFG5              => OEM1_CFG5,                -- OEM1 Configuration Register5
    OEM1_CFG6              => OEM1_CFG6,                -- OEM1 Configuration Register6
    OEM1_STORE             => OEM1_STORE,               -- OEM1 Store
    OEM1_ST                => OEM1_ST,                  -- OEM1 Singleturn
    OEM1_MT                => OEM1_MT,                  -- OEM1 Multiturn
    OEM1_POS2              => OEM1_POS2,                -- OEM1 Position2
    OEM1_SOL               => OEM1_SOL,                 -- OEM1 Sign of Life (Lebenszeichen) 
    OEM1_STAT              => OEM1_STAT,                -- OEM1 Status

    OEM1_INTN1              => OEM1_INTN1,                -- Interrupt Request to Micro Controller
    OEM1_INTN2              => OEM1_INTN2                -- Interrupt Request to Micro Controller
    );
    
    
--========================================================================================
--========================================================================================
-- Watchdog WD 
--------------

WD: WATCHDOG
 generic map (
          WATCH_TIME         => 300           -- us !! 
         )
    port map (
          CLK_WD             => CLK_WD,       -- watchdog clock domain 
          CEN_WD_CLK         => CEN_WD_CLK,   -- enable of for CLK_WD
          RESX               => nreset,       -- asynchronous Power On Reset (lo activ)
          SCAN_MODE          => scan_mode,    -- avoid DFT design rule violation
          SCIN_WD            => SCIN_WD,      -- input  of scan chain
          SCOUT_WD           => SCOUT_WD,     -- output of scan chain

          CLK                => clk,          -- application clock domain
          RES_APP            => nres,         -- global reset of application clock domain

          -- control ports (synchronous to CLK)
          ---------------------------------------------------------------
          TRIG               => start_wd,     -- async trigger from application
          TEST_EN            => cfg_wt_wd,    -- check of watchdog timeout (WT)

          -- status ports (synchronous to CLK)
          ---------------------------------------------------------------
          WD_IDX             => wm_idx,       -- '0': WD_0 activ
                                              -- '1': WD_1 activ 
          TIME_OUT           => wd_time_out,  -- timeout occurs
          TEST_OUT           => wd_wt_out     -- watchdog under test expires

         );

end generate;  -- IMPLEMENT_MONIT_FUNC


NOT_MONIT_FUNC: if (IMPLEMENT_MONIT_FUNC = 0) generate


       empf_rg4            <= (others => '0');  -- Receive Register4
       empf_rg1s           <= (others => '0');  -- Receive Register1S
       empf_rg3s           <= (others => '0');  -- Receive Register3S
       ds1_rg              <= (others => '0');  -- Data-Save Register 1
       ds2_rg              <= (others => '0');  -- Data-Save Register 2
       ds3_rg              <= (others => '0');  -- Data-Save Register 3
       ds4_rg              <= (others => '0');  -- Data-Save Register 4
       cfg4                <= (others => '0');  -- Configuration Register 4
       cfg5                <= (others => '0');  -- Configuration Register 5
       npv                 <= (others => '0');  -- Register for "Npv"
       tst3                <= (others => '0');  -- Test Register3
       off2                <= (others => '0');  -- Register for "Off2"
       frg                 <= (others => '0');  -- Error/Status Register
       fim                 <= (others => '0');  -- Error Interrupt Mask Register

       set_sende_from_ua1  <= '0';              -- Enable for TX for values 42,43,44 when UA1
       d_pretx_mx_from_saf <= "00000000000000"; -- Muxer for the values 942,943,944 for the TX reg
       pretx_mx_sel        <= '0';              -- Select for Muxer for TX

       enbl_for_wt_crc5    <= '0';              -- enable for test od CRC5 checker
       data_for_wt_crc5    <= '0';              -- serial data out
       rdy_wt_crc5         <= '0';              -- ready signal of WT CRC5 activity test
       pos1_index          <= '0';              -- Index for Pos1 for compare with Pos2

       cfg4(0)             <= '0';              -- 4-cycle (transmission mode ua1)

end generate;  -- not IMPLEMENT_MONIT_FUNC


--========================================================================================
--========================================================================================
-- Speed Module
--=============

SPEED_FUNC: if (IMPLEMENT_SPEED_FUNC = 1) generate

SPEEDY: speed_ctrl
   port map (
    clk                   => clk,                     -- Clock
    nres                  => nres,                    -- Reset

    d     	          => data_port_to_registers(15 downto 0),  -- Data from Port to Registers
    sel_mult_fact         => sel_mult_fact,           -- Select Register for multiplication factor

    write_pulse           => write_pulse(3 downto 0), -- Write Pulse for internal Registers

    cfg_dimp2             => cfg1(13 downto 8),     -- Data word length (Width of position value)
    cfg_speed             => cfg3(15),              -- configurate speed value output (32, 64 bit)
    eempf_rg1             => eempf_rg1,               -- enable for RX1
    empf_rg1              => empf_rg1(47 downto 0),   -- RX1

    mult_fact             => mult_fact,               -- Register for multiplier factor
    speed                 => speed,                   -- Speed Register
    dir                   => dir,                     -- Output for indication of direction 
    ready                 => speed_ready);            -- Ready signal

    input_2_srg(29) <= speed_ready;
    
end generate;  -- IMPLEMENT_SPEED_FUNC

NOT_SPEED_FUNC: if (IMPLEMENT_SPEED_FUNC = 0) generate

    mult_fact       <= (others => '0');
    speed           <= (others => '0');
    input_2_srg(29) <= '0';
    dir             <= '0';
    speed_ready     <= '0';
end generate;  -- not IMPLEMENT_SPEED_FUNC

--========================================================================================
--========================================================================================

-- Assignments
--------------------------------------
input_2_srg(28 downto 24) <= (others => '0');

D_SEND          <= tx(SENDE_WIDTH-1 downto 0);
D_EMPF1         <= empf_rg1(EMPF1_WIDTH-1 downto 0);
D_EMPF2         <= empf_rg2(EMPF2_WIDTH-1 downto 0);
D_EMPF3         <= empf_rg3(EMPF3_WIDTH-1 downto 0);
D_EMPF4         <= empf_rg4(EMPF4_WIDTH-1 downto 0);
D_EMPF1S        <= empf_rg1s(EMPF1S_WIDTH-1 downto 0);
D_EMPF3S        <= empf_rg3s(EMPF3S_WIDTH-1 downto 0);
D_KONF1         <= cfg1(KONF1_WIDTH-1 downto 0);
D_KONF2         <= cfg2(KONF2_WIDTH-1 downto 0);
D_KONF3         <= cfg3(KONF3_WIDTH-1 downto 0);
D_KONF4         <= cfg4(KONF4_WIDTH-1 downto 0);
D_KONF5         <= cfg5(KONF5_WIDTH-1 downto 0);

D_NPV           <= npv(NPV_WIDTH-1 downto 0);
D_OFFSET2       <= off2(OFFSET2_WIDTH-1 downto 0);
D_STATUS        <= stat(STATUS_WIDTH-1 downto 0);
D_S_INT_EN      <= im(STATUS_WIDTH-1 downto 0);
D_FEHLER        <= frg(FEHLER_WIDTH-1 downto 0);
D_F_INT_EN      <= fim(FEHLER_WIDTH-1 downto 0);
D_DS1_RG        <= ds1_rg(DS_WIDTH-1 downto 0);
D_DS2_RG        <= ds2_rg(DS_WIDTH-1 downto 0);
D_DS3_RG        <= ds3_rg(DS_WIDTH-1 downto 0);
D_DS4_RG        <= ds4_rg(DS_WIDTH-1 downto 0);
D_TEST1         <= tst1(TEST1_WIDTH-1 downto 0);
D_TEST2         <= tst2(TEST2_WIDTH-1 downto 0);
D_TEST3         <= tst3(TEST3_WIDTH-1 downto 0);
D_TEST4         <= tst4(TEST4_WIDTH-1 downto 0);

D_SRM           <= SRM(SRM_WIDTH-1 downto 0);
D_NSRPOS1       <= NSRPOS1(NSRPOS_WIDTH-1 downto 0);
D_NSRPOS2       <= NSRPOS2(NSRPOS_WIDTH-1 downto 0);

D_MULTIPL       <= mult_fact(MULTIPL_WIDTH-1 downto 0);
D_SPEED         <= speed(SPEED_WIDTH-1 downto 0);

D_OEM1_CTRL     <= OEM1_CTRL(OEM1_CNTRL_WIDTH-1 downto 0);   -- OEM1 Control Register
D_OEM1_IRQSTAT  <= OEM1_IRQSTAT(OEM1_INTSTAT_WIDTH-1 downto 0); -- OEM1 Interrupt Status Register
D_OEM1_IM       <= OEM1_IM(OEM1_I_INT_EN_WIDTH-1 downto 0);-- OEM1 Interrupt Mask
D_OEM1_KONF1    <= OEM1_CFG1(OEM1_KONF1_WIDTH-1 downto 0);   -- OEM1 Configuration Register1
D_OEM1_KONF2    <= OEM1_CFG2(OEM1_KONF2_WIDTH-1 downto 0);   -- OEM1 Configuration Register2
D_OEM1_KONF3    <= OEM1_CFG3(OEM1_KONF3_WIDTH-1 downto 0);   -- OEM1 Configuration Register3
D_OEM1_KONF4    <= OEM1_CFG4(OEM1_KONF4_WIDTH-1 downto 0);    -- OEM1 Configuration Register4
D_OEM1_KONF5    <= OEM1_CFG5(OEM1_KONF5_WIDTH-1 downto 0);   -- OEM1 Configuration Register5
D_OEM1_KONF6    <= OEM1_CFG6(OEM1_KONF6_WIDTH-1 downto 0);   -- OEM1 Configuration Register6
D_OEM1_STORE    <= OEM1_STORE(OEM1_STOR_WIDTH-1  downto 0);  -- OEM1 Store
D_OEM1_ST       <= OEM1_ST(OEM1_STURN_WIDTH-1 downto 0);   -- OEM1 Singleturn
D_OEM1_MT       <= OEM1_MT(OEM1_MTURN_WIDTH-1 downto 0);   -- OEM1 Multiturn
D_OEM1_POS2     <= OEM1_POS2(OEM1_POSI2_WIDTH-1 downto 0);   -- OEM1 Position2
D_OEM1_SOL      <= OEM1_SOL(OEM1_SOLCT_WIDTH-1 downto 0);   -- OEM1 Sign of Life (Lebenszeichen) 
D_OEM1_STATUS   <= OEM1_STAT(OEM1_STATUS_WIDTH-1 downto 0);  -- OEM1 Status

n_int1      <= intn;
n_int2      <= intn2;
n_int3      <= intn3;
n_int1_oem1  <= OEM1_INTN1;
n_int2_oem1  <= OEM1_INTN2;


end behav;
