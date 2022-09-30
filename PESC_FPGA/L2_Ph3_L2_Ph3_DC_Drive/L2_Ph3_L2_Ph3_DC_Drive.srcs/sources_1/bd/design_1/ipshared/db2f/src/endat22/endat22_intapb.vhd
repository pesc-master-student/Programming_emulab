--****************************************************************************************
--
--                                                          ENDAT22_INTAPB
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
--                   With internal SYNC_PORT-IF
-- 
-- History: F.Seiler 26.03. 2009 Initial Version
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


entity ENDAT22_INTAPB is
   generic (

        ADR_WIDTH:                 integer;
        IMPLEMENT_PORTS:           integer:= 1;
        IMPLEMENT_UC_IF:           integer:= 0;
        IMPLEMENT_PORT_2:          integer:= 1;
        INVERT_RD_DATA_2:          integer:= 0;
        OUTRG_SYNC_IF:             integer:= 1;
        IMPLEMENT_PORT_3:          integer:= 0;
        IMPLEMENT_MONIT_FUNC:      integer:= 1;
        IMPLEMENT_SPEED_FUNC:      integer:= 0;
        IMPLEMENT_INKR_FUNC:       integer:= 0;
        IMPLEMENT_OEM1:            integer:= 0;        -- Special Function
        IMPLEMENT_OEM2:            integer:= 0;        -- Special Function
        IMPLEMENT_TCLK_V1:         integer:= 0;        -- Select V1 or V2 
        IMPLEMENT_TCLK_V2:         integer:= 1         -- Select V1 or V2
           );
   port(clk        :         in    std_logic;
        CLK_WD     :         in    std_logic;
        nres       :         in    std_logic;                     -- Reset for modules
        nreset     :         in    std_logic;                     -- Reset for WD
        nres_spi1  :         in    std_logic;                     -- Delayed Reset from SPI
        nres_spi3  :         in    std_logic;                     -- Delayed Reset from SPI
        cfg1_29    :         out   std_logic;                     -- SW-Reset

        write_pulse1 :       in    std_logic_vector( 3 downto 0); -- Write pulse Port1
        write_pulse2 :       in    std_logic_vector( 3 downto 0); -- Write pulse Port2
        write_pulse3 :       in    std_logic_vector( 3 downto 0); -- Write pulse Port3

        AHB_DEN100 :         in    std_logic;                     -- sync enable of APB bus
        CEN_WD_CLK :         in    std_logic;                     -- enable of for CLK_WD (No further synchronisation in EnDat Master !!!!!)

        -- main read/write APB port
        PSEL     :           in    std_logic;                     -- PSEL (APB,Decoder)
        PENABLE  :           in    std_logic;                     -- PENABLE (APB)
        PWRITE   :           in    std_logic;                     -- PWRITE (APB)
        PWDATA   :           in    std_logic_vector(31 downto 0); -- PWDATA (APB)
        PADDR    :           in    std_logic_vector(ADR_WIDTH-1 downto 2); -- PADDR (APB)
        PRDATA   :           out   std_logic_vector(31 downto 0); -- DATA_OUT  
        PRDY     :           out   std_logic;                     -- READY
        D2MASK_S :           out   std_logic_vector(DATA_WIDTH-1 downto 0); -- between UC_IF and SYNC_PORT_DEC

        -- 2nd read only APB port
        PSEL2    :           in    std_logic;                     -- PSEL (APB,Decoder)
        PENABLE2 :           in    std_logic;                     -- PENABLE (APB)
        PWDATA2  :           in    std_logic_vector(31 downto 0); -- PWDATA (APB)
        PADDR2   :           in    std_logic_vector(ADR_WIDTH-1 downto 2); -- PADDR (APB)  (1 bit more because offset)
        PRDATA2  :           out   std_logic_vector(31 downto 0); -- inverted DATA_OUT
        PRDY2    :           out   std_logic;                     -- READY
        D2MASK_S2:           out   std_logic_vector(DATA_WIDTH-1 downto 0); -- between UC_IF and SYNC_PORT_DEC

        -- 3rd read/write APB port
        PSEL3    :           in    std_logic;                     -- PSEL (APB,Decoder)
        PENABLE3 :           in    std_logic;                     -- PENABLE (APB)
        PWRITE3  :           in    std_logic;                     -- PWRITE (APB)
        PWDATA3  :           in    std_logic_vector(31 downto 0); -- PWDATA (APB)
        PADDR3   :           in    std_logic_vector(ADR_WIDTH-1 downto 2); -- PADDR (APB)
        PRDATA3  :           out   std_logic_vector(31 downto 0); -- DATA_OUT  
        PRDY3    :           out   std_logic;                     -- READY
        D2MASK_S3:           out   std_logic_vector(DATA_WIDTH-1 downto 0); -- between UC_IF and SYNC_PORT_DEC

        -- Interrupt Request Micro Controller
        n_int1   :           out   std_logic;                     -- Interrupt Request1 to Micro Controller
        n_int2   :           out   std_logic;                     -- Interrupt Request2 to Micro Controller
        n_int3   :           out   std_logic;                     -- Interrupt Request3 to Micro Controller
        n_int1_oem1:          out   std_logic;                     -- Interrupt Request OEM1 to Micro Controller
        n_int2_oem1:          out   std_logic;                     -- Interrupt Request OEM2 to Micro Controller

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
attribute PORT_TYP of ENDAT22_INTAPB: ENTITY is "APB";
-- synopsys translate_on

-----------------------------------------------------------------------------------------
-- placeholder port signals -> assure error free compile
-----------------------------------------------------------------------------------------

end ENDAT22_INTAPB;

architecture behav of ENDAT22_INTAPB is

--==========================================================================================
--  Signal Declaration
--==========================================================================================
    -- internal port signals of first SYNC_PORT
    -------------------------------------------
    signal AHB_DEN100_i  : std_logic;                     -- sync enable of SYNC_PORT
    signal PSEL_i        : std_logic;                     -- PSEL (SYNC_PORT,Decoder)
    signal PENABLE_i     : std_logic;                     -- PENABLE (SYNC_PORT)
    signal PWRITE_i      : std_logic;                     -- PWRITE (SYNC_PORT)
    signal PRDY_i        : std_logic;                     -- PRDY (SYNC_PORT IF instance port)
    signal PWDATA_i      : std_logic_vector(31 downto 0); -- PWDATA (SYNC_PORT)
    signal PADDR_i       : std_logic_vector(ADR_WIDTH-1 downto 2); -- PADDR (SYNC_PORT)
    signal PRDATA_i      : std_logic_vector(31 downto 0); -- DATA_OUT (read data)

    -- internal port signals of second SYNC_PORT
    ------------------------------------------------------------------------------------
    signal PSEL2_i       : std_logic;                     -- PSEL (SYNC_PORT2,Decoder)
    signal PENABLE2_i    : std_logic;                     -- PENABLE (SYNC_PORT2)
    signal PWRITE2_i     : std_logic;                     -- PWRITE (SYNC_PORT2)
    signal PRDY2_i       : std_logic;                     -- PRDY (SYNC_PORT IF instance port 2)
    signal PWDATA2_i     : std_logic_vector(31 downto 0); -- PWDATA (SYNC_PORT2)
    signal PADDR2_i      : std_logic_vector(ADR_WIDTH downto 2); -- PADDR (SYNC_PORT2) Note: 1 bit more due to OFFSET
    signal PADDR2_ii     : std_logic_vector( 7 downto 0); -- immer 8 Bit !!!
    signal PADDR2_wo_off : std_logic_vector(ADR_WIDTH downto 2); -- PADDR (SYNC_PORT2) Note: 1 bit more due to OFFSET
    signal PRDATA2_i     : std_logic_vector(31 downto 0); -- DATA_OUT2 (read data)

    -- internal port signals of 3rd SYNC_PORT
    ------------------------------------------------------------------------------------
    signal PSEL3_i       : std_logic;
    signal qPSEL3_i      : std_logic;
    signal PENABLE3_i    : std_logic;
    signal PWRITE3_i     : std_logic;
    signal PRDY3_i       : std_logic;                             -- PRDY (SYNC_PORT 3)
    signal PADDR3_i      : std_logic_vector(ADR_WIDTH-1 downto 2); -- PADDR (SYNC_PORT 3)
    signal PWDATA3_i     : std_logic_vector(31 downto 0);          -- PWDATA (SYNC_PORT 3)
    signal PRDATA3_i     : std_logic_vector(31 downto 0);          -- DATA_OUT (read data SYNC_PORT 3)

--========================================================================================
    signal write_pulse   : std_logic_vector(3 downto 0); -- byte_enable of Registers
    
--  Signals for controlling registers
    signal sel_tx        : std_logic;             -- Select Transmission Register
    signal sel_rx1       : std_logic;             -- Select Receive Register 1
    signal sel_rx2       : std_logic;             -- Select Receive Register 2
    signal sel_rx3       : std_logic;             -- Select Receive Register 3
    signal sel_cfg1      : std_logic;             -- Select Configuration Register 1
    signal sel_cfg2      : std_logic;             -- Select Configuration Register 2
    signal sel_cfg3      : std_logic;             -- Select Configuration Register 3
    signal sel_stat      : std_logic;             -- Select Status Register 
    signal sel_im        : std_logic;             -- Select Interrupt Mask Register 
    signal sel_tst1      : std_logic;             -- Select Test Register 1
    signal sel_tst2      : std_logic;             -- Select Test Register 2
    signal sel_rx4       : std_logic;             -- Select Receive Register 4
    signal sel_ds1       : std_logic;             -- Select Data-Save Register 1
    signal sel_ds2       : std_logic;             -- Select Data-Save Register 2
    signal sel_ds3       : std_logic;             -- Select Data-Save Register 3
    signal sel_cfg4      : std_logic;             -- Select Configuration Register 4
    signal sel_cfg5      : std_logic;             -- Select Configuration Register 5
    signal sel_npv       : std_logic;             -- Select Register for "Npv"  value
    signal sel_npvh      : std_logic;             -- Select Register for "Npv"  value (high part)
    signal sel_tst3      : std_logic;             -- Select Test Register3
    signal sel_off2      : std_logic;             -- Select Register for "Off2" value
    signal sel_off2h     : std_logic;             -- Select Register for "Off2" value (high part)
    signal sel_frg       : std_logic;             -- Select Error/Status Register 
    signal sel_fim       : std_logic;             -- Select Error Interrupt Mask Register 
    signal sel_srm       : std_logic;             -- Select Register for "srM", srMH"
    signal sel_srmh      : std_logic;             -- Select Register for "srM", srMH"
    signal sel_nsrpos1   : std_logic;             -- Select Register for "nsrPOS1", "nsrPOS2" 
    signal sel_nsrpos2   : std_logic;             -- Select Register for "nsrPOS1", "nsrPOS2" 

    signal sel_mult_fact : std_logic;             -- Select Register for multiplier factor

    signal tx                       : std_logic_vector(29 downto 0); -- Transmission Register
    signal empf_rg1                 : std_logic_vector(55 downto 0); -- Receive Register 1
    signal empf_rg2, empf_rg3       : std_logic_vector(31 downto 0); -- Receive Register 2, 3

    signal cfg1                     : std_logic_vector(31 downto 0); -- Configuration Register 1
    signal cfg2                     : std_logic_vector(31 downto 0); -- Configuration Register 2
    signal cfg3                     : std_logic_vector(15 downto 0); -- Configuration Register 3
    signal stat                     : std_logic_vector(31 downto 0); -- Status Register 
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
    signal ds1_s                    : std_logic_vector(31 downto 0); -- Data-Save Register 1 signal to ports
    signal ds2_s                    : std_logic_vector(31 downto 0); -- Data-Save Register 2 signal to ports
    signal ds3_s                    : std_logic_vector(31 downto 0); -- Data-Save Register 3 signal to ports
    signal ds4_s                    : std_logic_vector(31 downto 0); -- Data-Save Register 4 signal to ports
    signal cfg4                     : std_logic_vector(31 downto 0); -- Configuration Register 4
    signal cfg5                     : std_logic_vector(31 downto 0); -- Configuration Register 5
    signal npv_rg                   : std_logic_vector(47 downto 0); -- Register for "Npv"   -- must 48 bit width !!
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

--  Data Stream from the Input Port to the internal registers 
    signal data_port_to_registers   : std_logic_vector(31 downto 0); -- Inputs from Port after MUX (SPI)
    signal data_port_to_registers_1 : std_logic_vector(31 downto 0); -- Inputs from Port
    signal data_port_to_registers_3 : std_logic_vector(31 downto 0); -- Inputs from Port
   

--========================================================================================
--  Signals of/for the Measurement System
-----------------------------------------    
    -- new added internal signals and constants
    -------------------------------------------
    constant IMPLEMENT_RDY4APB: integer:= 1;  --2008.04.03
    constant ADDR_OFFSET:       integer:= 32; -- address offset for 2nd SYNC_PORT = 0x20 dw address's

    -- constant signals
    --------------------------------
    signal hi, lo: std_logic; -- hi, lo driven signals

    -- write enable bus from SYNC_PORT_DEC
    --------------------------------
    signal we:                std_logic_vector(FIRST_RES to LAST_RES);
    signal we_1:              std_logic_vector(FIRST_RES to LAST_RES);
    signal we_3:              std_logic_vector(FIRST_RES to LAST_RES);

--========================================================================================
--========================================================================================
--  Signals to/from OEM1                                                              -- 2007.06
-----------------------   
    signal SEL_OEM1_CTRL :    std_logic;                     -- Select OEM1 Control Register
    signal SEL_OEM1_IRQSTAT : std_logic;                     -- Select OEM1 Interrupt Status Register
    signal SEL_OEM1_IM :      std_logic;                     -- Select OEM1 Interrupt Mask
    signal SEL_OEM1_CFG1   :    std_logic;                     -- Select OEM1 Configuration Register1
    signal SEL_OEM1_CFG2   :    std_logic;                     -- Select OEM1 Configuration Register2
    signal SEL_OEM1_CFG3   :    std_logic;                     -- Select OEM1 Configuration Register3
    signal SEL_OEM1_CFG4   :    std_logic;                     -- Select OEM1 Configuration Register4
    signal SEL_OEM1_CFG5_L :    std_logic;                     -- Select OEM1 Configuration Register5 (lower part)
    signal SEL_OEM1_CFG5_H :    std_logic;                     -- Select OEM1 Configuration Register5 (higher part)
    signal SEL_OEM1_CFG6   :    std_logic;                     -- Select OEM1 Configuration Register6
    signal SEL_OEM1_STAT   :    std_logic;                     -- Select OEM1 Status

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


--========================================================================================
-- Component Declaration
--========================================================================================


-- SYNC_PORT with resource decoding
----------------------------------
component SYNC_PORT_DEC
 generic (
          ADR_WIDTH:         integer;
          INVERT_RD_DATA:    integer;
          IMPLEMENT_RDY:     integer;
          OUTRG_SYNC_IF:     integer          -- only predared
         );
    port (
          CLK:               in    std_logic; -- clock
          RESX:              in    std_logic; -- Application Reset (lo activ)

          -- SYNC_PORT
          ---------------------------------------------------------------
          AHB_DEN100:        in    std_logic; -- sync enable between SYNC_PORT clock domain and CLK domain
          PSEL:              in    std_logic; -- port select
          PENABLE:           in    std_logic; -- enables access
          PWRITE:            in    std_logic; -- access mode: 1 -> write, 0 -> read
          DW_ADDR:           in    std_logic; -- marks dword addres boundary PADDR(1:0)="00"
          PADDR:             in    std_logic_vector( ADR_WIDTH-1 downto 2); -- dword address
          PWDATA:            in    std_logic_vector(DATA_WIDTH-1 downto 0); -- write data bus
          PRDATA:            out   std_logic_vector(DATA_WIDTH-1 downto 0); -- read  data bus
          D2MASK:            out   std_logic_vector(DATA_WIDTH-1 downto 0); -- data to mask
          PRDY:              out   std_logic; -- rdy port

          -- application Port
          ---------------------------------------------------------------
          WE:                out   std_logic_vector(FIRST_RES to LAST_RES );       -- write enable
          D_SEND:            in    std_logic_vector(SENDE_WIDTH-1 downto 0);
          D_EMPF1:           in    std_logic_vector(EMPF1_WIDTH-1 downto 0);
          D_EMPF2:           in    std_logic_vector(EMPF2_WIDTH-1 downto 0);
          D_EMPF3:           in    std_logic_vector(EMPF3_WIDTH-1 downto 0);
          D_EMPF4:           in    std_logic_vector(EMPF4_WIDTH-1 downto 0);
          D_EMPF1S:          in    std_logic_vector(EMPF1S_WIDTH-1 downto 0);
          D_EMPF3S:          in    std_logic_vector(EMPF3S_WIDTH-1 downto 0);
          D_KONF1:           in    std_logic_vector(KONF1_WIDTH-1 downto 0);
          D_KONF2:           in    std_logic_vector(KONF2_WIDTH-1 downto 0);
          D_KONF3:           in    std_logic_vector(KONF3_WIDTH-1 downto 0);
          D_KONF4:           in    std_logic_vector(KONF4_WIDTH-1 downto 0);
          D_KONF5:           in    std_logic_vector(KONF5_WIDTH-1 downto 0);
          D_NPV:             in    std_logic_vector(NPV_WIDTH-1 downto 0);
          D_OFFSET2:         in    std_logic_vector(OFFSET2_WIDTH-1 downto 0);
          D_STATUS:          in    std_logic_vector(STATUS_WIDTH-1 downto 0);
          D_S_INT_EN:        in    std_logic_vector(STATUS_WIDTH-1 downto 0);
          D_FEHLER:          in    std_logic_vector(FEHLER_WIDTH-1 downto 0);
          D_F_INT_EN:        in    std_logic_vector(FEHLER_WIDTH-1 downto 0);
          D_DS1:             in    std_logic_vector(DS_WIDTH-1 downto 0);
          D_DS2:             in    std_logic_vector(DS_WIDTH-1 downto 0);
          D_DS3:             in    std_logic_vector(DS_WIDTH-1 downto 0);
          D_DS4:             in    std_logic_vector(DS_WIDTH-1 downto 0);
          D_TEST1:           in    std_logic_vector(TEST1_WIDTH-1 downto 0);
          D_TEST2:           in    std_logic_vector(TEST2_WIDTH-1 downto 0);
          D_TEST3:           in    std_logic_vector(TEST3_WIDTH-1 downto 0);
          D_TEST4:           in    std_logic_vector(TEST4_WIDTH-1 downto 0);

          D_SRM:             in    std_logic_vector(SRM_WIDTH-1 downto 0);
          D_NSRPOS1:         in    std_logic_vector(NSRPOS_WIDTH-1 downto 0);
          D_NSRPOS2:         in    std_logic_vector(NSRPOS_WIDTH-1 downto 0);

          D_MULTIPL:         in    std_logic_vector(MULTIPL_WIDTH-1 downto 0);
          D_SPEED:           in    std_logic_vector(SPEED_WIDTH-1 downto 0);
                                                                                   -- 2007.06
          D_OEM1_CTRL :       in    std_logic_vector(OEM1_CNTRL_WIDTH-1 downto 0);   -- OEM1 Control Register
          D_OEM1_IRQSTAT :    in    std_logic_vector(OEM1_INTSTAT_WIDTH-1 downto 0); -- OEM1 Interrupt Status Register
          D_OEM1_IM :         in    std_logic_vector(OEM1_I_INT_EN_WIDTH-1 downto 0);-- OEM1 Interrupt Mask
          D_OEM1_KONF1 :      in    std_logic_vector(OEM1_KONF1_WIDTH-1 downto 0);   -- OEM1 Configuration Register1
          D_OEM1_KONF2 :      in    std_logic_vector(OEM1_KONF2_WIDTH-1 downto 0);   -- OEM1 Configuration Register2
          D_OEM1_KONF3 :      in    std_logic_vector(OEM1_KONF3_WIDTH-1 downto 0);   -- OEM1 Configuration Register3
          D_OEM1_KONF4 :      in    std_logic_vector(OEM1_KONF4_WIDTH-1 downto 0);   -- OEM1 Configuration Register4
          D_OEM1_KONF5 :      in    std_logic_vector(OEM1_KONF5_WIDTH-1 downto 0);   -- OEM1 Configuration Register5
          D_OEM1_KONF6 :      in    std_logic_vector(OEM1_KONF6_WIDTH-1 downto 0);   -- OEM1 Configuration Register6
          D_OEM1_STORE :      in    std_logic_vector(OEM1_STOR_WIDTH-1  downto 0);   -- OEM1 Store
          D_OEM1_ST :         in    std_logic_vector(OEM1_STURN_WIDTH-1 downto 0);   -- OEM1 Singleturn
          D_OEM1_MT :         in    std_logic_vector(OEM1_MTURN_WIDTH-1 downto 0);   -- OEM1 Multiturn
          D_OEM1_POS2 :       in    std_logic_vector(OEM1_POSI2_WIDTH-1 downto 0);   -- OEM1 Position2
          D_OEM1_SOL :        in    std_logic_vector(OEM1_SOLCT_WIDTH-1 downto 0);   -- OEM1 Sign of Life (Lebenszeichen) 
          D_OEM1_STATUS :     in    std_logic_vector(OEM1_STATUS_WIDTH-1 downto 0);  -- OEM1 Status

          D2APPL:            out   std_logic_vector(DATA_WIDTH-1 downto 0)
         );
end component;


component ENDAT22_INTREG
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
        SEL_OEM1_CFG3   :    in  std_logic;         -- Select OEM1 Configuration Register3
        SEL_OEM1_CFG4   :    in  std_logic;         -- Select OEM1 Configuration Register4
        SEL_OEM1_CFG5_L :    in  std_logic;         -- Select OEM1 Configuration Register5 (lower part)
        SEL_OEM1_CFG5_H :    in  std_logic;         -- Select OEM1 Configuration Register5 (higher part)
        SEL_OEM1_CFG6   :    in  std_logic;         -- Select OEM1 Configuration Register6
        SEL_OEM1_STAT   :    in  std_logic;         -- Select OEM1 Status

        sel_mult_fact   :    in  std_logic;         -- Select Register for multiplier factor

--  Data Stream from the Input Port to the internal registers 
        data_port_to_registers   : in std_logic_vector(31 downto 0); -- Inputs from Port
        write_pulse:         in    std_logic_vector( 3 downto 0); -- Write Pulse for internal Registers

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
        D_OEM1_KONF3 :       out   std_logic_vector(OEM1_KONF3_WIDTH-1 downto 0);   -- OEM1 Configuration Register3
        D_OEM1_KONF4 :       out   std_logic_vector(OEM1_KONF4_WIDTH-1 downto 0);   -- OEM1 Configuration Register4
        D_OEM1_KONF5 :       out   std_logic_vector(OEM1_KONF5_WIDTH-1 downto 0);   -- OEM1 Configuration Register5
        D_OEM1_KONF6 :       out   std_logic_vector(OEM1_KONF6_WIDTH-1 downto 0);   -- OEM1 Configuration Register6
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
        SCIN_WD:             in    std_logic;                     -- input of scan chain of watchdog
        SCOUT_WD:            out   std_logic;                     -- output of scan chain of watchdog

        axis_adr:            in    std_logic_vector( 4 downto 0)  -- Address Line of the encoder axis    
       );
