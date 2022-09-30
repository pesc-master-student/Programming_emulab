--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Tue Aug 30 14:10:02 2022
--Host        : NTNU13875 running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DRIVER1_D : out STD_LOGIC_VECTOR ( 5 downto 0 );
    DRIVER1_ENABLE : out STD_LOGIC;
    DRIVER1_OK : in STD_LOGIC;
    DRIVER1_RESET : out STD_LOGIC;
    DRIVER1_T : in STD_LOGIC_VECTOR ( 3 downto 0 );
    DRIVER2_D : out STD_LOGIC_VECTOR ( 5 downto 0 );
    DRIVER2_ENABLE : out STD_LOGIC;
    DRIVER2_OK : in STD_LOGIC;
    DRIVER2_RESET : out STD_LOGIC;
    DRIVER2_T : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ENC_ERR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ENC_LED : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ENC_P : in STD_LOGIC_VECTOR ( 2 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    HW_INTERLOCK : in STD_LOGIC_VECTOR ( 0 to 0 );
    LED_ALARM : out STD_LOGIC;
    LVCT_OE_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    PILOT_SIGNAL : out STD_LOGIC;
    RELAY : out STD_LOGIC_VECTOR ( 3 downto 0 );
    RS485_SCLK : out STD_LOGIC;
    RS485_SDIN : in STD_LOGIC;
    RS485_SDOUT : out STD_LOGIC;
    RS485_SOEN : out STD_LOGIC;
    SIG_D : in STD_LOGIC_VECTOR ( 5 downto 0 );
    SIG_R_PU : out STD_LOGIC_VECTOR ( 5 downto 0 );
    TEST : out STD_LOGIC_VECTOR ( 4 downto 0 );
    Vaux0_v_n : in STD_LOGIC;
    Vaux0_v_p : in STD_LOGIC;
    Vaux8_v_n : in STD_LOGIC;
    Vaux8_v_p : in STD_LOGIC;
    Vp_Vn_v_n : in STD_LOGIC;
    Vp_Vn_v_p : in STD_LOGIC;
    XADC_MUX : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ad_d_n : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ad_d_p : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ad_dcon : in STD_LOGIC;
    ad_dcop : in STD_LOGIC;
    ad_fcon : in STD_LOGIC;
    ad_fcop : in STD_LOGIC;
    ad_sclk : out STD_LOGIC;
    ad_scsb : out STD_LOGIC_VECTOR ( 0 to 0 );
    ad_sdio_tri_io : inout STD_LOGIC_VECTOR ( 0 to 0 );
    da_a_b : out STD_LOGIC;
    da_ab_cs : out STD_LOGIC;
    da_cd_cs : out STD_LOGIC;
    da_d : out STD_LOGIC_VECTOR ( 11 downto 0 );
    gpio1_d_tri_io : inout STD_LOGIC_VECTOR ( 15 downto 0 )
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    ENC_P : in STD_LOGIC_VECTOR ( 2 downto 0 );
    ENC_ERR : in STD_LOGIC_VECTOR ( 0 to 0 );
    SIG_D : in STD_LOGIC_VECTOR ( 5 downto 0 );
    ad_d_n : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ad_d_p : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ad_dcon : in STD_LOGIC;
    ad_dcop : in STD_LOGIC;
    ad_fcon : in STD_LOGIC;
    ad_fcop : in STD_LOGIC;
    TEST : out STD_LOGIC_VECTOR ( 4 downto 0 );
    da_a_b : out STD_LOGIC;
    da_ab_cs : out STD_LOGIC;
    da_cd_cs : out STD_LOGIC;
    da_d : out STD_LOGIC_VECTOR ( 11 downto 0 );
    DRIVER2_OK : in STD_LOGIC;
    DRIVER2_T : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ENC_LED : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ad_sclk : out STD_LOGIC;
    ad_scsb : out STD_LOGIC_VECTOR ( 0 to 0 );
    RELAY : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SIG_R_PU : out STD_LOGIC_VECTOR ( 5 downto 0 );
    LED_ALARM : out STD_LOGIC;
    LVCT_OE_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    XADC_MUX : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DRIVER1_RESET : out STD_LOGIC;
    DRIVER1_ENABLE : out STD_LOGIC;
    DRIVER1_D : out STD_LOGIC_VECTOR ( 5 downto 0 );
    PILOT_SIGNAL : out STD_LOGIC;
    DRIVER1_T : in STD_LOGIC_VECTOR ( 3 downto 0 );
    DRIVER1_OK : in STD_LOGIC;
    HW_INTERLOCK : in STD_LOGIC_VECTOR ( 0 to 0 );
    DRIVER2_ENABLE : out STD_LOGIC;
    DRIVER2_D : out STD_LOGIC_VECTOR ( 5 downto 0 );
    DRIVER2_RESET : out STD_LOGIC;
    RS485_SDIN : in STD_LOGIC;
    RS485_SDOUT : out STD_LOGIC;
    RS485_SCLK : out STD_LOGIC;
    RS485_SOEN : out STD_LOGIC;
    ad_sdio_tri_t : out STD_LOGIC_VECTOR ( 0 to 0 );
    ad_sdio_tri_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    ad_sdio_tri_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Vaux0_v_n : in STD_LOGIC;
    Vaux0_v_p : in STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    Vp_Vn_v_n : in STD_LOGIC;
    Vp_Vn_v_p : in STD_LOGIC;
    gpio1_d_tri_i : in STD_LOGIC_VECTOR ( 15 downto 0 );
    gpio1_d_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    gpio1_d_tri_t : out STD_LOGIC_VECTOR ( 15 downto 0 );
    Vaux8_v_n : in STD_LOGIC;
    Vaux8_v_p : in STD_LOGIC
  );
  end component design_1;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal ad_sdio_tri_i_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ad_sdio_tri_io_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ad_sdio_tri_o_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ad_sdio_tri_t_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio1_d_tri_i_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio1_d_tri_i_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio1_d_tri_i_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio1_d_tri_i_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio1_d_tri_i_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio1_d_tri_i_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio1_d_tri_i_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio1_d_tri_i_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio1_d_tri_i_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio1_d_tri_i_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio1_d_tri_i_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio1_d_tri_i_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio1_d_tri_i_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio1_d_tri_i_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio1_d_tri_i_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio1_d_tri_i_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio1_d_tri_io_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio1_d_tri_io_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio1_d_tri_io_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio1_d_tri_io_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio1_d_tri_io_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio1_d_tri_io_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio1_d_tri_io_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio1_d_tri_io_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio1_d_tri_io_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio1_d_tri_io_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio1_d_tri_io_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio1_d_tri_io_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio1_d_tri_io_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio1_d_tri_io_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio1_d_tri_io_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio1_d_tri_io_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio1_d_tri_o_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio1_d_tri_o_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio1_d_tri_o_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio1_d_tri_o_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio1_d_tri_o_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio1_d_tri_o_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio1_d_tri_o_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio1_d_tri_o_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio1_d_tri_o_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio1_d_tri_o_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio1_d_tri_o_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio1_d_tri_o_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio1_d_tri_o_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio1_d_tri_o_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio1_d_tri_o_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio1_d_tri_o_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio1_d_tri_t_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio1_d_tri_t_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio1_d_tri_t_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio1_d_tri_t_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio1_d_tri_t_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio1_d_tri_t_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio1_d_tri_t_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio1_d_tri_t_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio1_d_tri_t_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio1_d_tri_t_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio1_d_tri_t_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio1_d_tri_t_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio1_d_tri_t_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio1_d_tri_t_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio1_d_tri_t_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio1_d_tri_t_9 : STD_LOGIC_VECTOR ( 9 to 9 );
