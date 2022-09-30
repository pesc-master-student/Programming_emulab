--****************************************************************************************
--
--                                                          Endat22_S
--                                                          =========
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
--                   usable for APB, UC, SPI Port 
-- 
-- History: F.Seiler 24.11. 2003 Initial Version
--          F.Seiler 03.12. 2003 asynchr. Address Lines implemented
--          F.Seiler 06.02. 2004 n_int without Tristate
--                               enbl_tclk_start with cfg(0) 
--          F.Seiler 24.09. 2004 added module "control_saf"
--          R.Woyz.. 27.09. 2004 replace old if-module with SYNC_PORT_DEC
--          R.Woyz.. 01.10. 2004 entity isolated from architecture
--          F.Seiler,07.12. 2004 Axis Address: 5 Bit
--          F.Seiler,07.01. 2005 Add RX1-RG-Bit(55:48)
--          F.Seiler 04.05. 2005 new layer (Module) endat22_kernel with endat basic functions
--          F.Seiler 31.05. 2006 Deaktivierung Port1,2
--          F.Seiler xx.11. 2006 Changes   autom_srg_reset, nres_frg
--          F.Seiler,xx.06. 2007 7er cycle, OEM1 functions,
--          F.Seiler,xx.01. 2008 Change OEM1 functions
--          F.Seiler,xx.03. 2008 Divider (New pos1pos2 compare), TST4
--          F.Seiler 28.03. 2008 TCLK pin solution V1, V2
--          F.Seiler 30.07. 2008 Signaleausg. fuer TM Mess.
--          F.Seiler 22.10. 2008 Signal CEN_WD_CLK <= 1
--          F.Seiler 15.12. 2008 RM-Bit+ dstat vorbreitet
--          F.Seiler 08.01. 2009 SPI1,2,3 vorbreitet
--          F.Seiler xx.09. 2009 SPI3 (Reserve) + OEM1-scan_mode_ii korrigiert
--          F.Seiler xx.10. 2010 OEM1 Aenderungen (gemaess VHDL von JH)
--****************************************************************************************
-- Revision history
--
-- $Log
--
-------------------------------------------------------------------------------------------

architecture behav of ENDAT22_S is

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
    signal PSEL2_i        : std_logic;                     -- PSEL (SYNC_PORT2,Decoder)
    signal PENABLE2_i     : std_logic;                     -- PENABLE (SYNC_PORT2)
    signal PWRITE2_i      : std_logic;                     -- PWRITE (SYNC_PORT2)
    signal PRDY2_i        : std_logic;                     -- PRDY (SYNC_PORT IF instance port 2)
    signal PWDATA2_i      : std_logic_vector(31 downto 0); -- PWDATA (SYNC_PORT2)
    signal PADDR2_i       : std_logic_vector(ADR_WIDTH downto 2); -- PADDR (SYNC_PORT2) Note: 1 bit more due to OFFSET
--    signal PADDR2_wo_off  : std_logic_vector(ADR_WIDTH downto 2); -- PADDR (SYNC_PORT2) Note: 1 bit more due to OFFSET
    signal PRDATA2_i      : std_logic_vector(31 downto 0); -- DATA_OUT2 (read data)
    signal PSEL3_i, qPSEL3_i: std_logic;
    signal PENABLE3_i     : std_logic;
    signal PWRITE3_i      : std_logic;
    signal PADDR3_i       : std_logic_vector(ADR_WIDTH-1 downto 2);  -- PADDR (SYNC_PORT for SPI Module)
    signal PWDATA3_i      : std_logic_vector(31 downto 0);           -- PWDATA (SYNC_PORT for SPI Module)
    signal PRDATA3_i      : std_logic_vector(31 downto 0);           -- DATA_OUT (read data for SPI Module)
    signal write_pulse1   : std_logic_vector( 3 downto 0); -- byte_enable of Registers
    signal write_pulse2   : std_logic_vector( 3 downto 0); -- byte enable (similar to write_pulse)
    signal write_pulse3   : std_logic_vector( 3 downto 0);
       
    signal iclk32 :                               std_logic;

    signal cfg1_29, qcfg29, qqcfg29  :            std_logic;  
    signal intn1, intn2, intn3, OEM1_INTN1, OEM1_INTN2:   std_logic;

    signal clock, nres, nres1, nreset, nreset1, nreset2:  std_logic; 
    
