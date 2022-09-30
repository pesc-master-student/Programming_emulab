// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: PESC_NTNU:SysGen:emu_dc:5.16
// IP Revision: 289309423

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "sysgen" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_emu_dc_0_1 (
  enable_con1_in,
  enable_con2_in,
  gatesig1_in,
  gatesig2_in,
  theta_sync_sampl,
  clk,
  emu_dc_aresetn,
  emu_dc_s_axi_awaddr,
  emu_dc_s_axi_awvalid,
  emu_dc_s_axi_wdata,
  emu_dc_s_axi_wstrb,
  emu_dc_s_axi_wvalid,
  emu_dc_s_axi_bready,
  emu_dc_s_axi_araddr,
  emu_dc_s_axi_arvalid,
  emu_dc_s_axi_rready,
  csv_out,
  usv_out,
  ia_dac,
  pu_speed_dac,
  signalbus_out,
  theta_el_dac,
  theta_mech_dac,
  ua0_1_dac,
  uab_1_dac,
  uab_2_dac,
  ub0_1_dac,
  emu_dc_s_axi_awready,
  emu_dc_s_axi_wready,
  emu_dc_s_axi_bresp,
  emu_dc_s_axi_bvalid,
  emu_dc_s_axi_arready,
  emu_dc_s_axi_rdata,
  emu_dc_s_axi_rresp,
  emu_dc_s_axi_rvalid
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME enable_con1_in, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} max\
imum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 enable_con1_in DATA" *)
input wire [0 : 0] enable_con1_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME enable_con2_in, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} max\
imum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 enable_con2_in DATA" *)
input wire [0 : 0] enable_con2_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME gatesig1_in, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 6} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximu\
m {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 gatesig1_in DATA" *)
input wire [5 : 0] gatesig1_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME gatesig2_in, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 6} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximu\
m {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 gatesig2_in DATA" *)
input wire [5 : 0] gatesig2_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME theta_sync_sampl, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} m\
aximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 theta_sync_sampl DATA" *)
input wire [0 : 0] theta_sync_sampl;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF emu_dc_s_axi, ASSOCIATED_RESET emu_dc_aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME emu_dc_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 emu_dc_aresetn RST" *)
input wire emu_dc_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi AWADDR" *)
input wire [6 : 0] emu_dc_s_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi AWVALID" *)
input wire emu_dc_s_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi WDATA" *)
input wire [31 : 0] emu_dc_s_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi WSTRB" *)
input wire [3 : 0] emu_dc_s_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi WVALID" *)
input wire emu_dc_s_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi BREADY" *)
input wire emu_dc_s_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi ARADDR" *)
input wire [6 : 0] emu_dc_s_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi ARVALID" *)
input wire emu_dc_s_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi RREADY" *)
input wire emu_dc_s_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME csv_out, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}\
} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 csv_out DATA" *)
output wire [0 : 0] csv_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME usv_out, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}\
} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 usv_out DATA" *)
output wire [0 : 0] usv_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ia_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}\
} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ia_dac DATA" *)
output wire [15 : 0] ia_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pu_speed_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maxi\
mum {}} value 12} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 pu_speed_dac DATA" *)
output wire [15 : 0] pu_speed_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME signalbus_out, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 104} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} ma\
ximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 signalbus_out DATA" *)
output wire [103 : 0] signalbus_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME theta_el_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maxi\
mum {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 theta_el_dac DATA" *)
output wire [15 : 0] theta_el_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME theta_mech_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} ma\
ximum {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 theta_mech_dac DATA" *)
output wire [15 : 0] theta_mech_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ua0_1_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum\
 {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ua0_1_dac DATA" *)
output wire [15 : 0] ua0_1_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME uab_1_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum\
 {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 uab_1_dac DATA" *)
output wire [15 : 0] uab_1_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME uab_2_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum\
 {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 uab_2_dac DATA" *)
output wire [15 : 0] uab_2_dac;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ub0_1_dac, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum\
 {}} value 8} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}}}, PortType data, PortType.PROP_SRC false" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ub0_1_dac DATA" *)
output wire [15 : 0] ub0_1_dac;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi AWREADY" *)
output wire emu_dc_s_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi WREADY" *)
output wire emu_dc_s_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi BRESP" *)
output wire [1 : 0] emu_dc_s_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi BVALID" *)
output wire emu_dc_s_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi ARREADY" *)
output wire emu_dc_s_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi RDATA" *)
output wire [31 : 0] emu_dc_s_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi RRESP" *)
output wire [1 : 0] emu_dc_s_axi_rresp;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME emu_dc_s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 7, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_\
THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 emu_dc_s_axi RVALID" *)
output wire emu_dc_s_axi_rvalid;

  emu_dc inst (
    .enable_con1_in(enable_con1_in),
    .enable_con2_in(enable_con2_in),
    .gatesig1_in(gatesig1_in),
    .gatesig2_in(gatesig2_in),
    .theta_sync_sampl(theta_sync_sampl),
    .clk(clk),
    .emu_dc_aresetn(emu_dc_aresetn),
    .emu_dc_s_axi_awaddr(emu_dc_s_axi_awaddr),
    .emu_dc_s_axi_awvalid(emu_dc_s_axi_awvalid),
    .emu_dc_s_axi_wdata(emu_dc_s_axi_wdata),
    .emu_dc_s_axi_wstrb(emu_dc_s_axi_wstrb),
    .emu_dc_s_axi_wvalid(emu_dc_s_axi_wvalid),
    .emu_dc_s_axi_bready(emu_dc_s_axi_bready),
    .emu_dc_s_axi_araddr(emu_dc_s_axi_araddr),
    .emu_dc_s_axi_arvalid(emu_dc_s_axi_arvalid),
    .emu_dc_s_axi_rready(emu_dc_s_axi_rready),
    .csv_out(csv_out),
    .usv_out(usv_out),
    .ia_dac(ia_dac),
    .pu_speed_dac(pu_speed_dac),
    .signalbus_out(signalbus_out),
    .theta_el_dac(theta_el_dac),
    .theta_mech_dac(theta_mech_dac),
    .ua0_1_dac(ua0_1_dac),
    .uab_1_dac(uab_1_dac),
    .uab_2_dac(uab_2_dac),
    .ub0_1_dac(ub0_1_dac),
    .emu_dc_s_axi_awready(emu_dc_s_axi_awready),
    .emu_dc_s_axi_wready(emu_dc_s_axi_wready),
    .emu_dc_s_axi_bresp(emu_dc_s_axi_bresp),
    .emu_dc_s_axi_bvalid(emu_dc_s_axi_bvalid),
    .emu_dc_s_axi_arready(emu_dc_s_axi_arready),
    .emu_dc_s_axi_rdata(emu_dc_s_axi_rdata),
    .emu_dc_s_axi_rresp(emu_dc_s_axi_rresp),
    .emu_dc_s_axi_rvalid(emu_dc_s_axi_rvalid)
  );
endmodule
