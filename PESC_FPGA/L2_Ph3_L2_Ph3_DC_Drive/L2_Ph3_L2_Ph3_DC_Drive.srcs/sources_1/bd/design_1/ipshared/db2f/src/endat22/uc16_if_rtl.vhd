-- MAZeT. All rights reserved. This document and all informations           --
-- contained therein is considered confidential and proprietary of MAZeT.   --
------------------------------------------------------------------------------
--                                                                          --
-- File:             $RCSfile
--                                                                          --
-- Project:          EnDat6                                                 --
--                                                                          --
-- Modul / Unit:     UC_IF                                                  --
--                   (entity and architect.)                                --
--                                                                          --
-- Function:         8/16 bit microcontroller interface to SYNC_PORT IF     --
--                   build command signals for SYNC_PORT IF from port commands--
--                   and output enables of data port                        --
--                                                                          --
--                   Note:  to implement 16 bit port:                       --
--                       PIF_WIDTH = 16 in resource_pkg !!                  --
--                                                                          --
-- Author:           R. Woyzichovski                                        --
--                   MAZeT GmbH                                             --
--                   Goeschwitzer Strasse 32                                --
--                   D-07745 Jena                                           --
--                                                                          --
-- Synthesis:        (Tested with Synoplfy 8.6.2)                           --
--                                                                          --
-- Script:           ENDAT22.prj                                            --
--                                                                          --
-- Simulation:       Cadence NCVHDL V3.41, V5.1                             --
--                                                                          --
-- Function:         UC-interface (parallel port)                           --
--                                                                          --
-- History:          F.Seiler 12.05.2005 Splitted data bus                  --
--                   F.Seiler 29.09.2005 SYNC_PORT_SIGNALS                  --
--                   F.Seiler 23.01.2008 generics boolean -> integer        --
------------------------------------------------------------------------------
-- Revision history
--
-- $Log
--
------------------------------------------------------------------------------

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.conv_integer;
use ieee.std_logic_arith.all;
use endat22.resource_pkg.all;

entity UC_IF is
 generic (
          ADR_WIDTH:         integer:=endat22.resource_pkg.ADR_WIDTH;  -- recently = 7
          SPLIT_DATA_BUS:    integer:= 0;
          SYNC_PORT_SIGNALS: integer:= 0
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
          ADDR:              in    std_logic_vector(ADR_WIDTH-1 downto 0);  -- resource addresses 
          DATA:              inout std_logic_vector(PIF_WIDTH-1 downto 0);  -- bidir. data port
          DATA_IN:           in    std_logic_vector(PIF_WIDTH-1 downto 0);  -- splitted data port (input)
          DATA_OUT:          out   std_logic_vector(PIF_WIDTH-1 downto 0);  -- splitted data port (out)

          -- application Port (SYNC_PORT IF)
          ---------------------------------------------------------------
          PSEL:              out   std_logic; -- port select
          PWRITE:            out   std_logic; -- access mode: 1 -> write, 0 -> read
          PENABLE:           out   std_logic; -- enables access
          PADDR:             out   std_logic_vector(ADR_WIDTH-1 downto 2);  -- inner module address
          PWDATA:            out   std_logic_vector(DATA_WIDTH-1 downto 0); -- write data to appl.
          PRDATA:            in    std_logic_vector(DATA_WIDTH-1 downto 0); -- read  data from appl.
          D2MASK:            in    std_logic_vector(DATA_WIDTH-1 downto 0); -- mask write data
          PSLVERR:           out   std_logic;
          -- application specific control signals
          ---------------------------------------------------------------
          BE:                out   std_logic_vector(3 downto 0) -- byte enable from ADDR(1:0)
         );
end UC_IF;