--========================================================================================
--========================================================================================

    -- new added internal signals and constants
    -------------------------------------------
    constant IMPLEMENT_RDY4APB: integer:= 1;  --2008.04.03
    constant ADDR_OFFSET:       integer:= 32; -- address offset for 2nd SYNC_PORT = 0x20 dw address's

    -- constant signals
    --------------------------------
    signal hi, lo: std_logic; -- hi, lo driven signals


    -- interface signals between UC_IF and SYNC_PORT_DEC
    ----------------------------------------------
    signal d2mask_s:       std_logic_vector(DATA_WIDTH-1 downto 0); -- for main port
    signal d2mask_s2:      std_logic_vector(DATA_WIDTH-1 downto 0); -- for second port
    signal d2mask_s3:      std_logic_vector(DATA_WIDTH-1 downto 0); -- for main port

--========================================================================================
    signal input_2_srg:    std_logic_vector(29 downto 24); -- additional inputs to status register

--========================================================================================
--  Signals to/from WD
----------------------    
    signal CEN_WD_CLK_i:                 std_logic;                 -- Enable WD 
    signal scan_mode_ii:                 std_logic;                 -- Reset Umschaltg. fuer Scan Modus
    signal scin_i:                       std_logic;                 -- Scan Modus
    signal scen_i:                       std_logic;                 -- Scan Modus
    signal SCIN_WD_i :                   std_logic;                 -- input of scan chain of watchdog

--========================================================================================
--  Signals to/from SPI
-----------------------   
    signal nres_spi1, nres_spi2 :    std_logic;                       -- delayed reset from spi1,2
    signal nres_spi3 :               std_logic;                       -- delayed reset from spi3
    signal miso_1_i, miso_2_i :      std_logic;                       -- internal miso for Syncronization spi1,2
    signal miso_3_i :                std_logic;                       -- internal miso for Syncronization spi3
    signal miso_1_ii, miso_2_ii :    std_logic;                       -- internal miso for (Tristate)     spi1,2
    signal miso_3_ii  :              std_logic;                       -- internal miso for (Tristate)     spi3
    signal noe_miso_1, noe_miso_2 :  std_logic;                       -- enable for miso for (Tristate)   spi1,2
    signal noe_miso_3 :              std_logic;                       -- enable for miso for (Tristate)   spi3
    signal addr_1_i, addr_2_i:       std_logic_vector( 7 downto 0);   -- Address from spi1,2 to uc1,2
    signal addr_3_i:                 std_logic_vector( 7 downto 0);   -- Address from spi3   to uc3
    signal spi_data_port_to_uc_if:   std_logic_vector(15 downto 0);   -- Parallel Input Data zo   internal registers
    signal spi_data_port_from_uc_if: std_logic_vector(PIF_WIDTH-1 downto 0); -- Parallel Input Data from internal registers
    signal N_CS_1_i :                std_logic;                       -- Select pulse for 8/16 bit port1
    signal N_WR_1_i :                std_logic;                       -- Write pulse for 8/16 bit port1
    signal N_RD_1_i :                std_logic;                       -- Read pulse for 8/16 bit port1
    signal M16_1_i  :                std_logic;                       -- M16_1
    signal N_CS_2_i :                std_logic;                       -- Select pulse for 8/16 bit port2
    signal N_RD_2_i :                std_logic;                       -- Read pulse for 8/16 bit port2
    signal M16_2_i  :                std_logic;                       -- M16_2
    signal N_CS_3_i :                std_logic;                       -- Select pulse for 8/16 bit port3
    signal N_WR_3_i :                std_logic;                       -- Write pulse for 8/16 bit port3
    signal N_RD_3_i :                std_logic;                       -- Read pulse for 8/16 bit port3
    signal M16_3_i   :               std_logic;                       -- M16_3
    signal D_IN_i, D_OUT_i:          std_logic_vector(15 downto 0);   -- Parallel Input/Output Data to/from internal registers

--========================================================================================
-- Component Declaration
--========================================================================================

