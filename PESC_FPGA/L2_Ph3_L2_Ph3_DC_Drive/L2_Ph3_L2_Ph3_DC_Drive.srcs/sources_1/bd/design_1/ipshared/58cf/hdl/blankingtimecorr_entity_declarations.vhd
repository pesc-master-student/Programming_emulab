-------------------------------------------------------------------
-- System Generator version 2017.2 VHDL source file.
--
-- Copyright(C) 2017 by Xilinx, Inc.  All rights reserved.  This
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
-- text at all times.  (c) Copyright 1995-2017 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

---------------------------------------------------------------------
--
--  Filename      : xlslice.vhd
--
--  Description   : VHDL description of a block that sets the output to a
--                  specified range of the input bits. The output is always
--                  set to an unsigned type with it's binary point at zero.
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity blankingtimecorr_xlslice is
    generic (
        new_msb      : integer := 9;           -- position of new msb
        new_lsb      : integer := 1;           -- position of new lsb
        x_width      : integer := 16;          -- Width of x input
        y_width      : integer := 8);          -- Width of y output
    port (
        x : in std_logic_vector (x_width-1 downto 0);
        y : out std_logic_vector (y_width-1 downto 0));
end blankingtimecorr_xlslice;

architecture behavior of blankingtimecorr_xlslice is
begin
    y <= x(new_msb downto new_lsb);
