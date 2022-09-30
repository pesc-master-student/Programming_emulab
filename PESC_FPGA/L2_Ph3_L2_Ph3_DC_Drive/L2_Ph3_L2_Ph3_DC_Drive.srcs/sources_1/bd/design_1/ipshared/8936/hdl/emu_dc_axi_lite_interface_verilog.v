//-----------------------------------------------------------------
// System Generator version 2019.1 Verilog source file.
//
// Copyright(C) 2019 by Xilinx, Inc.  All rights reserved.  This
// text/file contains proprietary, confidential information of Xilinx,
// Inc., is distributed under license from Xilinx, Inc., and may be used,
// copied and/or disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
// this text/file solely for design, simulation, implementation and
// creation of design files limited to Xilinx devices or technologies.
// Use with non-Xilinx devices or technologies is expressly prohibited
// and immediately terminates your license unless covered by a separate
// agreement.
//
// Xilinx is providing this design, code, or information "as is" solely
// for use in developing programs and solutions for Xilinx devices.  By
// providing this design, code, or information as one possible
// implementation of this feature, application or standard, Xilinx is
// making no representation that this implementation is free from any
// claims of infringement.  You are responsible for obtaining any rights
// you may require for your implementation.  Xilinx expressly disclaims
// any warranty whatsoever with respect to the adequacy of the
// implementation, including but not limited to warranties of
// merchantability or fitness for a particular purpose.
//
// Xilinx products are not intended for use in life support appliances,
// devices, or systems.  Use in such applications is expressly prohibited.
//
// Any modifications that are made to the source code are done at the user's
// sole risk and will be unsupported.
//
// This copyright and support notice must be retained as part of this
// text at all times.  (c) Copyright 1995-2019 Xilinx, Inc.  All rights
// reserved.
//-----------------------------------------------------------------

