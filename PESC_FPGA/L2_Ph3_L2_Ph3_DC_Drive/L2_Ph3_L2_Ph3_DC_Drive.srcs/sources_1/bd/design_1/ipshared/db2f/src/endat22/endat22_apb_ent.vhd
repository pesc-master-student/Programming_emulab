--****************************************************************************************
--
--                                                          Endat22
--                                                          =======
-- File Name:        $RCSfile
-- Project:          endat22_apb_ent.vhd  
-- Modul Name:       ---
-- Author:           Frank Seiler/ MAZeT GmbH
--                   MAZeT GmbH
--                   Goeschwitzer Strasse 32	
--                   D-07745 Jena
--
-- Specification:    ---
--                                                             
-- Synthesis:        Synoplfy 8.6.2 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
-- 
-- Function:         Endat2.2-Interface for EnDat V2.2 (DR.J.HEIDENHAIN)
--                   Standard with APB-IF (without Safety)
-- 
-- History: F.Seiler 04.12. 2008 Initial Version
--          F.Seiler xx.01. 2009 updated
--          F.Seiler xx.09. 2009 updated
--          F.Seiler 12.10. 2010 OEM1 Aenderungen (n_int1_oem1, n_int2_oem1)
--          FSE      20.01. 2016 RT Erweiterung
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


entity ENDAT22_S is
   port(clk      :           in    std_logic;
        n_rs     :           in    std_logic; 

        AHB_DEN100 :         in    std_logic;                     -- sync enable of APB bus

        -- main read/write APB port
        PSEL     :           in    std_logic;                     -- PSEL (APB,Decoder)
        PENABLE  :           in    std_logic;                     -- PENABLE (APB)
        PWRITE   :           in    std_logic;                     -- PWRITE (APB)
        -- din_from_port
        PWDATA   :           in    std_logic_vector(31 downto 0); -- PWDATA (APB)
        PADDR    :           in    std_logic_vector(31 downto 0); -- PADDR (APB)
        -- Outputs to Port: (data_registers_to_port)
        PRDATA   :           out   std_logic_vector(31 downto 0); -- DATA_OUT  
        PRDY     :           out   std_logic;                     -- READY
        PSLVERR:           out   std_logic := '0';
        -- Interrupt Request Micro Controller
	n_int1 :             out   std_logic; 

        -- Mess System
        data_rc :            in    std_logic;
        data_dv :            out   std_logic;
        tclk :               out   std_logic;
        de :                 out   std_logic;

        nstr :               in    std_logic;
	ntimer :             out   std_logic;

        n_int6, n_int7 :     in    std_logic;
	clk2:                out   std_logic;
	dui    :             out   std_logic;
	tst_out_pin :        out   std_logic;
        n_si   :             out   std_logic;
        -- Recovery Time Flags
        RTM_START_O:         out   std_logic;
        RTM_STOPP_O:         out   std_logic
       );

-- synopsys translate_off
attribute PORT_TYP of ENDAT22_S: ENTITY is "APB";
-- synopsys translate_on

-----------------------------------------------------------------------------------------
-- placeholder port signals -> assure error free compile
-----------------------------------------------------------------------------------------
-- necessary when UC-IF is used
--signal AHB_DEN100 : std_logic;
--signal PSEL       : std_logic;
--signal PENABLE    : std_logic;
--signal PWRITE     : std_logic;
--signal PRDY       : std_logic;
--signal PADDR      : std_logic_vector(ADR_WIDTH-1 downto 2);
--signal PWDATA     : std_logic_vector(DATA_WIDTH-1 downto 0);
--signal PRDATA     : std_logic_vector(DATA_WIDTH-1 downto 0);

-- necessary when UC-IF is not used
signal M16       :  std_logic := '1';
signal N_CS      :  std_logic := '1';
signal N_WR      :  std_logic := '1';
signal N_RD      :  std_logic := '1';
signal N_READY   :  std_logic;
signal A         :  std_logic_vector(ADR_WIDTH-1 downto 0) := "000000";
signal D         :  std_logic_vector(PIF_WIDTH-1 downto 0);

-- necessary when APB-Port2 is not used
signal PSEL2      : std_logic;
signal PENABLE2   : std_logic;
signal PRDY2      : std_logic;
signal PADDR2     : std_logic_vector(ADR_WIDTH downto 2);
signal PRDATA2    : std_logic_vector(DATA_WIDTH-1 downto 0);

-- necessary when UC-IF 2 is not used
signal M16_2     :  std_logic := '1';
signal N_CS_2    :  std_logic := '1';
signal N_RD_2    :  std_logic := '1';
signal N_READY_2 :  std_logic;
signal A_2       :  std_logic_vector(ADR_WIDTH-1 downto 0) := "000000";
signal D_2       :  std_logic_vector(PIF_WIDTH-1 downto 0);

