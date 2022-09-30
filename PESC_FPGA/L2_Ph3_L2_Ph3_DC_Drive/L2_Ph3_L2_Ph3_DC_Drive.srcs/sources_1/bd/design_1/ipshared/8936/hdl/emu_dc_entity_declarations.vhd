-------------------------------------------------------------------
-- System Generator version 2019.1 VHDL source file.
--
-- Copyright(C) 2019 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2019 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_e4470cee2e is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sa : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_e4470cee2e;
architecture behavior of sysgen_bitbasher_e4470cee2e
is
  signal u_1_27: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsa_5_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_27 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_27, 1, 1);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsa_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  sa <= unsigned_to_std_logic_vector(fullsa_5_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mcode_block_a0e47c7f64 is
  port (
    s : in std_logic_vector((1 - 1) downto 0);
    ns : in std_logic_vector((1 - 1) downto 0);
    i : in std_logic_vector((32 - 1) downto 0);
    sel : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mcode_block_a0e47c7f64;
architecture behavior of sysgen_mcode_block_a0e47c7f64
is
  signal s_1_29: unsigned((1 - 1) downto 0);
  signal ns_1_32: unsigned((1 - 1) downto 0);
  signal i_1_36: signed((32 - 1) downto 0);
  signal bit_3_11: unsigned((1 - 1) downto 0);
  signal rel_3_10: boolean;
  signal rel_3_24: boolean;
  signal bool_3_10: boolean;
  signal bit_5_15: unsigned((1 - 1) downto 0);
  signal rel_5_14: boolean;
  signal rel_5_28: boolean;
  signal bool_5_14: boolean;
  signal sel_join_3_1: unsigned((1 - 1) downto 0);
begin
  s_1_29 <= std_logic_vector_to_unsigned(s);
  ns_1_32 <= std_logic_vector_to_unsigned(ns);
  i_1_36 <= std_logic_vector_to_signed(i);
  bit_3_11 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_3_10 <= bit_3_11 = std_logic_vector_to_unsigned("0");
  rel_3_24 <= i_1_36 >= std_logic_vector_to_signed("00000000000000000000000000000000");
  bool_3_10 <= rel_3_10 and rel_3_24;
  bit_5_15 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_5_14 <= bit_5_15 = std_logic_vector_to_unsigned("0");
  rel_5_28 <= i_1_36 < std_logic_vector_to_signed("00000000000000000000000000000000");
  bool_5_14 <= rel_5_14 and rel_5_28;
  proc_if_3_1: process (bool_3_10, bool_5_14, s_1_29)
  is
  begin
    if bool_3_10 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("0");
    elsif bool_5_14 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("1");
    else 
      sel_join_3_1 <= s_1_29;
    end if;
  end process proc_if_3_1;
  sel <= unsigned_to_std_logic_vector(sel_join_3_1);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_935d11a1f8 is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sb : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_935d11a1f8;
architecture behavior of sysgen_bitbasher_935d11a1f8
is
  signal u_1_27: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsb_5_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_27 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_27, 3, 3);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsb_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  sb <= unsigned_to_std_logic_vector(fullsb_5_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_35fa2a4022 is
  port (
    ia1 : in std_logic_vector((13 - 1) downto 0);
    ia2 : in std_logic_vector((13 - 1) downto 0);
    ib1 : in std_logic_vector((13 - 1) downto 0);
    ib2 : in std_logic_vector((13 - 1) downto 0);
    ic1 : in std_logic_vector((13 - 1) downto 0);
    ic2 : in std_logic_vector((13 - 1) downto 0);
    vdc1 : in std_logic_vector((13 - 1) downto 0);
    vdc2 : in std_logic_vector((13 - 1) downto 0);
    signal_bus : out std_logic_vector((104 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_35fa2a4022;
architecture behavior of sysgen_bitbasher_35fa2a4022
is
  signal ia1_1_35: signed((13 - 1) downto 0);
  signal ia2_1_40: signed((13 - 1) downto 0);
  signal ib1_1_45: signed((13 - 1) downto 0);
  signal ib2_1_50: signed((13 - 1) downto 0);
  signal ic1_1_55: signed((13 - 1) downto 0);
  signal ic2_1_60: signed((13 - 1) downto 0);
  signal vdc1_1_65: signed((13 - 1) downto 0);
  signal vdc2_1_71: signed((13 - 1) downto 0);
  signal fullsignal_bus_5_1_concat: unsigned((104 - 1) downto 0);
begin
  ia1_1_35 <= std_logic_vector_to_signed(ia1);
  ia2_1_40 <= std_logic_vector_to_signed(ia2);
  ib1_1_45 <= std_logic_vector_to_signed(ib1);
  ib2_1_50 <= std_logic_vector_to_signed(ib2);
  ic1_1_55 <= std_logic_vector_to_signed(ic1);
  ic2_1_60 <= std_logic_vector_to_signed(ic2);
  vdc1_1_65 <= std_logic_vector_to_signed(vdc1);
  vdc2_1_71 <= std_logic_vector_to_signed(vdc2);
  fullsignal_bus_5_1_concat <= std_logic_vector_to_unsigned(signed_to_std_logic_vector(vdc2_1_71) & signed_to_std_logic_vector(ic2_1_60) & signed_to_std_logic_vector(ib2_1_50) & signed_to_std_logic_vector(ia2_1_40) & signed_to_std_logic_vector(vdc1_1_65) & signed_to_std_logic_vector(ic1_1_55) & signed_to_std_logic_vector(ib1_1_45) & signed_to_std_logic_vector(ia1_1_35));
  signal_bus <= unsigned_to_std_logic_vector(fullsignal_bus_5_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mcode_block_18cd5248f3 is
  port (
    s : in std_logic_vector((1 - 1) downto 0);
    ns : in std_logic_vector((1 - 1) downto 0);
    i : in std_logic_vector((64 - 1) downto 0);
    sel : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mcode_block_18cd5248f3;
architecture behavior of sysgen_mcode_block_18cd5248f3
is
  signal s_1_29: unsigned((1 - 1) downto 0);
  signal ns_1_32: unsigned((1 - 1) downto 0);
  signal i_1_36: signed((64 - 1) downto 0);
  signal bit_3_11: unsigned((1 - 1) downto 0);
  signal rel_3_10: boolean;
  signal rel_3_24: boolean;
  signal bool_3_10: boolean;
  signal bit_5_15: unsigned((1 - 1) downto 0);
  signal rel_5_14: boolean;
  signal rel_5_28: boolean;
  signal bool_5_14: boolean;
  signal sel_join_3_1: unsigned((1 - 1) downto 0);
begin
  s_1_29 <= std_logic_vector_to_unsigned(s);
  ns_1_32 <= std_logic_vector_to_unsigned(ns);
  i_1_36 <= std_logic_vector_to_signed(i);
  bit_3_11 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_3_10 <= bit_3_11 = std_logic_vector_to_unsigned("0");
  rel_3_24 <= i_1_36 >= std_logic_vector_to_signed("0000000000000000000000000000000000000000000000000000000000000000");
  bool_3_10 <= rel_3_10 and rel_3_24;
  bit_5_15 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_5_14 <= bit_5_15 = std_logic_vector_to_unsigned("0");
  rel_5_28 <= i_1_36 < std_logic_vector_to_signed("0000000000000000000000000000000000000000000000000000000000000000");
  bool_5_14 <= rel_5_14 and rel_5_28;
  proc_if_3_1: process (bool_3_10, bool_5_14, s_1_29)
  is
  begin
    if bool_3_10 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("0");
    elsif bool_5_14 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("1");
    else 
      sel_join_3_1 <= s_1_29;
    end if;
  end process proc_if_3_1;
  sel <= unsigned_to_std_logic_vector(sel_join_3_1);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_6cafa897f0 is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sc : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_6cafa897f0;
architecture behavior of sysgen_bitbasher_6cafa897f0
is
  signal u_1_27: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsc_5_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_27 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_27, 5, 5);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsc_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  sc <= unsigned_to_std_logic_vector(fullsc_5_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_concat_6116e079a1 is
  port (
    in0 : in std_logic_vector((1 - 1) downto 0);
    in1 : in std_logic_vector((1 - 1) downto 0);
    in2 : in std_logic_vector((1 - 1) downto 0);
    in3 : in std_logic_vector((1 - 1) downto 0);
    in4 : in std_logic_vector((1 - 1) downto 0);
    in5 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_concat_6116e079a1;
architecture behavior of sysgen_concat_6116e079a1
is
  signal in0_1_23: unsigned((1 - 1) downto 0);
  signal in1_1_27: unsigned((1 - 1) downto 0);
  signal in2_1_31: unsigned((1 - 1) downto 0);
  signal in3_1_35: unsigned((1 - 1) downto 0);
  signal in4_1_39: unsigned((1 - 1) downto 0);
  signal in5_1_43: unsigned((1 - 1) downto 0);
  signal y_2_1_concat: unsigned((6 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  in3_1_35 <= std_logic_vector_to_unsigned(in3);
  in4_1_39 <= std_logic_vector_to_unsigned(in4);
  in5_1_43 <= std_logic_vector_to_unsigned(in5);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31) & unsigned_to_std_logic_vector(in3_1_35) & unsigned_to_std_logic_vector(in4_1_39) & unsigned_to_std_logic_vector(in5_1_43));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_2d9a011320 is
  port (
    op : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_2d9a011320;
architecture behavior of sysgen_constant_2d9a011320
is
begin
  op <= "11111111111111111111111111111111";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_d7a5e5b28b is
  port (
    op : out std_logic_vector((13 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_d7a5e5b28b;
architecture behavior of sysgen_constant_d7a5e5b28b
is
begin
  op <= "0000000000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_e74ec518d3 is
  port (
    op : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_e74ec518d3;
architecture behavior of sysgen_constant_e74ec518d3
is
begin
  op <= "000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_72767c8c86 is
  port (
    op : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_72767c8c86;
architecture behavior of sysgen_constant_72767c8c86
is
begin
  op <= "111111";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_6deb76d271 is
  port (
    op : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_6deb76d271;
architecture behavior of sysgen_constant_6deb76d271
is
begin
  op <= "00000000000000000000000000000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_57804e7959 is
  port (
    op : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_57804e7959;
architecture behavior of sysgen_constant_57804e7959
is
begin
  op <= "00000000000000000000000000000001";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

--$Header: /devl/xcs/repo/env/Jobs/sysgen/src/xbs/blocks/xlconvert/hdl/xlconvert.vhd,v 1.1 2004/11/22 00:17:30 rosty Exp $
---------------------------------------------------------------------
--
--  Filename      : xlconvert.vhd
--
--  Description   : VHDL description of a fixed point converter block that
--                  converts the input to a new output type.

--
---------------------------------------------------------------------


---------------------------------------------------------------------
--
--  Entity        : xlconvert
--
--  Architecture  : behavior
--
--  Description   : Top level VHDL description of fixed point conver block.
--
---------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity convert_func_call_emu_dc_xlconvert is
    generic (
        din_width    : integer := 16;            -- Width of input
        din_bin_pt   : integer := 4;             -- Binary point of input
        din_arith    : integer := xlUnsigned;    -- Type of arith of input
        dout_width   : integer := 8;             -- Width of output
        dout_bin_pt  : integer := 2;             -- Binary point of output
        dout_arith   : integer := xlUnsigned;    -- Type of arith of output
        quantization : integer := xlTruncate;    -- xlRound or xlTruncate
        overflow     : integer := xlWrap);       -- xlSaturate or xlWrap
    port (
        din : in std_logic_vector (din_width-1 downto 0);
        result : out std_logic_vector (dout_width-1 downto 0));
end convert_func_call_emu_dc_xlconvert ;

architecture behavior of convert_func_call_emu_dc_xlconvert is
begin
    -- Convert to output type and do saturation arith.
    result <= convert_type(din, din_width, din_bin_pt, din_arith,
                           dout_width, dout_bin_pt, dout_arith,
                           quantization, overflow);
end behavior;


library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity emu_dc_xlconvert  is
    generic (
        din_width    : integer := 16;            -- Width of input
        din_bin_pt   : integer := 4;             -- Binary point of input
        din_arith    : integer := xlUnsigned;    -- Type of arith of input
        dout_width   : integer := 8;             -- Width of output
        dout_bin_pt  : integer := 2;             -- Binary point of output
        dout_arith   : integer := xlUnsigned;    -- Type of arith of output
        en_width     : integer := 1;
        en_bin_pt    : integer := 0;
        en_arith     : integer := xlUnsigned;
        bool_conversion : integer :=0;           -- if one, convert ufix_1_0 to
                                                 -- bool
        latency      : integer := 0;             -- Ouput delay clk cycles
        quantization : integer := xlTruncate;    -- xlRound or xlTruncate
        overflow     : integer := xlWrap);       -- xlSaturate or xlWrap
    port (
        din : in std_logic_vector (din_width-1 downto 0);
        en  : in std_logic_vector (en_width-1 downto 0);
        ce  : in std_logic;
        clr : in std_logic;
        clk : in std_logic;
        dout : out std_logic_vector (dout_width-1 downto 0));

end emu_dc_xlconvert ;

architecture behavior of emu_dc_xlconvert  is

    component synth_reg
        generic (width       : integer;
                 latency     : integer);
        port (i       : in std_logic_vector(width-1 downto 0);
              ce      : in std_logic;
              clr     : in std_logic;
              clk     : in std_logic;
              o       : out std_logic_vector(width-1 downto 0));
    end component;

    component convert_func_call_emu_dc_xlconvert 
        generic (
            din_width    : integer := 16;            -- Width of input
            din_bin_pt   : integer := 4;             -- Binary point of input
            din_arith    : integer := xlUnsigned;    -- Type of arith of input
            dout_width   : integer := 8;             -- Width of output
            dout_bin_pt  : integer := 2;             -- Binary point of output
            dout_arith   : integer := xlUnsigned;    -- Type of arith of output
            quantization : integer := xlTruncate;    -- xlRound or xlTruncate
            overflow     : integer := xlWrap);       -- xlSaturate or xlWrap
        port (
            din : in std_logic_vector (din_width-1 downto 0);
            result : out std_logic_vector (dout_width-1 downto 0));
    end component;


    -- synthesis translate_off
--    signal real_din, real_dout : real;    -- For debugging info ports
    -- synthesis translate_on
    signal result : std_logic_vector(dout_width-1 downto 0);
    signal internal_ce : std_logic;

begin

    -- Debugging info for internal full precision variables
    -- synthesis translate_off
--     real_din <= to_real(din, din_bin_pt, din_arith);
--     real_dout <= to_real(dout, dout_bin_pt, dout_arith);
    -- synthesis translate_on

    internal_ce <= ce and en(0);

    bool_conversion_generate : if (bool_conversion = 1)
    generate
      result <= din;
    end generate; --bool_conversion_generate

    std_conversion_generate : if (bool_conversion = 0)
    generate
      -- Workaround for XST bug
      convert : convert_func_call_emu_dc_xlconvert 
        generic map (
          din_width   => din_width,
          din_bin_pt  => din_bin_pt,
          din_arith   => din_arith,
          dout_width  => dout_width,
          dout_bin_pt => dout_bin_pt,
          dout_arith  => dout_arith,
          quantization => quantization,
          overflow     => overflow)
        port map (
          din => din,
          result => result);
    end generate; --std_conversion_generate

    latency_test : if (latency > 0) generate
        reg : synth_reg
            generic map (
              width => dout_width,
              latency => latency
            )
            port map (
              i => result,
              ce => internal_ce,
              clr => clr,
              clk => clk,
              o => dout
            );
    end generate;

    latency0 : if (latency = 0)
    generate
        dout <= result;
    end generate latency0;

end  behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mcode_block_ea985bd348 is
  port (
    s : in std_logic_vector((1 - 1) downto 0);
    ns : in std_logic_vector((1 - 1) downto 0);
    i : in std_logic_vector((32 - 1) downto 0);
    sel : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mcode_block_ea985bd348;
architecture behavior of sysgen_mcode_block_ea985bd348
is
  signal s_1_29: unsigned((1 - 1) downto 0);
  signal ns_1_32: unsigned((1 - 1) downto 0);
  signal i_1_36: unsigned((32 - 1) downto 0);
  signal bit_3_11: unsigned((1 - 1) downto 0);
  signal rel_3_10: boolean;
  signal rel_3_24: boolean;
  signal bool_3_10: boolean;
  signal bit_5_15: unsigned((1 - 1) downto 0);
  signal rel_5_14: boolean;
  signal rel_5_28: boolean;
  signal bool_5_14: boolean;
  signal sel_join_3_1: unsigned((1 - 1) downto 0);
begin
  s_1_29 <= std_logic_vector_to_unsigned(s);
  ns_1_32 <= std_logic_vector_to_unsigned(ns);
  i_1_36 <= std_logic_vector_to_unsigned(i);
  bit_3_11 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_3_10 <= bit_3_11 = std_logic_vector_to_unsigned("0");
  rel_3_24 <= i_1_36 >= std_logic_vector_to_unsigned("00000000000000000000000000000000");
  bool_3_10 <= rel_3_10 and rel_3_24;
  bit_5_15 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(s_1_29) or unsigned_to_std_logic_vector(ns_1_32));
  rel_5_14 <= bit_5_15 = std_logic_vector_to_unsigned("0");
  rel_5_28 <= i_1_36 < std_logic_vector_to_unsigned("00000000000000000000000000000000");
  bool_5_14 <= rel_5_14 and rel_5_28;
  proc_if_3_1: process (bool_3_10, bool_5_14, s_1_29)
  is
  begin
    if bool_3_10 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("0");
    elsif bool_5_14 then
      sel_join_3_1 <= std_logic_vector_to_unsigned("1");
    else 
      sel_join_3_1 <= s_1_29;
    end if;
  end process proc_if_3_1;
  sel <= unsigned_to_std_logic_vector(sel_join_3_1);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity emu_dc_xldelay is
   generic(width        : integer := -1;
           latency      : integer := -1;
           reg_retiming : integer :=  0;
           reset        : integer :=  0);
   port(d       : in std_logic_vector (width-1 downto 0);
        ce      : in std_logic;
        clk     : in std_logic;
        en      : in std_logic;
        rst     : in std_logic;
        q       : out std_logic_vector (width-1 downto 0));

end emu_dc_xldelay;

architecture behavior of emu_dc_xldelay is
   component synth_reg
      generic (width       : integer;
               latency     : integer);
      port (i       : in std_logic_vector(width-1 downto 0);
            ce      : in std_logic;
            clr     : in std_logic;
            clk     : in std_logic;
            o       : out std_logic_vector(width-1 downto 0));
   end component; -- end component synth_reg

   component synth_reg_reg
      generic (width       : integer;
               latency     : integer);
      port (i       : in std_logic_vector(width-1 downto 0);
            ce      : in std_logic;
            clr     : in std_logic;
            clk     : in std_logic;
            o       : out std_logic_vector(width-1 downto 0));
   end component;

   signal internal_ce  : std_logic;

begin
   internal_ce  <= ce and en;

   srl_delay: if ((reg_retiming = 0) and (reset = 0)) or (latency < 1) generate
     synth_reg_srl_inst : synth_reg
       generic map (
         width   => width,
         latency => latency)
       port map (
         i   => d,
         ce  => internal_ce,
         clr => '0',
         clk => clk,
         o   => q);
   end generate srl_delay;

   reg_delay: if ((reg_retiming = 1) or (reset = 1)) and (latency >= 1) generate
     synth_reg_reg_inst : synth_reg_reg
       generic map (
         width   => width,
         latency => latency)
       port map (
         i   => d,
         ce  => internal_ce,
         clr => rst,
         clk => clk,
         o   => q);
   end generate reg_delay;
end architecture behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_inverter_3a7027cc95 is
  port (
    ip : in std_logic_vector((1 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_inverter_3a7027cc95;
architecture behavior of sysgen_inverter_3a7027cc95
is
  signal ip_1_26: unsigned((1 - 1) downto 0);
  type array_type_op_mem_22_20 is array (0 to (1 - 1)) of unsigned((1 - 1) downto 0);
  signal op_mem_22_20: array_type_op_mem_22_20 := (
    0 => "0");
  signal op_mem_22_20_front_din: unsigned((1 - 1) downto 0);
  signal op_mem_22_20_back: unsigned((1 - 1) downto 0);
  signal op_mem_22_20_push_front_pop_back_en: std_logic;
  signal internal_ip_12_1_bitnot: unsigned((1 - 1) downto 0);
begin
  ip_1_26 <= std_logic_vector_to_unsigned(ip);
  op_mem_22_20_back <= op_mem_22_20(0);
  proc_op_mem_22_20: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (op_mem_22_20_push_front_pop_back_en = '1')) then
        op_mem_22_20(0) <= op_mem_22_20_front_din;
      end if;
    end if;
  end process proc_op_mem_22_20;
  internal_ip_12_1_bitnot <= std_logic_vector_to_unsigned(not unsigned_to_std_logic_vector(ip_1_26));
  op_mem_22_20_front_din <= internal_ip_12_1_bitnot;
  op_mem_22_20_push_front_pop_back_en <= '1';
  op <= unsigned_to_std_logic_vector(op_mem_22_20_back);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_dfb2848d1a is
  port (
    d0 : in std_logic_vector((6 - 1) downto 0);
    d1 : in std_logic_vector((6 - 1) downto 0);
    y : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_dfb2848d1a;
architecture behavior of sysgen_logical_dfb2848d1a
is
  signal d0_1_24: std_logic_vector((6 - 1) downto 0);
  signal d1_1_27: std_logic_vector((6 - 1) downto 0);
  signal fully_2_1_bit: std_logic_vector((6 - 1) downto 0);
begin
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  y <= fully_2_1_bit;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_119ab8e99e is
  port (
    d0 : in std_logic_vector((32 - 1) downto 0);
    d1 : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_119ab8e99e;
architecture behavior of sysgen_logical_119ab8e99e
is
  signal d0_1_24: std_logic_vector((32 - 1) downto 0);
  signal d1_1_27: std_logic_vector((32 - 1) downto 0);
  type array_type_latency_pipe_5_26 is array (0 to (1 - 1)) of std_logic_vector((32 - 1) downto 0);
  signal latency_pipe_5_26: array_type_latency_pipe_5_26 := (
    0 => "00000000000000000000000000000000");
  signal latency_pipe_5_26_front_din: std_logic_vector((32 - 1) downto 0);
  signal latency_pipe_5_26_back: std_logic_vector((32 - 1) downto 0);
  signal latency_pipe_5_26_push_front_pop_back_en: std_logic;
  signal cast_2_50: std_logic_vector((32 - 1) downto 0);
  signal fully_2_1_bit: std_logic_vector((32 - 1) downto 0);
begin
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  latency_pipe_5_26_back <= latency_pipe_5_26(0);
  proc_latency_pipe_5_26: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (latency_pipe_5_26_push_front_pop_back_en = '1')) then
        latency_pipe_5_26(0) <= latency_pipe_5_26_front_din;
      end if;
    end if;
  end process proc_latency_pipe_5_26;
  cast_2_50 <= cast(d1_1_27, 28, 32, 28, xlUnsigned);
  fully_2_1_bit <= d0_1_24 and cast_2_50;
  latency_pipe_5_26_front_din <= fully_2_1_bit;
  latency_pipe_5_26_push_front_pop_back_en <= '1';
  y <= latency_pipe_5_26_back;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_0d19f6c4e5 is
  port (
    d0 : in std_logic_vector((32 - 1) downto 0);
    d1 : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_0d19f6c4e5;
architecture behavior of sysgen_logical_0d19f6c4e5
is
  signal d0_1_24: std_logic_vector((32 - 1) downto 0);
  signal d1_1_27: std_logic_vector((32 - 1) downto 0);
  signal cast_2_20: std_logic_vector((32 - 1) downto 0);
  signal fully_2_1_bit: std_logic_vector((32 - 1) downto 0);
begin
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  cast_2_20 <= cast(d0_1_24, 28, 32, 28, xlUnsigned);
  fully_2_1_bit <= cast_2_20 and d1_1_27;
  y <= fully_2_1_bit;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

---------------------------------------------------------------------
--
--  Filename      : xlregister.vhd
--
--  Description   : VHDL description of an arbitrary wide register.
--                  Unlike the delay block, an initial value is
--                  specified and is considered valid at the start
--                  of simulation.  The register is only one word
--                  deep.
--
--  Mod. History  : Removed valid bit logic from wrapper.
--                : Changed VHDL to use a bit_vector generic for its
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity emu_dc_xlregister is

   generic (d_width          : integer := 5;          -- Width of d input
            init_value       : bit_vector := b"00");  -- Binary init value string

   port (d   : in std_logic_vector (d_width-1 downto 0);
         rst : in std_logic_vector(0 downto 0) := "0";
         en  : in std_logic_vector(0 downto 0) := "1";
         ce  : in std_logic;
         clk : in std_logic;
         q   : out std_logic_vector (d_width-1 downto 0));

end emu_dc_xlregister;

architecture behavior of emu_dc_xlregister is

   component synth_reg_w_init
      generic (width      : integer;
               init_index : integer;
               init_value : bit_vector;
               latency    : integer);
      port (i   : in std_logic_vector(width-1 downto 0);
            ce  : in std_logic;
            clr : in std_logic;
            clk : in std_logic;
            o   : out std_logic_vector(width-1 downto 0));
   end component; -- end synth_reg_w_init

   -- synthesis translate_off
   signal real_d, real_q           : real;    -- For debugging info ports
   -- synthesis translate_on
   signal internal_clr             : std_logic;
   signal internal_ce              : std_logic;

begin

   internal_clr <= rst(0) and ce;
   internal_ce  <= en(0) and ce;

   -- Synthesizable behavioral model
   synth_reg_inst : synth_reg_w_init
      generic map (width      => d_width,
                   init_index => 2,
                   init_value => init_value,
                   latency    => 1)
      port map (i   => d,
                ce  => internal_ce,
                clr => internal_clr,
                clk => clk,
                o   => q);

end architecture behavior;


library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_relational_2c879613ee is
  port (
    a : in std_logic_vector((7 - 1) downto 0);
    b : in std_logic_vector((32 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_2c879613ee;
architecture behavior of sysgen_relational_2c879613ee
is
  signal a_1_31: unsigned((7 - 1) downto 0);
  signal b_1_34: unsigned((32 - 1) downto 0);
  type array_type_op_mem_37_22 is array (0 to (1 - 1)) of boolean;
  signal op_mem_37_22: array_type_op_mem_37_22 := (
    0 => false);
  signal op_mem_37_22_front_din: boolean;
  signal op_mem_37_22_back: boolean;
  signal op_mem_37_22_push_front_pop_back_en: std_logic;
  signal cast_12_12: unsigned((32 - 1) downto 0);
  signal result_12_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_unsigned(b);
  op_mem_37_22_back <= op_mem_37_22(0);
  proc_op_mem_37_22: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (op_mem_37_22_push_front_pop_back_en = '1')) then
        op_mem_37_22(0) <= op_mem_37_22_front_din;
      end if;
    end if;
  end process proc_op_mem_37_22;
  cast_12_12 <= u2u_cast(a_1_31, 0, 32, 0);
  result_12_3_rel <= cast_12_12 = b_1_34;
  op_mem_37_22_front_din <= result_12_3_rel;
  op_mem_37_22_push_front_pop_back_en <= '1';
  op <= boolean_to_vector(op_mem_37_22_back);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_45bf6f415d is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sa : out std_logic_vector((1 - 1) downto 0);
    nsa : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_45bf6f415d;
architecture behavior of sysgen_bitbasher_45bf6f415d
is
  signal u_1_31: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsa_5_1_concat: unsigned((1 - 1) downto 0);
  signal slice_6_40: unsigned((1 - 1) downto 0);
  signal concat_6_31: unsigned((1 - 1) downto 0);
  signal fullnsa_6_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_31 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_31, 1, 1);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsa_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  slice_6_40 <= u2u_slice(u_1_31, 0, 0);
  concat_6_31 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_6_40));
  fullnsa_6_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_6_31));
  sa <= unsigned_to_std_logic_vector(fullsa_5_1_concat);
  nsa <= unsigned_to_std_logic_vector(fullnsa_6_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_4271686010 is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sb : out std_logic_vector((1 - 1) downto 0);
    nsb : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_4271686010;
architecture behavior of sysgen_bitbasher_4271686010
is
  signal u_1_31: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsb_5_1_concat: unsigned((1 - 1) downto 0);
  signal slice_6_40: unsigned((1 - 1) downto 0);
  signal concat_6_31: unsigned((1 - 1) downto 0);
  signal fullnsb_6_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_31 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_31, 3, 3);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsb_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  slice_6_40 <= u2u_slice(u_1_31, 2, 2);
  concat_6_31 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_6_40));
  fullnsb_6_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_6_31));
  sb <= unsigned_to_std_logic_vector(fullsb_5_1_concat);
  nsb <= unsigned_to_std_logic_vector(fullnsb_6_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_bitbasher_d514526b4d is
  port (
    u : in std_logic_vector((6 - 1) downto 0);
    sc : out std_logic_vector((1 - 1) downto 0);
    nsc : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_bitbasher_d514526b4d;
architecture behavior of sysgen_bitbasher_d514526b4d
is
  signal u_1_31: unsigned((6 - 1) downto 0);
  signal slice_5_39: unsigned((1 - 1) downto 0);
  signal concat_5_30: unsigned((1 - 1) downto 0);
  signal fullsc_5_1_concat: unsigned((1 - 1) downto 0);
  signal slice_6_40: unsigned((1 - 1) downto 0);
  signal concat_6_31: unsigned((1 - 1) downto 0);
  signal fullnsc_6_1_concat: unsigned((1 - 1) downto 0);
begin
  u_1_31 <= std_logic_vector_to_unsigned(u);
  slice_5_39 <= u2u_slice(u_1_31, 5, 5);
  concat_5_30 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_39));
  fullsc_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_5_30));
  slice_6_40 <= u2u_slice(u_1_31, 4, 4);
  concat_6_31 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_6_40));
  fullnsc_6_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(concat_6_31));
  sc <= unsigned_to_std_logic_vector(fullsc_5_1_concat);
  nsc <= unsigned_to_std_logic_vector(fullnsc_6_1_concat);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_sgn_3f926e6f6d is
  port (
    x : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((2 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_sgn_3f926e6f6d;
architecture behavior of sysgen_sgn_3f926e6f6d
is
  signal x_1_20: signed((32 - 1) downto 0);
  type array_type_pipe_11_22 is array (0 to (1 - 1)) of signed((2 - 1) downto 0);
  signal pipe_11_22: array_type_pipe_11_22 := (
    0 => "00");
  signal pipe_11_22_front_din: signed((2 - 1) downto 0);
  signal pipe_11_22_back: signed((2 - 1) downto 0);
  signal pipe_11_22_push_front_pop_back_en: std_logic;
  signal slice_5_41: unsigned((1 - 1) downto 0);
  signal concat_5_32: unsigned((2 - 1) downto 0);
  signal unregy_5_5_force: signed((2 - 1) downto 0);
begin
  x_1_20 <= std_logic_vector_to_signed(x);
  pipe_11_22_back <= pipe_11_22(0);
  proc_pipe_11_22: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (pipe_11_22_push_front_pop_back_en = '1')) then
        pipe_11_22(0) <= pipe_11_22_front_din;
      end if;
    end if;
  end process proc_pipe_11_22;
  slice_5_41 <= s2u_slice(x_1_20, 31, 31);
  concat_5_32 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_41) & unsigned_to_std_logic_vector(std_logic_vector_to_unsigned("1")));
  unregy_5_5_force <= unsigned_to_signed(concat_5_32);
  pipe_11_22_front_din <= unregy_5_5_force;
  pipe_11_22_push_front_pop_back_en <= '1';
  y <= signed_to_std_logic_vector(pipe_11_22_back);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mux_3d251ba442 is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((32 - 1) downto 0);
    d1 : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mux_3d251ba442;
architecture behavior of sysgen_mux_3d251ba442
is
  signal sel_1_20: std_logic_vector((1 - 1) downto 0);
  signal d0_1_24: std_logic_vector((32 - 1) downto 0);
  signal d1_1_27: std_logic_vector((32 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((32 - 1) downto 0);
begin
  sel_1_20 <= sel;
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_1_20)
  is
  begin
    case sel_1_20 is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mux_376215cb10 is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((6 - 1) downto 0);
    d1 : in std_logic_vector((6 - 1) downto 0);
    y : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mux_376215cb10;
architecture behavior of sysgen_mux_376215cb10
is
  signal sel_1_20: std_logic_vector((1 - 1) downto 0);
  signal d0_1_24: std_logic_vector((6 - 1) downto 0);
  signal d1_1_27: std_logic_vector((6 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((6 - 1) downto 0);
begin
  sel_1_20 <= sel;
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_1_20)
  is
  begin
    case sel_1_20 is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mux_f631792396 is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((6 - 1) downto 0);
    d1 : in std_logic_vector((6 - 1) downto 0);
    y : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mux_f631792396;
architecture behavior of sysgen_mux_f631792396
is
  signal sel_1_20: std_logic;
  signal d0_1_24: std_logic_vector((6 - 1) downto 0);
  signal d1_1_27: std_logic_vector((6 - 1) downto 0);
  signal sel_internal_2_1_convert: std_logic_vector((1 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((6 - 1) downto 0);
begin
  sel_1_20 <= sel(0);
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  sel_internal_2_1_convert <= cast(std_logic_to_vector(sel_1_20), 0, 1, 0, xlUnsigned);
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_internal_2_1_convert)
  is
  begin
    case sel_internal_2_1_convert is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mux_86c098b96d is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((13 - 1) downto 0);
    d1 : in std_logic_vector((13 - 1) downto 0);
    y : out std_logic_vector((13 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mux_86c098b96d;
architecture behavior of sysgen_mux_86c098b96d
is
  signal sel_1_20: std_logic_vector((1 - 1) downto 0);
  signal d0_1_24: std_logic_vector((13 - 1) downto 0);
  signal d1_1_27: std_logic_vector((13 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((13 - 1) downto 0);
begin
  sel_1_20 <= sel;
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_1_20)
  is
  begin
    case sel_1_20 is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_8883052830 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_8883052830;
architecture behavior of sysgen_logical_8883052830
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_inverter_aa453897ef is
  port (
    ip : in std_logic_vector((1 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_inverter_aa453897ef;
architecture behavior of sysgen_inverter_aa453897ef
is
  signal ip_1_26: boolean;
  type array_type_op_mem_22_20 is array (0 to (1 - 1)) of boolean;
  signal op_mem_22_20: array_type_op_mem_22_20 := (
    0 => false);
  signal op_mem_22_20_front_din: boolean;
  signal op_mem_22_20_back: boolean;
  signal op_mem_22_20_push_front_pop_back_en: std_logic;
  signal internal_ip_12_1_bitnot: boolean;
begin
  ip_1_26 <= ((ip) = "1");
  op_mem_22_20_back <= op_mem_22_20(0);
  proc_op_mem_22_20: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (op_mem_22_20_push_front_pop_back_en = '1')) then
        op_mem_22_20(0) <= op_mem_22_20_front_din;
      end if;
    end if;
  end process proc_op_mem_22_20;
  internal_ip_12_1_bitnot <= ((not boolean_to_vector(ip_1_26)) = "1");
  op_mem_22_20_push_front_pop_back_en <= '0';
  op <= boolean_to_vector(internal_ip_12_1_bitnot);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_f5c169eedd is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_f5c169eedd;
architecture behavior of sysgen_logical_f5c169eedd
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 or d1_1_27;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_64f7e3bb3d is
  port (
    op : out std_logic_vector((64 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_64f7e3bb3d;
architecture behavior of sysgen_constant_64f7e3bb3d
is
begin
  op <= "0000010000000000000000000000000000000000000000000000000000000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_c1e2e26b84 is
  port (
    op : out std_logic_vector((64 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_c1e2e26b84;
architecture behavior of sysgen_constant_c1e2e26b84
is
begin
  op <= "1111110000000000000000000000000000000000000000000000000000000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_mux_f74f0d24ce is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((64 - 1) downto 0);
    d1 : in std_logic_vector((64 - 1) downto 0);
    y : out std_logic_vector((64 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_mux_f74f0d24ce;
architecture behavior of sysgen_mux_f74f0d24ce
is
  signal sel_1_20: std_logic;
  signal d0_1_24: std_logic_vector((64 - 1) downto 0);
  signal d1_1_27: std_logic_vector((64 - 1) downto 0);
  signal sel_internal_2_1_convert: std_logic_vector((1 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((64 - 1) downto 0);
begin
  sel_1_20 <= sel(0);
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  sel_internal_2_1_convert <= cast(std_logic_to_vector(sel_1_20), 0, 1, 0, xlUnsigned);
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_internal_2_1_convert)
  is
  begin
    case sel_internal_2_1_convert is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_relational_03e5441b28 is
  port (
    a : in std_logic_vector((64 - 1) downto 0);
    b : in std_logic_vector((64 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_03e5441b28;
architecture behavior of sysgen_relational_03e5441b28
is
  signal a_1_31: signed((64 - 1) downto 0);
  signal b_1_34: signed((64 - 1) downto 0);
  signal result_22_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_signed(a);
  b_1_34 <= std_logic_vector_to_signed(b);
  result_22_3_rel <= a_1_31 >= b_1_34;
  op <= boolean_to_vector(result_22_3_rel);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_relational_0e45bfa435 is
  port (
    a : in std_logic_vector((64 - 1) downto 0);
    b : in std_logic_vector((64 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_0e45bfa435;
architecture behavior of sysgen_relational_0e45bfa435
is
  signal a_1_31: signed((64 - 1) downto 0);
  signal b_1_34: signed((64 - 1) downto 0);
  signal result_20_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_signed(a);
  b_1_34 <= std_logic_vector_to_signed(b);
  result_20_3_rel <= a_1_31 <= b_1_34;
  op <= boolean_to_vector(result_20_3_rel);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity emu_dc_axi_lite_interface is 
    port(
        voltage_pu_bit_conv2 : out std_logic_vector(31 downto 0);
        voltage_pu_bit_conv1 : out std_logic_vector(31 downto 0);
        ra : out std_logic_vector(31 downto 0);
        polepairs : out std_logic_vector(31 downto 0);
        magnetization_4q_1q : out std_logic_vector(0 downto 0);
        kn : out std_logic_vector(31 downto 0);
        k_fnmechtstep : out std_logic_vector(31 downto 0);
        current_pu_bit_conv2 : out std_logic_vector(31 downto 0);
        current_pu_bit_conv1 : out std_logic_vector(31 downto 0);
        vdc2 : out std_logic_vector(31 downto 0);
        vdc1 : out std_logic_vector(31 downto 0);
        ts_la : out std_logic_vector(31 downto 0);
        ts_tm : out std_logic_vector(31 downto 0);
        ts_tf : out std_logic_vector(31 downto 0);
        tl : out std_logic_vector(31 downto 0);
        tlsum : in std_logic_vector(31 downto 0);
        ia : in std_logic_vector(31 downto 0);
        if_x0 : in std_logic_vector(31 downto 0);
        motor_id : in std_logic_vector(31 downto 0);
        speed : in std_logic_vector(31 downto 0);
        te : in std_logic_vector(31 downto 0);
        theta_el : in std_logic_vector(31 downto 0);
        theta_mech : in std_logic_vector(31 downto 0);
        clk : out std_logic;
        emu_dc_aclk : in std_logic;
        emu_dc_aresetn : in std_logic;
        emu_dc_s_axi_awaddr : in std_logic_vector(7-1 downto 0);
        emu_dc_s_axi_awvalid : in std_logic;
        emu_dc_s_axi_awready : out std_logic;
        emu_dc_s_axi_wdata : in std_logic_vector(32-1 downto 0);
        emu_dc_s_axi_wstrb : in std_logic_vector(32/8-1 downto 0);
        emu_dc_s_axi_wvalid : in std_logic;
        emu_dc_s_axi_wready : out std_logic;
        emu_dc_s_axi_bresp : out std_logic_vector(1 downto 0);
        emu_dc_s_axi_bvalid : out std_logic;
        emu_dc_s_axi_bready : in std_logic;
        emu_dc_s_axi_araddr : in std_logic_vector(7-1 downto 0);
        emu_dc_s_axi_arvalid : in std_logic;
        emu_dc_s_axi_arready : out std_logic;
        emu_dc_s_axi_rdata : out std_logic_vector(32-1 downto 0);
        emu_dc_s_axi_rresp : out std_logic_vector(1 downto 0);
        emu_dc_s_axi_rvalid : out std_logic;
        emu_dc_s_axi_rready : in std_logic
    );
end emu_dc_axi_lite_interface;
architecture structural of emu_dc_axi_lite_interface is 
component emu_dc_axi_lite_interface_verilog is
    port(
        voltage_pu_bit_conv2 : out std_logic_vector(31 downto 0);
        voltage_pu_bit_conv1 : out std_logic_vector(31 downto 0);
        ra : out std_logic_vector(31 downto 0);
        polepairs : out std_logic_vector(31 downto 0);
        magnetization_4q_1q : out std_logic_vector(0 downto 0);
        kn : out std_logic_vector(31 downto 0);
        k_fnmechtstep : out std_logic_vector(31 downto 0);
        current_pu_bit_conv2 : out std_logic_vector(31 downto 0);
        current_pu_bit_conv1 : out std_logic_vector(31 downto 0);
        vdc2 : out std_logic_vector(31 downto 0);
        vdc1 : out std_logic_vector(31 downto 0);
        ts_la : out std_logic_vector(31 downto 0);
        ts_tm : out std_logic_vector(31 downto 0);
        ts_tf : out std_logic_vector(31 downto 0);
        tl : out std_logic_vector(31 downto 0);
        tlsum : in std_logic_vector(31 downto 0);
        ia : in std_logic_vector(31 downto 0);
        if_x0 : in std_logic_vector(31 downto 0);
        motor_id : in std_logic_vector(31 downto 0);
        speed : in std_logic_vector(31 downto 0);
        te : in std_logic_vector(31 downto 0);
        theta_el : in std_logic_vector(31 downto 0);
        theta_mech : in std_logic_vector(31 downto 0);
        clk : out std_logic;
        emu_dc_aclk : in std_logic;
        emu_dc_aresetn : in std_logic;
        emu_dc_s_axi_awaddr : in std_logic_vector(7-1 downto 0);
        emu_dc_s_axi_awvalid : in std_logic;
        emu_dc_s_axi_awready : out std_logic;
        emu_dc_s_axi_wdata : in std_logic_vector(32-1 downto 0);
        emu_dc_s_axi_wstrb : in std_logic_vector(32/8-1 downto 0);
        emu_dc_s_axi_wvalid : in std_logic;
        emu_dc_s_axi_wready : out std_logic;
        emu_dc_s_axi_bresp : out std_logic_vector(1 downto 0);
        emu_dc_s_axi_bvalid : out std_logic;
        emu_dc_s_axi_bready : in std_logic;
        emu_dc_s_axi_araddr : in std_logic_vector(7-1 downto 0);
        emu_dc_s_axi_arvalid : in std_logic;
        emu_dc_s_axi_arready : out std_logic;
        emu_dc_s_axi_rdata : out std_logic_vector(32-1 downto 0);
        emu_dc_s_axi_rresp : out std_logic_vector(1 downto 0);
        emu_dc_s_axi_rvalid : out std_logic;
        emu_dc_s_axi_rready : in std_logic
    );
end component;
begin
inst : emu_dc_axi_lite_interface_verilog
    port map(
    voltage_pu_bit_conv2 => voltage_pu_bit_conv2,
    voltage_pu_bit_conv1 => voltage_pu_bit_conv1,
    ra => ra,
    polepairs => polepairs,
    magnetization_4q_1q => magnetization_4q_1q,
    kn => kn,
    k_fnmechtstep => k_fnmechtstep,
    current_pu_bit_conv2 => current_pu_bit_conv2,
    current_pu_bit_conv1 => current_pu_bit_conv1,
    vdc2 => vdc2,
    vdc1 => vdc1,
    ts_la => ts_la,
    ts_tm => ts_tm,
    ts_tf => ts_tf,
    tl => tl,
    tlsum => tlsum,
    ia => ia,
    if_x0 => if_x0,
    motor_id => motor_id,
    speed => speed,
    te => te,
    theta_el => theta_el,
    theta_mech => theta_mech,
    clk => clk,
    emu_dc_aclk => emu_dc_aclk,
    emu_dc_aresetn => emu_dc_aresetn,
    emu_dc_s_axi_awaddr => emu_dc_s_axi_awaddr,
    emu_dc_s_axi_awvalid => emu_dc_s_axi_awvalid,
    emu_dc_s_axi_awready => emu_dc_s_axi_awready,
    emu_dc_s_axi_wdata => emu_dc_s_axi_wdata,
    emu_dc_s_axi_wstrb => emu_dc_s_axi_wstrb,
    emu_dc_s_axi_wvalid => emu_dc_s_axi_wvalid,
    emu_dc_s_axi_wready => emu_dc_s_axi_wready,
    emu_dc_s_axi_bresp => emu_dc_s_axi_bresp,
    emu_dc_s_axi_bvalid => emu_dc_s_axi_bvalid,
    emu_dc_s_axi_bready => emu_dc_s_axi_bready,
    emu_dc_s_axi_araddr => emu_dc_s_axi_araddr,
    emu_dc_s_axi_arvalid => emu_dc_s_axi_arvalid,
    emu_dc_s_axi_arready => emu_dc_s_axi_arready,
    emu_dc_s_axi_rdata => emu_dc_s_axi_rdata,
    emu_dc_s_axi_rresp => emu_dc_s_axi_rresp,
    emu_dc_s_axi_rvalid => emu_dc_s_axi_rvalid,
    emu_dc_s_axi_rready => emu_dc_s_axi_rready
);
end structural;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

-------------------------------------------------------------------
 -- System Generator VHDL source file.
 --
 -- Copyright(C) 2018 by Xilinx, Inc.  All rights reserved.  This
 -- text/file contains proprietary, confidential information of Xilinx,
 -- Inc., is distributed under license from Xilinx, Inc., and may be used,
 -- copied and/or disclosed only pursuant to the terms of a valid license
 -- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
 -- this text/file solely for design, simulation, implementation and
 -- creation of design files limited to Xilinx devices or technologies.
 -- Use with non-Xilinx devices or technologies is expressly prohibited
 -- and immediately terminates your license unless covered by a separate
 -- agreement.
 --
 -- Xilinx is providing this design, code, or information "as is" solely
 -- for use in developing programs and solutions for Xilinx devices.  By
 -- providing this design, code, or information as one possible
 -- implementation of this feature, application or standard, Xilinx is
 -- making no representation that this implementation is free from any
 -- claims of infringement.  You are responsible for obtaining any rights
 -- you may require for your implementation.  Xilinx expressly disclaims
 -- any warranty whatsoever with respect to the adequacy of the
 -- implementation, including but not limited to warranties of
 -- merchantability or fitness for a particular purpose.
 --
 -- Xilinx products are not intended for use in life support appliances,
 -- devices, or systems.  Use in such applications is expressly prohibited.
 --
 -- Any modifications that are made to the source code are done at the user's
 -- sole risk and will be unsupported.
 --
 -- This copyright and support notice must be retained as part of this
 -- text at all times.  (c) Copyright 1995-2018 Xilinx, Inc.  All rights
 -- reserved.
 -------------------------------------------------------------------
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;

entity emu_dc_xladdsub is 
   generic (
     core_name0: string := "";
     a_width: integer := 16;
     a_bin_pt: integer := 4;
     a_arith: integer := xlUnsigned;
     c_in_width: integer := 16;
     c_in_bin_pt: integer := 4;
     c_in_arith: integer := xlUnsigned;
     c_out_width: integer := 16;
     c_out_bin_pt: integer := 4;
     c_out_arith: integer := xlUnsigned;
     b_width: integer := 8;
     b_bin_pt: integer := 2;
     b_arith: integer := xlUnsigned;
     s_width: integer := 17;
     s_bin_pt: integer := 4;
     s_arith: integer := xlUnsigned;
     rst_width: integer := 1;
     rst_bin_pt: integer := 0;
     rst_arith: integer := xlUnsigned;
     en_width: integer := 1;
     en_bin_pt: integer := 0;
     en_arith: integer := xlUnsigned;
     full_s_width: integer := 17;
     full_s_arith: integer := xlUnsigned;
     mode: integer := xlAddMode;
     extra_registers: integer := 0;
     latency: integer := 0;
     quantization: integer := xlTruncate;
     overflow: integer := xlWrap;
     c_latency: integer := 0;
     c_output_width: integer := 17;
     c_has_c_in : integer := 0;
     c_has_c_out : integer := 0
   );
   port (
     a: in std_logic_vector(a_width - 1 downto 0);
     b: in std_logic_vector(b_width - 1 downto 0);
     c_in : in std_logic_vector (0 downto 0) := "0";
     ce: in std_logic;
     clr: in std_logic := '0';
     clk: in std_logic;
     rst: in std_logic_vector(rst_width - 1 downto 0) := "0";
     en: in std_logic_vector(en_width - 1 downto 0) := "1";
     c_out : out std_logic_vector (0 downto 0);
     s: out std_logic_vector(s_width - 1 downto 0)
   );
 end emu_dc_xladdsub;
 
 architecture behavior of emu_dc_xladdsub is 
 component synth_reg
 generic (
 width: integer := 16;
 latency: integer := 5
 );
 port (
 i: in std_logic_vector(width - 1 downto 0);
 ce: in std_logic;
 clr: in std_logic;
 clk: in std_logic;
 o: out std_logic_vector(width - 1 downto 0)
 );
 end component;
 
 function format_input(inp: std_logic_vector; old_width, delta, new_arith,
 new_width: integer)
 return std_logic_vector
 is
 variable vec: std_logic_vector(old_width-1 downto 0);
 variable padded_inp: std_logic_vector((old_width + delta)-1 downto 0);
 variable result: std_logic_vector(new_width-1 downto 0);
 begin
 vec := inp;
 if (delta > 0) then
 padded_inp := pad_LSB(vec, old_width+delta);
 result := extend_MSB(padded_inp, new_width, new_arith);
 else
 result := extend_MSB(vec, new_width, new_arith);
 end if;
 return result;
 end;
 
 constant full_s_bin_pt: integer := fractional_bits(a_bin_pt, b_bin_pt);
 constant full_a_width: integer := full_s_width;
 constant full_b_width: integer := full_s_width;
 
 signal full_a: std_logic_vector(full_a_width - 1 downto 0);
 signal full_b: std_logic_vector(full_b_width - 1 downto 0);
 signal core_s: std_logic_vector(full_s_width - 1 downto 0);
 signal conv_s: std_logic_vector(s_width - 1 downto 0);
 signal temp_cout : std_logic;
 signal internal_clr: std_logic;
 signal internal_ce: std_logic;
 signal extra_reg_ce: std_logic;
 signal override: std_logic;
 signal logic1: std_logic_vector(0 downto 0);


 component emu_dc_c_addsub_v12_0_i0
    port ( 
    a: in std_logic_vector(33 - 1 downto 0);
    clk: in std_logic:= '0';
    ce: in std_logic:= '0';
    s: out std_logic_vector(c_output_width - 1 downto 0);
    b: in std_logic_vector(33 - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_c_addsub_v12_0_i1
    port ( 
    a: in std_logic_vector(65 - 1 downto 0);
    clk: in std_logic:= '0';
    ce: in std_logic:= '0';
    s: out std_logic_vector(c_output_width - 1 downto 0);
    b: in std_logic_vector(65 - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_c_addsub_v12_0_i2
    port ( 
    a: in std_logic_vector(33 - 1 downto 0);
    s: out std_logic_vector(c_output_width - 1 downto 0);
    b: in std_logic_vector(33 - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_c_addsub_v12_0_i3
    port ( 
    a: in std_logic_vector(33 - 1 downto 0);
    s: out std_logic_vector(c_output_width - 1 downto 0);
    b: in std_logic_vector(33 - 1 downto 0) 
 		  ); 
 end component;

begin
 internal_clr <= (clr or (rst(0))) and ce;
 internal_ce <= ce and en(0);
 logic1(0) <= '1';
 addsub_process: process (a, b, core_s)
 begin
 full_a <= format_input (a, a_width, b_bin_pt - a_bin_pt, a_arith,
 full_a_width);
 full_b <= format_input (b, b_width, a_bin_pt - b_bin_pt, b_arith,
 full_b_width);
 conv_s <= convert_type (core_s, full_s_width, full_s_bin_pt, full_s_arith,
 s_width, s_bin_pt, s_arith, quantization, overflow);
 end process addsub_process;


 comp0: if ((core_name0 = "emu_dc_c_addsub_v12_0_i0")) generate 
  core_instance0:emu_dc_c_addsub_v12_0_i0
   port map ( 
         a => full_a,
         clk => clk,
         ce => internal_ce,
         s => core_s,
         b => full_b
  ); 
   end generate;

 comp1: if ((core_name0 = "emu_dc_c_addsub_v12_0_i1")) generate 
  core_instance1:emu_dc_c_addsub_v12_0_i1
   port map ( 
         a => full_a,
         clk => clk,
         ce => internal_ce,
         s => core_s,
         b => full_b
  ); 
   end generate;

 comp2: if ((core_name0 = "emu_dc_c_addsub_v12_0_i2")) generate 
  core_instance2:emu_dc_c_addsub_v12_0_i2
   port map ( 
         a => full_a,
         s => core_s,
         b => full_b
  ); 
   end generate;

 comp3: if ((core_name0 = "emu_dc_c_addsub_v12_0_i3")) generate 
  core_instance3:emu_dc_c_addsub_v12_0_i3
   port map ( 
         a => full_a,
         s => core_s,
         b => full_b
  ); 
   end generate;

latency_test: if (extra_registers > 0) generate
 override_test: if (c_latency > 1) generate
 override_pipe: synth_reg
 generic map (
 width => 1,
 latency => c_latency
 )
 port map (
 i => logic1,
 ce => internal_ce,
 clr => internal_clr,
 clk => clk,
 o(0) => override);
 extra_reg_ce <= ce and en(0) and override;
 end generate override_test;
 no_override: if ((c_latency = 0) or (c_latency = 1)) generate
 extra_reg_ce <= ce and en(0);
 end generate no_override;
 extra_reg: synth_reg
 generic map (
 width => s_width,
 latency => extra_registers
 )
 port map (
 i => conv_s,
 ce => extra_reg_ce,
 clr => internal_clr,
 clk => clk,
 o => s
 );
 cout_test: if (c_has_c_out = 1) generate
 c_out_extra_reg: synth_reg
 generic map (
 width => 1,
 latency => extra_registers
 )
 port map (
 i(0) => temp_cout,
 ce => extra_reg_ce,
 clr => internal_clr,
 clk => clk,
 o => c_out
 );
 end generate cout_test;
 end generate;
 
 latency_s: if ((latency = 0) or (extra_registers = 0)) generate
 s <= conv_s;
 end generate latency_s;
 latency0: if (((latency = 0) or (extra_registers = 0)) and
 (c_has_c_out = 1)) generate
 c_out(0) <= temp_cout;
 end generate latency0;
 tie_dangling_cout: if (c_has_c_out = 0) generate
 c_out <= "0";
 end generate tie_dangling_cout;
 end architecture behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

-------------------------------------------------------------------
 -- System Generator VHDL source file.
 --
 -- Copyright(C) 2018 by Xilinx, Inc.  All rights reserved.  This
 -- text/file contains proprietary, confidential information of Xilinx,
 -- Inc., is distributed under license from Xilinx, Inc., and may be used,
 -- copied and/or disclosed only pursuant to the terms of a valid license
 -- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
 -- this text/file solely for design, simulation, implementation and
 -- creation of design files limited to Xilinx devices or technologies.
 -- Use with non-Xilinx devices or technologies is expressly prohibited
 -- and immediately terminates your license unless covered by a separate
 -- agreement.
 --
 -- Xilinx is providing this design, code, or information "as is" solely
 -- for use in developing programs and solutions for Xilinx devices.  By
 -- providing this design, code, or information as one possible
 -- implementation of this feature, application or standard, Xilinx is
 -- making no representation that this implementation is free from any
 -- claims of infringement.  You are responsible for obtaining any rights
 -- you may require for your implementation.  Xilinx expressly disclaims
 -- any warranty whatsoever with respect to the adequacy of the
 -- implementation, including but not limited to warranties of
 -- merchantability or fitness for a particular purpose.
 --
 -- Xilinx products are not intended for use in life support appliances,
 -- devices, or systems.  Use in such applications is expressly prohibited.
 --
 -- Any modifications that are made to the source code are done at the user's
 -- sole risk and will be unsupported.
 --
 -- This copyright and support notice must be retained as part of this
 -- text at all times.  (c) Copyright 1995-2018 Xilinx, Inc.  All rights
 -- reserved.
 -------------------------------------------------------------------
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;

entity emu_dc_xlcmult is 
   generic (
     core_name0: string := "";
     a_width: integer := 4;
     a_bin_pt: integer := 2;
     a_arith: integer := xlSigned;
     b_width: integer := 4;
     b_bin_pt: integer := 2;
     b_arith: integer := xlSigned;
     p_width: integer := 8;
     p_bin_pt: integer := 2;
     p_arith: integer := xlSigned;
     rst_width: integer := 1;
     rst_bin_pt: integer := 0;
     rst_arith: integer := xlUnsigned;
     en_width: integer := 1;
     en_bin_pt: integer := 0;
     en_arith: integer := xlUnsigned;
     multsign: integer := xlSigned;
     quantization: integer := xlTruncate;
     overflow: integer := xlWrap;
     extra_registers: integer := 0;
     c_a_width: integer := 7;
     c_b_width: integer := 7;
     c_a_type: integer := 0;
     c_b_type: integer := 0;
     c_type: integer := 0;
     const_bin_pt: integer := 1;
     zero_const : integer := 0;
     c_output_width: integer := 16
   );
   port (
     a: in std_logic_vector(a_width - 1 downto 0);
     ce: in std_logic;
     clr: in std_logic;
     clk: in std_logic;
     core_ce: in std_logic:= '0';
     core_clr: in std_logic:= '0';
     core_clk: in std_logic:= '0';
     rst: in std_logic_vector(rst_width - 1 downto 0);
     en: in std_logic_vector(en_width - 1 downto 0);
     p: out std_logic_vector(p_width - 1 downto 0)
   );
 end emu_dc_xlcmult;
 
 architecture behavior of emu_dc_xlcmult is
 component synth_reg
 generic (
 width: integer := 16;
 latency: integer := 5
 );
 port (
 i: in std_logic_vector(width - 1 downto 0);
 ce: in std_logic;
 clr: in std_logic;
 clk: in std_logic;
 o: out std_logic_vector(width - 1 downto 0)
 );
 end component;
 signal tmp_a: std_logic_vector(c_a_width - 1 downto 0);
 signal tmp_p: std_logic_vector(c_output_width - 1 downto 0);
 signal conv_p: std_logic_vector(p_width - 1 downto 0);
 -- synthesis translate_off
 signal real_a, real_p: real;
 -- synthesis translate_on
 signal nd: std_logic;
 signal internal_ce: std_logic;
 signal internal_clr: std_logic;
 signal internal_core_ce: std_logic;


 component emu_dc_mult_gen_v12_0_i1
    port ( 
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      p: out std_logic_vector(c_output_width - 1 downto 0);
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

begin
 -- synthesis translate_off
 -- synthesis translate_on
 input_process: process(a)
 variable tmp_p_bin_pt, tmp_p_arith: integer;
 begin
 tmp_a <= zero_ext(a, c_a_width);
 end process;
 output_process: process(tmp_p)
 begin
 conv_p <= convert_type(tmp_p, c_output_width, a_bin_pt+b_bin_pt, multsign,
 p_width, p_bin_pt, p_arith, quantization, overflow);
 end process;
 internal_ce <= ce and en(0);
 internal_core_ce <= core_ce and en(0);
 internal_clr <= (clr or rst(0)) and ce;
 nd <= internal_ce;


 comp0: if ((core_name0 = "emu_dc_mult_gen_v12_0_i1")) generate 
  core_instance0:emu_dc_mult_gen_v12_0_i1
   port map ( 
      sclr => internal_clr,
      clk => clk,
      ce => internal_ce,
      p => tmp_p,
      a => tmp_a
  ); 
   end generate;

latency_gt_0: if (extra_registers > 0) and (zero_const = 0)
 generate
 reg: synth_reg
 generic map (
 width => p_width,
 latency => extra_registers
 )
 port map (
 i => conv_p,
 ce => internal_ce,
 clr => internal_clr,
 clk => clk,
 o => p
 );
 end generate;
 latency0: if ( (extra_registers = 0) and (zero_const = 0) )
 generate
 p <= conv_p;
 end generate latency0;
 zero_constant: if (zero_const = 1)
 generate
 p <= integer_to_std_logic_vector(0,p_width,p_arith);
 end generate zero_constant;
 end architecture behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

---------------------------------------------------------------------
 --
 --  Filename      : xlcounter.vhd
 --
 --  Created       : 5/31/00
 --  Modified      : 6/7/00
 --
 --  Description   : VHDL wrapper for a counter. This wrapper
 --                  uses the Binary Counter CoreGenerator core.
 --
 ---------------------------------------------------------------------
 
 
 ---------------------------------------------------------------------
 --
 --  Entity        : xlcounter
 --
 --  Architecture  : behavior
 --
 --  Description   : Top level VHDL description of a counter.
 --
 ---------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;

entity emu_dc_xlcounter_limit is 
   generic (
     core_name0: string := "";
     op_width: integer := 5;
     op_arith: integer := xlSigned;
     cnt_63_48: integer:= 0;
     cnt_47_32: integer:= 0;
     cnt_31_16: integer:= 0;
     cnt_15_0: integer:= 0;
     count_limited: integer := 0		-- 0 if cnt_to = (2^n)-1 else 1
   );
   port (
     ce: in std_logic;
     clr: in std_logic;
     clk: in std_logic;
     op: out std_logic_vector(op_width - 1 downto 0);
     up: in std_logic_vector(0 downto 0) := (others => '0');
     en: in std_logic_vector(0 downto 0);
     rst: in std_logic_vector(0 downto 0)
   );
 end emu_dc_xlcounter_limit;
 
 architecture behavior of emu_dc_xlcounter_limit is
 signal high_cnt_to: std_logic_vector(31 downto 0);
 signal low_cnt_to: std_logic_vector(31 downto 0);
 signal cnt_to: std_logic_vector(63 downto 0);
 signal core_sinit, op_thresh0, core_ce: std_logic;
 signal rst_overrides_en: std_logic;
 signal op_net: std_logic_vector(op_width - 1 downto 0);
 
 -- synthesis translate_off
 signal real_op : real; -- For debugging info ports
 -- synthesis translate_on
 
 function equals(op, cnt_to : std_logic_vector; width, arith : integer)
 return std_logic
 is
 variable signed_op, signed_cnt_to : signed (width - 1 downto 0);
 variable unsigned_op, unsigned_cnt_to : unsigned (width - 1 downto 0);
 variable result : std_logic;
 begin
 -- synthesis translate_off
 if ((is_XorU(op)) or (is_XorU(cnt_to)) ) then
 result := '0';
 return result;
 end if;
 -- synthesis translate_on
 
 if (op = cnt_to) then
 result := '1';
 else
 result := '0';
 end if;
 return result;
 end;


 component emu_dc_c_counter_binary_v12_0_i0
    port ( 
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0) 
 		  ); 
 end component;

-- synthesis translate_off
   constant zeroVec : std_logic_vector(op_width - 1 downto 0) := (others => '0');
   constant oneVec : std_logic_vector(op_width - 1 downto 0) := (others => '1');
   constant zeroStr : string(1 to op_width) :=
     std_logic_vector_to_bin_string(zeroVec);
   constant oneStr : string(1 to op_width) :=
     std_logic_vector_to_bin_string(oneVec);
 -- synthesis translate_on
 
 begin
   -- Debugging info for internal full precision variables
   -- synthesis translate_off
 --     real_op <= to_real(op, op_bin_pt, op_arith);
   -- synthesis translate_on
 
   cnt_to(63 downto 48) <= integer_to_std_logic_vector(cnt_63_48, 16, op_arith);
   cnt_to(47 downto 32) <= integer_to_std_logic_vector(cnt_47_32, 16, op_arith);
   cnt_to(31 downto 16) <= integer_to_std_logic_vector(cnt_31_16, 16, op_arith);
   cnt_to(15 downto 0) <= integer_to_std_logic_vector(cnt_15_0, 16, op_arith);
 
   -- Output of counter always valid
   op <= op_net;
   core_ce <= ce and en(0);
   rst_overrides_en <= rst(0) or en(0);
 
   limit : if (count_limited = 1) generate
     eq_cnt_to : process (op_net, cnt_to)
     begin
       -- Had to pass cnt_to(op_width - 1 downto 0) instead of cnt_to so
       -- that XST would infer a macro
       op_thresh0 <= equals(op_net, cnt_to(op_width - 1 downto 0),
                      op_width, op_arith);
     end process;
 
     core_sinit <= (op_thresh0 or clr or rst(0)) and ce and rst_overrides_en;
   end generate;
 
   no_limit : if (count_limited = 0) generate
     core_sinit <= (clr or rst(0)) and ce and rst_overrides_en;
   end generate;


 comp0: if ((core_name0 = "emu_dc_c_counter_binary_v12_0_i0")) generate 
  core_instance0:emu_dc_c_counter_binary_v12_0_i0
   port map ( 
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
  ); 
   end generate;

end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

-------------------------------------------------------------------
 -- System Generator VHDL source file.
 --
 -- Copyright(C) 2018 by Xilinx, Inc.  All rights reserved.  This
 -- text/file contains proprietary, confidential information of Xilinx,
 -- Inc., is distributed under license from Xilinx, Inc., and may be used,
 -- copied and/or disclosed only pursuant to the terms of a valid license
 -- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
 -- this text/file solely for design, simulation, implementation and
 -- creation of design files limited to Xilinx devices or technologies.
 -- Use with non-Xilinx devices or technologies is expressly prohibited
 -- and immediately terminates your license unless covered by a separate
 -- agreement.
 --
 -- Xilinx is providing this design, code, or information "as is" solely
 -- for use in developing programs and solutions for Xilinx devices.  By
 -- providing this design, code, or information as one possible
 -- implementation of this feature, application or standard, Xilinx is
 -- making no representation that this implementation is free from any
 -- claims of infringement.  You are responsible for obtaining any rights
 -- you may require for your implementation.  Xilinx expressly disclaims
 -- any warranty whatsoever with respect to the adequacy of the
 -- implementation, including but not limited to warranties of
 -- merchantability or fitness for a particular purpose.
 --
 -- Xilinx products are not intended for use in life support appliances,
 -- devices, or systems.  Use in such applications is expressly prohibited.
 --
 -- Any modifications that are made to the source code are done at the user's
 -- sole risk and will be unsupported.
 --
 -- This copyright and support notice must be retained as part of this
 -- text at all times.  (c) Copyright 1995-2018 Xilinx, Inc.  All rights
 -- reserved.
 -------------------------------------------------------------------
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;

entity emu_dc_xlmult is 
   generic (
     core_name0: string := "";
     a_width: integer := 4;
     a_bin_pt: integer := 2;
     a_arith: integer := xlSigned;
     b_width: integer := 4;
     b_bin_pt: integer := 1;
     b_arith: integer := xlSigned;
     p_width: integer := 8;
     p_bin_pt: integer := 2;
     p_arith: integer := xlSigned;
     rst_width: integer := 1;
     rst_bin_pt: integer := 0;
     rst_arith: integer := xlUnsigned;
     en_width: integer := 1;
     en_bin_pt: integer := 0;
     en_arith: integer := xlUnsigned;
     quantization: integer := xlTruncate;
     overflow: integer := xlWrap;
     extra_registers: integer := 0;
     c_a_width: integer := 7;
     c_b_width: integer := 7;
     c_type: integer := 0;
     c_a_type: integer := 0;
     c_b_type: integer := 0;
     c_pipelined: integer := 1;
     c_baat: integer := 4;
     multsign: integer := xlSigned;
     c_output_width: integer := 16
   );
   port (
     a: in std_logic_vector(a_width - 1 downto 0);
     b: in std_logic_vector(b_width - 1 downto 0);
     ce: in std_logic;
     clr: in std_logic;
     clk: in std_logic;
     core_ce: in std_logic := '0';
     core_clr: in std_logic := '0';
     core_clk: in std_logic := '0';
     rst: in std_logic_vector(rst_width - 1 downto 0);
     en: in std_logic_vector(en_width - 1 downto 0);
     p: out std_logic_vector(p_width - 1 downto 0)
   );
 end  emu_dc_xlmult;
 
 architecture behavior of emu_dc_xlmult is
 component synth_reg
 generic (
 width: integer := 16;
 latency: integer := 5
 );
 port (
 i: in std_logic_vector(width - 1 downto 0);
 ce: in std_logic;
 clr: in std_logic;
 clk: in std_logic;
 o: out std_logic_vector(width - 1 downto 0)
 );
 end component;


 component emu_dc_mult_gen_v12_0_i0
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_mult_gen_v12_0_i2
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_mult_gen_v12_0_i3
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_mult_gen_v12_0_i4
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_mult_gen_v12_0_i5
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

 component emu_dc_mult_gen_v12_0_i6
    port ( 
      b: in std_logic_vector(c_b_width - 1 downto 0);
      p: out std_logic_vector(c_output_width - 1 downto 0);
      clk: in std_logic;
      ce: in std_logic;
      sclr: in std_logic;
      a: in std_logic_vector(c_a_width - 1 downto 0) 
 		  ); 
 end component;

signal tmp_a: std_logic_vector(c_a_width - 1 downto 0);
 signal conv_a: std_logic_vector(c_a_width - 1 downto 0);
 signal tmp_b: std_logic_vector(c_b_width - 1 downto 0);
 signal conv_b: std_logic_vector(c_b_width - 1 downto 0);
 signal tmp_p: std_logic_vector(c_output_width - 1 downto 0);
 signal conv_p: std_logic_vector(p_width - 1 downto 0);
 -- synthesis translate_off
 signal real_a, real_b, real_p: real;
 -- synthesis translate_on
 signal rfd: std_logic;
 signal rdy: std_logic;
 signal nd: std_logic;
 signal internal_ce: std_logic;
 signal internal_clr: std_logic;
 signal internal_core_ce: std_logic;
 begin
 -- synthesis translate_off
 -- synthesis translate_on
 internal_ce <= ce and en(0);
 internal_core_ce <= core_ce and en(0);
 internal_clr <= (clr or rst(0)) and ce;
 nd <= internal_ce;
 input_process: process (a,b)
 begin
 tmp_a <= zero_ext(a, c_a_width);
 tmp_b <= zero_ext(b, c_b_width);
 end process;
 output_process: process (tmp_p)
 begin
 conv_p <= convert_type(tmp_p, c_output_width, a_bin_pt+b_bin_pt, multsign,
 p_width, p_bin_pt, p_arith, quantization, overflow);
 end process;


 comp0: if ((core_name0 = "emu_dc_mult_gen_v12_0_i0")) generate 
  core_instance0:emu_dc_mult_gen_v12_0_i0
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

 comp1: if ((core_name0 = "emu_dc_mult_gen_v12_0_i2")) generate 
  core_instance1:emu_dc_mult_gen_v12_0_i2
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

 comp2: if ((core_name0 = "emu_dc_mult_gen_v12_0_i3")) generate 
  core_instance2:emu_dc_mult_gen_v12_0_i3
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

 comp3: if ((core_name0 = "emu_dc_mult_gen_v12_0_i4")) generate 
  core_instance3:emu_dc_mult_gen_v12_0_i4
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

 comp4: if ((core_name0 = "emu_dc_mult_gen_v12_0_i5")) generate 
  core_instance4:emu_dc_mult_gen_v12_0_i5
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

 comp5: if ((core_name0 = "emu_dc_mult_gen_v12_0_i6")) generate 
  core_instance5:emu_dc_mult_gen_v12_0_i6
   port map ( 
        a => tmp_a,
        clk => clk,
        ce => internal_ce,
        sclr => internal_clr,
        p => tmp_p,
        b => tmp_b
  ); 
   end generate;

latency_gt_0: if (extra_registers > 0) generate
 reg: synth_reg
 generic map (
 width => p_width,
 latency => extra_registers
 )
 port map (
 i => conv_p,
 ce => internal_ce,
 clr => internal_clr,
 clk => clk,
 o => p
 );
 end generate;
 latency_eq_0: if (extra_registers = 0) generate
 p <= conv_p;
 end generate;
 end architecture behavior;

