-- Generated from Simulink block emu_dc/Integrator_modified1/SaturationBlock
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_saturationblock is
  port (
    in_x0 : in std_logic_vector( 64-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    disable_pulse : out std_logic_vector( 1-1 downto 0 )
  );
end emu_dc_saturationblock;
architecture structural of emu_dc_saturationblock is 
  signal mux_y_net : std_logic_vector( 64-1 downto 0 );
  signal ce_net : std_logic;
  signal clk_net : std_logic;
  signal relational_op_net : std_logic_vector( 1-1 downto 0 );
  signal min_op_net : std_logic_vector( 64-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal max_op_net : std_logic_vector( 64-1 downto 0 );
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
begin
  disable_pulse <= inverter1_op_net;
  register6_q_net <= in_x0;
  clk_net <= clk_1;
  ce_net <= ce_1;
  inverter1 : entity xil_defaultlib.sysgen_inverter_aa453897ef 
  port map (
    clr => '0',
    ip => logical1_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_f5c169eedd 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational1_op_net,
    d1 => relational_op_net,
    y => logical1_y_net
  );
  max : entity xil_defaultlib.sysgen_constant_64f7e3bb3d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => max_op_net
  );
  min : entity xil_defaultlib.sysgen_constant_c1e2e26b84 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => min_op_net
  );
  mux : entity xil_defaultlib.sysgen_mux_f74f0d24ce 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => relational_op_net,
    d0 => register6_q_net,
    d1 => max_op_net,
    y => mux_y_net
  );
  relational : entity xil_defaultlib.sysgen_relational_03e5441b28 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => register6_q_net,
    b => max_op_net,
    op => relational_op_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_0e45bfa435 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => mux_y_net,
    b => min_op_net,
    op => relational1_op_net
  );
end structural;
-- Generated from Simulink block emu_dc/Integrator_modified1
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_integrator_modified1 is
  port (
    u : in std_logic_vector( 32-1 downto 0 );
    csv : in std_logic_vector( 1-1 downto 0 );
    usv : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y : out std_logic_vector( 32-1 downto 0 )
  );
end emu_dc_integrator_modified1;
architecture structural of emu_dc_integrator_modified1 is 
  signal convert_dout_net : std_logic_vector( 32-1 downto 0 );
  signal la_p_net : std_logic_vector( 32-1 downto 0 );
  signal relational3_op_net : std_logic_vector( 1-1 downto 0 );
  signal delay_q_net : std_logic_vector( 1-1 downto 0 );
  signal addsub_s_net : std_logic_vector( 64-1 downto 0 );
  signal ce_net : std_logic;
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal register7_q_net : std_logic_vector( 32-1 downto 0 );
  signal register5_q_net : std_logic_vector( 64-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
begin
  y <= convert_dout_net;
  la_p_net <= u;
  relational3_op_net <= csv;
  delay_q_net <= usv;
  clk_net <= clk_1;
  ce_net <= ce_1;
  saturationblock : entity xil_defaultlib.emu_dc_saturationblock 
  port map (
    in_x0 => register6_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    disable_pulse => inverter1_op_net
  );
  addsub : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 56,
    b_width => 64,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 65,
    core_name0 => "emu_dc_c_addsub_v12_0_i1",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 65,
    latency => 1,
    overflow => 1,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 56,
    s_width => 64
  )
  port map (
    clr => '0',
    en => "1",
    a => register7_q_net,
    b => register5_q_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub_s_net
  );
  convert : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 56,
    din_width => 64,
    dout_arith => 2,
    dout_bin_pt => 28,
    dout_width => 32,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => register6_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_8883052830 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational3_op_net,
    d1 => inverter1_op_net,
    y => logical2_y_net
  );
  register5 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => logical2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register5_q_net
  );
  register6 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register6_q_net
  );
  register7 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => la_p_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register7_q_net
  );
end structural;
-- Generated from Simulink block emu_dc/Integrator_modified2/SaturationBlock
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_saturationblock_x0 is
  port (
    in_x0 : in std_logic_vector( 64-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    disable_pulse : out std_logic_vector( 1-1 downto 0 )
  );
end emu_dc_saturationblock_x0;
architecture structural of emu_dc_saturationblock_x0 is 
  signal min_op_net : std_logic_vector( 64-1 downto 0 );
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal clk_net : std_logic;
  signal ce_net : std_logic;
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal relational_op_net : std_logic_vector( 1-1 downto 0 );
  signal max_op_net : std_logic_vector( 64-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal mux_y_net : std_logic_vector( 64-1 downto 0 );
begin
  disable_pulse <= inverter1_op_net;
  register6_q_net <= in_x0;
  clk_net <= clk_1;
  ce_net <= ce_1;
  inverter1 : entity xil_defaultlib.sysgen_inverter_aa453897ef 
  port map (
    clr => '0',
    ip => logical1_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_f5c169eedd 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational1_op_net,
    d1 => relational_op_net,
    y => logical1_y_net
  );
  max : entity xil_defaultlib.sysgen_constant_64f7e3bb3d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => max_op_net
  );
  min : entity xil_defaultlib.sysgen_constant_c1e2e26b84 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => min_op_net
  );
  mux : entity xil_defaultlib.sysgen_mux_f74f0d24ce 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => relational_op_net,
    d0 => register6_q_net,
    d1 => max_op_net,
    y => mux_y_net
  );
  relational : entity xil_defaultlib.sysgen_relational_03e5441b28 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => register6_q_net,
    b => max_op_net,
    op => relational_op_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_0e45bfa435 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => mux_y_net,
    b => min_op_net,
    op => relational1_op_net
  );
end structural;
-- Generated from Simulink block emu_dc/Integrator_modified2
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_integrator_modified2 is
  port (
    u : in std_logic_vector( 32-1 downto 0 );
    csv : in std_logic_vector( 1-1 downto 0 );
    usv : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y : out std_logic_vector( 32-1 downto 0 )
  );
end emu_dc_integrator_modified2;
architecture structural of emu_dc_integrator_modified2 is 
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal addsub_s_net : std_logic_vector( 64-1 downto 0 );
  signal relational3_op_net : std_logic_vector( 1-1 downto 0 );
  signal delay_q_net : std_logic_vector( 1-1 downto 0 );
  signal convert_dout_net : std_logic_vector( 32-1 downto 0 );
  signal tf_p_net : std_logic_vector( 32-1 downto 0 );
  signal clk_net : std_logic;
  signal register5_q_net : std_logic_vector( 64-1 downto 0 );
  signal ce_net : std_logic;
  signal register7_q_net : std_logic_vector( 32-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
begin
  y <= convert_dout_net;
  tf_p_net <= u;
  relational3_op_net <= csv;
  delay_q_net <= usv;
  clk_net <= clk_1;
  ce_net <= ce_1;
  saturationblock : entity xil_defaultlib.emu_dc_saturationblock_x0 
  port map (
    in_x0 => register6_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    disable_pulse => inverter1_op_net
  );
  addsub : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 56,
    b_width => 64,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 65,
    core_name0 => "emu_dc_c_addsub_v12_0_i1",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 65,
    latency => 1,
    overflow => 1,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 56,
    s_width => 64
  )
  port map (
    clr => '0',
    en => "1",
    a => register7_q_net,
    b => register5_q_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub_s_net
  );
  convert : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 56,
    din_width => 64,
    dout_arith => 2,
    dout_bin_pt => 28,
    dout_width => 32,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => register6_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_8883052830 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational3_op_net,
    d1 => inverter1_op_net,
    y => logical2_y_net
  );
  register5 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => logical2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register5_q_net
  );
  register6 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register6_q_net
  );
  register7 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => tf_p_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register7_q_net
  );