architecture RTL of UC_IF is

  -----------------------------------------------------------------------------
  -- type declaration
  -----------------------------------------------------------------------------
  -- array types to support register implementation
  type a_array is array(integer range <>) of std_logic_vector(ADR_WIDTH-1 downto 0);
  type d_array is array(integer range <>) of std_logic_vector(PIF_WIDTH-1 downto 0);

  -----------------------------------------------------------------------------
  -- signal declaration
  -----------------------------------------------------------------------------
  -- combinatorical signals
  -------------------------

  -- register ressources
  -------------------------
  signal cs_r:   std_logic_vector(2 downto 0);
  signal wr_r:   std_logic_vector(2 downto 0);
  signal rd_r:   std_logic_vector(1 downto 0);
  signal addr_r: a_array(2 downto 0);
  signal din_r:  d_array(2 downto 0);
  signal do_s:   std_logic_vector(PIF_WIDTH-1 downto 0);
  signal rdy_r:  std_logic;
  signal accs_r: std_logic;
  signal accs_s: std_logic_vector(1 downto 0);
  signal addr_s: std_logic_vector(ADR_WIDTH-1 downto 0);


begin

--***************************************************************************
-- Synchronization
--***************************************************************************

-- with Synchronization
-----------------------------------------------------------------------------
SYNC_PORT_SIG: if (SYNC_PORT_SIGNALS = 1) generate

   sync: process (RESX, CLK)
   begin
   if RESX = '0' then
      cs_r   <= (others => '0');
      rd_r   <= (others => '0');
      wr_r   <= (others => '0');
      addr_r <= (others=> (others => '0'));
--    din_r  <= (others=> (others => '0'));
      accs_r <= '0';
      rdy_r  <= '0';
   elsif CLK'event and CLK='1' then
      cs_r   <= (not CSX, cs_r(2), cs_r(1));
      rd_r   <= (not RDX, rd_r(1));
      wr_r   <= (not WRX, wr_r(2), wr_r(1));
      addr_r <= (ADDR, addr_r(2), addr_r(1));
--    din_r  <= (DATA, din_r(2), din_r(1));
      rdy_r  <= (cs_r(1) and (rd_r(0) or wr_r(1)));
      accs_r <= accs_s(1);
   end if;
   end process;

-----------------------------------------------------------------------------

-- Splitted DATA to DATA_IN, DATA_OUT
   NOT_SPLIT_D: if (SPLIT_DATA_BUS = 0) generate

      sync_data: process (RESX, CLK)
      begin
      if RESX = '0' then
         din_r  <= (others=> (others => '0'));
      elsif CLK'event and CLK='1' then
         din_r  <= (DATA, din_r(2), din_r(1));
      end if;
      end process;
   end generate;  -- not SPLIT_DATA_BUS

   SPLIT_D: if (SPLIT_DATA_BUS = 1) generate

      sync_data2: process (RESX, CLK)
      begin
      if RESX = '0' then
         din_r  <= (others=> (others => '0'));
      elsif CLK'event and CLK='1' then
         din_r  <= (DATA_IN, din_r(2), din_r(1));
      end if;
      end process;
   end generate;  -- SPLIT_DATA_BUS
-----------------------------------------------------------------------------
end generate;  -- SYNC_PORT_SIGNALS
-----------------------------------------------------------------------------


-- without Synchronization
-----------------------------------------------------------------------------
   NOT_SYNC_PORT_SIG: if (SYNC_PORT_SIGNALS = 0) generate

   no_sync: process (RESX, CLK)
   begin
   if RESX = '0' then
      cs_r(0)   <= '0';
      wr_r(0)   <= '0';
      addr_r(0) <= (others => '0');
      accs_r <= '0';
      rdy_r  <= '0';
   elsif CLK'event and CLK='1' then
      cs_r  (0) <= cs_r(1);
      wr_r  (0) <= wr_r(1);
      addr_r(0) <= addr_r(1);
      rdy_r  <= (cs_r(1) and (rd_r(0) or wr_r(1)));
      accs_r <= accs_s(1);
   end if;
   end process;

   rd_r  (0) <= not RDX;
   cs_r  (1) <= not CSX;
   wr_r  (1) <= not WRX;
   addr_r(1) <= ADDR;