component  spi_if
   port(clk :                     in  std_logic; 
        nres :                    in  std_logic;
        nres_spi_out :            out std_logic;
        m16 :                     in  std_logic;

        sck :                     in  std_logic;                     -- SPI colck input
        n_ss :                    in  std_logic;                     -- Chip Select for SPI

        mosi :                    in  std_logic;                     -- Serial Data input (from Master)
        miso :                    out std_logic;                     -- Serial Data output (to  Master)
        noe_miso :                out std_logic;                     -- output enable for miso

        addr :                    out std_logic_vector( 7 downto 0); 
        data_port_to_uc_if:       out std_logic_vector(15 downto 0); -- Parallel Input Data zo   internal registers
        data_port_from_uc_if:     in  std_logic_vector(15 downto 0); -- Parallel Input Data from internal registers
        
        m16_to_uc_if:             out std_logic;                     -- M16 for UC IF
        n_cs :                    out std_logic;                     -- Select pulse for 8/16 bit port
        n_wr :                    out std_logic;                     -- Write pulse for 8/16 bit port
        n_rd :                    out std_logic);                    -- Read pulse for 8/16 bit port
end component;


component UC_IF
 generic (
          ADR_WIDTH:         integer;
          SPLIT_DATA_BUS:    integer := 0;
          SYNC_PORT_SIGNALS: integer := 0
         );
    port (
          CLK:               in    std_logic; -- clock
          RESX:              in    std_logic; -- Application Reset (lo activ)

          -- UC PORT
          ---------------------------------------------------------------
          M16:               in    std_logic; -- port width: 1 -> 16 bit, 0 -> 8 bit
          CSX:               in    std_logic; -- port select
          RDX:               in    std_logic; -- read  access; lo activ
          WRX:               in    std_logic; -- write access; lo activ
          RDYX:              out   std_logic; -- enables data
          ADDR:              in    std_logic_vector(31 downto 0);  -- resource addresses
          DATA:              inout std_logic_vector(PIF_WIDTH-1 downto 0);  -- bidir. data port
          DATA_IN:           in    std_logic_vector(PIF_WIDTH-1 downto 0);  -- splitted data port (input)
          DATA_OUT:          out   std_logic_vector(PIF_WIDTH-1 downto 0);  -- splitted data port (out)

          -- application Port (SYNC_PORT IF)
          ---------------------------------------------------------------
          PSEL:              out   std_logic; -- port select
          PWRITE:            out   std_logic; -- access mode: 1 -> write, 0 -> read
          PENABLE:           out   std_logic; -- enables access
          PADDR:             out   std_logic_vector(DATA_WIDTH-1 downto 2);  -- inner module address
          PWDATA:            out   std_logic_vector(DATA_WIDTH-1 downto 0); -- write data to appl.
          PRDATA:            in    std_logic_vector(DATA_WIDTH-1 downto 0); -- read  data from appl.
          D2MASK:            in    std_logic_vector(DATA_WIDTH-1 downto 0); -- mask write data
          PSLVERR:           out   std_logic;

          -- application specific control signals
          ---------------------------------------------------------------
          BE:                out   std_logic_vector(3 downto 0) -- byte enable from ADDR(1:0)
         );
end component;


component  ENDAT22_INTAPB
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
        n_int1_oem1:         out   std_logic;                     -- Interrupt Request OEM1 to Micro Controller
        n_int2_oem1:         out   std_logic;                     -- Interrupt Request OEM1 to Micro Controller

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
end component;

    
begin

--========================================================================================
-- constant level signals
hi <= '1';
lo <= '0';

-- VHDL-Place Holder for Pads
-----------------------------

U_CLK :  clock    <= clk;
U_RS  :  nreset   <= n_rs; 	  
U_SYN :  clk2     <= iclk32;	


--========================================================================================
--========================================================================================
-- Clocks and Reset
--=================

-- CLK_32: 2:1 clock divider
----------------------------
   process (nres,clock)
   begin
     if (nres = '0') then 
 	iclk32 <= '0';     
     elsif clock'event and clock='1' then
 	iclk32 <= not iclk32;
     end if;
   end process;


-- Internal RESET delay
-------------------------
   process (nres1,clock)
   begin
     if (nres1 = '0') then 
 	qcfg29  <= '1';     
 	qqcfg29 <= '1';     
     elsif clock'event and clock='1' then
 	qqcfg29 <= qcfg29; 
 	qcfg29  <= not cfg1_29;
     end if;
   end process;
 
 
-- Resetsynchronisation:
-------------------------
   process (clock)
   begin
	 if clock'event and clock='1' then
			nreset1 <= nreset;
			nreset2 <= nreset1;
	 end if;
   end process;

--nres1 <= nreset2 and nreset1 and nreset;
--nres  <= nreset2 and nreset1 and nreset and qqcfg29;