begin
ad_sdio_tri_iobuf_0: component IOBUF
     port map (
      I => ad_sdio_tri_o_0(0),
      IO => ad_sdio_tri_io(0),
      O => ad_sdio_tri_i_0(0),
      T => ad_sdio_tri_t_0(0)
    );
design_1_i: component design_1
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      DRIVER1_D(5 downto 0) => DRIVER1_D(5 downto 0),
      DRIVER1_ENABLE => DRIVER1_ENABLE,
      DRIVER1_OK => DRIVER1_OK,
      DRIVER1_RESET => DRIVER1_RESET,
      DRIVER1_T(3 downto 0) => DRIVER1_T(3 downto 0),
      DRIVER2_D(5 downto 0) => DRIVER2_D(5 downto 0),
      DRIVER2_ENABLE => DRIVER2_ENABLE,
      DRIVER2_OK => DRIVER2_OK,
      DRIVER2_RESET => DRIVER2_RESET,
      DRIVER2_T(3 downto 0) => DRIVER2_T(3 downto 0),
      ENC_ERR(0) => ENC_ERR(0),
      ENC_LED(3 downto 0) => ENC_LED(3 downto 0),
      ENC_P(2 downto 0) => ENC_P(2 downto 0),
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      HW_INTERLOCK(0) => HW_INTERLOCK(0),
      LED_ALARM => LED_ALARM,
      LVCT_OE_N(0) => LVCT_OE_N(0),
      PILOT_SIGNAL => PILOT_SIGNAL,
      RELAY(3 downto 0) => RELAY(3 downto 0),
      RS485_SCLK => RS485_SCLK,
      RS485_SDIN => RS485_SDIN,
      RS485_SDOUT => RS485_SDOUT,
      RS485_SOEN => RS485_SOEN,
      SIG_D(5 downto 0) => SIG_D(5 downto 0),
      SIG_R_PU(5 downto 0) => SIG_R_PU(5 downto 0),
      TEST(4 downto 0) => TEST(4 downto 0),
      Vaux0_v_n => Vaux0_v_n,
      Vaux0_v_p => Vaux0_v_p,
      Vaux8_v_n => Vaux8_v_n,
      Vaux8_v_p => Vaux8_v_p,
      Vp_Vn_v_n => Vp_Vn_v_n,
      Vp_Vn_v_p => Vp_Vn_v_p,
      XADC_MUX(1 downto 0) => XADC_MUX(1 downto 0),
      ad_d_n(7 downto 0) => ad_d_n(7 downto 0),
      ad_d_p(7 downto 0) => ad_d_p(7 downto 0),
      ad_dcon => ad_dcon,
      ad_dcop => ad_dcop,
      ad_fcon => ad_fcon,
      ad_fcop => ad_fcop,
      ad_sclk => ad_sclk,
      ad_scsb(0) => ad_scsb(0),
      ad_sdio_tri_i(0) => ad_sdio_tri_i_0(0),
      ad_sdio_tri_o(0) => ad_sdio_tri_o_0(0),
      ad_sdio_tri_t(0) => ad_sdio_tri_t_0(0),
      da_a_b => da_a_b,
      da_ab_cs => da_ab_cs,
      da_cd_cs => da_cd_cs,
      da_d(11 downto 0) => da_d(11 downto 0),
      gpio1_d_tri_i(15) => gpio1_d_tri_i_15(15),
      gpio1_d_tri_i(14) => gpio1_d_tri_i_14(14),
      gpio1_d_tri_i(13) => gpio1_d_tri_i_13(13),
      gpio1_d_tri_i(12) => gpio1_d_tri_i_12(12),
      gpio1_d_tri_i(11) => gpio1_d_tri_i_11(11),
      gpio1_d_tri_i(10) => gpio1_d_tri_i_10(10),
      gpio1_d_tri_i(9) => gpio1_d_tri_i_9(9),
      gpio1_d_tri_i(8) => gpio1_d_tri_i_8(8),
      gpio1_d_tri_i(7) => gpio1_d_tri_i_7(7),
      gpio1_d_tri_i(6) => gpio1_d_tri_i_6(6),
      gpio1_d_tri_i(5) => gpio1_d_tri_i_5(5),
      gpio1_d_tri_i(4) => gpio1_d_tri_i_4(4),
      gpio1_d_tri_i(3) => gpio1_d_tri_i_3(3),
      gpio1_d_tri_i(2) => gpio1_d_tri_i_2(2),
      gpio1_d_tri_i(1) => gpio1_d_tri_i_1(1),
      gpio1_d_tri_i(0) => gpio1_d_tri_i_0(0),
      gpio1_d_tri_o(15) => gpio1_d_tri_o_15(15),
      gpio1_d_tri_o(14) => gpio1_d_tri_o_14(14),
      gpio1_d_tri_o(13) => gpio1_d_tri_o_13(13),
      gpio1_d_tri_o(12) => gpio1_d_tri_o_12(12),
      gpio1_d_tri_o(11) => gpio1_d_tri_o_11(11),
      gpio1_d_tri_o(10) => gpio1_d_tri_o_10(10),
      gpio1_d_tri_o(9) => gpio1_d_tri_o_9(9),
      gpio1_d_tri_o(8) => gpio1_d_tri_o_8(8),
      gpio1_d_tri_o(7) => gpio1_d_tri_o_7(7),
      gpio1_d_tri_o(6) => gpio1_d_tri_o_6(6),
      gpio1_d_tri_o(5) => gpio1_d_tri_o_5(5),
      gpio1_d_tri_o(4) => gpio1_d_tri_o_4(4),
      gpio1_d_tri_o(3) => gpio1_d_tri_o_3(3),
      gpio1_d_tri_o(2) => gpio1_d_tri_o_2(2),
      gpio1_d_tri_o(1) => gpio1_d_tri_o_1(1),
      gpio1_d_tri_o(0) => gpio1_d_tri_o_0(0),
      gpio1_d_tri_t(15) => gpio1_d_tri_t_15(15),
      gpio1_d_tri_t(14) => gpio1_d_tri_t_14(14),
      gpio1_d_tri_t(13) => gpio1_d_tri_t_13(13),
      gpio1_d_tri_t(12) => gpio1_d_tri_t_12(12),
      gpio1_d_tri_t(11) => gpio1_d_tri_t_11(11),
      gpio1_d_tri_t(10) => gpio1_d_tri_t_10(10),
      gpio1_d_tri_t(9) => gpio1_d_tri_t_9(9),
      gpio1_d_tri_t(8) => gpio1_d_tri_t_8(8),
      gpio1_d_tri_t(7) => gpio1_d_tri_t_7(7),
      gpio1_d_tri_t(6) => gpio1_d_tri_t_6(6),
      gpio1_d_tri_t(5) => gpio1_d_tri_t_5(5),
      gpio1_d_tri_t(4) => gpio1_d_tri_t_4(4),
      gpio1_d_tri_t(3) => gpio1_d_tri_t_3(3),
      gpio1_d_tri_t(2) => gpio1_d_tri_t_2(2),
      gpio1_d_tri_t(1) => gpio1_d_tri_t_1(1),
      gpio1_d_tri_t(0) => gpio1_d_tri_t_0(0)
    );
