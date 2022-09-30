-- MAZeT. All rights reserved. This document and all informations        --
-- contained therein is considered confidential and proprietary of MAZeT.--
---------------------------------------------------------------------------
--                                                                       --
-- File:          $RCSfile
--                                                                       --
-- Project:       END_SAFE                                               --
--                                                                       --
-- Modul / Unit:  SYNC_PORT_DEC                                          --
--                (entity and architect.)                                --
--                                                                       --
-- Function:      address decode and build of write-/read-               --
--                and output enables for address space of                --
--                the ENDAT Kernel                                       --
--                with SYN_PORT interface                                --
--                                                                       --
-- Author:        R. Woyzichovski                                        --
--                MAZeT GmbH                                             --
--                Goeschwitzer Strasse 32                                --
--                D-07745 Jena                                           --
--                                                                       --
--                                                                       --
-- Synthesis:     Synplify 9.6.1
--                              
-- Script:        ENDAT22.prj
--                               
-- Simulation:    Cadence NCVHDL V8.21
---------------------------------------------------------------------------
-- Revision history
-- History:       F.Seiler 15.06.2005 Register MULTIPL, SPEED, SPEED_H 
--                F.Seiler xx.06.2007 OEM1 Registers
--                F.Seiler xx.01.2008 OEM1 Store
--                F.Seiler 02-03.2008 D_SRM, D_NSRPOS1, D_NSRPOS2, TST4
--                F.Seiler 08.01.2009 OUTRG_SYNC_IF vorbreitet
--                F.Seiler XX.03.2009 KONF5, EMPF1S, EMPF3S, DS4
--                F.Seiler 13.10.2010 OEM1_KONF3...6
---------------------------------------------------------------------------

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.conv_integer;
use endat22.resource_pkg.all;

entity SYNC_PORT_DEC is
 generic (
          ADR_WIDTH:         integer:=endat22.resource_pkg.ADR_WIDTH; -- recently = 7
          INVERT_RD_DATA:    integer:=0;         -- 0 read data non inverted, else inverted
          IMPLEMENT_RDY:     integer:=1;         -- in case of slow read mux (> 1cc)
                                                 -- IMPLEMENT_RDY = 1 inserts
                                                 -- 1 cc propagation time and rdy logic
                                                 -- additionaly 
          OUTRG_SYNC_IF:     integer:=1          -- only predared
         );
    port (
          CLK:               in    std_logic; -- clock 
          RESX:              in    std_logic; -- Application Reset (lo activ)

          -- SYNC_PORT
          ---------------------------------------------------------------
          AHB_DEN100:        in    std_logic; -- sync enable between SYNC_PORT clock and CLK
          PSEL:              in    std_logic; -- port select
          PENABLE:           in    std_logic; -- enables access
          PWRITE:            in    std_logic; -- access mode: 1 -> write, 0 -> read 
          DW_ADDR:           in    std_logic; -- marks dword address boundary PADDR(1:0)="00"
          PADDR:             in    std_logic_vector(ADR_WIDTH-1 downto 2);  -- dw address 
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
          D_OEM1_CTRL :      in    std_logic_vector(OEM1_CNTRL_WIDTH-1 downto 0);    -- OEM1 Control Register
          D_OEM1_IRQSTAT :   in    std_logic_vector(OEM1_INTSTAT_WIDTH-1 downto 0);  -- OEM1 Interrupt Status Register
          D_OEM1_IM :        in    std_logic_vector(OEM1_I_INT_EN_WIDTH-1 downto 0); -- OEM1 Interrupt Mask
          D_OEM1_KONF1 :     in    std_logic_vector(OEM1_KONF1_WIDTH-1 downto 0);    -- OEM1 Configuration Register1
          D_OEM1_KONF2 :     in    std_logic_vector(OEM1_KONF2_WIDTH-1 downto 0);    -- OEM1 Configuration Register2
          D_OEM1_KONF3 :     in    std_logic_vector(OEM1_KONF3_WIDTH-1 downto 0);    -- OEM1 Configuration Register3
          D_OEM1_KONF4 :     in    std_logic_vector(OEM1_KONF4_WIDTH-1 downto 0);    -- OEM1 Configuration Register4
          D_OEM1_KONF5 :     in    std_logic_vector(OEM1_KONF5_WIDTH-1 downto 0);    -- OEM1 Configuration Register5
          D_OEM1_KONF6 :     in    std_logic_vector(OEM1_KONF6_WIDTH-1 downto 0);    -- OEM1 Configuration Register6
          D_OEM1_STORE :     in    std_logic_vector(OEM1_STOR_WIDTH-1 downto 0);     -- OEM1 TM time Register
          D_OEM1_ST :        in    std_logic_vector(OEM1_STURN_WIDTH-1 downto 0);    -- OEM1 Singleturn
          D_OEM1_MT :        in    std_logic_vector(OEM1_MTURN_WIDTH-1 downto 0);    -- OEM1 Multiturn
          D_OEM1_POS2 :      in    std_logic_vector(OEM1_POSI2_WIDTH-1 downto 0);    -- OEM1 Position2
          D_OEM1_SOL :       in    std_logic_vector(OEM1_SOLCT_WIDTH-1 downto 0);    -- OEM1 Sign of Life (Lebenszeichen) 
          D_OEM1_STATUS :    in    std_logic_vector(OEM1_STATUS_WIDTH-1 downto 0);   -- OEM1 Status

          D2APPL:            out   std_logic_vector(DATA_WIDTH-1 downto 0)
         );