-- neu ensprechend dem Vorschlag von Hrn. Taucher:
nres1 <= nreset2 and nreset1 and nreset              when scan_mode_ii ='0' else nreset;
nres  <= nreset2 and nreset1 and nreset and qqcfg29  when scan_mode_ii ='0' else nreset;

--========================================================================================
--========================================================================================


--========================================================================================
--========================================================================================
-- parallel uC interface
-------------------------

port_1_2: if (IMPLEMENT_PORTS = 1) generate

SPI1: if (IMPLEMENT_SPI1) generate

   -- SPI IF
   ---------
   SPI_1: spi_if
      port map (
        clk                    => clk,                 -- Clock
        nres                   => nres1,               -- Reset
        nres_spi_out           => nres_spi1,
        m16                    => M16,                  -- M16

        sck                    => sck,                 -- SPI colck input
        n_ss                   => n_ss,                -- Chip Select for SPI

        mosi                   => mosi,                -- Serial Data input (from Master)
        miso                   => miso_1_i,            -- Serial Data output (to  Master)
        noe_miso               => noe_miso_1,          -- output enable for miso

        addr                   => addr_1_i,            -- Address
        data_port_to_uc_if     => D_IN_i,              -- Parallel Input Data zo   internal registers
        data_port_from_uc_if   => D_OUT_i,             -- Parallel Input Data from internal registers
        
        m16_to_uc_if           => M16_1_i,            -- M16 for UC IF
        n_cs                   => N_CS_1_i,            -- Select pulse for 8/16 bit port
        n_wr                   => N_WR_1_i,           -- Write pulse for 8/16 bit port
        n_rd                   => N_RD_1_i);          -- Read pulse for 8/16 bit port


   -- Enable to SCK
   -------------------
      process (nres1, clock)
      begin
        if nres1 = '0' then
           miso_1_ii  <= '0';
        elsif clock'event and clock ='1' then
           if sck = '1'  then
              miso_1_ii  <= miso_1_i;
           end if;
        end if;
       end process;

miso  <= miso_1_ii when noe_miso_1 = '0' else 'Z';

end generate;  -- IMPLEMENT_SPI1


NOT_SPI1: if (not IMPLEMENT_SPI1) generate

        M16_1_i                         <= M16;
        N_CS_1_i                        <= N_CS;
        N_WR_1_i                        <= N_WR;
        N_RD_1_i                        <= N_RD;
        addr_1_i(ADR_WIDTH-1 downto 0)  <= A;
        D_IN_i                          <= D_IN;
        D_OUT                           <= D_OUT_i;
        nres_spi1                       <= nres;
        miso_1_i                        <= '0';
        miso_1_ii                       <= '0';
        noe_miso_1                      <= '0';

end generate;  -- not IMPLEMENT_SPI1



port_uc: if (IMPLEMENT_UC_IF = 1) generate

   AHB_DEN100_i  <= '1'; -- AEN_DEN100_i  not needed

   -- main read/write port
   ------------------------
   io_port: UC_IF
     generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             SPLIT_DATA_BUS    => SPLIT_DATA_BUS,
             SYNC_PORT_SIGNALS => SYNC_UC_IF_SIGNAL1
            )
     port map
            (
             CLK               => clock,             -- System Clock
             RESX              => nres_spi1,         -- asynchr. RESET (low active)
  
             -- UC PORT
             ---------------------------------------------------------------
             M16               => M16_1_i,
             CSX               => N_CS_1_i,
             RDX               => N_RD_1_i,
             WRX               => N_WR_1_i,
             RDYX              => N_READY,
             ADDR              => addr_1_i(ADR_WIDTH-1 downto 0),
             DATA              => D,
             DATA_IN           => D_IN_i,
             DATA_OUT          => D_OUT_i,
  
             -- application Port (SYNC_PORT IF)
             ---------------------------------------------------------------
             PSEL              => PSEL_i,
             PWRITE            => PWRITE_i,
             PENABLE           => PENABLE_i,
             PADDR             => PADDR_i,
             PWDATA            => PWDATA_i,
             PRDATA            => PRDATA_i,
             D2MASK            => d2mask_s,
             PSLVERR           => PSLVERR,
             -- application specific control signals
             ---------------------------------------------------------------
             BE                => write_pulse1
            );


   -- second read only port
   ------------------------