end component;


    
begin


--========================================================================================
-- constant level signals
hi <= '1';
lo <= '0';

--========================================================================================
--========================================================================================
-- parallel uC interface
-------------------------

port_1_2: if (IMPLEMENT_PORTS = 1) generate


   AHB_DEN100_i<= AHB_DEN100;

   PSEL_i      <= PSEL;
   PWRITE_i    <= PWRITE;
   PENABLE_i   <= PENABLE;
   PADDR_i     <= PADDR;
   PWDATA_i    <= PWDATA;
   PRDATA      <= PRDATA_i;
   PRDY        <= PRDY_i;

   PSEL2_i     <= PSEL2;
   PWRITE2_i   <= lo;
   PENABLE2_i  <= PENABLE2;
   PADDR2_i    <= ('0' & PADDR2);
--   PADDR2_wo_off <= PADDR2_i - ADDR_OFFSET;
   PWDATA2_i   <= PWDATA2;
   PRDATA2     <= PRDATA2_i;
   PRDY2       <= PRDY2_i;


UC_IF: if (IMPLEMENT_UC_IF = 1) generate
   PADDR2_wo_off <= PADDR2_i;
end generate;  --IMPLEMENT_UC_IF
NOT_UC_IF: if (IMPLEMENT_UC_IF = 0) generate
   PADDR2_wo_off <= PADDR2_i - ADDR_OFFSET;
