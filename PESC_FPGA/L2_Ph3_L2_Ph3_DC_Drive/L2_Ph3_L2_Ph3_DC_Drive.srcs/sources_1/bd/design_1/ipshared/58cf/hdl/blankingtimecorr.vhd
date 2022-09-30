-- Generated from Simulink block BlankingTimeCorr/Phase a/BlankingTime Counter
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter;
architecture structural of blankingtimecorr_blankingtime_counter is 
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
  signal ce_net : std_logic;
  signal clk_net : std_logic;
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
begin
  out_x0 <= delay5_q_net;
  register1_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase a/BlankingTime Counter1
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter1 is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter1;
architecture structural of blankingtimecorr_blankingtime_counter1 is 
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
  signal clk_net : std_logic;
  signal ce_net : std_logic;
begin
  out_x0 <= delay5_q_net;
  register2_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register2_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase a/Rising/falling edge detector
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_falling_edge_detector is
  port (
    u : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y_rise : out std_logic_vector( 1-1 downto 0 );
    y_fall : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_falling_edge_detector;
architecture structural of blankingtimecorr_falling_edge_detector is 
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal inverter3_op_net : std_logic_vector( 1-1 downto 0 );
  signal delay2_q_net : std_logic_vector( 1-1 downto 0 );
  signal slice_y_net : std_logic_vector( 1-1 downto 0 );
begin
  y_rise <= logical3_y_net;
  y_fall <= logical13_y_net;
  slice_y_net <= u;
  clk_net <= clk_1;
  ce_net <= ce_1;
  delay1 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => inverter1_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  delay2 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay2_q_net
  );
  inverter1 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  inverter3 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter3_op_net
  );
  logical13 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => inverter3_op_net,
    d1 => delay2_q_net,
    y => logical13_y_net
  );
  logical3 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => slice_y_net,
    d1 => delay1_q_net,
    y => logical3_y_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase a
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_phase_a is
  port (
    igbt_bit : in std_logic_vector( 1-1 downto 0 );
    current : in std_logic_vector( 16-1 downto 0 );
    blanking_time : in std_logic_vector( 16-1 downto 0 );
    count_rst : in std_logic_vector( 1-1 downto 0 );
    reg_en : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    t_phse_on : out std_logic_vector( 32-1 downto 0 );
    intr_o : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_phase_a;
architecture structural of blankingtimecorr_phase_a is 
  signal logical12_y_net : std_logic_vector( 1-1 downto 0 );
  signal slice_y_net : std_logic_vector( 1-1 downto 0 );
  signal register3_q_net : std_logic_vector( 32-1 downto 0 );
  signal inverter_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical11_y_net : std_logic_vector( 1-1 downto 0 );
  signal relational6_op_net : std_logic_vector( 1-1 downto 0 );
  signal delay5_q_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal constant6_op_net : std_logic_vector( 16-1 downto 0 );
  signal logical10_y_net : std_logic_vector( 1-1 downto 0 );
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical4_y_net : std_logic_vector( 1-1 downto 0 );
  signal ia_in_net : std_logic_vector( 16-1 downto 0 );
  signal ce_net : std_logic;
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal constant5_op_net : std_logic_vector( 16-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal delay4_q_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal logical3_y_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal counter3_op_net : std_logic_vector( 32-1 downto 0 );
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical5_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical6_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical8_y_net : std_logic_vector( 1-1 downto 0 );
begin
  t_phse_on <= register3_q_net;
  intr_o <= logical12_y_net;
  slice_y_net <= igbt_bit;
  ia_in_net <= current;
  blankingtime_net <= blanking_time;
  delay1_q_net <= count_rst;
  logical3_y_net_x0 <= reg_en;
  clk_net <= clk_1;
  ce_net <= ce_1;
  blankingtime_counter : entity xil_defaultlib.blankingtimecorr_blankingtime_counter 
  port map (
    en => register1_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net_x0
  );
  blankingtime_counter1 : entity xil_defaultlib.blankingtimecorr_blankingtime_counter1 
  port map (
    en => register2_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net
  );
  falling_edge_detector : entity xil_defaultlib.blankingtimecorr_falling_edge_detector 
  port map (
    u => slice_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y_rise => logical3_y_net,
    y_fall => logical13_y_net
  );
  constant5 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant5_op_net
  );
  constant6 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant6_op_net
  );
  counter3 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i0",
    op_arith => xlUnsigned,
    op_width => 32
  )
  port map (
    clr => '0',
    rst => delay1_q_net,
    en => logical12_y_net,
    clk => clk_net,
    ce => ce_net,
    op => counter3_op_net
  );
  delay4 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 3,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay4_q_net
  );
  inverter : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical11_y_net,
    d1 => relational6_op_net,
    y => logical1_y_net
  );
  logical10 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical4_y_net,
    d1 => delay5_q_net,
    y => logical10_y_net
  );
  logical11 : entity xil_defaultlib.sysgen_logical_efbfa67d13 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => register2_q_net,
    en => relational6_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical11_y_net
  );
  logical12 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical2_y_net,
    d1 => logical1_y_net,
    y => logical12_y_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical6_y_net,
    d1 => relational1_op_net,
    y => logical2_y_net
  );
  logical4 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational6_op_net,
    d1 => logical13_y_net,
    y => logical4_y_net
  );
  logical5 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical3_y_net,
    d1 => relational1_op_net,
    y => logical5_y_net
  );
  logical6 : entity xil_defaultlib.sysgen_logical_606816afb7 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => inverter_op_net,
    en => relational1_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical6_y_net
  );
  logical8 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical5_y_net,
    d1 => delay5_q_net_x0,
    y => logical8_y_net
  );
  register1 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical5_y_net,
    en => logical8_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register1_q_net
  );
  register2 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical4_y_net,
    en => logical10_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register2_q_net
  );
  register3 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => counter3_op_net,
    en => logical3_y_net_x0,
    clk => clk_net,
    ce => ce_net,
    q => register3_q_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_c3849d09cf 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => constant5_op_net,
    b => ia_in_net,
    op => relational1_op_net
  );
  relational6 : entity xil_defaultlib.sysgen_relational_2f58baf397 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => ia_in_net,
    b => constant6_op_net,
    op => relational6_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase b/BlankingTime Counter
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter_x0 is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter_x0;
architecture structural of blankingtimecorr_blankingtime_counter_x0 is 
  signal ce_net : std_logic;
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
begin
  out_x0 <= delay5_q_net;
  register1_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase b/BlankingTime Counter1
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter1_x0 is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter1_x0;
architecture structural of blankingtimecorr_blankingtime_counter1_x0 is 
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal ce_net : std_logic;
  signal clk_net : std_logic;