SPI2: if (IMPLEMENT_SPI2) generate

   -- SPI IF
   ---------
   SPI_2: spi_if
      port map (
        clk                    => clk,                 -- Clock
        nres                   => nres1,               -- Reset
        nres_spi_out           => nres_spi2,
        m16                    => M16_2,               -- M16

        sck                    => sck_2,               -- SPI colck input
        n_ss                   => n_ss_2,              -- Chip Select for SPI

        mosi                   => mosi_2,              -- Serial Data input (from Master)
        miso                   => miso_2_i,            -- Serial Data output (to  Master)
        noe_miso               => noe_miso_2,          -- output enable for miso

        addr                   => addr_2_i,            -- Address
        data_port_to_uc_if     => D_IN_2,              -- Parallel Input Data zo   internal registers
        data_port_from_uc_if   => D_OUT_2,             -- Parallel Input Data from internal registers
        
        m16_to_uc_if           => M16_2_i,             -- M16 for UC IF
        n_cs                   => N_CS_2_i,            -- Select pulse for 8/16 bit port
        n_wr                   => open,                -- Write pulse for 8/16 bit port
        n_rd                   => N_RD_2_i);           -- Read pulse for 8/16 bit port


   -- Enable to SCK
   -------------------
      process (nres1, clock)
      begin
        if nres1 = '0' then
           miso_2_ii  <= '0';
        elsif clock'event and clock='1' then
           if sck_2 = '0' then
              miso_2_ii  <= miso_2_i;
           end if;
        end if;
       end process;

miso_2  <= miso_2_ii when noe_miso_2 = '0' else 'Z';

end generate;  -- IMPLEMENT_SPI2


PORT_2a: if (IMPLEMENT_PORT_2 = 1) generate

   io_port2: UC_IF
     generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             SPLIT_DATA_BUS    => SPLIT_DATA_BUS,
             SYNC_PORT_SIGNALS => SYNC_UC_IF_SIGNAL2
            )
     port map
            (
             CLK               => clock,             -- System Clock
             RESX              => nres_spi2,         -- asynchr. RESET (low active)

             -- UC PORT
             ---------------------------------------------------------------
             M16               => M16_2_i,
             CSX               => N_CS_2_i,
             RDX               => N_RD_2_i,
             WRX               => hi,
             RDYX              => N_READY_2,
             ADDR              => addr_2_i(ADR_WIDTH-1 downto 0),
             DATA              => D_2,
             DATA_IN           => D_IN_2,
             DATA_OUT          => D_OUT_2,

             -- application Port (SYNC_PORT IF)
             ---------------------------------------------------------------
             PSEL              => PSEL2_i,
             PWRITE            => PWRITE2_i,
             PENABLE           => PENABLE2_i,
--             PADDR             => PADDR2_wo_off(PADDR2_wo_off'high-1 downto PADDR2_wo_off'low),
             PADDR             => PADDR2_i(PADDR2_i'high-1 downto PADDR2_i'low),
             PWDATA            => PWDATA2_i,
             PRDATA            => PRDATA2_i,
             D2MASK            => d2mask_s2,

             -- application specific control signals
             ---------------------------------------------------------------
             BE                => write_pulse2
            );

end generate;  -- IMPLEMENT_PORT_2


NOT_SPLIT: if (SPLIT_DATA_BUS = 0) generate

    U_INT1 : n_int1   <= '0' when intn1='0' else 'Z';
    U_INT2 : n_int2   <= '0' when intn2='0' else 'Z';
    U_INT3 : n_int3   <= '0' when intn3='0' else 'Z';
    U_INT1_OEM1 : n_int1_oem1   <= '0' when OEM1_INTN1='0' else 'Z';
    U_INT2_OEM1 : n_int2_oem1   <= '0' when OEM1_INTN2='0' else 'Z';

end generate;  -- not SPLIT_DATA_BUS

SPLIT:     if (SPLIT_DATA_BUS = 1) generate

    U_INT1 : n_int1   <= intn1;
    U_INT2 : n_int2   <= intn2;
    U_INT3 : n_int3   <= intn3;
    U_INT1_OEM1 : n_int1_oem1   <= OEM1_INTN1;
    U_INT2_OEM1 : n_int2_oem1   <= OEM1_INTN2;

end generate;  -- SPLIT_DATA_BUS

end generate;  -- IMPLEMENT_UC_IF