-- necessary when UC-IF 3 is not used
signal M16_3     :  std_logic := '1';

-- necessary when DATA BUS is splitted
--signal D         :  std_logic_vector(PIF_WIDTH-1 downto 0);
--signal D_IN_2    :  std_logic_vector(PIF_WIDTH-1 downto 0);
--signal D_OUT_2   :  std_logic_vector(PIF_WIDTH-1 downto 0);

-- necessary when DATA BUS is not splitted
signal D_IN      :  std_logic_vector(PIF_WIDTH-1 downto 0);
signal D_IN_2    :  std_logic_vector(PIF_WIDTH-1 downto 0);
signal D_OUT     :  std_logic_vector(PIF_WIDTH-1 downto 0);
signal D_OUT_2   :  std_logic_vector(PIF_WIDTH-1 downto 0);


-- necessary when SCAN is not used
signal scan_mode_i: std_logic;                     -- Reset Umschaltg. fuer Scan Modus
signal scin:        std_logic;                     -- Scan Modus
signal scen:        std_logic;                     -- Scan Modus
signal scout:       std_logic;                     -- Scan Modus
signal SCIN_WD:     std_logic;                     -- input of scan chain of watchdog
signal SCOUT_WD:    std_logic;                     -- output of scan chain of watchdog

-- necessary when MOMITOR is not used
signal axis_adr:    std_logic_vector( 4 downto 0); -- Address Line of the encoder axis    
signal n_int2:      std_logic;                     -- Interrupt Request2 to Micro Controller
signal n_int3 :     std_logic;                     -- Interrupt Request3 to Micro Controller 
signal CLK_WD:      std_logic;                     -- Clock signal for Watchdog WD

-- necessary when SPI is not used
signal sck :        std_logic;                       -- SPI colck input
signal n_ss :       std_logic;                       -- Chip Select for SPI
signal mosi :       std_logic;                       -- Serial Data input (from Master)
signal miso :       std_logic;                       -- Serial Data output (to  Master)

-- necessary when SPI2 is not used
signal sck_2 :        std_logic;                       -- SPI colck input
signal n_ss_2 :       std_logic;                       -- Chip Select for SPI
signal mosi_2 :       std_logic;                       -- Serial Data input (from Master)
signal miso_2 :       std_logic;                       -- Serial Data output (to  Master)

-- necessary when SPI3 is not used
signal sck_3 :        std_logic;                       -- SPI colck input
signal n_ss_3 :       std_logic;                       -- Chip Select for SPI
--signal n_ss_id_3 :    std_logic;                       -- Chip Select for ID of SPI
signal mosi_3 :       std_logic;                       -- Serial Data input (from Master)
signal miso_3 :       std_logic;                       -- Serial Data output (to  Master)

-- necessary when OEM1 is not used
signal n_int1_oem1 :  std_logic;                       -- Interrupt Request OEM1 to Micro Controller 
signal n_int2_oem1 :  std_logic;                       -- Interrupt Request OEM1 to Micro Controller 
signal CEN_WD_CLK :   std_logic;                       -- enable of for CLK_WD (No further synchronisation in EnDat Master !!!!!)

-- Constants for generating of the design
constant IMPLEMENT_SCAN:       boolean:= false;
constant SPLIT_DATA_BUS:       integer:= 0;
constant IMPLEMENT_PORTS:      integer:= 1;
constant IMPLEMENT_SPI1:       boolean:= false;        
constant IMPLEMENT_SPI2:       boolean:= false;        
constant IMPLEMENT_UC_IF:      integer:= 0;
constant SYNC_UC_IF_SIGNAL1:   integer:= 1;
constant IMPLEMENT_PORT_2:     integer:= 0;
constant SYNC_UC_IF_SIGNAL2:   integer:= 0;
constant INVERT_RD_DATA_2:     integer:= 1;
constant OUTRG_SYNC_IF:        integer:= 1;
constant IMPLEMENT_PORT_3:     integer:= 0;
constant IMPLEMENT_SPI3:       boolean:= false;
constant IMPLEMENT_SPI4:       boolean:= false;
constant IMPLEMENT_MONIT_FUNC: integer:= 0;
constant IMPLEMENT_SPEED_FUNC: integer:= 0;
constant IMPLEMENT_INKR_FUNC:  integer:= 0;
constant IMPLEMENT_OEM1:       integer:= 0;
constant IMPLEMENT_OEM2:       integer:= 0;
constant IMPLEMENT_TCLK_V1:    integer:= 1;            -- Select V1 or V2 
constant IMPLEMENT_TCLK_V2:    integer:= 0;            -- Select V1 or V2

end ENDAT22_S;