gpio1_d_tri_iobuf_0: component IOBUF
     port map (
      I => gpio1_d_tri_o_0(0),
      IO => gpio1_d_tri_io(0),
      O => gpio1_d_tri_i_0(0),
      T => gpio1_d_tri_t_0(0)
    );
gpio1_d_tri_iobuf_1: component IOBUF
     port map (
      I => gpio1_d_tri_o_1(1),
      IO => gpio1_d_tri_io(1),
      O => gpio1_d_tri_i_1(1),
      T => gpio1_d_tri_t_1(1)
    );
gpio1_d_tri_iobuf_10: component IOBUF
     port map (
      I => gpio1_d_tri_o_10(10),
      IO => gpio1_d_tri_io(10),
      O => gpio1_d_tri_i_10(10),
      T => gpio1_d_tri_t_10(10)
    );
gpio1_d_tri_iobuf_11: component IOBUF
     port map (
      I => gpio1_d_tri_o_11(11),
      IO => gpio1_d_tri_io(11),
      O => gpio1_d_tri_i_11(11),
      T => gpio1_d_tri_t_11(11)
    );
gpio1_d_tri_iobuf_12: component IOBUF
     port map (
      I => gpio1_d_tri_o_12(12),
      IO => gpio1_d_tri_io(12),
      O => gpio1_d_tri_i_12(12),
      T => gpio1_d_tri_t_12(12)
    );