end  behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_constant_92fca9b0f5 is
  port (
    op : out std_logic_vector((16 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_constant_92fca9b0f5;
architecture behavior of sysgen_constant_92fca9b0f5
is
begin
  op <= "0000000000000000";
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;


entity blankingtimecorr_xldelay is
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

end blankingtimecorr_xldelay;

architecture behavior of blankingtimecorr_xldelay is
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
entity sysgen_inverter_4779162bd7 is
  port (
    ip : in std_logic_vector((1 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_inverter_4779162bd7;
architecture behavior of sysgen_inverter_4779162bd7
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
entity sysgen_logical_ef36cd3004 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_ef36cd3004;
architecture behavior of sysgen_logical_ef36cd3004
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
entity sysgen_logical_41e6918a05 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_41e6918a05;
architecture behavior of sysgen_logical_41e6918a05
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
  signal unregy_3_1_convert: std_logic_vector((1 - 1) downto 0);
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 or d1_1_27;
  unregy_3_1_convert <= cast(std_logic_to_vector(fully_2_1_bit), 0, 1, 0, xlUnsigned);
  y <= unregy_3_1_convert;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_efbfa67d13 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    en : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_efbfa67d13;
architecture behavior of sysgen_logical_efbfa67d13
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal en_1_30: std_logic;
  type array_type_latency_pipe_5_26 is array (0 to (1 - 1)) of std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26: array_type_latency_pipe_5_26 := (
    0 => "0");
  signal latency_pipe_5_26_front_din: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26_back: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26_push_front_pop_back_en: std_logic;
  signal fully_2_1_bit: std_logic;
  signal unregy_3_1_convert: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_shift_join_7_1: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_shift_join_7_1_en: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  en_1_30 <= en(0);
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
  fully_2_1_bit <= d0_1_24 or d1_1_27;
  unregy_3_1_convert <= cast(std_logic_to_vector(fully_2_1_bit), 0, 1, 0, xlUnsigned);
  proc_if_7_1: process (en_1_30, unregy_3_1_convert)
  is
  begin
    if en_1_30 = '1' then
      latency_pipe_shift_join_7_1_en <= '1';
    else 
      latency_pipe_shift_join_7_1_en <= '0';
    end if;
    latency_pipe_shift_join_7_1 <= unregy_3_1_convert;
  end process proc_if_7_1;
  latency_pipe_5_26_front_din <= latency_pipe_shift_join_7_1;
  latency_pipe_5_26_push_front_pop_back_en <= latency_pipe_shift_join_7_1_en;
  y <= latency_pipe_5_26_back;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_912fe01300 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_912fe01300;
architecture behavior of sysgen_logical_912fe01300
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
  signal unregy_3_1_convert: std_logic_vector((1 - 1) downto 0);
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  unregy_3_1_convert <= cast(std_logic_to_vector(fully_2_1_bit), 0, 1, 0, xlUnsigned);
  y <= unregy_3_1_convert;
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_logical_606816afb7 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    en : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_logical_606816afb7;
architecture behavior of sysgen_logical_606816afb7
is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal en_1_30: std_logic;
  type array_type_latency_pipe_5_26 is array (0 to (1 - 1)) of std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26: array_type_latency_pipe_5_26 := (
    0 => "0");
  signal latency_pipe_5_26_front_din: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26_back: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_5_26_push_front_pop_back_en: std_logic;
  signal fully_2_1_bit: std_logic;
  signal unregy_3_1_convert: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_shift_join_7_1: std_logic_vector((1 - 1) downto 0);
  signal latency_pipe_shift_join_7_1_en: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  en_1_30 <= en(0);
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
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  unregy_3_1_convert <= cast(std_logic_to_vector(fully_2_1_bit), 0, 1, 0, xlUnsigned);
  proc_if_7_1: process (en_1_30, unregy_3_1_convert)
  is
  begin
    if en_1_30 = '1' then
      latency_pipe_shift_join_7_1_en <= '1';
    else 
      latency_pipe_shift_join_7_1_en <= '0';
    end if;
    latency_pipe_shift_join_7_1 <= unregy_3_1_convert;
  end process proc_if_7_1;
  latency_pipe_5_26_front_din <= latency_pipe_shift_join_7_1;
  latency_pipe_5_26_push_front_pop_back_en <= latency_pipe_shift_join_7_1_en;
  y <= latency_pipe_5_26_back;
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


entity blankingtimecorr_xlregister is

   generic (d_width          : integer := 5;          -- Width of d input
            init_value       : bit_vector := b"00");  -- Binary init value string

   port (d   : in std_logic_vector (d_width-1 downto 0);
         rst : in std_logic_vector(0 downto 0) := "0";
         en  : in std_logic_vector(0 downto 0) := "1";
         ce  : in std_logic;
         clk : in std_logic;
         q   : out std_logic_vector (d_width-1 downto 0));

end blankingtimecorr_xlregister;

architecture behavior of blankingtimecorr_xlregister is

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
entity sysgen_relational_c3849d09cf is
  port (
    a : in std_logic_vector((16 - 1) downto 0);
    b : in std_logic_vector((16 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_c3849d09cf;
architecture behavior of sysgen_relational_c3849d09cf
is
  signal a_1_31: signed((16 - 1) downto 0);
  signal b_1_34: signed((16 - 1) downto 0);
  signal cast_16_12: signed((30 - 1) downto 0);
  signal cast_16_16: signed((30 - 1) downto 0);
  signal result_16_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_signed(a);
  b_1_34 <= std_logic_vector_to_signed(b);
  cast_16_12 <= s2s_cast(a_1_31, 14, 30, 14);
  cast_16_16 <= s2s_cast(b_1_34, 0, 30, 14);
  result_16_3_rel <= cast_16_12 < cast_16_16;
  op <= boolean_to_vector(result_16_3_rel);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_relational_2f58baf397 is
  port (
    a : in std_logic_vector((16 - 1) downto 0);
    b : in std_logic_vector((16 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_2f58baf397;
architecture behavior of sysgen_relational_2f58baf397
is
  signal a_1_31: signed((16 - 1) downto 0);
  signal b_1_34: signed((16 - 1) downto 0);
  signal cast_16_12: signed((30 - 1) downto 0);
  signal cast_16_16: signed((30 - 1) downto 0);
  signal result_16_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_signed(a);
  b_1_34 <= std_logic_vector_to_signed(b);
  cast_16_12 <= s2s_cast(a_1_31, 0, 30, 14);
  cast_16_16 <= s2s_cast(b_1_34, 14, 30, 14);
  result_16_3_rel <= cast_16_12 < cast_16_16;
  op <= boolean_to_vector(result_16_3_rel);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sysgen_relational_849cf2ec16 is
  port (
    a : in std_logic_vector((18 - 1) downto 0);
    b : in std_logic_vector((16 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_relational_849cf2ec16;
architecture behavior of sysgen_relational_849cf2ec16
is
  signal a_1_31: unsigned((18 - 1) downto 0);
  signal b_1_34: signed((16 - 1) downto 0);
  signal cast_18_12: signed((19 - 1) downto 0);
  signal cast_18_16: signed((19 - 1) downto 0);
  signal result_18_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_signed(b);
  cast_18_12 <= u2s_cast(a_1_31, 0, 19, 0);
  cast_18_16 <= s2s_cast(b_1_34, 0, 19, 0);
  result_18_3_rel <= cast_18_12 > cast_18_16;
  op <= boolean_to_vector(result_18_3_rel);
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


entity convert_func_call_blankingtimecorr_xlconvert is
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
end convert_func_call_blankingtimecorr_xlconvert ;

architecture behavior of convert_func_call_blankingtimecorr_xlconvert is
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


entity blankingtimecorr_xlconvert  is
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

end blankingtimecorr_xlconvert ;

architecture behavior of blankingtimecorr_xlconvert  is

    component synth_reg
        generic (width       : integer;
                 latency     : integer);
        port (i       : in std_logic_vector(width-1 downto 0);
              ce      : in std_logic;
              clr     : in std_logic;
              clk     : in std_logic;
              o       : out std_logic_vector(width-1 downto 0));
    end component;

    component convert_func_call_blankingtimecorr_xlconvert 
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
      convert : convert_func_call_blankingtimecorr_xlconvert 
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
entity sysgen_inverter_0a189768af is
  port (
    ip : in std_logic_vector((1 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end sysgen_inverter_0a189768af;
architecture behavior of sysgen_inverter_0a189768af
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
  op_mem_22_20_front_din <= internal_ip_12_1_bitnot;
  op_mem_22_20_push_front_pop_back_en <= '1';
  op <= boolean_to_vector(op_mem_22_20_back);
end behavior;

library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity blankingtimecorr_axi_lite_interface is 
    port(
        ic_in : out std_logic_vector(15 downto 0);
        ib_in : out std_logic_vector(15 downto 0);
        ia_in : out std_logic_vector(15 downto 0);
        blankingtime : out std_logic_vector(15 downto 0);
        t_samp_on : in std_logic_vector(31 downto 0);
        ta_on : in std_logic_vector(31 downto 0);
        tb_on : in std_logic_vector(31 downto 0);
        tc_on : in std_logic_vector(31 downto 0);
        clk : out std_logic;
        blankingtimecorr_aclk : in std_logic;
        blankingtimecorr_aresetn : in std_logic;
        blankingtimecorr_s_axi_awaddr : in std_logic_vector(5-1 downto 0);
        blankingtimecorr_s_axi_awvalid : in std_logic;
        blankingtimecorr_s_axi_awready : out std_logic;
        blankingtimecorr_s_axi_wdata : in std_logic_vector(32-1 downto 0);
        blankingtimecorr_s_axi_wstrb : in std_logic_vector(32/8-1 downto 0);
        blankingtimecorr_s_axi_wvalid : in std_logic;
        blankingtimecorr_s_axi_wready : out std_logic;
        blankingtimecorr_s_axi_bresp : out std_logic_vector(1 downto 0);
        blankingtimecorr_s_axi_bvalid : out std_logic;
        blankingtimecorr_s_axi_bready : in std_logic;
        blankingtimecorr_s_axi_araddr : in std_logic_vector(5-1 downto 0);
        blankingtimecorr_s_axi_arvalid : in std_logic;
        blankingtimecorr_s_axi_arready : out std_logic;
        blankingtimecorr_s_axi_rdata : out std_logic_vector(32-1 downto 0);
        blankingtimecorr_s_axi_rresp : out std_logic_vector(1 downto 0);
        blankingtimecorr_s_axi_rvalid : out std_logic;
        blankingtimecorr_s_axi_rready : in std_logic
    );
end blankingtimecorr_axi_lite_interface;
architecture structural of blankingtimecorr_axi_lite_interface is 
component blankingtimecorr_axi_lite_interface_verilog is
    port(
        ic_in : out std_logic_vector(15 downto 0);
        ib_in : out std_logic_vector(15 downto 0);
        ia_in : out std_logic_vector(15 downto 0);
        blankingtime : out std_logic_vector(15 downto 0);
        t_samp_on : in std_logic_vector(31 downto 0);
        ta_on : in std_logic_vector(31 downto 0);
        tb_on : in std_logic_vector(31 downto 0);
        tc_on : in std_logic_vector(31 downto 0);
        clk : out std_logic;
        blankingtimecorr_aclk : in std_logic;
        blankingtimecorr_aresetn : in std_logic;
        blankingtimecorr_s_axi_awaddr : in std_logic_vector(5-1 downto 0);
        blankingtimecorr_s_axi_awvalid : in std_logic;
        blankingtimecorr_s_axi_awready : out std_logic;
        blankingtimecorr_s_axi_wdata : in std_logic_vector(32-1 downto 0);
        blankingtimecorr_s_axi_wstrb : in std_logic_vector(32/8-1 downto 0);
        blankingtimecorr_s_axi_wvalid : in std_logic;
        blankingtimecorr_s_axi_wready : out std_logic;
        blankingtimecorr_s_axi_bresp : out std_logic_vector(1 downto 0);
        blankingtimecorr_s_axi_bvalid : out std_logic;
        blankingtimecorr_s_axi_bready : in std_logic;
        blankingtimecorr_s_axi_araddr : in std_logic_vector(5-1 downto 0);
        blankingtimecorr_s_axi_arvalid : in std_logic;
        blankingtimecorr_s_axi_arready : out std_logic;
        blankingtimecorr_s_axi_rdata : out std_logic_vector(32-1 downto 0);
        blankingtimecorr_s_axi_rresp : out std_logic_vector(1 downto 0);
        blankingtimecorr_s_axi_rvalid : out std_logic;
        blankingtimecorr_s_axi_rready : in std_logic
    );
end component;
begin
inst : blankingtimecorr_axi_lite_interface_verilog
    port map(
    ic_in => ic_in,
    ib_in => ib_in,
    ia_in => ia_in,
    blankingtime => blankingtime,
    t_samp_on => t_samp_on,
    ta_on => ta_on,
    tb_on => tb_on,
    tc_on => tc_on,
    clk => clk,
    blankingtimecorr_aclk => blankingtimecorr_aclk,
    blankingtimecorr_aresetn => blankingtimecorr_aresetn,
    blankingtimecorr_s_axi_awaddr => blankingtimecorr_s_axi_awaddr,
    blankingtimecorr_s_axi_awvalid => blankingtimecorr_s_axi_awvalid,
    blankingtimecorr_s_axi_awready => blankingtimecorr_s_axi_awready,
    blankingtimecorr_s_axi_wdata => blankingtimecorr_s_axi_wdata,
    blankingtimecorr_s_axi_wstrb => blankingtimecorr_s_axi_wstrb,
    blankingtimecorr_s_axi_wvalid => blankingtimecorr_s_axi_wvalid,
    blankingtimecorr_s_axi_wready => blankingtimecorr_s_axi_wready,
    blankingtimecorr_s_axi_bresp => blankingtimecorr_s_axi_bresp,
    blankingtimecorr_s_axi_bvalid => blankingtimecorr_s_axi_bvalid,
    blankingtimecorr_s_axi_bready => blankingtimecorr_s_axi_bready,
    blankingtimecorr_s_axi_araddr => blankingtimecorr_s_axi_araddr,
    blankingtimecorr_s_axi_arvalid => blankingtimecorr_s_axi_arvalid,
    blankingtimecorr_s_axi_arready => blankingtimecorr_s_axi_arready,
    blankingtimecorr_s_axi_rdata => blankingtimecorr_s_axi_rdata,
    blankingtimecorr_s_axi_rresp => blankingtimecorr_s_axi_rresp,
    blankingtimecorr_s_axi_rvalid => blankingtimecorr_s_axi_rvalid,
    blankingtimecorr_s_axi_rready => blankingtimecorr_s_axi_rready
);
end structural;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;

---------------------------------------------------------------------
 --
 --  Filename      : xlcounter_rst.vhd
 --
 --  Created       : 1/31/01
 --  Modified      :
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

entity blankingtimecorr_xlcounter_free is 
   generic (
     core_name0: string := "";
     op_width: integer := 5;
     op_arith: integer := xlSigned
   );
   port (
     ce: in std_logic;
     clr: in std_logic;
     clk: in std_logic;
     op: out std_logic_vector(op_width - 1 downto 0);
     up: in std_logic_vector(0 downto 0) := (others => '0');
     load: in std_logic_vector(0 downto 0) := (others => '0');
     din: in std_logic_vector(op_width - 1 downto 0) := (others => '0');
     en: in std_logic_vector(0 downto 0);
     rst: in std_logic_vector(0 downto 0)
   );
 end blankingtimecorr_xlcounter_free;
 
 architecture behavior of blankingtimecorr_xlcounter_free is


 component blankingtimecorr_c_counter_binary_v12_0_i0
    port ( 
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0) 
 		  ); 
 end component;

 component blankingtimecorr_c_counter_binary_v12_0_i1
    port ( 
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0) 
 		  ); 
 end component;

-- synthesis translate_off
   constant zeroVec: std_logic_vector(op_width - 1 downto 0) := (others => '0');
   constant oneVec: std_logic_vector(op_width - 1 downto 0) := (others => '1');
   constant zeroStr: string(1 to op_width) :=
     std_logic_vector_to_bin_string(zeroVec);
   constant oneStr: string(1 to op_width) :=
     std_logic_vector_to_bin_string(oneVec);
 -- synthesis translate_on
 
   signal core_sinit: std_logic;
   signal core_ce: std_logic;
   signal op_net: std_logic_vector(op_width - 1 downto 0);
 begin
   core_ce <= ce and en(0);
   core_sinit <= (clr or rst(0)) and ce;
   op <= op_net;


 comp0: if ((core_name0 = "blankingtimecorr_c_counter_binary_v12_0_i0")) generate 
  core_instance0:blankingtimecorr_c_counter_binary_v12_0_i0
   port map ( 
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
  ); 
   end generate;

 comp1: if ((core_name0 = "blankingtimecorr_c_counter_binary_v12_0_i1")) generate 
  core_instance1:blankingtimecorr_c_counter_binary_v12_0_i1
   port map ( 
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
  ); 
   end generate;

end behavior;