end SYNC_PORT_DEC;


architecture RTL of SYNC_PORT_DEC is

  -----------------------------------------------------------------------------
  -- type declaration
  -----------------------------------------------------------------------------
  -- array types to support output mux implementation
  subtype slv64 is std_logic_vector(2*DATA_WIDTH-1 downto 0); 
  type s_array is array(integer range <>) of slv64;

  -----------------------------------------------------------------------------
  -- definition of resource addresses -> package resource_pkg
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- signal declaration
  -----------------------------------------------------------------------------
  -- combinatorical signals
  -------------------------
  signal rd_data_s:      slv64;   -- output of read mux
  signal adr_i:          integer; -- internal representation of dword address

  -- register ressources
  -------------------------
  signal rd_data_r:      slv64; -- read buffer
  signal dvld:           std_logic; -- registered copy of PSEL or PENABLE
                                    -- IPLEMENT_RDY = true:  dvld <= PENABLE
                                    -- IPLEMENT_RDY = false: dvld <= PSEL
                                    -- if dvld = '1' then read data valid

  -- workaround: wr_mask_copy a copy of constant wr_mask @ resource_pkg due to
  -- NCVHDL could'nt deal with constants at sensitivity list, but
  -- FPGA Compiler II Version: 2002.05-FC3.7, Build: 3.7.1.7701  fails without
  -- wr_mask @ sensitivity list (Synplify doesn't need wr_mask @ sensitivity list)
  signal wr_mask_copy:  r_array(resource_addr'range);

begin

-- internal representation of dword address
-----------------------------------------------------------------------------
adr_i <= conv_integer(PADDR);

--***************************************************************************
-- READ
--***************************************************************************

-- read multiplexer 
-----------------------------------------------------------------------------
read_mux: process (adr_i, rd_data_r, DW_ADDR,
                   D_SEND, D_EMPF1, D_EMPF2, D_EMPF3, D_EMPF4, D_EMPF1S, D_EMPF3S, D_KONF1, D_KONF2,
                   D_KONF3, D_KONF4, D_KONF5, D_NPV, D_OFFSET2, D_STATUS, D_S_INT_EN,
                   D_FEHLER, D_F_INT_EN, D_DS1, D_DS2, D_DS3, D_DS4, D_TEST1, D_TEST2, D_TEST3, D_TEST4,
                   D_SRM, D_NSRPOS1, D_NSRPOS2, D_MULTIPL, D_SPEED,                      -- 2008.02
                   D_OEM1_CTRL, D_OEM1_IRQSTAT, D_OEM1_IM, D_OEM1_KONF1, D_OEM1_KONF2,   -- 2007.06
                   D_OEM1_KONF3, D_OEM1_KONF4, D_OEM1_KONF5, D_OEM1_KONF6,
                   D_OEM1_STORE, D_OEM1_ST, D_OEM1_MT, D_OEM1_POS2, D_OEM1_SOL, D_OEM1_STATUS)
variable rd_mux_v:  s_array(resource_addr'range);
variable rd_data_v: std_logic_vector(rd_data_r'range);
begin
   rd_mux_v := (others=> (others=>'0'));
   rd_mux_v(SEND)(D_SEND'range)                      := D_SEND;
   rd_mux_v(EMPF1)(D_EMPF1'range)                    := D_EMPF1;
   rd_mux_v(EMPF2)(D_EMPF2'range)                    := D_EMPF2;
   rd_mux_v(EMPF3)(D_EMPF3'range)                    := D_EMPF3;
   rd_mux_v(EMPF4)(D_EMPF4'range)                    := D_EMPF4;
   rd_mux_v(EMPF1S)(D_EMPF1S'range)                  := D_EMPF1S;
   rd_mux_v(EMPF3S)(D_EMPF3S'range)                  := D_EMPF3S;
   rd_mux_v(KONF1)(D_KONF1'range)                    := D_KONF1;
   rd_mux_v(KONF2)(D_KONF2'range)                    := D_KONF2;
   rd_mux_v(KONF3)(D_KONF3'range)                    := D_KONF3;
   rd_mux_v(KONF4)(D_KONF4'range)                    := D_KONF4;
   rd_mux_v(KONF5)(D_KONF5'range)                    := D_KONF5;
   rd_mux_v(NPV)(DATA_WIDTH-1 downto 0)              := D_NPV(DATA_WIDTH-1 downto 0);
   rd_mux_v(NPV_H)(D_NPV'high-DATA_WIDTH downto 0)   := D_NPV(D_NPV'high downto DATA_WIDTH);
   rd_mux_v(OFFSET2)(DATA_WIDTH-1 downto 0)          := D_OFFSET2(DATA_WIDTH-1 downto 0);
   rd_mux_v(OFFSET2_H)(D_OFFSET2'high-DATA_WIDTH downto 0) := D_OFFSET2(D_OFFSET2'high downto DATA_WIDTH);
   rd_mux_v(ID)(ID_WIDTH-1 downto 0)                 := ID_DEF_VALUE;
   rd_mux_v(STATUS)(D_STATUS'range)                  := D_STATUS;
   rd_mux_v(S_INT_EN)(D_S_INT_EN'range)              := D_S_INT_EN;
   rd_mux_v(FEHLER)(D_FEHLER'range)                  := D_FEHLER;
   rd_mux_v(F_INT_EN)(D_F_INT_EN'range)              := D_F_INT_EN;
   rd_mux_v(DS1)(D_DS1'range)                        := D_DS1;
   rd_mux_v(DS2)(D_DS2'range)                        := D_DS2;
   rd_mux_v(DS3)(D_DS3'range)                        := D_DS3;
   rd_mux_v(DS4)(D_DS4'range)                        := D_DS4;
   rd_mux_v(T1)(D_TEST1'range)                       := D_TEST1;
   rd_mux_v(T2)(D_TEST2'range)                       := D_TEST2;
   rd_mux_v(T3)(D_TEST3'range)                       := D_TEST3;
   rd_mux_v(T4)(D_TEST4'range)                       := D_TEST4;

   rd_mux_v(SR_M)(DATA_WIDTH-1 downto 0)             := D_SRM(DATA_WIDTH-1 downto 0);
   rd_mux_v(SR_M_H)(D_SRM'high-DATA_WIDTH downto 0)  := D_SRM(D_SRM'high downto DATA_WIDTH);
   rd_mux_v(NSR_POS1)(D_NSRPOS1'range)               := D_NSRPOS1;
   rd_mux_v(NSR_POS2)(D_NSRPOS2'range)	             := D_NSRPOS2;

   rd_mux_v(MULTIPL)(D_MULTIPL'range)                := D_MULTIPL;
   rd_mux_v(SPEED)(D_SPEED'range)                    := D_SPEED;

   rd_mux_v(OEM1_CNTRL)(D_OEM1_CTRL'range)           := D_OEM1_CTRL;    -- OEM1 Control Register               -- 2007.06
   rd_mux_v(OEM1_INTSTAT)(D_OEM1_IRQSTAT'range)      := D_OEM1_IRQSTAT; -- OEM1 Interrupt Status Register
   rd_mux_v(OEM1_I_INT_EN)(D_OEM1_IM'range)          := D_OEM1_IM;      -- OEM1 Interrupt Mask
   rd_mux_v(OEM1_KONF1)(D_OEM1_KONF1'range)          := D_OEM1_KONF1;   -- OEM1 Configuration Register1
   rd_mux_v(OEM1_KONF2)(D_OEM1_KONF2'range)          := D_OEM1_KONF2;   -- OEM1 Configuration Register2
   rd_mux_v(OEM1_KONF3)(D_OEM1_KONF3'RANGE)                      := D_OEM1_KONF3;  -- OEM1 Configuration Register3
   rd_mux_v(OEM1_KONF4)(D_OEM1_KONF4'RANGE)                      := D_OEM1_KONF4;  -- OEM1 Configuration Register4
   rd_mux_v(OEM1_KONF5)(DATA_WIDTH-1 DOWNTO 0)                   := D_OEM1_KONF5(DATA_WIDTH-1 DOWNTO 0);  -- OEM1 Configuration Register5
   rd_mux_v(OEM1_KONF5_H)(D_OEM1_KONF5'HIGH-DATA_WIDTH DOWNTO 0) := D_OEM1_KONF5(D_OEM1_KONF5'HIGH DOWNTO DATA_WIDTH);
   rd_mux_v(OEM1_KONF6)(D_OEM1_KONF6'RANGE)                      := D_OEM1_KONF6;  -- OEM1 Configuration Register6
   rd_mux_v(OEM1_STOR)(D_OEM1_STORE'range)           := D_OEM1_STORE;   -- OEM1 Store Register               -- 2008.01
   rd_mux_v(OEM1_STURN)(D_OEM1_ST'range)             := D_OEM1_ST;      -- OEM1 Singleturn
   rd_mux_v(OEM1_MTURN)(D_OEM1_MT'range)             := D_OEM1_MT;      -- OEM1 Multiturn
   rd_mux_v(OEM1_POSI2)(D_OEM1_POS2'range)           := D_OEM1_POS2;    -- OEM1 Position2
   rd_mux_v(OEM1_SOLCT)(D_OEM1_SOL'range)            := D_OEM1_SOL;     -- OEM1 Sign of Life (Lebenszeichen) 
   rd_mux_v(OEM1_STATUS)(D_OEM1_STATUS'range)        := D_OEM1_STATUS;    -- OEM1 Status


   rd_data_v := rd_data_r;
   for i in resource_addr'range loop
      -- decode 32 bit address
      if adr_i = RESOURCE_ADDR(i) then
         case i is
            when EMPF1|EMPF1S|EMPF4|SPEED|T4|OEM1_STURN =>
               if DW_ADDR='1' then
                   rd_data_v := rd_mux_v(i);
               end if;
            when EMPF1_H|EMPF1S_H|EMPF4_H|SPEED_H|T4_H|OEM1_STURN_H => null;
            when others =>
               rd_data_v := rd_mux_v(i);
         end case;
      end if;
   end loop;
rd_data_s <= rd_data_v;
end process;
 
-- registered read buffer
---------------------------------------------------------------------------
read_buf: process (RESX, CLK)
begin
if RESX = '0' then
   rd_data_r <= (others=>'0');
   dvld     <= '0';
elsif CLK'event and CLK='1' then
   if IMPLEMENT_RDY/=0 then
      if AHB_DEN100='1' then
         dvld <= PENABLE;
      end if;
      if PWRITE='0' and PENABLE='1' and dvld='0' then
         rd_data_r <= rd_data_s;
      end if;
   else
      if AHB_DEN100='1' then
         dvld <= PSEL;
      end if;
      if PWRITE='0' and PSEL='1' and dvld='0' then
         rd_data_r <= rd_data_s;
      end if;
   end if;
end if;
end process;

-- RDY logic = f(IMPLEMENT_RDY, PWRITE)
---------------------------------------------------------------------------
rdy_gen: process (PENABLE, PSEL, PWRITE, dvld)
begin
if IMPLEMENT_RDY/=0 then
   PRDY <= (not PENABLE) or (not PSEL) or PWRITE or dvld;
else
   PRDY <= '1';
end if;
end process;

-- output port for read data
---------------------------------------------------------------------------
out2port: process (rd_data_r, adr_i, PSEL, PWRITE )
variable out_data_v: std_logic_vector(rd_data_r'range);
begin
if INVERT_RD_DATA = 0 then
   out_data_v := rd_data_r;
else
   out_data_v := not rd_data_r;
end if;
if PSEL='0' or PWRITE='1' then
   PRDATA <= (others=>'0');
else
   PRDATA <= out_data_v(  DATA_WIDTH-1 downto 0);
   for i in RESOURCE_ADDR'range loop
      if adr_i = RESOURCE_ADDR(i) then
		 case i is
            when EMPF1_H|EMPF1S_H|EMPF4_H|SPEED_H|T4_H|OEM1_STURN_H => PRDATA <= out_data_v(2*DATA_WIDTH-1 downto DATA_WIDTH);
            when others          => null;
         end case;
	  end if;
   end loop;
end if;
end process;

D2MASK <= rd_data_s(D2MASK'range);

--***************************************************************************
-- WRITE
--***************************************************************************

-- Build write Enable signals for single access
-----------------------------------------------------------------------------
-- Note: constant wr_mask_copy in sensitivity list due to "never reached" warning from
--       FPGA Compiler II Version: 2002.05-FC3.7, Build: 3.7.1.7701

wr_mask_copy <= wr_mask;

wr_ctrl: process (rd_data_s, adr_i, AHB_DEN100, PSEL, PENABLE, PWRITE, PWDATA, wr_mask_copy)
variable we_v   : std_logic_vector(WE'range);
variable data_v : std_logic_vector(D2APPL'range);
begin
-- decode address and generate corresponding enables
-- mask read only databits to avoid overwrite
we_v  := (others=>'0');
data_v:= rd_data_s(D2APPL'range);
for i in RESOURCE_ADDR'range loop
   if adr_i = RESOURCE_ADDR(i) then
      we_v(i):=PSEL and PENABLE and AHB_DEN100 and PWRITE;
      for k in D2APPL'range loop
         if wr_mask_copy(i)(k)='1' then
            data_v(k) := PWDATA(k);
         end if;
      end loop;
   end if;
end loop;
WE     <= we_v;
D2APPL <= data_v;
end process;


end RTL;
