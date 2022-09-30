-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: ntnu.no:user:ENDAT22_S:3.8
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY endat22;
USE endat22.ENDAT22_S;

ENTITY design_1_ENDAT22_S_0_0 IS
  PORT (
    clk : IN STD_LOGIC;
    n_rs : IN STD_LOGIC;
    AHB_DEN100 : IN STD_LOGIC;
    PSEL : IN STD_LOGIC;
    PENABLE : IN STD_LOGIC;
    PWRITE : IN STD_LOGIC;
    PWDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    PADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    PRDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    PRDY : OUT STD_LOGIC;
    PSLVERR : OUT STD_LOGIC;
    n_int1 : OUT STD_LOGIC;
    data_rc : IN STD_LOGIC;
    data_dv : OUT STD_LOGIC;
    tclk : OUT STD_LOGIC;
    de : OUT STD_LOGIC;
    nstr : IN STD_LOGIC;
    ntimer : OUT STD_LOGIC;
    n_int6 : IN STD_LOGIC;
    n_int7 : IN STD_LOGIC;
    clk2 : OUT STD_LOGIC;
    dui : OUT STD_LOGIC;
    tst_out_pin : OUT STD_LOGIC;
    n_si : OUT STD_LOGIC;
    RTM_START_O : OUT STD_LOGIC;
    RTM_STOPP_O : OUT STD_LOGIC
  );
END design_1_ENDAT22_S_0_0;

ARCHITECTURE design_1_ENDAT22_S_0_0_arch OF design_1_ENDAT22_S_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_ENDAT22_S_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT ENDAT22_S IS
    PORT (
      clk : IN STD_LOGIC;
      n_rs : IN STD_LOGIC;
      AHB_DEN100 : IN STD_LOGIC;
      PSEL : IN STD_LOGIC;
      PENABLE : IN STD_LOGIC;
      PWRITE : IN STD_LOGIC;
      PWDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PRDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PRDY : OUT STD_LOGIC;
      PSLVERR : OUT STD_LOGIC;
      n_int1 : OUT STD_LOGIC;
      data_rc : IN STD_LOGIC;
      data_dv : OUT STD_LOGIC;
      tclk : OUT STD_LOGIC;
      de : OUT STD_LOGIC;
      nstr : IN STD_LOGIC;
      ntimer : OUT STD_LOGIC;
      n_int6 : IN STD_LOGIC;
      n_int7 : IN STD_LOGIC;
      clk2 : OUT STD_LOGIC;
      dui : OUT STD_LOGIC;
      tst_out_pin : OUT STD_LOGIC;
      n_si : OUT STD_LOGIC;
      RTM_START_O : OUT STD_LOGIC;
      RTM_STOPP_O : OUT STD_LOGIC
    );
  END COMPONENT ENDAT22_S;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_ENDAT22_S_0_0_arch: ARCHITECTURE IS "ENDAT22_S,Vivado 2019.1";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_ENDAT22_S_0_0_arch : ARCHITECTURE IS "design_1_ENDAT22_S_0_0,ENDAT22_S,{}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_ENDAT22_S_0_0_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF PSLVERR: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PSLVERR";
  ATTRIBUTE X_INTERFACE_INFO OF PRDY: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PREADY";
  ATTRIBUTE X_INTERFACE_INFO OF PRDATA: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PRDATA";
  ATTRIBUTE X_INTERFACE_INFO OF PADDR: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PADDR";
  ATTRIBUTE X_INTERFACE_INFO OF PWDATA: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PWDATA";
  ATTRIBUTE X_INTERFACE_INFO OF PWRITE: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PWRITE";
  ATTRIBUTE X_INTERFACE_INFO OF PENABLE: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PENABLE";
  ATTRIBUTE X_INTERFACE_INFO OF PSEL: SIGNAL IS "xilinx.com:interface:apb:1.0 APB_S PSEL";
  ATTRIBUTE X_INTERFACE_PARAMETER OF clk: SIGNAL IS "XIL_INTERFACENAME clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF clk: SIGNAL IS "xilinx.com:signal:clock:1.0 clk CLK";
BEGIN
  U0 : ENDAT22_S
    PORT MAP (
      clk => clk,
      n_rs => n_rs,
      AHB_DEN100 => AHB_DEN100,
      PSEL => PSEL,
      PENABLE => PENABLE,
      PWRITE => PWRITE,
      PWDATA => PWDATA,
      PADDR => PADDR,
      PRDATA => PRDATA,
      PRDY => PRDY,
      PSLVERR => PSLVERR,
      n_int1 => n_int1,
      data_rc => data_rc,
      data_dv => data_dv,
      tclk => tclk,
      de => de,
      nstr => nstr,
      ntimer => ntimer,
      n_int6 => n_int6,
      n_int7 => n_int7,
      clk2 => clk2,
      dui => dui,
      tst_out_pin => tst_out_pin,
      n_si => n_si,
      RTM_START_O => RTM_START_O,
      RTM_STOPP_O => RTM_STOPP_O
    );
END design_1_ENDAT22_S_0_0_arch;