end generate;  --IMPLEMENT_UC_IF


-- most significant byte of DSi depends on port implementation
--------------------------------------------------------------
ds_data_map: process (PADDR2_i, PADDR2_ii, ds1_rg, ds2_rg, ds3_rg, ds4_rg)
begin
 ds1_s <= ds1_rg;
 ds2_s <= ds2_rg;
 ds3_s <= ds3_rg;
 ds4_s <= ds4_rg;
 PADDR2_ii <= (others => '0');
 if (IMPLEMENT_UC_IF = 0) then
    PADDR2_ii( 7        downto 0) <= "00000000";
    PADDR2_ii(ADR_WIDTH-1 downto 2) <= PADDR2_i(ADR_WIDTH-1 downto 2);
    ds1_s(31 downto 24) <= PADDR2_ii;
    ds2_s(31 downto 24) <= PADDR2_ii; 
    ds3_s(31 downto 24) <= PADDR2_ii;
    ds4_s(31 downto 24) <= PADDR2_ii;
 end if;
end process;


--========================================================================================
--========================================================================================

-- 1. Port (Main Port)
----------------------
io1: SYNC_PORT_DEC
  generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             INVERT_RD_DATA    => 0,
             IMPLEMENT_RDY     => IMPLEMENT_RDY4APB,
             OUTRG_SYNC_IF     => OUTRG_SYNC_IF
            )
   port map
            (
             CLK               => clk,               -- System Clock
             RESX              => nres_spi1,         -- asynchr. RESET (low active)
             -- SYNC_PORT
             ---------------------------------------------------------------
             AHB_DEN100        => AHB_DEN100_i,
             PSEL              => PSEL_i,
             PENABLE           => PENABLE_i,
             PWRITE            => PWRITE_i,
             DW_ADDR           => write_pulse1(0),
             PADDR             => PADDR_i,
             PWDATA            => PWDATA_i,
             PRDATA            => PRDATA_i,
             D2MASK            => d2mask_s,
             PRDY              => PRDY_i,
             -- application Port
             ---------------------------------------------------------------
             WE                => we_1,
             D_SEND            => tx(SENDE_WIDTH-1 downto 0),
             D_EMPF1           => empf_rg1,
             D_EMPF2           => empf_rg2,
             D_EMPF3           => empf_rg3,
             D_EMPF4           => empf_rg4,
             D_EMPF1S          => empf_rg1s,
             D_EMPF3S          => empf_rg3s,
             D_KONF1           => cfg1,
             D_KONF2           => cfg2,
             D_KONF3           => cfg3(KONF3_WIDTH-1 downto 0),
             D_KONF4           => cfg4,
             D_KONF5           => cfg5,
             D_NPV             => npv_rg,
             D_OFFSET2         => off2,
             D_STATUS          => stat,
             D_S_INT_EN        => im,
             D_FEHLER          => frg,
             D_F_INT_EN        => fim,
             D_DS1             => ds1_rg,
             D_DS2             => ds2_rg,
             D_DS3             => ds3_rg,
             D_DS4             => ds4_rg,
             D_TEST1           => tst1,
             D_TEST2           => tst2,
             D_TEST3           => tst3,
             D_TEST4           => tst4,

             D_SRM             => SRM,
             D_NSRPOS1         => NSRPOS1,
             D_NSRPOS2         => NSRPOS2,

             D_MULTIPL         => mult_fact,
             D_SPEED           => speed,
                                                          -- 2007.06
             D_OEM1_CTRL        => OEM1_CTRL,
             D_OEM1_IRQSTAT     => OEM1_IRQSTAT,
             D_OEM1_IM          => OEM1_IM,
             D_OEM1_KONF1       => OEM1_CFG1,
             D_OEM1_KONF2       => OEM1_CFG2,
             D_OEM1_KONF3       => OEM1_CFG3,
             D_OEM1_KONF4       => OEM1_CFG4,
             D_OEM1_KONF5       => OEM1_CFG5,
             D_OEM1_KONF6       => OEM1_CFG6,
             D_OEM1_STORE       => OEM1_STORE,
             D_OEM1_ST          => OEM1_ST,
             D_OEM1_MT          => OEM1_MT,
             D_OEM1_POS2        => OEM1_POS2,
             D_OEM1_SOL         => OEM1_SOL,
             D_OEM1_STATUS      => OEM1_STAT,

             D2APPL            => data_port_to_registers_1
            );