-----------------------------------------------------------------------------

   -- Splitted DATA to DATA_IN, DATA_OUT
   NOT_SPLIT_D: if (SPLIT_DATA_BUS = 0) generate
      din_r(1)  <= DATA;
   end generate;

   SPLIT_D: if (SPLIT_DATA_BUS = 1) generate
      din_r(1)  <= DATA_IN;
   end generate;

   sync_data: process (RESX, CLK)
   begin
   if RESX = '0' then
      din_r(0)  <= (others => '0');
   elsif CLK'event and CLK='1' then
      din_r(0)  <= din_r(1);
   end if;
   end process;

   din_r(2)  <= (others => '0');
   addr_r(2) <= (others => '0');

-----------------------------------------------------------------------------
end generate;  -- NOT SYNC_PORT_SIGNALS
-----------------------------------------------------------------------------


--***************************************************************************
--***************************************************************************



-- access valid at falling edge of read or rising edge of write
---------------------------------------------------------------
accs_s <= ((cs_r(1) and rd_r(0)) or ((cs_r(0) and not wr_r(1) and wr_r(0))), accs_r);

--***************************************************************************
-- input path with data mask and byte enabel generation
--***************************************************************************
imask_ctrl: process (din_r, addr_s, M16, D2MASK)
variable be_v: std_logic_vector(BE'high+1 downto 0);
variable masked_d: std_logic_vector(3*BYTE+PIF_WIDTH-1 downto 0);
begin
be_v:=(others=>'0');
masked_d(D2MASK'range):=D2MASK;
if M16='1' then
   for i in 0 to 3 loop
      if i = conv_integer(addr_s(1 downto 0)) then
         be_v((i+1) downto i) := "11";
         masked_d((i+2)*BYTE-1 downto i*BYTE) := din_r(0);
      end if;
   end loop;
else
   for i in 0 to 3 loop
      if i = conv_integer(addr_s(1 downto 0)) then
         be_v(i) := '1';
         masked_d((i+1)*BYTE-1 downto i*BYTE) := din_r(0)(BYTE-1 downto 0);
      end if;
   end loop;
end if;
BE     <= be_v(BE'range);
PWDATA <= masked_d(PWDATA'range);
end process;


--***************************************************************************
-- output path with combinatorical data path
--***************************************************************************
omux_ctrl: process (PRDATA, addr_r)
variable omux_v: std_logic_vector(3*BYTE+PIF_WIDTH-1 downto 0);
begin
   omux_v:=(others=>'0'); 
   omux_v(PRDATA'range):=PRDATA;
   do_s <= (others =>'0');
   for i in 0 to 3 loop
      if i = conv_integer(addr_r(1)(1 downto 0)) then
         do_s<=omux_v(i*BYTE+PIF_WIDTH-1 downto i*BYTE);
      end if;
   end loop;
end process;

addr_s <= addr_r(0) when wr_r(0)='1' else addr_r(1);

--***************************************************************************
-- combinatorical port assignments
--***************************************************************************
PSEL     <= cs_r(0) when wr_r(0)='1' else cs_r(1);
PENABLE  <= '1' when accs_s="10" else '0'; -- @ rise of access
PADDR    <= addr_s(ADR_WIDTH-1 downto 2);
PWRITE   <= wr_r(0);

RDYX     <= (not rdy_r) or (RDX and WRX) ;


--***************************************************************************
-- Split DATA BUS
--***************************************************************************

NOT_SPLIT: if (SPLIT_DATA_BUS = 0) generate

   DATA(1*BYTE-1 downto 0*BYTE)<=do_s(1*BYTE-1 downto 0*BYTE) when (cs_r(0) and rd_r(0))='1'
                              else (others => 'Z');

   DATA(2*BYTE-1 downto 1*BYTE)<=do_s(2*BYTE-1 downto 1*BYTE) when (cs_r(0) and rd_r(0) and M16)='1'
                              else (others => 'Z');
end generate;


SPLIT: if (SPLIT_DATA_BUS = 1) generate

   DATA_OUT(1*BYTE-1 downto 0*BYTE)<=do_s(1*BYTE-1 downto 0*BYTE);
   DATA_OUT(2*BYTE-1 downto 1*BYTE)<=do_s(2*BYTE-1 downto 1*BYTE) when M16 ='1' else (others => '0');
end generate;


--***************************************************************************

end RTL;