end structural;
-- Generated from Simulink block emu_dc/Integrator_modified3/SaturationBlock
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_saturationblock_x1 is
  port (
    in_x0 : in std_logic_vector( 64-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    disable_pulse : out std_logic_vector( 1-1 downto 0 )
  );
end emu_dc_saturationblock_x1;
architecture structural of emu_dc_saturationblock_x1 is 
  signal relational_op_net : std_logic_vector( 1-1 downto 0 );
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal clk_net : std_logic;
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal mux_y_net : std_logic_vector( 64-1 downto 0 );
  signal min_op_net : std_logic_vector( 64-1 downto 0 );
  signal max_op_net : std_logic_vector( 64-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
begin
  disable_pulse <= inverter1_op_net;
  register6_q_net <= in_x0;
  clk_net <= clk_1;
  ce_net <= ce_1;
  inverter1 : entity xil_defaultlib.sysgen_inverter_aa453897ef 
  port map (
    clr => '0',
    ip => logical1_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_f5c169eedd 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational1_op_net,
    d1 => relational_op_net,
    y => logical1_y_net
  );
  max : entity xil_defaultlib.sysgen_constant_64f7e3bb3d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => max_op_net
  );
  min : entity xil_defaultlib.sysgen_constant_c1e2e26b84 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => min_op_net
  );
  mux : entity xil_defaultlib.sysgen_mux_f74f0d24ce 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => relational_op_net,
    d0 => register6_q_net,
    d1 => max_op_net,
    y => mux_y_net
  );
  relational : entity xil_defaultlib.sysgen_relational_03e5441b28 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => register6_q_net,
    b => max_op_net,
    op => relational_op_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_0e45bfa435 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => mux_y_net,
    b => min_op_net,
    op => relational1_op_net
  );
end structural;
-- Generated from Simulink block emu_dc/Integrator_modified3
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_integrator_modified3 is
  port (
    u : in std_logic_vector( 32-1 downto 0 );
    csv : in std_logic_vector( 1-1 downto 0 );
    usv : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y : out std_logic_vector( 32-1 downto 0 )
  );
end emu_dc_integrator_modified3;
architecture structural of emu_dc_integrator_modified3 is 
  signal delay_q_net : std_logic_vector( 1-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal register6_q_net : std_logic_vector( 64-1 downto 0 );
  signal relational3_op_net : std_logic_vector( 1-1 downto 0 );
  signal addsub_s_net : std_logic_vector( 64-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
  signal register7_q_net : std_logic_vector( 32-1 downto 0 );
  signal register5_q_net : std_logic_vector( 64-1 downto 0 );
  signal clk_net : std_logic;
  signal mult8_p_net : std_logic_vector( 32-1 downto 0 );
  signal convert_dout_net : std_logic_vector( 32-1 downto 0 );
begin
  y <= convert_dout_net;
  mult8_p_net <= u;
  relational3_op_net <= csv;
  delay_q_net <= usv;
  clk_net <= clk_1;
  ce_net <= ce_1;
  saturationblock : entity xil_defaultlib.emu_dc_saturationblock_x1 
  port map (
    in_x0 => register6_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    disable_pulse => inverter1_op_net
  );
  addsub : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 56,
    b_width => 64,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 65,
    core_name0 => "emu_dc_c_addsub_v12_0_i1",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 65,
    latency => 1,
    overflow => 1,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 56,
    s_width => 64
  )
  port map (
    clr => '0',
    en => "1",
    a => register7_q_net,
    b => register5_q_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub_s_net
  );
  convert : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 56,
    din_width => 64,
    dout_arith => 2,
    dout_bin_pt => 28,
    dout_width => 32,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => register6_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_8883052830 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational3_op_net,
    d1 => inverter1_op_net,
    y => logical2_y_net
  );
  register5 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => logical2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register5_q_net
  );
  register6 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub_s_net,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register6_q_net
  );
  register7 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => mult8_p_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register7_q_net
  );