-- 2. Port (read only)
----------------------

PORT_2: if (IMPLEMENT_PORT_2 = 1) generate

   io2: SYNC_PORT_DEC
     generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             INVERT_RD_DATA    => INVERT_RD_DATA_2,                             -- 2008.02.26 
             IMPLEMENT_RDY     => IMPLEMENT_RDY4APB,
             OUTRG_SYNC_IF     => OUTRG_SYNC_IF
            )
     port map
            (
             CLK               => clk,               -- System Clock
             RESX              => nres,              -- asynchr. RESET (low active)
             -- SYNC_PORT
             ---------------------------------------------------------------
             AHB_DEN100        => AHB_DEN100_i,
             PSEL              => PSEL2_i,
             PENABLE           => PENABLE2_i,
             PWRITE            => PWRITE2_i,
             DW_ADDR           => write_pulse2(0),
             PADDR             => PADDR2_wo_off(PADDR2_wo_off'high-1 downto PADDR2_wo_off'low),
--             PADDR             => PADDR2_i(PADDR2_i'high-1 downto PADDR2_i'low),
             PWDATA            => PWDATA2_i,
             PRDATA            => PRDATA2_i,
             D2MASK            => d2mask_s2,
             PRDY              => PRDY2_i,
             -- application Port
             ---------------------------------------------------------------
             WE                => open,
             D_SEND            => tx(SENDE_WIDTH-1 downto 0),
             D_EMPF1           => empf_rg1,
             D_EMPF2           => empf_rg2,
             D_EMPF3           => empf_rg3,
             D_EMPF4           => empf_rg4,
             D_EMPF1S          => empf_rg1s,
             D_EMPF3S          => empf_rg3s,
             D_KONF1           => cfg1,
             D_KONF2           => cfg2,
             D_KONF3           => cfg3(KONF3_WIDTH-1 downto 0),
             D_KONF4           => cfg4,
             D_KONF5           => cfg5,
             D_NPV             => npv_rg,
             D_OFFSET2         => off2,
             D_STATUS          => stat,
             D_S_INT_EN        => im,
             D_FEHLER          => frg,
             D_F_INT_EN        => fim,
             D_DS1             => ds1_s,
             D_DS2             => ds2_s,
             D_DS3             => ds3_s,
             D_DS4             => ds4_s,
             D_TEST1           => tst1,
             D_TEST2           => tst2,
             D_TEST3           => tst3,
             D_TEST4           => tst4,

             D_SRM             => SRM,
             D_NSRPOS1         => NSRPOS1,
             D_NSRPOS2         => NSRPOS2,

             D_MULTIPL         => mult_fact,
             D_SPEED           => speed,
                                                          -- 2007.06
             D_OEM1_CTRL        => OEM1_CTRL,
             D_OEM1_IRQSTAT     => OEM1_IRQSTAT,
             D_OEM1_IM          => OEM1_IM,
             D_OEM1_KONF1       => OEM1_CFG1,
             D_OEM1_KONF2       => OEM1_CFG2,
             D_OEM1_KONF3       => OEM1_CFG3,
             D_OEM1_KONF4       => OEM1_CFG4,
             D_OEM1_KONF5       => OEM1_CFG5,
             D_OEM1_KONF6       => OEM1_CFG6,
             D_OEM1_STORE       => OEM1_STORE,
             D_OEM1_ST          => OEM1_ST,
             D_OEM1_MT          => OEM1_MT,
             D_OEM1_POS2        => OEM1_POS2,
             D_OEM1_SOL         => OEM1_SOL,
             D_OEM1_STATUS      => OEM1_STAT,

             D2APPL            => open
            );