gpio1_d_tri_iobuf_13: component IOBUF
     port map (
      I => gpio1_d_tri_o_13(13),
      IO => gpio1_d_tri_io(13),
      O => gpio1_d_tri_i_13(13),
      T => gpio1_d_tri_t_13(13)
    );
gpio1_d_tri_iobuf_14: component IOBUF
     port map (
      I => gpio1_d_tri_o_14(14),
      IO => gpio1_d_tri_io(14),
      O => gpio1_d_tri_i_14(14),
      T => gpio1_d_tri_t_14(14)
    );
gpio1_d_tri_iobuf_15: component IOBUF
     port map (
      I => gpio1_d_tri_o_15(15),
      IO => gpio1_d_tri_io(15),
      O => gpio1_d_tri_i_15(15),
      T => gpio1_d_tri_t_15(15)
    );
gpio1_d_tri_iobuf_2: component IOBUF
     port map (
      I => gpio1_d_tri_o_2(2),
      IO => gpio1_d_tri_io(2),
      O => gpio1_d_tri_i_2(2),
      T => gpio1_d_tri_t_2(2)
    );
gpio1_d_tri_iobuf_3: component IOBUF
     port map (
      I => gpio1_d_tri_o_3(3),
      IO => gpio1_d_tri_io(3),
      O => gpio1_d_tri_i_3(3),
      T => gpio1_d_tri_t_3(3)
    );