-- parallel SYNC_PORT interface
-------------------------------
-- Note: due to dword access no byte or word enable decoding necessary
--       all bytes enabled always -> write_pulse(3:0)<="1111"

port_abp: if (IMPLEMENT_UC_IF = 0) generate
   AHB_DEN100_i<= AHB_DEN100;

   write_pulse1 <= (others => '1'); -- if SYNC_PORTs only
   PSEL_i       <= PSEL;
   PWRITE_i     <= PWRITE;
   PENABLE_i    <= PENABLE;
   PADDR_i      <= PADDR(5 downto 2);
   PWDATA_i     <= PWDATA;
   PRDATA       <= PRDATA_i;
   PRDY         <= PRDY_i;

   write_pulse2 <= (others => '1'); -- if SYNC_PORTs only
   PSEL2_i      <= PSEL2;
   PWRITE2_i    <= lo;
   PENABLE2_i   <= PENABLE2;
   PADDR2_i     <= PADDR2;
--   PADDR2_wo_off <= PADDR2_i - ADDR_OFFSET;
   PWDATA2_i    <= (others => '1');
   PRDATA2      <= PRDATA2_i;
   PRDY2        <= PRDY2_i;

U_INT1 : n_int1   <= intn1;
U_INT2 : n_int2   <= intn2;
U_INT3 : n_int3   <= intn3;
U_INT1_OEM1 : n_int1_oem1   <= OEM1_INTN1;
U_INT2_OEM1 : n_int2_oem1   <= OEM1_INTN2;

end generate;  -- not IMPLEMENT_UC_IF

end generate;   -- IMPLEMENT_PORTS

NOT_SPI2: if (not IMPLEMENT_SPI2) generate

        M16_2_i                         <= M16_2;
        N_CS_2_i                        <= N_CS_2;
        N_RD_2_i                        <= N_RD_2;
        addr_2_i(ADR_WIDTH-1 downto 0)  <= A_2;
        nres_spi2                       <= nres;
        miso_2_i                        <= '0';
        miso_2_ii                       <= '0';
        noe_miso_2                      <= '0';

end generate;  -- not IMPLEMENT_SPI2



--========================================================================================
--========================================================================================
-- SPI3
--=======================

SPI_3: if (IMPLEMENT_SPI3) generate

   -- SPI IF
   ---------
   SPI3: spi_if
      port map (
        clk                    => clk,                 -- Clock
        nres                   => nres1,               -- Reset
        nres_spi_out           => nres_spi3,
        m16                    => M16_3,               -- M16

        sck                    => sck_3,               -- SPI colck input
        n_ss                   => n_ss_3,              -- Chip Select for SPI

        mosi                   => mosi_3,              -- Serial Data input (from Master)
        miso                   => miso_3_i,            -- Serial Data output (to  Master)
        noe_miso               => noe_miso_3,          -- output enable for miso

        addr                   => addr_3_i,           -- Address
        data_port_to_uc_if     => spi_data_port_to_uc_if,   -- Parallel Input Data zo   internal registers
        data_port_from_uc_if   => spi_data_port_from_uc_if(15 downto 0), -- Parallel Input Data from internal registers
        
        m16_to_uc_if           => M16_3_i,            -- M16 for UC IF
        n_cs                   => N_CS_3_i,           -- Select pulse for 8/16 bit port
        n_wr                   => N_WR_3_i,           -- Write pulse for 8/16 bit port
        n_rd                   => N_RD_3_i);          -- Read pulse for 8/16 bit port

   -- Enable to SCK
   -------------------
      process (nres1, clock)
      begin
        if nres1 = '0' then
           miso_3_ii  <= '0';
        elsif clock'event and clock='1' then
           if sck_3 = '0' then
              miso_3_ii  <= miso_3_i;
           end if;
        end if;
       end process;