end generate;   -- IMPLEMENT_PORT_2


end generate;   -- IMPLEMENT_PORTS


NOT_PORT_1_2: if (IMPLEMENT_PORTS = 0) generate
        we_1                      <= (others => '0');
        data_port_to_registers_1  <= (others => '0');
end generate;  -- NOT IMPLEMENT_PORTS


--========================================================================================
--========================================================================================
-- 3. Port
----------

PORT_3: if (IMPLEMENT_PORT_3 = 1) generate

   PSEL3_i     <= PSEL3;
   PWRITE3_i   <= PWRITE3;
   PENABLE3_i  <= PENABLE3;
   PADDR3_i    <= PADDR3;
   PWDATA3_i   <= PWDATA3;
   PRDATA3     <= PRDATA3_i;
   PRDY3       <= PRDY3_i;


    io3: SYNC_PORT_DEC
      generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             INVERT_RD_DATA    => 0,
             IMPLEMENT_RDY     => IMPLEMENT_RDY4APB,
             OUTRG_SYNC_IF     => OUTRG_SYNC_IF
            )
      port map
            (
             CLK               => clk,                -- System Clock
             RESX              => nres_spi3,          -- asynchr. RESET (low active)
             -- SYNC_PORT
             ---------------------------------------------------------------
             AHB_DEN100        => hi,
             PSEL              => PSEL3_i,
             PENABLE           => PENABLE3_i,
             PWRITE            => PWRITE3_i,
             DW_ADDR           => write_pulse3(0),
             PADDR             => PADDR3_i,
             PWDATA            => PWDATA3_i,
             PRDATA            => PRDATA3_i,
             D2MASK            => d2mask_s3,
             PRDY              => PRDY3_i,
             -- application Port
             ---------------------------------------------------------------
             WE                => we_3,
             D_SEND            => tx(SENDE_WIDTH-1 downto 0),
             D_EMPF1           => empf_rg1,
             D_EMPF2           => empf_rg2,
             D_EMPF3           => empf_rg3,
             D_EMPF4           => empf_rg4,
             D_EMPF1S          => empf_rg1s,
             D_EMPF3S          => empf_rg3s,
             D_KONF1           => cfg1,
             D_KONF2           => cfg2,
             D_KONF3           => cfg3(KONF3_WIDTH-1 downto 0),
             D_KONF4           => cfg4,
             D_KONF5           => cfg5,
             D_NPV             => npv_rg,
             D_OFFSET2         => off2,
             D_STATUS          => stat,
             D_S_INT_EN        => im,
             D_FEHLER          => frg,
             D_F_INT_EN        => fim,
             D_DS1             => ds1_rg,
             D_DS2             => ds2_rg,
             D_DS3             => ds3_rg,
             D_DS4             => ds4_rg,
             D_TEST1           => tst1,
             D_TEST2           => tst2,
             D_TEST3           => tst3,
             D_TEST4           => tst4,

             D_SRM             => SRM,
             D_NSRPOS1         => NSRPOS1,
             D_NSRPOS2         => NSRPOS2,
	     
             D_MULTIPL         => mult_fact,
             D_SPEED           => speed,
                                                          -- 2007.06, 2008.01
             D_OEM1_CTRL       => OEM1_CTRL,
             D_OEM1_IRQSTAT    => OEM1_IRQSTAT,
             D_OEM1_IM         => OEM1_IM,
             D_OEM1_KONF1      => OEM1_CFG1,
             D_OEM1_KONF2      => OEM1_CFG2,
             D_OEM1_KONF3      => OEM1_CFG3,
             D_OEM1_KONF4      => OEM1_CFG4,
             D_OEM1_KONF5      => OEM1_CFG5,
             D_OEM1_KONF6      => OEM1_CFG6,
             D_OEM1_STORE      => OEM1_STORE,
             D_OEM1_ST         => OEM1_ST,
             D_OEM1_MT         => OEM1_MT,
             D_OEM1_POS2       => OEM1_POS2,
             D_OEM1_SOL        => OEM1_SOL,
             D_OEM1_STATUS     => OEM1_STAT,

             D2APPL            => data_port_to_registers_3
            );

        we                     <= we_3                     or we_1;
        data_port_to_registers <= data_port_to_registers_3 when (PSEL3_i = '1' or qPSEL3_i = '1') else
	                          data_port_to_registers_1;
        write_pulse            <= write_pulse3            when (PSEL3_i = '1' or qPSEL3_i = '1') else
	                          write_pulse1;

     -- PSEL_SPI delay
     ------------------
      process (nres_spi3, clk)
      begin
        if (nres_spi3 = '0') then 
           qPSEL3_i  <= '0';     
        elsif clk'event and clk='1' then
           qPSEL3_i  <= PSEL3_i;
        end if;
       end process;