gpio1_d_tri_iobuf_4: component IOBUF
     port map (
      I => gpio1_d_tri_o_4(4),
      IO => gpio1_d_tri_io(4),
      O => gpio1_d_tri_i_4(4),
      T => gpio1_d_tri_t_4(4)
    );
gpio1_d_tri_iobuf_5: component IOBUF
     port map (
      I => gpio1_d_tri_o_5(5),
      IO => gpio1_d_tri_io(5),
      O => gpio1_d_tri_i_5(5),
      T => gpio1_d_tri_t_5(5)
    );
gpio1_d_tri_iobuf_6: component IOBUF
     port map (
      I => gpio1_d_tri_o_6(6),
      IO => gpio1_d_tri_io(6),
      O => gpio1_d_tri_i_6(6),
      T => gpio1_d_tri_t_6(6)
    );
gpio1_d_tri_iobuf_7: component IOBUF
     port map (
      I => gpio1_d_tri_o_7(7),
      IO => gpio1_d_tri_io(7),
      O => gpio1_d_tri_i_7(7),
      T => gpio1_d_tri_t_7(7)
    );
gpio1_d_tri_iobuf_8: component IOBUF
     port map (
      I => gpio1_d_tri_o_8(8),
      IO => gpio1_d_tri_io(8),
      O => gpio1_d_tri_i_8(8),
      T => gpio1_d_tri_t_8(8)
    );
gpio1_d_tri_iobuf_9: component IOBUF
     port map (
      I => gpio1_d_tri_o_9(9),
      IO => gpio1_d_tri_io(9),
      O => gpio1_d_tri_i_9(9),
      T => gpio1_d_tri_t_9(9)
    );
end STRUCTURE;