end structural;
-- Generated from Simulink block emu_dc_struct
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_struct is
  port (
    tl : in std_logic_vector( 32-1 downto 0 );
    ts_tf : in std_logic_vector( 32-1 downto 0 );
    ts_tm : in std_logic_vector( 32-1 downto 0 );
    ts_la : in std_logic_vector( 32-1 downto 0 );
    vdc1 : in std_logic_vector( 32-1 downto 0 );
    vdc2 : in std_logic_vector( 32-1 downto 0 );
    current_pu_bit_conv1 : in std_logic_vector( 32-1 downto 0 );
    current_pu_bit_conv2 : in std_logic_vector( 32-1 downto 0 );
    enable_con1_in : in std_logic_vector( 1-1 downto 0 );
    enable_con2_in : in std_logic_vector( 1-1 downto 0 );
    gatesig1_in : in std_logic_vector( 6-1 downto 0 );
    gatesig2_in : in std_logic_vector( 6-1 downto 0 );
    k_fnmechtstep : in std_logic_vector( 32-1 downto 0 );
    kn : in std_logic_vector( 32-1 downto 0 );
    magnetization_4q_1q : in std_logic_vector( 1-1 downto 0 );
    polepairs : in std_logic_vector( 32-1 downto 0 );
    ra : in std_logic_vector( 32-1 downto 0 );
    theta_sync_sampl : in std_logic_vector( 1-1 downto 0 );
    voltage_pu_bit_conv1 : in std_logic_vector( 32-1 downto 0 );
    voltage_pu_bit_conv2 : in std_logic_vector( 32-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    csv_out : out std_logic_vector( 1-1 downto 0 );
    tlsum : out std_logic_vector( 32-1 downto 0 );
    usv_out : out std_logic_vector( 1-1 downto 0 );
    ia : out std_logic_vector( 32-1 downto 0 );
    ia_dac : out std_logic_vector( 16-1 downto 0 );
    if_x0 : out std_logic_vector( 32-1 downto 0 );
    motor_id : out std_logic_vector( 32-1 downto 0 );
    pu_speed_dac : out std_logic_vector( 16-1 downto 0 );
    signalbus_out : out std_logic_vector( 104-1 downto 0 );
    speed : out std_logic_vector( 32-1 downto 0 );
    te : out std_logic_vector( 32-1 downto 0 );
    theta_el : out std_logic_vector( 32-1 downto 0 );
    theta_el_dac : out std_logic_vector( 16-1 downto 0 );
    theta_mech : out std_logic_vector( 32-1 downto 0 );
    theta_mech_dac : out std_logic_vector( 16-1 downto 0 );
    ua0_1_dac : out std_logic_vector( 16-1 downto 0 );
    uab_1_dac : out std_logic_vector( 16-1 downto 0 );
    uab_2_dac : out std_logic_vector( 16-1 downto 0 );
    ub0_1_dac : out std_logic_vector( 16-1 downto 0 )
  );
end emu_dc_struct;
architecture structural of emu_dc_struct is 
  signal ts_tf_net : std_logic_vector( 32-1 downto 0 );
  signal tl_net : std_logic_vector( 32-1 downto 0 );
  signal relational3_op_net : std_logic_vector( 1-1 downto 0 );
  signal te_tl1_s_net : std_logic_vector( 32-1 downto 0 );
  signal ts_tm_net : std_logic_vector( 32-1 downto 0 );
  signal convert23_dout_net : std_logic_vector( 16-1 downto 0 );
  signal register2_q_net : std_logic_vector( 32-1 downto 0 );
  signal convert2_dout_net : std_logic_vector( 16-1 downto 0 );
  signal current_pu_bit_conv2_net : std_logic_vector( 32-1 downto 0 );
  signal gatesig2_in_net : std_logic_vector( 6-1 downto 0 );
  signal convert_dout_net_x2 : std_logic_vector( 32-1 downto 0 );
  signal ts_la_net : std_logic_vector( 32-1 downto 0 );
  signal gatesig1_in_net : std_logic_vector( 6-1 downto 0 );
  signal convert11_dout_net : std_logic_vector( 16-1 downto 0 );
  signal register13_q_net : std_logic_vector( 104-1 downto 0 );
  signal register34_q_net : std_logic_vector( 32-1 downto 0 );
  signal theta_sync_sampl_net : std_logic_vector( 1-1 downto 0 );
  signal kn_net : std_logic_vector( 32-1 downto 0 );
  signal convert6_dout_net : std_logic_vector( 16-1 downto 0 );
  signal current_pu_bit_conv1_net : std_logic_vector( 32-1 downto 0 );
  signal convert_dout_net : std_logic_vector( 16-1 downto 0 );
  signal ra_net : std_logic_vector( 32-1 downto 0 );
  signal n_pu : std_logic_vector( 32-1 downto 0 );
  signal convert4_dout_net : std_logic_vector( 16-1 downto 0 );
  signal convert7_dout_net : std_logic_vector( 16-1 downto 0 );
  signal vdc1_net : std_logic_vector( 32-1 downto 0 );
  signal enable_con1_in_net : std_logic_vector( 1-1 downto 0 );
  signal enable_con2_in_net : std_logic_vector( 1-1 downto 0 );
  signal motor_id_op_net : std_logic_vector( 32-1 downto 0 );
  signal vdc2_net : std_logic_vector( 32-1 downto 0 );
  signal k_fnmechtstep_net : std_logic_vector( 32-1 downto 0 );
  signal register8_q_net : std_logic_vector( 32-1 downto 0 );
  signal register7_q_net : std_logic_vector( 32-1 downto 0 );
  signal polepairs_net : std_logic_vector( 32-1 downto 0 );
  signal magnetization_4q_1q_net : std_logic_vector( 1-1 downto 0 );
  signal delay_q_net : std_logic_vector( 1-1 downto 0 );
  signal a_x0 : std_logic_vector( 1-1 downto 0 );
  signal convert8_dout_net : std_logic_vector( 16-1 downto 0 );
  signal voltage_pu_bit_conv2_net : std_logic_vector( 32-1 downto 0 );
  signal convert_dout_net_x1 : std_logic_vector( 32-1 downto 0 );
  signal tf_p_net : std_logic_vector( 32-1 downto 0 );
  signal ce_net : std_logic;
  signal addsub_s_net : std_logic_vector( 32-1 downto 0 );
  signal a : std_logic_vector( 1-1 downto 0 );
  signal register4_q_net : std_logic_vector( 32-1 downto 0 );
  signal la_p_net : std_logic_vector( 32-1 downto 0 );
  signal mult8_p_net : std_logic_vector( 32-1 downto 0 );
  signal clk_net : std_logic;
  signal addsub2_s_net : std_logic_vector( 32-1 downto 0 );
  signal convert_dout_net_x0 : std_logic_vector( 32-1 downto 0 );
  signal voltage_pu_bit_conv1_net : std_logic_vector( 32-1 downto 0 );
  signal ua : std_logic_vector( 32-1 downto 0 );
  signal delay2_q_net : std_logic_vector( 32-1 downto 0 );
  signal addsub3_s_net : std_logic_vector( 32-1 downto 0 );
  signal aphase2_sel_net : std_logic_vector( 1-1 downto 0 );
  signal addsub6_s_net : std_logic_vector( 64-1 downto 0 );
  signal sa_nsa6_sa_net : std_logic_vector( 1-1 downto 0 );
  signal register9_q_net : std_logic_vector( 32-1 downto 0 );
  signal mult5_p_net : std_logic_vector( 64-1 downto 0 );
  signal sa_nsa3_sa_net : std_logic_vector( 1-1 downto 0 );
  signal sa_nsa3_nsa_net : std_logic_vector( 1-1 downto 0 );
  signal sa_nsa6_nsa_net : std_logic_vector( 1-1 downto 0 );
  signal addsub1_s_net : std_logic_vector( 32-1 downto 0 );
  signal delay3_q_net : std_logic_vector( 32-1 downto 0 );
  signal ea : std_logic_vector( 32-1 downto 0 );
  signal register16_q_net : std_logic_vector( 32-1 downto 0 );
  signal register25_q_net : std_logic_vector( 64-1 downto 0 );
  signal aphase1_sel_net : std_logic_vector( 1-1 downto 0 );
  signal ra_ia_p_net : std_logic_vector( 32-1 downto 0 );
  signal register28_q_net : std_logic_vector( 32-1 downto 0 );
  signal addsub4_s_net : std_logic_vector( 32-1 downto 0 );
  signal register10_q_net : std_logic_vector( 32-1 downto 0 );
  signal convert13_dout_net : std_logic_vector( 13-1 downto 0 );
  signal bitbasher_signal_bus_net : std_logic_vector( 104-1 downto 0 );
  signal b_x0 : std_logic_vector( 1-1 downto 0 );
  signal magnetization_4q_1q2_y_net : std_logic_vector( 13-1 downto 0 );
  signal convert9_dout_net : std_logic_vector( 13-1 downto 0 );
  signal sa_nsa4_nsb_net : std_logic_vector( 1-1 downto 0 );
  signal cmult1_p_net : std_logic_vector( 64-1 downto 0 );
  signal sa_nsa7_sb_net : std_logic_vector( 1-1 downto 0 );
  signal sa_nsa7_nsb_net : std_logic_vector( 1-1 downto 0 );
  signal c_x0 : std_logic_vector( 1-1 downto 0 );
  signal b : std_logic_vector( 1-1 downto 0 );
  signal convert1_dout_net : std_logic_vector( 13-1 downto 0 );
  signal constant13_op_net : std_logic_vector( 13-1 downto 0 );
  signal magnetization_4q_1q3_y_net : std_logic_vector( 13-1 downto 0 );
  signal bphase1_sel_net : std_logic_vector( 1-1 downto 0 );
  signal bphase2_sel_net : std_logic_vector( 1-1 downto 0 );
  signal cmult2_p_net : std_logic_vector( 64-1 downto 0 );
  signal sa_nsa4_sb_net : std_logic_vector( 1-1 downto 0 );
  signal constant10_op_net : std_logic_vector( 32-1 downto 0 );
  signal constant15_op_net : std_logic_vector( 32-1 downto 0 );
  signal concat3_y_net : std_logic_vector( 6-1 downto 0 );
  signal c_x2 : std_logic_vector( 1-1 downto 0 );
  signal a_x1 : std_logic_vector( 1-1 downto 0 );
  signal a_x2 : std_logic_vector( 1-1 downto 0 );
  signal c_x1 : std_logic_vector( 1-1 downto 0 );
  signal b_x2 : std_logic_vector( 1-1 downto 0 );
  signal b_x1 : std_logic_vector( 1-1 downto 0 );
  signal c : std_logic_vector( 1-1 downto 0 );
  signal concat2_y_net : std_logic_vector( 6-1 downto 0 );
  signal constant19_op_net : std_logic_vector( 32-1 downto 0 );
  signal constant4_op_net : std_logic_vector( 6-1 downto 0 );
  signal constant3_op_net : std_logic_vector( 6-1 downto 0 );
  signal constant9_op_net : std_logic_vector( 32-1 downto 0 );
  signal constant18_op_net : std_logic_vector( 32-1 downto 0 );
  signal constant5_op_net : std_logic_vector( 32-1 downto 0 );
  signal constant16_op_net : std_logic_vector( 6-1 downto 0 );
  signal convert10_dout_net : std_logic_vector( 32-1 downto 0 );
  signal constant17_op_net : std_logic_vector( 6-1 downto 0 );
  signal register26_q_net : std_logic_vector( 64-1 downto 0 );
  signal mult1_p_net : std_logic_vector( 12-1 downto 0 );
  signal convert22_dout_net : std_logic_vector( 32-1 downto 0 );
  signal convert3_dout_net : std_logic_vector( 13-1 downto 0 );
  signal mult3_p_net : std_logic_vector( 12-1 downto 0 );
  signal mult7_p_net : std_logic_vector( 12-1 downto 0 );
  signal mult12_p_net : std_logic_vector( 64-1 downto 0 );
  signal counter5_op_net : std_logic_vector( 7-1 downto 0 );
  signal mult6_p_net : std_logic_vector( 12-1 downto 0 );
  signal sa_nsa8_sc_net : std_logic_vector( 1-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 64-1 downto 0 );
  signal sa_nsa8_nsc_net : std_logic_vector( 1-1 downto 0 );
  signal cphase2_sel_net : std_logic_vector( 1-1 downto 0 );
  signal logical7_y_net : std_logic_vector( 32-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_a3_y_net : std_logic_vector( 6-1 downto 0 );
  signal vdc_x0 : std_logic_vector( 32-1 downto 0 );
  signal logical5_y_net : std_logic_vector( 6-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 6-1 downto 0 );
  signal vdc : std_logic_vector( 32-1 downto 0 );
  signal logical4_y_net : std_logic_vector( 32-1 downto 0 );
  signal logical8_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_a5_y_net : std_logic_vector( 6-1 downto 0 );
  signal n : std_logic_vector( 32-1 downto 0 );
  signal te_x0 : std_logic_vector( 32-1 downto 0 );
  signal register22_q_net : std_logic_vector( 32-1 downto 0 );
  signal register14_q_net : std_logic_vector( 32-1 downto 0 );
  signal sign_n_n_2_p_net : std_logic_vector( 32-1 downto 0 );
  signal mult9_p_net : std_logic_vector( 32-1 downto 0 );
  signal register15_q_net : std_logic_vector( 32-1 downto 0 );
  signal register23_q_net : std_logic_vector( 32-1 downto 0 );
  signal te_tl_s_net : std_logic_vector( 32-1 downto 0 );
  signal uc0 : std_logic_vector( 32-1 downto 0 );
  signal vinv_c2_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_a2_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_b1_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_b2_y_net : std_logic_vector( 32-1 downto 0 );
  signal vinv_a4_y_net : std_logic_vector( 32-1 downto 0 );
  signal magnetization_4q_1q_y_net : std_logic_vector( 32-1 downto 0 );
  signal threshold_y_net : std_logic_vector( 2-1 downto 0 );
  signal magnetization_4q_1q1_y_net : std_logic_vector( 32-1 downto 0 );
  signal n_2_p_net : std_logic_vector( 32-1 downto 0 );
begin
  csv_out <= relational3_op_net;
  tl_net <= tl;
  tlsum <= te_tl1_s_net;
  ts_tf_net <= ts_tf;
  ts_tm_net <= ts_tm;
  ts_la_net <= ts_la;
  usv_out <= delay_q_net;
  vdc1_net <= vdc1;
  vdc2_net <= vdc2;
  current_pu_bit_conv1_net <= current_pu_bit_conv1;
  current_pu_bit_conv2_net <= current_pu_bit_conv2;
  enable_con1_in_net <= enable_con1_in;
  enable_con2_in_net <= enable_con2_in;
  gatesig1_in_net <= gatesig1_in;
  gatesig2_in_net <= gatesig2_in;
  ia <= convert_dout_net_x2;
  ia_dac <= convert_dout_net;
  if_x0 <= register8_q_net;
  k_fnmechtstep_net <= k_fnmechtstep;
  kn_net <= kn;
  magnetization_4q_1q_net <= magnetization_4q_1q;
  motor_id <= motor_id_op_net;
  polepairs_net <= polepairs;
  pu_speed_dac <= convert11_dout_net;
  ra_net <= ra;
  signalbus_out <= register13_q_net;
  speed <= n_pu;
  te <= register7_q_net;
  theta_el <= register34_q_net;
  theta_el_dac <= convert23_dout_net;
  theta_mech <= register2_q_net;
  theta_mech_dac <= convert2_dout_net;
  theta_sync_sampl_net <= theta_sync_sampl;
  ua0_1_dac <= convert6_dout_net;
  uab_1_dac <= convert4_dout_net;
  uab_2_dac <= convert7_dout_net;
  ub0_1_dac <= convert8_dout_net;
  voltage_pu_bit_conv1_net <= voltage_pu_bit_conv1;
  voltage_pu_bit_conv2_net <= voltage_pu_bit_conv2;
  clk_net <= clk_1;
  ce_net <= ce_1;
  integrator_modified1 : entity xil_defaultlib.emu_dc_integrator_modified1 
  port map (
    u => la_p_net,
    csv => relational3_op_net,
    usv => delay_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y => convert_dout_net_x2
  );
  integrator_modified2 : entity xil_defaultlib.emu_dc_integrator_modified2 
  port map (
    u => tf_p_net,
    csv => relational3_op_net,
    usv => delay_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y => convert_dout_net_x1
  );
  integrator_modified3 : entity xil_defaultlib.emu_dc_integrator_modified3 
  port map (
    u => mult8_p_net,
    csv => relational3_op_net,
    usv => delay_q_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y => convert_dout_net_x0
  );
  tf : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlUnsigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 1,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i0",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => addsub_s_net,
    b => ts_tf_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => tf_p_net
  );
  la : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlUnsigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 1,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i0",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => addsub2_s_net,
    b => ts_la_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => la_p_net
  );
  a_1 : entity xil_defaultlib.sysgen_bitbasher_e4470cee2e 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig2_in_net,
    sa => a_x0
  );
  a_2 : entity xil_defaultlib.sysgen_bitbasher_e4470cee2e 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig1_in_net,
    sa => a
  );
  addsub : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i0",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 1,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    en => "1",
    a => register4_q_net,
    b => convert_dout_net_x1,
    clk => clk_net,
    ce => ce_net,
    s => addsub_s_net
  );
  addsub1 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i0",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 1,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    en => "1",
    a => ua,
    b => ea,
    clk => clk_net,
    ce => ce_net,
    s => addsub1_s_net
  );
  addsub2 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i0",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 1,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    en => "1",
    a => addsub1_s_net,
    b => ra_ia_p_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub2_s_net
  );
  addsub3 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i0",
    en_arith => xlUnsigned,
    en_bin_pt => 0,
    en_width => 1,
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 1,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    a => register9_q_net,
    b => register28_q_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub3_s_net
  );
  addsub4 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i0",
    en_arith => xlUnsigned,
    en_bin_pt => 0,
    en_width => 1,
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 1,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    a => register10_q_net,
    b => register16_q_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub4_s_net
  );
  addsub6 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 56,
    a_width => 64,
    b_arith => xlSigned,
    b_bin_pt => 56,
    b_width => 64,
    c_has_c_out => 0,
    c_latency => 1,
    c_output_width => 65,
    core_name0 => "emu_dc_c_addsub_v12_0_i1",
    en_arith => xlUnsigned,
    en_bin_pt => 0,
    en_width => 1,
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 65,
    latency => 1,
    overflow => 1,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 56,
    s_width => 64
  )
  port map (
    clr => '0',
    a => mult5_p_net,
    b => register25_q_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    s => addsub6_s_net
  );
  aphase1 : entity xil_defaultlib.sysgen_mcode_block_a0e47c7f64 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    s => sa_nsa3_sa_net,
    ns => sa_nsa3_nsa_net,
    i => delay2_q_net,
    sel => aphase1_sel_net
  );
  aphase2 : entity xil_defaultlib.sysgen_mcode_block_a0e47c7f64 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    s => sa_nsa6_sa_net,
    ns => sa_nsa6_nsa_net,
    i => delay3_q_net,
    sel => aphase2_sel_net
  );
  b_1 : entity xil_defaultlib.sysgen_bitbasher_935d11a1f8 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig2_in_net,
    sb => b_x0
  );
  b_2 : entity xil_defaultlib.sysgen_bitbasher_935d11a1f8 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig1_in_net,
    sb => b
  );
  bitbasher : entity xil_defaultlib.sysgen_bitbasher_35fa2a4022 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    ia1 => convert1_dout_net,
    ia2 => magnetization_4q_1q3_y_net,
    ib1 => constant13_op_net,
    ib2 => constant13_op_net,
    ic1 => magnetization_4q_1q2_y_net,
    ic2 => constant13_op_net,
    vdc1 => convert13_dout_net,
    vdc2 => convert9_dout_net,
    signal_bus => bitbasher_signal_bus_net
  );
  bphase1 : entity xil_defaultlib.sysgen_mcode_block_18cd5248f3 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    s => sa_nsa4_sb_net,
    ns => sa_nsa4_nsb_net,
    i => cmult1_p_net,
    sel => bphase1_sel_net
  );
  bphase2 : entity xil_defaultlib.sysgen_mcode_block_18cd5248f3 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    s => sa_nsa7_sb_net,
    ns => sa_nsa7_nsb_net,
    i => cmult2_p_net,
    sel => bphase2_sel_net
  );
  c_1 : entity xil_defaultlib.sysgen_bitbasher_6cafa897f0 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig2_in_net,
    sc => c_x0
  );
  c_2 : entity xil_defaultlib.sysgen_bitbasher_6cafa897f0 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => gatesig1_in_net,
    sc => c
  );
  cmult1 : entity xil_defaultlib.emu_dc_xlcmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_bin_pt => 56,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 64,
    c_output_width => 96,
    core_name0 => "emu_dc_mult_gen_v12_0_i1",
    extra_registers => 0,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 56,
    p_width => 64,
    quantization => 1,
    zero_const => 0
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => convert_dout_net_x1,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => cmult1_p_net
  );
  cmult2 : entity xil_defaultlib.emu_dc_xlcmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_bin_pt => 56,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 64,
    c_output_width => 96,
    core_name0 => "emu_dc_mult_gen_v12_0_i1",
    extra_registers => 0,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 56,
    p_width => 64,
    quantization => 1,
    zero_const => 0
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => convert_dout_net_x2,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => cmult2_p_net
  );
  concat2 : entity xil_defaultlib.sysgen_concat_6116e079a1 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    in0 => c_x0,
    in1 => c_x2,
    in2 => b_x0,
    in3 => b_x2,
    in4 => a_x0,
    in5 => a_x2,
    y => concat2_y_net
  );
  concat3 : entity xil_defaultlib.sysgen_concat_6116e079a1 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    in0 => c,
    in1 => c_x1,
    in2 => b,
    in3 => b_x1,
    in4 => a,
    in5 => a_x1,
    y => concat3_y_net
  );
  constant10 : entity xil_defaultlib.sysgen_constant_2d9a011320 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant10_op_net
  );
  constant13 : entity xil_defaultlib.sysgen_constant_d7a5e5b28b 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant13_op_net
  );
  constant15 : entity xil_defaultlib.sysgen_constant_2d9a011320 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant15_op_net
  );
  constant16 : entity xil_defaultlib.sysgen_constant_e74ec518d3 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant16_op_net
  );
  constant17 : entity xil_defaultlib.sysgen_constant_72767c8c86 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant17_op_net
  );
  constant18 : entity xil_defaultlib.sysgen_constant_6deb76d271 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant18_op_net
  );
  constant19 : entity xil_defaultlib.sysgen_constant_6deb76d271 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant19_op_net
  );
  constant3 : entity xil_defaultlib.sysgen_constant_e74ec518d3 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant3_op_net
  );
  constant4 : entity xil_defaultlib.sysgen_constant_72767c8c86 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant4_op_net
  );
  constant5 : entity xil_defaultlib.sysgen_constant_57804e7959 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant5_op_net
  );
  constant9 : entity xil_defaultlib.sysgen_constant_6deb76d271 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant9_op_net
  );
  convert : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => convert_dout_net_x2,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  convert1 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 0,
    din_width => 12,
    dout_arith => 2,
    dout_bin_pt => 0,
    dout_width => 13,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => mult1_p_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert1_dout_net
  );
  convert10 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 56,
    din_width => 64,
    dout_arith => 2,
    dout_bin_pt => 24,
    dout_width => 32,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => register26_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert10_dout_net
  );
  convert11 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 12,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => n_pu,
    clk => clk_net,
    ce => ce_net,
    dout => convert11_dout_net
  );
  convert13 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 0,
    din_width => 12,
    dout_arith => 2,
    dout_bin_pt => 0,
    dout_width => 13,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => mult7_p_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert13_dout_net
  );
  convert2 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 24,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => convert10_dout_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert2_dout_net
  );
  convert22 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 56,
    din_width => 64,
    dout_arith => 2,
    dout_bin_pt => 24,
    dout_width => 32,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => mult12_p_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert22_dout_net
  );
  convert23 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 24,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => convert22_dout_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert23_dout_net
  );
  convert3 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 0,
    din_width => 12,
    dout_arith => 2,
    dout_bin_pt => 0,
    dout_width => 13,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => mult3_p_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert3_dout_net
  );
  convert4 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => addsub3_s_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert4_dout_net
  );
  convert6 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => register9_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert6_dout_net
  );
  convert7 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => addsub4_s_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert7_dout_net
  );
  convert8 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 28,
    din_width => 32,
    dout_arith => 2,
    dout_bin_pt => 8,
    dout_width => 16,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => register28_q_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert8_dout_net
  );
  convert9 : entity xil_defaultlib.emu_dc_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 2,
    din_bin_pt => 0,
    din_width => 12,
    dout_arith => 2,
    dout_bin_pt => 0,
    dout_width => 13,
    latency => 1,
    overflow => xlSaturate,
    quantization => xlRound
  )
  port map (
    clr => '0',
    en => "1",
    din => mult6_p_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert9_dout_net
  );
  counter5 : entity xil_defaultlib.emu_dc_xlcounter_limit 
  generic map (
    cnt_15_0 => 100,
    cnt_31_16 => 0,
    cnt_47_32 => 0,
    cnt_63_48 => 0,
    core_name0 => "emu_dc_c_counter_binary_v12_0_i0",
    count_limited => 1,
    op_arith => xlUnsigned,
    op_width => 7
  )
  port map (
    en => "1",
    rst => "0",
    clr => '0',
    clk => clk_net,
    ce => ce_net,
    op => counter5_op_net
  );
  cphase2 : entity xil_defaultlib.sysgen_mcode_block_ea985bd348 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    s => sa_nsa8_sc_net,
    ns => sa_nsa8_nsc_net,
    i => constant18_op_net,
    sel => cphase2_sel_net
  );
  delay : entity xil_defaultlib.emu_dc_xldelay 
  generic map (
    latency => 50,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '0',
    d => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay_q_net
  );
  delay1 : entity xil_defaultlib.emu_dc_xldelay 
  generic map (
    latency => 3,
    reg_retiming => 0,
    reset => 0,
    width => 64
  )
  port map (
    en => '1',
    rst => '0',
    d => addsub6_s_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  delay2 : entity xil_defaultlib.emu_dc_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 32
  )
  port map (
    en => '1',
    rst => '0',
    d => convert_dout_net_x1,
    clk => clk_net,
    ce => ce_net,
    q => delay2_q_net
  );
  delay3 : entity xil_defaultlib.emu_dc_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 32
  )
  port map (
    en => '1',
    rst => '0',
    d => convert_dout_net_x2,
    clk => clk_net,
    ce => ce_net,
    q => delay3_q_net
  );
  inverter3 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => a_x0,
    clk => clk_net,
    ce => ce_net,
    op => a_x2
  );
  inverter4 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => b_x0,
    clk => clk_net,
    ce => ce_net,
    op => b_x2
  );
  inverter5 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => c_x0,
    clk => clk_net,
    ce => ce_net,
    op => c_x2
  );
  inverter6 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => a,
    clk => clk_net,
    ce => ce_net,
    op => a_x1
  );
  inverter7 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => b,
    clk => clk_net,
    ce => ce_net,
    op => b_x1
  );
  inverter8 : entity xil_defaultlib.sysgen_inverter_3a7027cc95 
  port map (
    clr => '0',
    ip => c,
    clk => clk_net,
    ce => ce_net,
    op => c_x1
  );
  logical1 : entity xil_defaultlib.sysgen_logical_dfb2848d1a 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => concat2_y_net,
    d1 => vinv_a3_y_net,
    y => logical1_y_net
  );
  logical3 : entity xil_defaultlib.sysgen_logical_119ab8e99e 
  port map (
    clr => '0',
    d0 => vdc_x0,
    d1 => constant10_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical3_y_net
  );
  logical4 : entity xil_defaultlib.sysgen_logical_0d19f6c4e5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => constant9_op_net,
    d1 => vdc_x0,
    y => logical4_y_net
  );
  logical5 : entity xil_defaultlib.sysgen_logical_dfb2848d1a 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => concat3_y_net,
    d1 => vinv_a5_y_net,
    y => logical5_y_net
  );
  logical7 : entity xil_defaultlib.sysgen_logical_119ab8e99e 
  port map (
    clr => '0',
    d0 => vdc,
    d1 => constant15_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical7_y_net
  );
  logical8 : entity xil_defaultlib.sysgen_logical_0d19f6c4e5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => constant19_op_net,
    d1 => vdc,
    y => logical8_y_net
  );
  motor_id_x0 : entity xil_defaultlib.sysgen_constant_57804e7959 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => motor_id_op_net
  );
  mult : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => convert_dout_net_x1,
    b => n,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => ea
  );
  mult1 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 0,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 0,
    p_width => 12,
    quantization => 2
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => register14_q_net,
    b => convert_dout_net_x2,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult1_p_net
  );
  mult12 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 56,
    a_width => 64,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 64,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 64,
    c_output_width => 96,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i3",
    extra_registers => 0,
    multsign => 2,
    overflow => 1,
    p_arith => xlSigned,
    p_bin_pt => 56,
    p_width => 64,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => addsub6_s_net,
    b => polepairs_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult12_p_net
  );
  mult2 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => convert_dout_net_x2,
    b => convert_dout_net_x1,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => te_x0
  );
  mult3 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 0,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 0,
    p_width => 12,
    quantization => 2
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => register22_q_net,
    b => convert_dout_net_x1,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult3_p_net
  );
  mult5 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i4",
    extra_registers => 0,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 56,
    p_width => 64,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => n_pu,
    b => k_fnmechtstep_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult5_p_net
  );
  mult6 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 0,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 0,
    p_width => 12,
    quantization => 2
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => vdc_x0,
    b => register15_q_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult6_p_net
  );
  mult7 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 0,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 0,
    p_width => 12,
    quantization => 2
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => vdc,
    b => register23_q_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult7_p_net
  );
  mult8 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => te_tl_s_net,
    b => ts_tm_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult8_p_net
  );
  mult9 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => sign_n_n_2_p_net,
    b => kn_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => mult9_p_net
  );
  register_x0 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub3_s_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => ua
  );
  register1 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => n_pu,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => n
  );
  register10 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => vinv_a2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register10_q_net
  );
  register12 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => vinv_c2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => uc0
  );
  register13 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 104,
    init_value => b"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => bitbasher_signal_bus_net,
    clk => clk_net,
    ce => ce_net,
    q => register13_q_net
  );
  register14 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => current_pu_bit_conv1_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register14_q_net
  );
  register15 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => voltage_pu_bit_conv2_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register15_q_net
  );
  register16 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => vinv_b1_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register16_q_net
  );
  register19 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => convert_dout_net_x0,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => n_pu
  );
  register2 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => convert10_dout_net,
    en => theta_sync_sampl_net,
    clk => clk_net,
    ce => ce_net,
    q => register2_q_net
  );
  register22 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => current_pu_bit_conv2_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register22_q_net
  );
  register23 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => voltage_pu_bit_conv1_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register23_q_net
  );
  register24 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => vdc2_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => vdc_x0
  );
  register25 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => addsub6_s_net,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register25_q_net
  );
  register26 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 64,
    init_value => b"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => delay1_q_net,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register26_q_net
  );
  register27 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => vdc1_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => vdc
  );
  register28 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => vinv_b2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register28_q_net
  );
  register34 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => convert22_dout_net,
    en => theta_sync_sampl_net,
    clk => clk_net,
    ce => ce_net,
    q => register34_q_net
  );
  register4 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => magnetization_4q_1q_y_net,
    en => relational3_op_net,
    clk => clk_net,
    ce => ce_net,
    q => register4_q_net
  );
  register7 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => te_x0,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register7_q_net
  );
  register8 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => convert_dout_net_x1,
    en => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => register8_q_net
  );
  register9 : entity xil_defaultlib.emu_dc_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    en => "1",
    rst => "0",
    d => vinv_a4_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register9_q_net
  );
  relational3 : entity xil_defaultlib.sysgen_relational_2c879613ee 
  port map (
    clr => '0',
    a => counter5_op_net,
    b => constant5_op_net,
    clk => clk_net,
    ce => ce_net,
    op => relational3_op_net
  );
  sa_nsa3 : entity xil_defaultlib.sysgen_bitbasher_45bf6f415d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => logical1_y_net,
    sa => sa_nsa3_sa_net,
    nsa => sa_nsa3_nsa_net
  );
  sa_nsa4 : entity xil_defaultlib.sysgen_bitbasher_4271686010 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => logical1_y_net,
    sb => sa_nsa4_sb_net,
    nsb => sa_nsa4_nsb_net
  );
  sa_nsa6 : entity xil_defaultlib.sysgen_bitbasher_45bf6f415d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => logical5_y_net,
    sa => sa_nsa6_sa_net,
    nsa => sa_nsa6_nsa_net
  );
  sa_nsa7 : entity xil_defaultlib.sysgen_bitbasher_4271686010 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => logical5_y_net,
    sb => sa_nsa7_sb_net,
    nsb => sa_nsa7_nsb_net
  );
  sa_nsa8 : entity xil_defaultlib.sysgen_bitbasher_d514526b4d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    u => logical5_y_net,
    sc => sa_nsa8_sc_net,
    nsc => sa_nsa8_nsc_net
  );
  threshold : entity xil_defaultlib.sysgen_sgn_3f926e6f6d 
  port map (
    clr => '0',
    x => convert_dout_net_x0,
    clk => clk_net,
    ce => ce_net,
    y => threshold_y_net
  );
  vinv_a2 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => aphase1_sel_net,
    d0 => logical4_y_net,
    d1 => logical3_y_net,
    y => vinv_a2_y_net
  );
  vinv_a3 : entity xil_defaultlib.sysgen_mux_376215cb10 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => enable_con2_in_net,
    d0 => constant3_op_net,
    d1 => constant4_op_net,
    y => vinv_a3_y_net
  );
  vinv_a4 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => aphase2_sel_net,
    d0 => logical8_y_net,
    d1 => logical7_y_net,
    y => vinv_a4_y_net
  );
  vinv_a5 : entity xil_defaultlib.sysgen_mux_f631792396 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => enable_con1_in_net,
    d0 => constant16_op_net,
    d1 => constant17_op_net,
    y => vinv_a5_y_net
  );
  vinv_b1 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => bphase1_sel_net,
    d0 => logical4_y_net,
    d1 => logical3_y_net,
    y => vinv_b1_y_net
  );
  vinv_b2 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => bphase2_sel_net,
    d0 => logical8_y_net,
    d1 => logical7_y_net,
    y => vinv_b2_y_net
  );
  vinv_c2 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => cphase2_sel_net,
    d0 => logical8_y_net,
    d1 => magnetization_4q_1q1_y_net,
    y => vinv_c2_y_net
  );
  magnetization_4q_1q_x0 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => magnetization_4q_1q_net,
    d0 => addsub4_s_net,
    d1 => uc0,
    y => magnetization_4q_1q_y_net
  );
  magnetization_4q_1q1 : entity xil_defaultlib.sysgen_mux_3d251ba442 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => magnetization_4q_1q_net,
    d0 => logical7_y_net,
    d1 => vdc_x0,
    y => magnetization_4q_1q1_y_net
  );
  magnetization_4q_1q2 : entity xil_defaultlib.sysgen_mux_86c098b96d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => magnetization_4q_1q_net,
    d0 => constant13_op_net,
    d1 => convert3_dout_net,
    y => magnetization_4q_1q2_y_net
  );
  magnetization_4q_1q3 : entity xil_defaultlib.sysgen_mux_86c098b96d 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    sel => magnetization_4q_1q_net,
    d0 => convert3_dout_net,
    d1 => constant13_op_net,
    y => magnetization_4q_1q3_y_net
  );
  n_2 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i2",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => convert_dout_net_x0,
    b => convert_dout_net_x0,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => n_2_p_net
  );
  ra_ia : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlUnsigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_a_type => 1,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 32,
    c_baat => 32,
    c_output_width => 64,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i5",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => ra_net,
    b => convert_dout_net_x2,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => ra_ia_p_net
  );
  sign_n_n_2 : entity xil_defaultlib.emu_dc_xlmult 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 0,
    b_width => 2,
    c_a_type => 0,
    c_a_width => 32,
    c_b_type => 0,
    c_b_width => 2,
    c_baat => 32,
    c_output_width => 34,
    c_type => 0,
    core_name0 => "emu_dc_mult_gen_v12_0_i6",
    extra_registers => 1,
    multsign => 2,
    overflow => 2,
    p_arith => xlSigned,
    p_bin_pt => 28,
    p_width => 32,
    quantization => 1
  )
  port map (
    clr => '0',
    core_clr => '1',
    en => "1",
    rst => "0",
    a => n_2_p_net,
    b => threshold_y_net,
    clk => clk_net,
    ce => ce_net,
    core_clk => clk_net,
    core_ce => ce_net,
    p => sign_n_n_2_p_net
  );
  te_tl : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 0,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i2",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 0,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    en => "1",
    a => register7_q_net,
    b => te_tl1_s_net,
    clk => clk_net,
    ce => ce_net,
    s => te_tl_s_net
  );
  te_tl1 : entity xil_defaultlib.emu_dc_xladdsub 
  generic map (
    a_arith => xlSigned,
    a_bin_pt => 28,
    a_width => 32,
    b_arith => xlSigned,
    b_bin_pt => 28,
    b_width => 32,
    c_has_c_out => 0,
    c_latency => 0,
    c_output_width => 33,
    core_name0 => "emu_dc_c_addsub_v12_0_i3",
    extra_registers => 0,
    full_s_arith => 2,
    full_s_width => 33,
    latency => 0,
    overflow => 2,
    quantization => 1,
    s_arith => xlSigned,
    s_bin_pt => 28,
    s_width => 32
  )
  port map (
    clr => '0',
    en => "1",
    a => tl_net,
    b => mult9_p_net,
    clk => clk_net,
    ce => ce_net,
    s => te_tl1_s_net
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc_default_clock_driver is
  port (
    emu_dc_sysclk : in std_logic;
    emu_dc_sysce : in std_logic;
    emu_dc_sysclr : in std_logic;
    emu_dc_clk1 : out std_logic;
    emu_dc_ce1 : out std_logic
  );
end emu_dc_default_clock_driver;
architecture structural of emu_dc_default_clock_driver is 
begin
  clockdriver : entity xil_defaultlib.xlclockdriver 
  generic map (
    period => 1,
    log_2_period => 1
  )
  port map (
    sysclk => emu_dc_sysclk,
    sysce => emu_dc_sysce,
    sysclr => emu_dc_sysclr,
    clk => emu_dc_clk1,
    ce => emu_dc_ce1
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity emu_dc is
  port (
    enable_con1_in : in std_logic_vector( 1-1 downto 0 );
    enable_con2_in : in std_logic_vector( 1-1 downto 0 );
    gatesig1_in : in std_logic_vector( 6-1 downto 0 );
    gatesig2_in : in std_logic_vector( 6-1 downto 0 );
    theta_sync_sampl : in std_logic_vector( 1-1 downto 0 );
    clk : in std_logic;
    emu_dc_aresetn : in std_logic;
    emu_dc_s_axi_awaddr : in std_logic_vector( 7-1 downto 0 );
    emu_dc_s_axi_awvalid : in std_logic;
    emu_dc_s_axi_wdata : in std_logic_vector( 32-1 downto 0 );
    emu_dc_s_axi_wstrb : in std_logic_vector( 4-1 downto 0 );
    emu_dc_s_axi_wvalid : in std_logic;
    emu_dc_s_axi_bready : in std_logic;
    emu_dc_s_axi_araddr : in std_logic_vector( 7-1 downto 0 );
    emu_dc_s_axi_arvalid : in std_logic;
    emu_dc_s_axi_rready : in std_logic;
    csv_out : out std_logic_vector( 1-1 downto 0 );
    usv_out : out std_logic_vector( 1-1 downto 0 );
    ia_dac : out std_logic_vector( 16-1 downto 0 );
    pu_speed_dac : out std_logic_vector( 16-1 downto 0 );
    signalbus_out : out std_logic_vector( 104-1 downto 0 );
    theta_el_dac : out std_logic_vector( 16-1 downto 0 );
    theta_mech_dac : out std_logic_vector( 16-1 downto 0 );
    ua0_1_dac : out std_logic_vector( 16-1 downto 0 );
    uab_1_dac : out std_logic_vector( 16-1 downto 0 );
    uab_2_dac : out std_logic_vector( 16-1 downto 0 );
    ub0_1_dac : out std_logic_vector( 16-1 downto 0 );
    emu_dc_s_axi_awready : out std_logic;
    emu_dc_s_axi_wready : out std_logic;
    emu_dc_s_axi_bresp : out std_logic_vector( 2-1 downto 0 );
    emu_dc_s_axi_bvalid : out std_logic;
    emu_dc_s_axi_arready : out std_logic;
    emu_dc_s_axi_rdata : out std_logic_vector( 32-1 downto 0 );
    emu_dc_s_axi_rresp : out std_logic_vector( 2-1 downto 0 );
    emu_dc_s_axi_rvalid : out std_logic
  );
end emu_dc;
architecture structural of emu_dc is 
  attribute core_generation_info : string;
  attribute core_generation_info of structural : architecture is "emu_dc,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynq,part=xc7z030,speed=-1,package=sbg485,synthesis_language=vhdl,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=0,ce_clr=0,clock_period=10,system_simulink_period=1e-08,waveform_viewer=0,axilite_interface=1,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.04,addsub=11,bitbasher=13,cmult=2,concat=2,constant=19,convert=17,counter=1,delay=4,inv=9,logical=12,mcode=6,mult=15,mux=18,register=35,relational=7,sgn=1,}";
  signal clk_net : std_logic;
  signal ra : std_logic_vector( 32-1 downto 0 );
  signal polepairs : std_logic_vector( 32-1 downto 0 );
  signal voltage_pu_bit_conv2 : std_logic_vector( 32-1 downto 0 );
  signal te : std_logic_vector( 32-1 downto 0 );
  signal theta_mech : std_logic_vector( 32-1 downto 0 );
  signal motor_id : std_logic_vector( 32-1 downto 0 );
  signal clk_1_net : std_logic;
  signal voltage_pu_bit_conv1 : std_logic_vector( 32-1 downto 0 );
  signal theta_el : std_logic_vector( 32-1 downto 0 );
  signal speed : std_logic_vector( 32-1 downto 0 );
  signal ce_1_net : std_logic;
  signal tl : std_logic_vector( 32-1 downto 0 );
  signal ts_tf : std_logic_vector( 32-1 downto 0 );
  signal ts_tm : std_logic_vector( 32-1 downto 0 );
  signal vdc2 : std_logic_vector( 32-1 downto 0 );
  signal current_pu_bit_conv1 : std_logic_vector( 32-1 downto 0 );
  signal vdc1 : std_logic_vector( 32-1 downto 0 );
  signal current_pu_bit_conv2 : std_logic_vector( 32-1 downto 0 );
  signal ia : std_logic_vector( 32-1 downto 0 );
  signal if_x0 : std_logic_vector( 32-1 downto 0 );
  signal tlsum : std_logic_vector( 32-1 downto 0 );
  signal ts_la : std_logic_vector( 32-1 downto 0 );
  signal k_fnmechtstep : std_logic_vector( 32-1 downto 0 );
  signal kn : std_logic_vector( 32-1 downto 0 );
  signal magnetization_4q_1q : std_logic_vector( 1-1 downto 0 );
begin
  emu_dc_axi_lite_interface : entity xil_defaultlib.emu_dc_axi_lite_interface 
  port map (
    tlsum => tlsum,
    ia => ia,
    if_x0 => if_x0,
    motor_id => motor_id,
    speed => speed,
    te => te,
    theta_el => theta_el,
    theta_mech => theta_mech,
    emu_dc_s_axi_awaddr => emu_dc_s_axi_awaddr,
    emu_dc_s_axi_awvalid => emu_dc_s_axi_awvalid,
    emu_dc_s_axi_wdata => emu_dc_s_axi_wdata,
    emu_dc_s_axi_wstrb => emu_dc_s_axi_wstrb,
    emu_dc_s_axi_wvalid => emu_dc_s_axi_wvalid,
    emu_dc_s_axi_bready => emu_dc_s_axi_bready,
    emu_dc_s_axi_araddr => emu_dc_s_axi_araddr,
    emu_dc_s_axi_arvalid => emu_dc_s_axi_arvalid,
    emu_dc_s_axi_rready => emu_dc_s_axi_rready,
    emu_dc_aresetn => emu_dc_aresetn,
    emu_dc_aclk => clk,
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
    emu_dc_s_axi_awready => emu_dc_s_axi_awready,
    emu_dc_s_axi_wready => emu_dc_s_axi_wready,
    emu_dc_s_axi_bresp => emu_dc_s_axi_bresp,
    emu_dc_s_axi_bvalid => emu_dc_s_axi_bvalid,
    emu_dc_s_axi_arready => emu_dc_s_axi_arready,
    emu_dc_s_axi_rdata => emu_dc_s_axi_rdata,
    emu_dc_s_axi_rresp => emu_dc_s_axi_rresp,
    emu_dc_s_axi_rvalid => emu_dc_s_axi_rvalid,
    clk => clk_net
  );
  emu_dc_default_clock_driver : entity xil_defaultlib.emu_dc_default_clock_driver 
  port map (
    emu_dc_sysclk => clk_net,
    emu_dc_sysce => '1',
    emu_dc_sysclr => '0',
    emu_dc_clk1 => clk_1_net,
    emu_dc_ce1 => ce_1_net
  );
  emu_dc_struct : entity xil_defaultlib.emu_dc_struct 
  port map (
    tl => tl,
    ts_tf => ts_tf,
    ts_tm => ts_tm,
    ts_la => ts_la,
    vdc1 => vdc1,
    vdc2 => vdc2,
    current_pu_bit_conv1 => current_pu_bit_conv1,
    current_pu_bit_conv2 => current_pu_bit_conv2,
    enable_con1_in => enable_con1_in,
    enable_con2_in => enable_con2_in,
    gatesig1_in => gatesig1_in,
    gatesig2_in => gatesig2_in,
    k_fnmechtstep => k_fnmechtstep,
    kn => kn,
    magnetization_4q_1q => magnetization_4q_1q,
    polepairs => polepairs,
    ra => ra,
    theta_sync_sampl => theta_sync_sampl,
    voltage_pu_bit_conv1 => voltage_pu_bit_conv1,
    voltage_pu_bit_conv2 => voltage_pu_bit_conv2,
    clk_1 => clk_1_net,
    ce_1 => ce_1_net,
    csv_out => csv_out,
    tlsum => tlsum,
    usv_out => usv_out,
    ia => ia,
    ia_dac => ia_dac,
    if_x0 => if_x0,
    motor_id => motor_id,
    pu_speed_dac => pu_speed_dac,
    signalbus_out => signalbus_out,
    speed => speed,
    te => te,
    theta_el => theta_el,
    theta_el_dac => theta_el_dac,
    theta_mech => theta_mech,
    theta_mech_dac => theta_mech_dac,
    ua0_1_dac => ua0_1_dac,
    uab_1_dac => uab_1_dac,
    uab_2_dac => uab_2_dac,
    ub0_1_dac => ub0_1_dac
  );
end structural;