miso  <= miso_3_ii when noe_miso_3 = '0' else 'Z';


   -- SPI needs it's own main read/write port (8/16)
   -------------------------------------------------
   io_port_spi: UC_IF
     generic map
            (
             ADR_WIDTH         => ADR_WIDTH,
             SPLIT_DATA_BUS    => 1,
             SYNC_PORT_SIGNALS => 0
            )
     port map
            (
             CLK               => clock,             -- System Clock
             RESX              => nres_spi3,          -- asynchr. RESET (low active)
  
             -- UC PORT
             ---------------------------------------------------------------
             M16               => M16_3_i,
             CSX               => N_CS_3_i,
             RDX               => N_RD_3_i,
             WRX               => N_WR_3_i,
             RDYX              => open,
             ADDR              => addr_3_i(ADR_WIDTH-1 downto 0),
             DATA              => open,
             DATA_IN           => spi_data_port_to_uc_if,
             DATA_OUT          => spi_data_port_from_uc_if,
  
             -- application Port (SYNC_PORT IF)
             ---------------------------------------------------------------
             PSEL              => PSEL3_i,
             PWRITE            => PWRITE3_i,
             PENABLE           => PENABLE3_i,
             PADDR             => PADDR3_i,
             PWDATA            => PWDATA3_i,
             PRDATA            => PRDATA3_i,
             D2MASK            => d2mask_s3,
  
             -- application specific control signals
             ---------------------------------------------------------------
             BE                => write_pulse3
            );


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


end generate;  -- IMPLEMENT_SPI3


NOT_SPI3: if (not IMPLEMENT_SPI3) generate

        addr_3_i               <= (others => '0');
        spi_data_port_to_uc_if <= (others => '0');

        nres_spi3              <= '0';
        PSEL3_i                <= '0';
        qPSEL3_i               <= '0';
        PENABLE3_i             <= '0';
        PWRITE3_i              <= '0';
        M16_3_i                <= '0';
        N_CS_3_i               <= '0';
        N_RD_3_i               <= '0';
        N_WR_3_i               <= '0';
        PADDR3_i               <= (others => '0');
        PWDATA3_i              <= (others => '0');
--        PRDATA3_i              <= (others => '0');
        write_pulse3           <= (others => '0');
--        d2mask_s3           <= (others => '0');
        spi_data_port_from_uc_if   <= (others => '0');

        miso_3_i               <= '0';
        miso_3_ii              <= '0';
        noe_miso_3             <= '0';

end generate;  -- not IMPLEMENT_SPI3


--========================================================================================
--========================================================================================