end generate;  -- IMPLEMENT_PORT_3


NOT_PORT_3: if (IMPLEMENT_PORT_3 = 0) generate

        we                     <= we_1;
        data_port_to_registers <= data_port_to_registers_1;
        write_pulse            <= write_pulse1;

        PSEL3_i                <= '0';
        qPSEL3_i               <= '0';
        PENABLE3_i             <= '0';
        PWRITE3_i              <= '0';
        PADDR3_i               <= (others => '0');
        PWDATA3_i              <= (others => '0');
        PRDATA3_i              <= (others => '0');
        PRDATA3                <= (others => '0');
        PRDY3_i                <= '1';
        we_3                   <= (others => '0');
        d2mask_s3              <= (others => '0');
        data_port_to_registers_3 <= (others => '0');

end generate;  -- not IMPLEMENT_PORT_3

   
--========================================================================================
--========================================================================================



-- map write enable to former select signals
-----------------------------------------------------------------------------------------
    sel_tx            <= we(SEND);       -- Select Transmission Register
    sel_rx1           <= we(EMPF1);      -- Select Receive Register 1
    sel_rx2           <= we(EMPF2);      -- Select Receive Register 2
    sel_rx3           <= we(EMPF3);      -- Select Receive Register 3
    sel_cfg1          <= we(KONF1);      -- Select Configuration Register 1
    sel_cfg2          <= we(KONF2);      -- Select Configuration Register 2
    sel_cfg3          <= we(KONF3);      -- Select Configuration Register 3
    sel_stat          <= we(STATUS);     -- Select Status Register
    sel_im            <= we(S_INT_EN);   -- Select Interrupt Mask Register
    sel_tst1          <= we(T1);         -- Select Test Register 1
    sel_tst2          <= we(T2);         -- Select Test Register 2

    sel_rx4           <= we(EMPF4);      -- Select Receive Register 4
    sel_ds1           <= we(DS1);        -- Select Data-Save Register 1
    sel_ds2           <= we(DS2);        -- Select Data-Save Register 2
    sel_ds3           <= we(DS3);        -- Select Data-Save Register 3
    sel_cfg4          <= we(KONF4);      -- Select Configuration Register 4
    sel_cfg5          <= we(KONF5);      -- Select Configuration Register 5
    sel_npv           <= we(NPV);        -- Select Register for "Npv"  value
    sel_npvh          <= we(NPV_H);      -- Select Register for "Npv"  value (high part)
    sel_tst3          <= we(T3);         -- Select Test Register3
    sel_off2          <= we(OFFSET2);    -- Select Register for "Off2" value
    sel_off2h         <= we(OFFSET2_H);  -- Select Register for "Off2" value (high part)
    sel_frg           <= we(FEHLER);     -- Select Error/Status Register
    sel_fim           <= we(F_INT_EN);   -- Select Error Interrupt Mask Register

    sel_srm           <= we(SR_M);       -- Select Register for "srM"
    sel_srmh          <= we(SR_M_H);     -- Select Register for "srM" (high)
    sel_nsrpos1       <= we(NSR_POS1);   -- Select Register for "nsrPOS1"
    sel_nsrpos2       <= we(NSR_POS2);   -- Select Register for "nsrPOS2"

    sel_mult_fact     <= we(MULTIPL);    -- Select Register for multiplier factor

    SEL_OEM1_CTRL      <= we(OEM1_CNTRL);   -- Select OEM1 Control Register
    SEL_OEM1_IRQSTAT   <= we(OEM1_INTSTAT); -- Select OEM1 Interrupt Status Register
    SEL_OEM1_IM        <= we(OEM1_I_INT_EN);-- Select OEM1 Interrupt Mask
    SEL_OEM1_CFG1      <= we(OEM1_KONF1);   -- Select OEM1 Configuration Register1
    SEL_OEM1_CFG2      <= we(OEM1_KONF2);   -- Select OEM1 Configuration Register2
    SEL_OEM1_CFG3      <= we(OEM1_KONF3);   -- Select OEM1 Configuration Register3
    SEL_OEM1_CFG4      <= we(OEM1_KONF4);   -- Select OEM1 Configuration Register4
    SEL_OEM1_CFG5_L    <= we(OEM1_KONF5);   -- Select OEM1 Configuration Register5 (lower part)
    SEL_OEM1_CFG5_H    <= we(OEM1_KONF5_H); -- Select OEM1 Configuration Register5 (higher part)
    SEL_OEM1_CFG6      <= we(OEM1_KONF6);   -- Select OEM1 Configuration Register6
    SEL_OEM1_STAT      <= we(OEM1_STATUS);  -- Select OEM1 Status