begin
  out_x0 <= delay5_q_net;
  register2_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register2_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase b/Rising/falling edge detector
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_falling_edge_detector_x0 is
  port (
    u : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y_rise : out std_logic_vector( 1-1 downto 0 );
    y_fall : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_falling_edge_detector_x0;
architecture structural of blankingtimecorr_falling_edge_detector_x0 is 
  signal delay2_q_net : std_logic_vector( 1-1 downto 0 );
  signal inverter3_op_net : std_logic_vector( 1-1 downto 0 );
  signal slice1_y_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
begin
  y_rise <= logical3_y_net;
  y_fall <= logical13_y_net;
  slice1_y_net <= u;
  clk_net <= clk_1;
  ce_net <= ce_1;
  delay1 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => inverter1_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  delay2 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice1_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay2_q_net
  );
  inverter1 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice1_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  inverter3 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice1_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter3_op_net
  );
  logical13 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => inverter3_op_net,
    d1 => delay2_q_net,
    y => logical13_y_net
  );
  logical3 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => slice1_y_net,
    d1 => delay1_q_net,
    y => logical3_y_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase b
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_phase_b is
  port (
    igbt_bit : in std_logic_vector( 1-1 downto 0 );
    current : in std_logic_vector( 16-1 downto 0 );
    blanking_time : in std_logic_vector( 16-1 downto 0 );
    count_rst : in std_logic_vector( 1-1 downto 0 );
    reg_en : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    t_phse_on : out std_logic_vector( 32-1 downto 0 );
    intr_o : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_phase_b;
architecture structural of blankingtimecorr_phase_b is 
  signal slice1_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal delay5_q_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal counter3_op_net : std_logic_vector( 32-1 downto 0 );
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
  signal constant6_op_net : std_logic_vector( 16-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal delay4_q_net : std_logic_vector( 1-1 downto 0 );
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical12_y_net : std_logic_vector( 1-1 downto 0 );
  signal register3_q_net : std_logic_vector( 32-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal ce_net : std_logic;
  signal ib_in_net : std_logic_vector( 16-1 downto 0 );
  signal clk_net : std_logic;
  signal inverter_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal constant5_op_net : std_logic_vector( 16-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical11_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical5_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical10_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical4_y_net : std_logic_vector( 1-1 downto 0 );
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical8_y_net : std_logic_vector( 1-1 downto 0 );
  signal relational6_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical6_y_net : std_logic_vector( 1-1 downto 0 );
begin
  t_phse_on <= register3_q_net;
  intr_o <= logical12_y_net;
  slice1_y_net <= igbt_bit;
  ib_in_net <= current;
  blankingtime_net <= blanking_time;
  delay1_q_net <= count_rst;
  logical3_y_net_x0 <= reg_en;
  clk_net <= clk_1;
  ce_net <= ce_1;
  blankingtime_counter : entity xil_defaultlib.blankingtimecorr_blankingtime_counter_x0 
  port map (
    en => register1_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net_x0
  );
  blankingtime_counter1 : entity xil_defaultlib.blankingtimecorr_blankingtime_counter1_x0 
  port map (
    en => register2_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net
  );
  falling_edge_detector : entity xil_defaultlib.blankingtimecorr_falling_edge_detector_x0 
  port map (
    u => slice1_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y_rise => logical3_y_net,
    y_fall => logical13_y_net
  );
  constant5 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant5_op_net
  );
  constant6 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant6_op_net
  );
  counter3 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i0",
    op_arith => xlUnsigned,
    op_width => 32
  )
  port map (
    clr => '0',
    rst => delay1_q_net,
    en => logical12_y_net,
    clk => clk_net,
    ce => ce_net,
    op => counter3_op_net
  );
  delay4 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 3,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice1_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay4_q_net
  );
  inverter : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical11_y_net,
    d1 => relational6_op_net,
    y => logical1_y_net
  );
  logical10 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical4_y_net,
    d1 => delay5_q_net,
    y => logical10_y_net
  );
  logical11 : entity xil_defaultlib.sysgen_logical_efbfa67d13 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => register2_q_net,
    en => relational6_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical11_y_net
  );
  logical12 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical2_y_net,
    d1 => logical1_y_net,
    y => logical12_y_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical6_y_net,
    d1 => relational1_op_net,
    y => logical2_y_net
  );
  logical4 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational6_op_net,
    d1 => logical13_y_net,
    y => logical4_y_net
  );
  logical5 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical3_y_net,
    d1 => relational1_op_net,
    y => logical5_y_net
  );
  logical6 : entity xil_defaultlib.sysgen_logical_606816afb7 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => inverter_op_net,
    en => relational1_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical6_y_net
  );
  logical8 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical5_y_net,
    d1 => delay5_q_net_x0,
    y => logical8_y_net
  );
  register1 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical5_y_net,
    en => logical8_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register1_q_net
  );
  register2 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical4_y_net,
    en => logical10_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register2_q_net
  );
  register3 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => counter3_op_net,
    en => logical3_y_net_x0,
    clk => clk_net,
    ce => ce_net,
    q => register3_q_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_c3849d09cf 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => constant5_op_net,
    b => ib_in_net,
    op => relational1_op_net
  );
  relational6 : entity xil_defaultlib.sysgen_relational_2f58baf397 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => ib_in_net,
    b => constant6_op_net,
    op => relational6_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase c/BlankingTime Counter
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter_x1 is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter_x1;
architecture structural of blankingtimecorr_blankingtime_counter_x1 is 
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal ce_net : std_logic;
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
  signal clk_net : std_logic;
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
begin
  out_x0 <= delay5_q_net;
  register1_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase c/BlankingTime Counter1
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_blankingtime_counter1_x1 is
  port (
    en : in std_logic_vector( 1-1 downto 0 );
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    out_x0 : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_blankingtime_counter1_x1;
architecture structural of blankingtimecorr_blankingtime_counter1_x1 is 
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal clk_net : std_logic;
  signal relational10_op_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal counter2_op_net : std_logic_vector( 18-1 downto 0 );
begin
  out_x0 <= delay5_q_net;
  register2_q_net <= en;
  blankingtime_net <= blankingtime;
  clk_net <= clk_1;
  ce_net <= ce_1;
  counter2 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i1",
    op_arith => xlUnsigned,
    op_width => 18
  )
  port map (
    clr => '0',
    rst => delay5_q_net,
    en => register2_q_net,
    clk => clk_net,
    ce => ce_net,
    op => counter2_op_net
  );
  delay5 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => relational10_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay5_q_net
  );
  relational10 : entity xil_defaultlib.sysgen_relational_849cf2ec16 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => counter2_op_net,
    b => blankingtime_net,
    op => relational10_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase c/Rising/falling edge detector
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_falling_edge_detector_x1 is
  port (
    u : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y_rise : out std_logic_vector( 1-1 downto 0 );
    y_fall : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_falling_edge_detector_x1;
architecture structural of blankingtimecorr_falling_edge_detector_x1 is 
  signal inverter3_op_net : std_logic_vector( 1-1 downto 0 );
  signal slice2_y_net : std_logic_vector( 1-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal delay2_q_net : std_logic_vector( 1-1 downto 0 );
begin
  y_rise <= logical3_y_net;
  y_fall <= logical13_y_net;
  slice2_y_net <= u;
  clk_net <= clk_1;
  ce_net <= ce_1;
  delay1 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => inverter1_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  delay2 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay2_q_net
  );
  inverter1 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice2_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  inverter3 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => slice2_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter3_op_net
  );
  logical13 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => inverter3_op_net,
    d1 => delay2_q_net,
    y => logical13_y_net
  );
  logical3 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => slice2_y_net,
    d1 => delay1_q_net,
    y => logical3_y_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Phase c
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_phase_c is
  port (
    igbt_bit : in std_logic_vector( 1-1 downto 0 );
    current : in std_logic_vector( 16-1 downto 0 );
    blanking_time : in std_logic_vector( 16-1 downto 0 );
    count_rst : in std_logic_vector( 1-1 downto 0 );
    reg_en : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    t_phse_on : out std_logic_vector( 32-1 downto 0 );
    intr_o : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_phase_c;
architecture structural of blankingtimecorr_phase_c is 
  signal clk_net : std_logic;
  signal ic_in_net : std_logic_vector( 16-1 downto 0 );
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal delay5_q_net : std_logic_vector( 1-1 downto 0 );
  signal counter3_op_net : std_logic_vector( 32-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal slice2_y_net : std_logic_vector( 1-1 downto 0 );
  signal register1_q_net : std_logic_vector( 1-1 downto 0 );
  signal delay5_q_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal constant5_op_net : std_logic_vector( 16-1 downto 0 );
  signal ce_net : std_logic;
  signal constant6_op_net : std_logic_vector( 16-1 downto 0 );
  signal logical3_y_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal register2_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical12_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical13_y_net : std_logic_vector( 1-1 downto 0 );
  signal register3_q_net : std_logic_vector( 32-1 downto 0 );
  signal logical5_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical1_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical6_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical10_y_net : std_logic_vector( 1-1 downto 0 );
  signal relational1_op_net : std_logic_vector( 1-1 downto 0 );
  signal relational6_op_net : std_logic_vector( 1-1 downto 0 );
  signal inverter_op_net : std_logic_vector( 1-1 downto 0 );
  signal logical2_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical11_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical4_y_net : std_logic_vector( 1-1 downto 0 );
  signal delay4_q_net : std_logic_vector( 1-1 downto 0 );
  signal logical8_y_net : std_logic_vector( 1-1 downto 0 );
begin
  t_phse_on <= register3_q_net;
  intr_o <= logical12_y_net;
  slice2_y_net <= igbt_bit;
  ic_in_net <= current;
  blankingtime_net <= blanking_time;
  delay1_q_net <= count_rst;
  logical3_y_net_x0 <= reg_en;
  clk_net <= clk_1;
  ce_net <= ce_1;
  blankingtime_counter : entity xil_defaultlib.blankingtimecorr_blankingtime_counter_x1 
  port map (
    en => register1_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net_x0
  );
  blankingtime_counter1 : entity xil_defaultlib.blankingtimecorr_blankingtime_counter1_x1 
  port map (
    en => register2_q_net,
    blankingtime => blankingtime_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    out_x0 => delay5_q_net
  );
  falling_edge_detector : entity xil_defaultlib.blankingtimecorr_falling_edge_detector_x1 
  port map (
    u => slice2_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y_rise => logical3_y_net,
    y_fall => logical13_y_net
  );
  constant5 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant5_op_net
  );
  constant6 : entity xil_defaultlib.sysgen_constant_92fca9b0f5 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant6_op_net
  );
  counter3 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i0",
    op_arith => xlUnsigned,
    op_width => 32
  )
  port map (
    clr => '0',
    rst => delay1_q_net,
    en => logical12_y_net,
    clk => clk_net,
    ce => ce_net,
    op => counter3_op_net
  );
  delay4 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 3,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => slice2_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay4_q_net
  );
  inverter : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => register1_q_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter_op_net
  );
  logical1 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical11_y_net,
    d1 => relational6_op_net,
    y => logical1_y_net
  );
  logical10 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical4_y_net,
    d1 => delay5_q_net,
    y => logical10_y_net
  );
  logical11 : entity xil_defaultlib.sysgen_logical_efbfa67d13 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => register2_q_net,
    en => relational6_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical11_y_net
  );
  logical12 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical2_y_net,
    d1 => logical1_y_net,
    y => logical12_y_net
  );
  logical2 : entity xil_defaultlib.sysgen_logical_ef36cd3004 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical6_y_net,
    d1 => relational1_op_net,
    y => logical2_y_net
  );
  logical4 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => relational6_op_net,
    d1 => logical13_y_net,
    y => logical4_y_net
  );
  logical5 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical3_y_net,
    d1 => relational1_op_net,
    y => logical5_y_net
  );
  logical6 : entity xil_defaultlib.sysgen_logical_606816afb7 
  port map (
    clr => '0',
    d0 => delay4_q_net,
    d1 => inverter_op_net,
    en => relational1_op_net,
    clk => clk_net,
    ce => ce_net,
    y => logical6_y_net
  );
  logical8 : entity xil_defaultlib.sysgen_logical_41e6918a05 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => logical5_y_net,
    d1 => delay5_q_net_x0,
    y => logical8_y_net
  );
  register1 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical5_y_net,
    en => logical8_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register1_q_net
  );
  register2 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 1,
    init_value => b"0"
  )
  port map (
    rst => "0",
    d => logical4_y_net,
    en => logical10_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register2_q_net
  );
  register3 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => counter3_op_net,
    en => logical3_y_net_x0,
    clk => clk_net,
    ce => ce_net,
    q => register3_q_net
  );
  relational1 : entity xil_defaultlib.sysgen_relational_c3849d09cf 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => constant5_op_net,
    b => ic_in_net,
    op => relational1_op_net
  );
  relational6 : entity xil_defaultlib.sysgen_relational_2f58baf397 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    a => ic_in_net,
    b => constant6_op_net,
    op => relational6_op_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Sequencer/Rising edge detector
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_rising_edge_detector is
  port (
    u : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    y_rise : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_rising_edge_detector;
architecture structural of blankingtimecorr_rising_edge_detector is 
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal convert_dout_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal clk_net : std_logic;
begin
  y_rise <= logical3_y_net;
  convert_dout_net <= u;
  clk_net <= clk_1;
  ce_net <= ce_1;
  delay1 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => inverter1_op_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  inverter1 : entity xil_defaultlib.sysgen_inverter_4779162bd7 
  port map (
    clr => '0',
    ip => convert_dout_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  logical3 : entity xil_defaultlib.sysgen_logical_912fe01300 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    d0 => convert_dout_net,
    d1 => delay1_q_net,
    y => logical3_y_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr/Sequencer
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_sequencer is
  port (
    intr1 : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    t_samp_on : out std_logic_vector( 32-1 downto 0 );
    count_rst : out std_logic_vector( 1-1 downto 0 );
    reg_rst : out std_logic_vector( 1-1 downto 0 )
  );
end blankingtimecorr_sequencer;
architecture structural of blankingtimecorr_sequencer is 
  signal convert_dout_net : std_logic_vector( 1-1 downto 0 );
  signal counter4_op_net : std_logic_vector( 32-1 downto 0 );
  signal intr_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal delay_q_net : std_logic_vector( 1-1 downto 0 );
  signal register_q_net : std_logic_vector( 32-1 downto 0 );
  signal inverter1_op_net : std_logic_vector( 1-1 downto 0 );
  signal ce_net : std_logic;
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
begin
  t_samp_on <= register_q_net;
  count_rst <= delay1_q_net;
  reg_rst <= logical3_y_net;
  intr_net <= intr1;
  clk_net <= clk_1;
  ce_net <= ce_1;
  rising_edge_detector : entity xil_defaultlib.blankingtimecorr_rising_edge_detector 
  port map (
    u => convert_dout_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    y_rise => logical3_y_net
  );
  convert : entity xil_defaultlib.blankingtimecorr_xlconvert 
  generic map (
    bool_conversion => 1,
    din_arith => 1,
    din_bin_pt => 0,
    din_width => 1,
    dout_arith => 1,
    dout_bin_pt => 0,
    dout_width => 1,
    latency => 0,
    overflow => xlWrap,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => intr_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  counter4 : entity xil_defaultlib.blankingtimecorr_xlcounter_free 
  generic map (
    core_name0 => "blankingtimecorr_c_counter_binary_v12_0_i0",
    op_arith => xlUnsigned,
    op_width => 32
  )
  port map (
    clr => '0',
    rst => delay_q_net,
    en => inverter1_op_net,
    clk => clk_net,
    ce => ce_net,
    op => counter4_op_net
  );
  delay : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 1,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => logical3_y_net,
    clk => clk_net,
    ce => ce_net,
    q => delay_q_net
  );
  delay1 : entity xil_defaultlib.blankingtimecorr_xldelay 
  generic map (
    latency => 10,
    reg_retiming => 0,
    reset => 0,
    width => 1
  )
  port map (
    en => '1',
    rst => '1',
    d => delay_q_net,
    clk => clk_net,
    ce => ce_net,
    q => delay1_q_net
  );
  inverter1 : entity xil_defaultlib.sysgen_inverter_0a189768af 
  port map (
    clr => '0',
    ip => logical3_y_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter1_op_net
  );
  register_x0 : entity xil_defaultlib.blankingtimecorr_xlregister 
  generic map (
    d_width => 32,
    init_value => b"00000000000000000000000000000000"
  )
  port map (
    rst => "0",
    d => counter4_op_net,
    en => logical3_y_net,
    clk => clk_net,
    ce => ce_net,
    q => register_q_net
  );
end structural;
-- Generated from Simulink block BlankingTimeCorr_struct
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_struct is
  port (
    blankingtime : in std_logic_vector( 16-1 downto 0 );
    intr : in std_logic_vector( 1-1 downto 0 );
    driver_signals : in std_logic_vector( 6-1 downto 0 );
    ia_in : in std_logic_vector( 16-1 downto 0 );
    ib_in : in std_logic_vector( 16-1 downto 0 );
    ic_in : in std_logic_vector( 16-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    t_samp_on : out std_logic_vector( 32-1 downto 0 );
    ta_on : out std_logic_vector( 32-1 downto 0 );
    tb_on : out std_logic_vector( 32-1 downto 0 );
    tc_on : out std_logic_vector( 32-1 downto 0 )
  );
end blankingtimecorr_struct;
architecture structural of blankingtimecorr_struct is 
  signal blankingtime_net : std_logic_vector( 16-1 downto 0 );
  signal intr_net : std_logic_vector( 1-1 downto 0 );
  signal register_q_net : std_logic_vector( 32-1 downto 0 );
  signal register3_q_net_x1 : std_logic_vector( 32-1 downto 0 );
  signal ce_net : std_logic;
  signal clk_net : std_logic;
  signal logical12_y_net : std_logic_vector( 1-1 downto 0 );
  signal ia_in_net : std_logic_vector( 16-1 downto 0 );
  signal slice_y_net : std_logic_vector( 1-1 downto 0 );
  signal ic_in_net : std_logic_vector( 16-1 downto 0 );
  signal logical12_y_net_x0 : std_logic_vector( 1-1 downto 0 );
  signal slice2_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical3_y_net : std_logic_vector( 1-1 downto 0 );
  signal logical12_y_net_x1 : std_logic_vector( 1-1 downto 0 );
  signal driver_signals_net : std_logic_vector( 6-1 downto 0 );
  signal register3_q_net : std_logic_vector( 32-1 downto 0 );
  signal ib_in_net : std_logic_vector( 16-1 downto 0 );
  signal delay1_q_net : std_logic_vector( 1-1 downto 0 );
  signal slice1_y_net : std_logic_vector( 1-1 downto 0 );
  signal register3_q_net_x0 : std_logic_vector( 32-1 downto 0 );
begin
  blankingtime_net <= blankingtime;
  intr_net <= intr;
  t_samp_on <= register_q_net;
  ta_on <= register3_q_net_x1;
  tb_on <= register3_q_net_x0;
  tc_on <= register3_q_net;
  driver_signals_net <= driver_signals;
  ia_in_net <= ia_in;
  ib_in_net <= ib_in;
  ic_in_net <= ic_in;
  clk_net <= clk_1;
  ce_net <= ce_1;
  phase_a : entity xil_defaultlib.blankingtimecorr_phase_a 
  port map (
    igbt_bit => slice_y_net,
    current => ia_in_net,
    blanking_time => blankingtime_net,
    count_rst => delay1_q_net,
    reg_en => logical3_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    t_phse_on => register3_q_net_x1,
    intr_o => logical12_y_net_x1
  );
  phase_b : entity xil_defaultlib.blankingtimecorr_phase_b 
  port map (
    igbt_bit => slice1_y_net,
    current => ib_in_net,
    blanking_time => blankingtime_net,
    count_rst => delay1_q_net,
    reg_en => logical3_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    t_phse_on => register3_q_net_x0,
    intr_o => logical12_y_net_x0
  );
  phase_c : entity xil_defaultlib.blankingtimecorr_phase_c 
  port map (
    igbt_bit => slice2_y_net,
    current => ic_in_net,
    blanking_time => blankingtime_net,
    count_rst => delay1_q_net,
    reg_en => logical3_y_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    t_phse_on => register3_q_net,
    intr_o => logical12_y_net
  );
  sequencer : entity xil_defaultlib.blankingtimecorr_sequencer 
  port map (
    intr1 => intr_net,
    clk_1 => clk_net,
    ce_1 => ce_net,
    t_samp_on => register_q_net,
    count_rst => delay1_q_net,
    reg_rst => logical3_y_net
  );
  slice : entity xil_defaultlib.blankingtimecorr_xlslice 
  generic map (
    new_lsb => 1,
    new_msb => 1,
    x_width => 6,
    y_width => 1
  )
  port map (
    x => driver_signals_net,
    y => slice_y_net
  );
  slice1 : entity xil_defaultlib.blankingtimecorr_xlslice 
  generic map (
    new_lsb => 3,
    new_msb => 3,
    x_width => 6,
    y_width => 1
  )
  port map (
    x => driver_signals_net,
    y => slice1_y_net
  );
  slice2 : entity xil_defaultlib.blankingtimecorr_xlslice 
  generic map (
    new_lsb => 5,
    new_msb => 5,
    x_width => 6,
    y_width => 1
  )
  port map (
    x => driver_signals_net,
    y => slice2_y_net
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr_default_clock_driver is
  port (
    blankingtimecorr_sysclk : in std_logic;
    blankingtimecorr_sysce : in std_logic;
    blankingtimecorr_sysclr : in std_logic;
    blankingtimecorr_clk1 : out std_logic;
    blankingtimecorr_ce1 : out std_logic
  );
end blankingtimecorr_default_clock_driver;
architecture structural of blankingtimecorr_default_clock_driver is 
begin
  clockdriver : entity xil_defaultlib.xlclockdriver 
  generic map (
    period => 1,
    log_2_period => 1
  )
  port map (
    sysclk => blankingtimecorr_sysclk,
    sysce => blankingtimecorr_sysce,
    sysclr => blankingtimecorr_sysclr,
    clk => blankingtimecorr_clk1,
    ce => blankingtimecorr_ce1
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity blankingtimecorr is
  port (
    intr : in std_logic;
    driver_signals : in std_logic_vector( 6-1 downto 0 );
    clk : in std_logic;
    blankingtimecorr_aresetn : in std_logic;
    blankingtimecorr_s_axi_awaddr : in std_logic_vector( 5-1 downto 0 );
    blankingtimecorr_s_axi_awvalid : in std_logic;
    blankingtimecorr_s_axi_wdata : in std_logic_vector( 32-1 downto 0 );
    blankingtimecorr_s_axi_wstrb : in std_logic_vector( 4-1 downto 0 );
    blankingtimecorr_s_axi_wvalid : in std_logic;
    blankingtimecorr_s_axi_bready : in std_logic;
    blankingtimecorr_s_axi_araddr : in std_logic_vector( 5-1 downto 0 );
    blankingtimecorr_s_axi_arvalid : in std_logic;
    blankingtimecorr_s_axi_rready : in std_logic;
    blankingtimecorr_s_axi_awready : out std_logic;
    blankingtimecorr_s_axi_wready : out std_logic;
    blankingtimecorr_s_axi_bresp : out std_logic_vector( 2-1 downto 0 );
    blankingtimecorr_s_axi_bvalid : out std_logic;
    blankingtimecorr_s_axi_arready : out std_logic;
    blankingtimecorr_s_axi_rdata : out std_logic_vector( 32-1 downto 0 );
    blankingtimecorr_s_axi_rresp : out std_logic_vector( 2-1 downto 0 );
    blankingtimecorr_s_axi_rvalid : out std_logic
  );
end blankingtimecorr;
architecture structural of blankingtimecorr is 
  attribute core_generation_info : string;
  attribute core_generation_info of structural : architecture is "blankingtimecorr,sysgen_core_2017_2,{,compilation=IP Catalog,block_icon_display=Default,family=zynq,part=xc7z030,speed=-1,package=sbg485,synthesis_language=vhdl,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=1,ce_clr=0,clock_period=10,system_simulink_period=1e-08,waveform_viewer=0,axilite_interface=1,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.02,constant=6,convert=1,counter=10,delay=18,inv=11,logical=34,register=10,relational=12,slice=3,}";
  signal t_samp_on : std_logic_vector( 32-1 downto 0 );
  signal ib_in : std_logic_vector( 16-1 downto 0 );
  signal ia_in : std_logic_vector( 16-1 downto 0 );
  signal ic_in : std_logic_vector( 16-1 downto 0 );
  signal tc_on : std_logic_vector( 32-1 downto 0 );
  signal blankingtime : std_logic_vector( 16-1 downto 0 );
  signal ce_1_net : std_logic;
  signal ta_on : std_logic_vector( 32-1 downto 0 );
  signal tb_on : std_logic_vector( 32-1 downto 0 );
  signal clk_1_net : std_logic;
  signal clk_net : std_logic;
begin
  blankingtimecorr_axi_lite_interface : entity xil_defaultlib.blankingtimecorr_axi_lite_interface 
  port map (
    t_samp_on => t_samp_on,
    ta_on => ta_on,
    tb_on => tb_on,
    tc_on => tc_on,
    blankingtimecorr_s_axi_awaddr => blankingtimecorr_s_axi_awaddr,
    blankingtimecorr_s_axi_awvalid => blankingtimecorr_s_axi_awvalid,
    blankingtimecorr_s_axi_wdata => blankingtimecorr_s_axi_wdata,
    blankingtimecorr_s_axi_wstrb => blankingtimecorr_s_axi_wstrb,
    blankingtimecorr_s_axi_wvalid => blankingtimecorr_s_axi_wvalid,
    blankingtimecorr_s_axi_bready => blankingtimecorr_s_axi_bready,
    blankingtimecorr_s_axi_araddr => blankingtimecorr_s_axi_araddr,
    blankingtimecorr_s_axi_arvalid => blankingtimecorr_s_axi_arvalid,
    blankingtimecorr_s_axi_rready => blankingtimecorr_s_axi_rready,
    blankingtimecorr_aresetn => blankingtimecorr_aresetn,
    blankingtimecorr_aclk => clk,
    ic_in => ic_in,
    ib_in => ib_in,
    ia_in => ia_in,
    blankingtime => blankingtime,
    blankingtimecorr_s_axi_awready => blankingtimecorr_s_axi_awready,
    blankingtimecorr_s_axi_wready => blankingtimecorr_s_axi_wready,
    blankingtimecorr_s_axi_bresp => blankingtimecorr_s_axi_bresp,
    blankingtimecorr_s_axi_bvalid => blankingtimecorr_s_axi_bvalid,
    blankingtimecorr_s_axi_arready => blankingtimecorr_s_axi_arready,
    blankingtimecorr_s_axi_rdata => blankingtimecorr_s_axi_rdata,
    blankingtimecorr_s_axi_rresp => blankingtimecorr_s_axi_rresp,
    blankingtimecorr_s_axi_rvalid => blankingtimecorr_s_axi_rvalid,
    clk => clk_net
  );
  blankingtimecorr_default_clock_driver : entity xil_defaultlib.blankingtimecorr_default_clock_driver 
  port map (
    blankingtimecorr_sysclk => clk_net,
    blankingtimecorr_sysce => '1',
    blankingtimecorr_sysclr => '0',
    blankingtimecorr_clk1 => clk_1_net,
    blankingtimecorr_ce1 => ce_1_net
  );
  blankingtimecorr_struct : entity xil_defaultlib.blankingtimecorr_struct 
  port map (
    blankingtime => blankingtime,
    intr(0) => intr,
    driver_signals => driver_signals,
    ia_in => ia_in,
    ib_in => ib_in,
    ic_in => ic_in,
    clk_1 => clk_1_net,
    ce_1 => ce_1_net,
    t_samp_on => t_samp_on,
    ta_on => ta_on,
    tb_on => tb_on,
    tc_on => tc_on
  );
end structural;