-- EnDat Master
---------------
U_INTAPB: ENDAT22_INTAPB
  generic map
            (
             ADR_WIDTH              => ADR_WIDTH,
             IMPLEMENT_PORTS        => IMPLEMENT_PORTS,
             IMPLEMENT_UC_IF        => IMPLEMENT_UC_IF,
             IMPLEMENT_PORT_2       => IMPLEMENT_PORT_2,
             INVERT_RD_DATA_2       => INVERT_RD_DATA_2,
             OUTRG_SYNC_IF          => OUTRG_SYNC_IF,
             IMPLEMENT_PORT_3       => IMPLEMENT_PORT_3,
             IMPLEMENT_MONIT_FUNC   => IMPLEMENT_MONIT_FUNC,
             IMPLEMENT_SPEED_FUNC   => IMPLEMENT_SPEED_FUNC,
             IMPLEMENT_INKR_FUNC    => IMPLEMENT_INKR_FUNC,
             IMPLEMENT_OEM1         => IMPLEMENT_OEM1,        -- Special Function
             IMPLEMENT_OEM2         => IMPLEMENT_OEM2,        -- Special Function
             IMPLEMENT_TCLK_V1      => IMPLEMENT_TCLK_V1,     -- Select V1 or V2 
             IMPLEMENT_TCLK_V2      => IMPLEMENT_TCLK_V2      -- Select V1 or V2
            )
   port map
            (
             CLK                    => clock,                 -- System Clock
             CLK_WD                 => CLK_WD,                -- Watch Dog Clock
             nres                   => nres,                  -- asynchr. Reset for modules
             nreset                 => nreset,                -- asynchr. Reset for WD
             nres_spi1              => nres_spi1,             -- Delayed Reset from SPI
             nres_spi3              => nres_spi3,             -- Delayed Reset from SPI
             cfg1_29                => cfg1_29,               -- SW-Reset

             write_pulse1           => write_pulse1,
             write_pulse2           => write_pulse2,
             write_pulse3           => write_pulse3,
             ---------------------------------------------------------------
             -- SYNC_PORT
             AHB_DEN100             => AHB_DEN100_i,
             CEN_WD_CLK             => CEN_WD_CLK_i,      -- enable of for CLK_WD (No further synchronisation in EnDat Master !!!!!)

             PSEL                   => PSEL_i,
             PENABLE                => PENABLE_i,
             PWRITE                 => PWRITE_i,
             PWDATA                 => PWDATA_i,
             PADDR(5 downto 2)      => PADDR_i, -- 19.12.2021 TSHaugan
             --PADDR      => PADDR_i, -- 19.12.2021 TSHaugan
             PRDATA                 => PRDATA_i,
             PRDY                   => PRDY_i,
             D2MASK_S               => d2mask_s,

             PSEL2                  => PSEL2_i,
             PENABLE2               => PENABLE2_i,
--             PADDR2                 => PADDR2_wo_off(PADDR2_wo_off'high-1 downto PADDR2_wo_off'low),
             PWDATA2                => PWDATA2_i,
             PADDR2                 => PADDR2_i(PADDR2_i'high-1 downto PADDR2_i'low),
             PRDATA2                => PRDATA2_i,
             PRDY2                  => PRDY2_i,
             D2MASK_S2              => d2mask_s2,

             PSEL3                  => PSEL3_i,
             PENABLE3               => PENABLE3_i,
             PWRITE3                => PWRITE3_i,
             PWDATA3                => PWDATA3_i,
             PADDR3                 => PADDR3_i,
             PRDATA3                => PRDATA3_i,
             PRDY3                  => open,
             D2MASK_S3              => d2mask_s3,

             -- Interrupt Request Micro Controller
             n_int1                 => intn1,                  -- Interrupt Request1 to Micro Controller
             n_int2                 => intn2,                  -- Interrupt Request2 to Micro Controller
             n_int3                 => intn3,                  -- Interrupt Request3 to Micro Controller
             n_int1_oem1            => OEM1_INTN1,             -- Interrupt Request OEM1 to Micro Controller
             n_int2_oem1            => OEM1_INTN2,             -- Interrupt Request OEM1 to Micro Controller

             -- Mess System
             data_rc                => data_rc,
             data_dv                => data_dv,
             tclk                   => tclk,
             de                     => de,

             nstr                   => nstr,
             ntimer                 => ntimer,

             n_int6                 => n_int6,
             n_int7                 => n_int7,
             dui                    => dui,
             tst_out_pin            => tst_out_pin,
             n_si                   => n_si,
             -- Recovery Time Flags
             RTM_START_O            => RTM_START_O,
             RTM_STOPP_O            => RTM_STOPP_O,

             --Scan
             scan_mode              => scan_mode_ii,           -- Reset Umschaltg. fuer Scan Modus
--             scin                   => scin_i,                 -- Scan Modus
--             scen                   => scen_i,                 -- Scan Modus
--             scout                  => scout,                  -- Scan Modus
             SCIN_WD                => SCIN_WD_i,              -- input of scan chain of watchdog
             SCOUT_WD               => SCOUT_WD,               -- output of scan chain of watchdog

             axis_adr               => axis_adr                -- Address Line of the encoder axis    
             );
   
--========================================================================================
--========================================================================================

G_OEM1: if (IMPLEMENT_OEM1 = 1) generate
          CEN_WD_CLK_i     <= CEN_WD_CLK;       -- enable of for CLK_WD (only OEM function)
end generate;  -- IMPLEMENT_OEM1
GN_OEM1: if (IMPLEMENT_OEM1 = 0) generate
          CEN_WD_CLK_i     <= '1';              -- enable of for CLK_WD (only OEM function)
end generate;  -- not IMPLEMENT_OEM1

--========================================================================================
--========================================================================================

SCAN: if (IMPLEMENT_SCAN) generate

       scan_mode_ii       <= scan_mode_i;      -- Reset Umschaltg. fuer Scan Modus
       scin_i             <= scin;             -- Scan Modus
       scen_i             <= scen;             -- Scan Modus

       SCIN_WD_i          <= SCIN_WD;          -- input of scan chain of watchdog

end generate;  -- IMPLEMENT_SCAN

NOT_SCAN: if (not IMPLEMENT_SCAN) generate

       scan_mode_ii       <= '0';              -- Reset Umschaltg. fuer Scan Modus
       scin_i             <= '0';              -- Scan Modus
       scen_i             <= '0';              -- Scan Modus

       SCIN_WD_i          <= '0';              -- input of scan chain of watchdog

end generate;  -- not IMPLEMENT_SCAN


--========================================================================================
--========================================================================================

-- Assignments
--------------------------------------
input_2_srg(28 downto 24) <= (others => '0');

end behav;