`include "conv_pkg.v"
module emu_dc_axi_lite_interface_verilog#(parameter C_S_AXI_DATA_WIDTH = 32, C_S_AXI_ADDR_WIDTH = 7, C_S_NUM_OFFSETS = 23)(
  output wire[31:0] voltage_pu_bit_conv2,
  output wire[31:0] voltage_pu_bit_conv1,
  output wire[31:0] ra,
  output wire[31:0] polepairs,
  output wire[0:0] magnetization_4q_1q,
  output wire[31:0] kn,
  output wire[31:0] k_fnmechtstep,
  output wire[31:0] current_pu_bit_conv2,
  output wire[31:0] current_pu_bit_conv1,
  output wire[31:0] vdc2,
  output wire[31:0] vdc1,
  output wire[31:0] ts_la,
  output wire[31:0] ts_tm,
  output wire[31:0] ts_tf,
  output wire[31:0] tl,
  input wire[31:0] tlsum,
  input wire[31:0] ia,
  input wire[31:0] if_x0,
  input wire[31:0] motor_id,
  input wire[31:0] speed,
  input wire[31:0] te,
  input wire[31:0] theta_el,
  input wire[31:0] theta_mech,
  output wire clk,
  input wire emu_dc_aclk,
  input wire emu_dc_aresetn,
  input  wire [C_S_AXI_ADDR_WIDTH - 1:0] emu_dc_s_axi_awaddr,
  input  wire emu_dc_s_axi_awvalid,
  output wire emu_dc_s_axi_awready,
  input  wire [C_S_AXI_DATA_WIDTH-1:0] emu_dc_s_axi_wdata,
  input  wire [C_S_AXI_DATA_WIDTH/8-1:0] emu_dc_s_axi_wstrb,
  input  wire emu_dc_s_axi_wvalid,
  output wire emu_dc_s_axi_wready,
  output wire [1:0] emu_dc_s_axi_bresp,
  output wire emu_dc_s_axi_bvalid,
  input  wire emu_dc_s_axi_bready,
  input  wire [C_S_AXI_ADDR_WIDTH - 1:0] emu_dc_s_axi_araddr,
  input  wire emu_dc_s_axi_arvalid,
  output wire emu_dc_s_axi_arready,
  output wire [C_S_AXI_DATA_WIDTH-1:0] emu_dc_s_axi_rdata,
  output wire [1:0] emu_dc_s_axi_rresp,
  output wire emu_dc_s_axi_rvalid,
  input  wire emu_dc_s_axi_rready
);
function integer clogb2 (input integer bit_depth);
begin
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
    bit_depth = bit_depth >> 1;
  end
endfunction
localparam integer ADDR_LSB = clogb2(C_S_AXI_DATA_WIDTH/8);
localparam integer ADDR_MSB = C_S_AXI_ADDR_WIDTH;
localparam integer DEC_SIZE = clogb2(C_S_NUM_OFFSETS);
reg [1 :0] axi_rresp;
reg [1 :0] axi_bresp;
reg axi_awready;
reg axi_wready;
reg axi_bvalid;
reg axi_rvalid;
reg [ADDR_MSB-1:0] axi_awaddr;
reg [ADDR_MSB-1:0] axi_araddr;
reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
reg axi_arready;
wire [C_S_AXI_DATA_WIDTH-1:0] slv_wire_array [0:C_S_NUM_OFFSETS-1];
reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg_array [0:C_S_NUM_OFFSETS-1];
wire slv_reg_rden;
wire slv_reg_wren;
reg [DEC_SIZE-1:0] dec_w;
reg [DEC_SIZE-1:0] dec_r;
reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
integer byte_index;
integer offset_index;
assign emu_dc_s_axi_awready = axi_awready;
assign emu_dc_s_axi_wready  = axi_wready;
assign emu_dc_s_axi_bresp  = axi_bresp;
assign emu_dc_s_axi_bvalid = axi_bvalid;
assign emu_dc_s_axi_arready = axi_arready;
assign emu_dc_s_axi_rdata  = axi_rdata;
assign emu_dc_s_axi_rvalid = axi_rvalid;
assign emu_dc_s_axi_rresp  = axi_rresp;
// map input 0
assign slv_wire_array[0] = slv_reg_array[0];
assign voltage_pu_bit_conv2[31:0] = slv_wire_array[0][31:0];
// map input 1
assign slv_wire_array[1] = slv_reg_array[1];
assign voltage_pu_bit_conv1[31:0] = slv_wire_array[1][31:0];
// map input 2
assign slv_wire_array[2] = slv_reg_array[2];
assign ra[31:0] = slv_wire_array[2][31:0];
// map input 3
assign slv_wire_array[3] = slv_reg_array[3];
assign polepairs[31:0] = slv_wire_array[3][31:0];
// map input 4
assign slv_wire_array[4] = slv_reg_array[4];
assign magnetization_4q_1q = slv_wire_array[4][0];
// map input 5
assign slv_wire_array[5] = slv_reg_array[5];
assign kn[31:0] = slv_wire_array[5][31:0];
// map input 6
assign slv_wire_array[6] = slv_reg_array[6];
assign k_fnmechtstep[31:0] = slv_wire_array[6][31:0];
// map input 7
assign slv_wire_array[7] = slv_reg_array[7];
assign current_pu_bit_conv2[31:0] = slv_wire_array[7][31:0];
// map input 8
assign slv_wire_array[8] = slv_reg_array[8];
assign current_pu_bit_conv1[31:0] = slv_wire_array[8][31:0];
// map input 9
assign slv_wire_array[9] = slv_reg_array[9];
assign vdc2[31:0] = slv_wire_array[9][31:0];
// map input 10
assign slv_wire_array[10] = slv_reg_array[10];
assign vdc1[31:0] = slv_wire_array[10][31:0];
// map input 11
assign slv_wire_array[11] = slv_reg_array[11];
assign ts_la[31:0] = slv_wire_array[11][31:0];
// map input 12
assign slv_wire_array[12] = slv_reg_array[12];
assign ts_tm[31:0] = slv_wire_array[12][31:0];
// map input 13
assign slv_wire_array[13] = slv_reg_array[13];
assign ts_tf[31:0] = slv_wire_array[13][31:0];
// map input 14
assign slv_wire_array[14] = slv_reg_array[14];
assign tl[31:0] = slv_wire_array[14][31:0];
// map output 15
assign slv_wire_array[15] = tlsum[31:0];
// map output 16
assign slv_wire_array[16] = ia[31:0];
// map output 17
assign slv_wire_array[17] = if_x0[31:0];
// map output 18
assign slv_wire_array[18] = motor_id[31:0];
// map output 19
assign slv_wire_array[19] = speed[31:0];
// map output 20
assign slv_wire_array[20] = te[31:0];
// map output 21
assign slv_wire_array[21] = theta_el[31:0];
// map output 22
assign slv_wire_array[22] = theta_mech[31:0];
  initial
  begin
    slv_reg_array[0] = 32'd0;
    slv_reg_array[1] = 32'd0;
    slv_reg_array[2] = 32'd0;
    slv_reg_array[3] = 32'd0;
    slv_reg_array[4] = 32'd0;
    slv_reg_array[5] = 32'd0;
    slv_reg_array[6] = 32'd0;
    slv_reg_array[7] = 32'd0;
    slv_reg_array[8] = 32'd0;
    slv_reg_array[9] = 32'd0;
    slv_reg_array[10] = 32'd0;
    slv_reg_array[11] = 32'd0;
    slv_reg_array[12] = 32'd0;
    slv_reg_array[13] = 32'd0;
    slv_reg_array[14] = 32'd0;
  end
  always @(axi_awaddr)
  begin
    case(axi_awaddr)
      7'd0 : dec_w = 0;
      7'd4 : dec_w = 1;
      7'd8 : dec_w = 2;
      7'd12 : dec_w = 3;
      7'd16 : dec_w = 4;
      7'd20 : dec_w = 5;
      7'd24 : dec_w = 6;
      7'd28 : dec_w = 7;
      7'd32 : dec_w = 8;
      7'd36 : dec_w = 9;
      7'd40 : dec_w = 10;
      7'd44 : dec_w = 11;
      7'd48 : dec_w = 12;
      7'd52 : dec_w = 13;
      7'd56 : dec_w = 14;
      7'd60 : dec_w = 15;
      7'd64 : dec_w = 16;
      7'd68 : dec_w = 17;
      7'd72 : dec_w = 18;
      7'd76 : dec_w = 19;
      7'd80 : dec_w = 20;
      7'd84 : dec_w = 21;
      7'd88 : dec_w = 22;
      default : dec_w = 0;
    endcase
  end
  always @(axi_araddr)
  begin
    case(axi_araddr)
      7'd0 : dec_r = 0;
      7'd4 : dec_r = 1;
      7'd8 : dec_r = 2;
      7'd12 : dec_r = 3;
      7'd16 : dec_r = 4;
      7'd20 : dec_r = 5;
      7'd24 : dec_r = 6;
      7'd28 : dec_r = 7;
      7'd32 : dec_r = 8;
      7'd36 : dec_r = 9;
      7'd40 : dec_r = 10;
      7'd44 : dec_r = 11;
      7'd48 : dec_r = 12;
      7'd52 : dec_r = 13;
      7'd56 : dec_r = 14;
      7'd60 : dec_r = 15;
      7'd64 : dec_r = 16;
      7'd68 : dec_r = 17;
      7'd72 : dec_r = 18;
      7'd76 : dec_r = 19;
      7'd80 : dec_r = 20;
      7'd84 : dec_r = 21;
      7'd88 : dec_r = 22;
      default : dec_r = 0;
    endcase
  end
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_awready <= 1'b0;
        axi_awaddr <= 0;
      end
    else
      begin
        if (~axi_awready && emu_dc_s_axi_awvalid && emu_dc_s_axi_wvalid)
          begin
            axi_awready <= 1'b1;
            axi_awaddr <= emu_dc_s_axi_awaddr;
          end
        else
          begin
            axi_awready <= 1'b0;
          end
      end
  end
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_wready <= 1'b0;
      end
    else
      begin
        if (~axi_wready && emu_dc_s_axi_wvalid && emu_dc_s_axi_awvalid)
          begin
            axi_wready <= 1'b1;
          end
        else
          begin
            axi_wready <= 1'b0;
          end
      end
  end
  assign slv_reg_wren = axi_wready && emu_dc_s_axi_wvalid && axi_awready && emu_dc_s_axi_awvalid;
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        slv_reg_array[0] = 32'd0;
        slv_reg_array[1] = 32'd0;
        slv_reg_array[2] = 32'd0;
        slv_reg_array[3] = 32'd0;
        slv_reg_array[4] = 32'd0;
        slv_reg_array[5] = 32'd0;
        slv_reg_array[6] = 32'd0;
        slv_reg_array[7] = 32'd0;
        slv_reg_array[8] = 32'd0;
        slv_reg_array[9] = 32'd0;
        slv_reg_array[10] = 32'd0;
        slv_reg_array[11] = 32'd0;
        slv_reg_array[12] = 32'd0;
        slv_reg_array[13] = 32'd0;
        slv_reg_array[14] = 32'd0;
      end
    else begin
      if (slv_reg_wren)
        begin
          for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
            if ( emu_dc_s_axi_wstrb[byte_index] == 1 ) begin
              slv_reg_array[dec_w][(byte_index*8) +: 8] <= emu_dc_s_axi_wdata[(byte_index*8) +: 8];
            end
        end
    end
  end
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_bvalid  <= 0;
        axi_bresp   <= 2'b0;
      end
    else
      begin
        if (axi_awready && emu_dc_s_axi_awvalid && ~axi_bvalid && axi_wready && emu_dc_s_axi_wvalid)
          begin
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b0; 
          end
        else
          begin
            if (emu_dc_s_axi_bready && axi_bvalid)
              begin
                axi_bvalid <= 1'b0;
              end
          end
      end
  end
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_arready <= 1'b0;
        axi_araddr  <= {ADDR_MSB{1'b0}};
      end
    else
      begin
        if (~axi_arready && emu_dc_s_axi_arvalid)
          begin
            axi_arready <= 1'b1;
            axi_araddr  <= emu_dc_s_axi_araddr;
          end
        else
          begin
            axi_arready <= 1'b0;
          end
      end
  end

  // AXI read response (inferred flops)
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_rvalid <= 1'b0;
        axi_rresp  <= 2'b0;
      end
    else
      begin
        if (slv_reg_rden)
          begin
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b0; 
          end
        else if (axi_rvalid && emu_dc_s_axi_rready)
          begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b0; 
          end
      end
  end
  assign slv_reg_rden = axi_arready & emu_dc_s_axi_arvalid & ~axi_rvalid;
  always @(emu_dc_aresetn, slv_reg_rden, axi_araddr, slv_wire_array, dec_r)
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        reg_data_out <= {C_S_AXI_DATA_WIDTH{1'b0}};
      end
    else
      begin
     reg_data_out <= slv_wire_array[dec_r];
      end
  end
  // flop for AXI read data
  always @( posedge emu_dc_aclk )
  begin
    if ( emu_dc_aresetn == 1'b0 )
      begin
        axi_rdata  <= 0;
      end
    else
      begin
        if (slv_reg_rden)
          begin
            axi_rdata <= reg_data_out;
          end
      end
  end

  assign clk = emu_dc_aclk;

endmodule