--========================================================================================
--========================================================================================

   
--========================================================================================
--========================================================================================
U_INTREG:  ENDAT22_INTREG
   generic map(
        IMPLEMENT_MONIT_FUNC   => IMPLEMENT_MONIT_FUNC,
        IMPLEMENT_SPEED_FUNC   => IMPLEMENT_SPEED_FUNC,
        IMPLEMENT_INKR_FUNC    => IMPLEMENT_INKR_FUNC,
        IMPLEMENT_OEM1         => IMPLEMENT_OEM1,         -- Special Function
        IMPLEMENT_OEM2         => IMPLEMENT_OEM2,         -- Special Function
        IMPLEMENT_TCLK_V1      => IMPLEMENT_TCLK_V1,      -- Select V1 or V2 
        IMPLEMENT_TCLK_V2      => IMPLEMENT_TCLK_V2       -- Select V1 or V2
           )
   port map(clk            => clk,
        CLK_WD                 => CLK_WD,                 -- watchdog clock domain 
        nres                   => nres,                   -- Reset for modules
        nreset                 => nreset,                 -- Reset for WD

        CEN_WD_CLK             => CEN_WD_CLK,              -- enable of for CLK_WD

        PSEL2                  => PSEL2_i,                 -- PSEL (SYNC_PORT2,Decoder)
        PENABLE2               => PENABLE2_i,              -- PENABLE (SYNC_PORT2)

-------------------------------------------------------------------------------------------
-- load pulse for registers
-- map write enable to former select signals
-------------------------------------------------------------------------------------------
        sel_tx                 => sel_tx,                  -- Select Transmission Register
        sel_rx1                => sel_rx1,                 -- Select Receive Register 1
        sel_rx2                => sel_rx2,                 -- Select Receive Register 2
        sel_rx3                => sel_rx3,                 -- Select Receive Register 3
        sel_cfg1               => sel_cfg1,                -- Select Configuration Register 1
        sel_cfg2               => sel_cfg2,                -- Select Configuration Register 2
        sel_cfg3               => sel_cfg3,                -- Select Configuration Register 3
        sel_stat               => sel_stat,                -- Select Status Register
        sel_im                 => sel_im,                  -- Select Interrupt Mask Register
        sel_tst1               => sel_tst1,                -- Select Test Register 1
        sel_tst2               => sel_tst2,                -- Select Test Register 2
 
        soft_str               => we(STROBE),              -- Soft Strobe

        sel_rx4                => sel_rx4,                 -- Select Receive Register 4
        sel_cfg4               => sel_cfg4,                -- Select Configuration Register 4
        sel_cfg5               => sel_cfg5,                -- Select Configuration Register 5
        sel_npv                => sel_npv,                 -- Select Register for "Npv"  value (low part)
        sel_npvh               => sel_npvh,                -- Select Register for "Npv"  value (high part)
        sel_tst3               => sel_tst3,                -- Select Test Register3
        sel_off2               => sel_off2,                -- Select Register for "Off2" value (low part)
        sel_off2h              => sel_off2h,               -- Select Register for "Off2" value (high part)
        sel_frg                => sel_frg,                 -- Select Error/Status Register 
        sel_fim                => sel_fim,                 -- Select Error Interrupt Mask Register 

        sel_srm                => sel_srm,                 -- Select Register for "srM" 
        sel_srmh               => sel_srmh,                -- Select Register for "srM" (high) 
        sel_nsrpos1            => sel_nsrpos1,             -- Select Register for "nsrPOS1" 
        sel_nsrpos2            => sel_nsrpos2 ,            -- Select Register for "nsrPOS2"  

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

        sel_mult_fact          => sel_mult_fact,           -- Select Register for multiplier factor

--  Data Stream from the Input Port to the internal registers 
        data_port_to_registers => data_port_to_registers,  -- Inputs from Port
        write_pulse            => write_pulse,             -- Write Pulse for internal Registers

        D_SEND                 => tx(SENDE_WIDTH-1 downto 0),
        D_EMPF1                => empf_rg1,
        D_EMPF2                => empf_rg2,
        D_EMPF3                => empf_rg3,
        D_EMPF4                => empf_rg4,
        D_EMPF1S               => empf_rg1s,
        D_EMPF3S               => empf_rg3s,
        D_KONF1                => cfg1,
        D_KONF2                => cfg2,
        D_KONF3                => cfg3(KONF3_WIDTH-1 downto 0),
        D_KONF4                => cfg4,
        D_KONF5                => cfg5,
        D_NPV                  => npv_rg,
        D_OFFSET2              => off2,
        D_STATUS               => stat,
        D_S_INT_EN             => im,
        D_FEHLER               => frg,
        D_F_INT_EN             => fim,
        D_DS1_RG               => ds1_rg,
        D_DS2_RG               => ds2_rg,
        D_DS3_RG               => ds3_rg,
        D_DS4_RG               => ds4_rg,
        D_TEST1                => tst1,
        D_TEST2                => tst2,
        D_TEST3                => tst3,
        D_TEST4                => tst4,

        D_SRM                  => SRM,
        D_NSRPOS1              => NSRPOS1,
        D_NSRPOS2              => NSRPOS2,

        D_MULTIPL              => mult_fact,
        D_SPEED                => speed,
 
        D_OEM1_CTRL            => OEM1_CTRL,
        D_OEM1_IRQSTAT         => OEM1_IRQSTAT,
        D_OEM1_IM              => OEM1_IM,
        D_OEM1_KONF1           => OEM1_CFG1,
        D_OEM1_KONF2           => OEM1_CFG2,
        D_OEM1_KONF3           => OEM1_CFG3,
        D_OEM1_KONF4           => OEM1_CFG4,
        D_OEM1_KONF5           => OEM1_CFG5,
        D_OEM1_KONF6           => OEM1_CFG6,
        D_OEM1_STORE           => OEM1_STORE,
        D_OEM1_ST              => OEM1_ST,
        D_OEM1_MT              => OEM1_MT,
        D_OEM1_POS2            => OEM1_POS2,
        D_OEM1_SOL             => OEM1_SOL,
        D_OEM1_STATUS          => OEM1_STAT,

        -- Interrupt Request Micro Controller
        n_int1                 => n_int1,                     -- Interrupt Request1 to Micro Controller
        n_int2                 => n_int2,                     -- Interrupt Request2 to Micro Controller
        n_int3                 => n_int3,                     -- Interrupt Request3 to Micro Controller
        n_int1_oem1             => n_int1_oem1,                 -- Interrupt Request OEM1 to Micro Controller
        n_int2_oem1             => n_int2_oem1,                 -- Interrupt Request OEM2 to Micro Controller

        -- Mess System
        data_rc               => data_rc,
        data_dv               => data_dv,
        tclk                  => tclk,
        de                    => de,

        nstr                  => nstr,
        ntimer                => ntimer,

        n_int6                => n_int6,
        n_int7                => n_int7,
        dui                   => dui,
        tst_out_pin           => tst_out_pin,
        n_si                  => n_si,
        -- Recovery Time Flags
        RTM_START_O           => RTM_START_O,
        RTM_STOPP_O           => RTM_STOPP_O,

        --Scan
        scan_mode             => scan_mode,                   -- Reset Umschaltg. fuer Scan Modus
        SCIN_WD               => SCIN_WD,                     -- input of scan chain of watchdog
        SCOUT_WD              => SCOUT_WD,                    -- output of scan chain of watchdog

        axis_adr              => axis_adr  -- Address Line of the encoder axis    
       );


--========================================================================================
--========================================================================================
-- Assignments
--------------------------------------
cfg1_29  <= cfg1(29);


end behav;
