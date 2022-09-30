#---------------------------------------------
# PicoZed based processor board v1.0  Sinterf Energi AS. May 2015.
# Signal allocation on carrier board.
# Pin allocation for PicoZed Z7030, with Xilinx XC7Z030-1 SBG485C AP
# Z7015 is not fully compatible, it requires 2.5V IO bank supply voltage for the LVDS ports.
#-----------------------------------------------------------



#set_property PACKAGE_PIN 	H11	[get_ports {JTAG_TCK]}]; # Pin X1.1	JTAG_TCK
#set_property PACKAGE_PIN 	H10	[get_ports {JTAG_TMS]}]; # Pin X1.2	JTAG_TMS
#set_property PACKAGE_PIN 	G9	[get_ports {JTAG_TDO]}]; # Pin X1.3	JTAG_TDO
#set_property PACKAGE_PIN 	H9	[get_ports {JTAG_TDI]}]; # Pin X1.4	JTAG_TDI

#-----------------------------------------------------------------
# 3V, system
set_property PACKAGE_PIN P2 [get_ports {LVCT_OE_N[0]}]
set_property PACKAGE_PIN T16 [get_ports LED_ALARM]


#------------------------------------------------------------------
# Drivers testleds

set_property PACKAGE_PIN A4 [get_ports {HW_INTERLOCK[0]}]

set_property PACKAGE_PIN R8 [get_ports DRIVER1_OK]

set_property PACKAGE_PIN A5 [get_ports {DRIVER1_T[0]}]
set_property PACKAGE_PIN L4 [get_ports {DRIVER1_T[1]}]
set_property PACKAGE_PIN L5 [get_ports {DRIVER1_T[2]}]
set_property PACKAGE_PIN H8 [get_ports {DRIVER1_T[3]}]

set_property PACKAGE_PIN G7 [get_ports {DRIVER1_D[0]}]
set_property PACKAGE_PIN G8 [get_ports {DRIVER1_D[1]}]
set_property PACKAGE_PIN A6 [get_ports {DRIVER1_D[2]}]
set_property PACKAGE_PIN A7 [get_ports {DRIVER1_D[3]}]
set_property PACKAGE_PIN B6 [get_ports {DRIVER1_D[4]}]
set_property PACKAGE_PIN B7 [get_ports {DRIVER1_D[5]}]

set_property PACKAGE_PIN C8 [get_ports DRIVER1_RESET]
set_property PACKAGE_PIN B8 [get_ports DRIVER1_ENABLE]


set_property PACKAGE_PIN H6 [get_ports DRIVER2_OK]
set_property PACKAGE_PIN H5 [get_ports {DRIVER2_T[3]}]
set_property PACKAGE_PIN H4 [get_ports {DRIVER2_T[2]}]
set_property PACKAGE_PIN H3 [get_ports {DRIVER2_T[1]}]
set_property PACKAGE_PIN F5 [get_ports {DRIVER2_T[0]}]

set_property PACKAGE_PIN G3 [get_ports {DRIVER2_D[0]}]
set_property PACKAGE_PIN E5 [get_ports {DRIVER2_D[1]}]
set_property PACKAGE_PIN F2 [get_ports {DRIVER2_D[2]}]
set_property PACKAGE_PIN G2 [get_ports {DRIVER2_D[3]}]
set_property PACKAGE_PIN G4 [get_ports {DRIVER2_D[4]}]
set_property PACKAGE_PIN F1 [get_ports {DRIVER2_D[5]}]

set_property PACKAGE_PIN E4 [get_ports DRIVER2_ENABLE]
set_property PACKAGE_PIN F4 [get_ports DRIVER2_RESET]


set_property PACKAGE_PIN L6 [get_ports PILOT_SIGNAL]

set_property PACKAGE_PIN M6 [get_ports {TEST[4]}]
set_property PACKAGE_PIN J5 [get_ports {TEST[3]}]
set_property PACKAGE_PIN K5 [get_ports {TEST[2]}]
set_property PACKAGE_PIN R5 [get_ports {TEST[1]}]
set_property PACKAGE_PIN R4 [get_ports {TEST[0]}]

#--------------------------------------------------------
# DA,  Encoder



set_property PACKAGE_PIN M4 [get_ports {da_d[0]}]
set_property PACKAGE_PIN M3 [get_ports {da_d[1]}]
set_property PACKAGE_PIN J2 [get_ports {da_d[2]}]
set_property PACKAGE_PIN J1 [get_ports {da_d[3]}]

set_property PACKAGE_PIN K7 [get_ports {da_d[4]}]
set_property PACKAGE_PIN L7 [get_ports {da_d[5]}]
set_property PACKAGE_PIN J3 [get_ports {da_d[6]}]
set_property PACKAGE_PIN K2 [get_ports {da_d[7]}]

set_property PACKAGE_PIN P7 [get_ports {da_d[8]}]
set_property PACKAGE_PIN R7 [get_ports {da_d[9]}]
set_property PACKAGE_PIN L2 [get_ports {da_d[10]}]
set_property PACKAGE_PIN L1 [get_ports {da_d[11]}]

set_property PACKAGE_PIN N4 [get_ports da_a_b]
set_property PACKAGE_PIN N3 [get_ports da_ab_cs]
set_property PACKAGE_PIN P3 [get_ports da_cd_cs]
#DA RW not connected. Cannot read back from DA.

set_property PACKAGE_PIN N8 [get_ports {ENC_P[0]}]
set_property PACKAGE_PIN M7 [get_ports {ENC_P[1]}]
set_property PACKAGE_PIN M8 [get_ports {ENC_P[2]}]
set_property PACKAGE_PIN P8 [get_ports {ENC_ERR[0]}]

# --------------------------------------------------------
# Signal in, XADC

set_property PACKAGE_PIN M2 [get_ports {SIG_D[0]}]
set_property PACKAGE_PIN M1 [get_ports {SIG_D[1]}]
set_property PACKAGE_PIN N1 [get_ports {SIG_D[2]}]
set_property PACKAGE_PIN P1 [get_ports {SIG_D[3]}]
set_property PACKAGE_PIN K4 [get_ports {SIG_D[4]}]
set_property PACKAGE_PIN K3 [get_ports {SIG_D[5]}]

set_property PACKAGE_PIN T2 [get_ports {SIG_R_PU[0]}]
set_property PACKAGE_PIN T1 [get_ports {SIG_R_PU[1]}]
set_property PACKAGE_PIN U2 [get_ports {SIG_R_PU[2]}]
set_property PACKAGE_PIN U1 [get_ports {SIG_R_PU[3]}]
set_property PACKAGE_PIN R3 [get_ports {SIG_R_PU[4]}]
set_property PACKAGE_PIN R2 [get_ports {SIG_R_PU[5]}]


set_property PACKAGE_PIN AB19 [get_ports {XADC_MUX[1]}]
set_property PACKAGE_PIN AB18 [get_ports {XADC_MUX[0]}]







#set_property PACKAGE_PIN    xxx [get_ports {XADC_VN[0]}]
#set_property PACKAGE_PIN    xxx [get_ports {XADC_VP[0]}]


#set_property PACKAGE_PIN    F7 [get_ports XADC_AD_P]
#set_property PACKAGE_PIN    E7 [get_ports XADC_AD_N]

#---------------------------------------------------------
# Analog in.




set_property PACKAGE_PIN E3 [get_ports ad_sclk]
set_property PACKAGE_PIN G6 [get_ports {ad_sdio_tri_io[0]}]
set_property PACKAGE_PIN F6 [get_ports {ad_scsb[0]}]

set_property PACKAGE_PIN D5 [get_ports ad_dcop]
set_property PACKAGE_PIN C4 [get_ports ad_dcon]

set_property PACKAGE_PIN B4 [get_ports ad_fcop]
set_property PACKAGE_PIN B3 [get_ports ad_fcon]


set_property PACKAGE_PIN B2 [get_ports {ad_d_p[7]}]
set_property PACKAGE_PIN B1 [get_ports {ad_d_n[7]}]

set_property PACKAGE_PIN E8 [get_ports {ad_d_p[6]}]
set_property PACKAGE_PIN D8 [get_ports {ad_d_n[6]}]

set_property PACKAGE_PIN H1 [get_ports {ad_d_p[5]}]
set_property PACKAGE_PIN G1 [get_ports {ad_d_n[5]}]

set_property PACKAGE_PIN C6 [get_ports {ad_d_p[4]}]
set_property PACKAGE_PIN C5 [get_ports {ad_d_n[4]}]

set_property PACKAGE_PIN D3 [get_ports {ad_d_p[3]}]
set_property PACKAGE_PIN C3 [get_ports {ad_d_n[3]}]

set_property PACKAGE_PIN D1 [get_ports {ad_d_p[2]}]
set_property PACKAGE_PIN C1 [get_ports {ad_d_n[2]}]

set_property PACKAGE_PIN A2 [get_ports {ad_d_p[1]}]
set_property PACKAGE_PIN A1 [get_ports {ad_d_n[1]}]


set_property PACKAGE_PIN E2 [get_ports {ad_d_p[0]}]
set_property PACKAGE_PIN D2 [get_ports {ad_d_n[0]}]


#------------------------------------------------------------





set_property PACKAGE_PIN P6 [get_ports {ENC_LED[1]}]
set_property PACKAGE_PIN J6 [get_ports {ENC_LED[0]}]
set_property PACKAGE_PIN J7 [get_ports {ENC_LED[2]}]
set_property PACKAGE_PIN P5 [get_ports {ENC_LED[3]}]

set_property PACKAGE_PIN J8 [get_ports {RELAY[0]}]
set_property PACKAGE_PIN K8 [get_ports {RELAY[1]}]
set_property PACKAGE_PIN N6 [get_ports {RELAY[2]}]
set_property PACKAGE_PIN N5 [get_ports {RELAY[3]}]


#--
set_property PACKAGE_PIN AB21 [get_ports {gpio1_d_tri_io[0]}]
set_property PACKAGE_PIN AB22 [get_ports {gpio1_d_tri_io[1]}]
set_property PACKAGE_PIN AA19 [get_ports {gpio1_d_tri_io[2]}]
set_property PACKAGE_PIN AA20 [get_ports {gpio1_d_tri_io[3]}]

set_property PACKAGE_PIN V18 [get_ports {gpio1_d_tri_io[4]}]
set_property PACKAGE_PIN W18 [get_ports {gpio1_d_tri_io[5]}]
set_property PACKAGE_PIN U19 [get_ports {gpio1_d_tri_io[6]}]
set_property PACKAGE_PIN V19 [get_ports {gpio1_d_tri_io[7]}]

set_property PACKAGE_PIN Y14 [get_ports {gpio1_d_tri_io[8]}]
set_property PACKAGE_PIN Y15 [get_ports {gpio1_d_tri_io[9]}]
set_property PACKAGE_PIN AA14 [get_ports {gpio1_d_tri_io[10]}]
set_property PACKAGE_PIN AA15 [get_ports {gpio1_d_tri_io[11]}]

set_property PACKAGE_PIN AA11 [get_ports {gpio1_d_tri_io[12]}]
set_property PACKAGE_PIN AB11 [get_ports {gpio1_d_tri_io[13]}]
set_property PACKAGE_PIN Y12 [get_ports {gpio1_d_tri_io[14]}]
set_property PACKAGE_PIN Y13 [get_ports {gpio1_d_tri_io[15]}]


# -- EnDat22
set_property PACKAGE_PIN V11 [get_ports RS485_SOEN]
set_property PACKAGE_PIN W11 [get_ports RS485_SDIN]
set_property PACKAGE_PIN V13 [get_ports RS485_SDOUT]
set_property PACKAGE_PIN V14 [get_ports RS485_SCLK]


#set_property PACKAGE_PIN V15 [get_ports {gpio2_d_tri_io[0]}]
#set_property PACKAGE_PIN W15 [get_ports {gpio2_d_tri_io[1]}]
#set_property PACKAGE_PIN V16 [get_ports {gpio2_d_tri_io[2]}]
#set_property PACKAGE_PIN W16 [get_ports {gpio2_d_tri_io[3]}]

#set_property PACKAGE_PIN W12 [get_ports {gpio2_d_tri_io[4]}]
#set_property PACKAGE_PIN W13 [get_ports {gpio2_d_tri_io[5]}]
#set_property PACKAGE_PIN R17 [get_ports {gpio2_d_tri_io[6]}]
#set_property PACKAGE_PIN T17 [get_ports {gpio2_d_tri_io[7]}]

#set_property PACKAGE_PIN Y18 [get_ports {gpio2_d_tri_io[8]}]
#set_property PACKAGE_PIN Y19 [get_ports {gpio2_d_tri_io[9]}]
#set_property PACKAGE_PIN AA16 [get_ports {gpio2_d_tri_io[10]}]
#set_property PACKAGE_PIN AA17 [get_ports {gpio2_d_tri_io[11]}]













#---------------------------------------------------------------
# Gigabit port pins.

#set_property PACKAGE_PIN AB7 [get_ports {mgt_rx0_rxn[0]}]
#set_property PACKAGE_PIN AB3 [get_ports {mgt_tx0_txn[0]}]
#set_property PACKAGE_PIN AA7 [get_ports {mgt_rx0_rxp[0]}]
#set_property PACKAGE_PIN AA3 [get_ports {mgt_tx0_txp[0]}]

#set_property PACKAGE_PIN Y8 [get_ports {mgt_rx1_rxn[0]}]
#set_property PACKAGE_PIN Y4 [get_ports {mgt_tx1_txn[0]}]
#set_property PACKAGE_PIN W8 [get_ports {mgt_rx1_rxp[0]}]
#set_property PACKAGE_PIN W4 [get_ports {mgt_tx1_txp[0]}]


#set_property PACKAGE_PIN AB9 [get_ports {mgt_rx2_rxn[0]}]
#set_property PACKAGE_PIN AB5 [get_ports {mgt_tx2_txn[0]}]
#set_property PACKAGE_PIN AA9 [get_ports {mgt_rx2_rxp[0]}]
#set_property PACKAGE_PIN AA5 [get_ports {mgt_tx2_txp[0]}]


#set_property PACKAGE_PIN W6 [get_ports {mgt_rx3_rxp[0]}]
#set_property PACKAGE_PIN Y6 [get_ports {mgt_rx3_rxn[0]}]
#set_property PACKAGE_PIN Y2 [get_ports {mgt_tx3_txn[0]}]
#set_property PACKAGE_PIN W2 [get_ports {mgt_tx3_txp[0]}]


#set_property PACKAGE_PIN U9 [get_ports mgt_refclk0_clk_p]
#set_property PACKAGE_PIN V9 [get_ports mgt_refclk0_clk_n]



# Unconnected pins.


#set_property PROHIBIT true [get_sites V9]
#set_property PROHIBIT true [get_sites U9]

set_property PROHIBIT true [get_sites V5]
set_property PROHIBIT true [get_sites U5]

#set_property PROHIBIT true [get_sites AB7]
#set_property PROHIBIT true [get_sites AA7]
#set_property PROHIBIT true [get_sites AB3]
#set_property PROHIBIT true [get_sites AA3]

#set_property PROHIBIT true [get_sites Y8]
#set_property PROHIBIT true [get_sites W8]
#set_property PROHIBIT true [get_sites Y4]
#set_property PROHIBIT true [get_sites W4]

#set_property PROHIBIT true [get_sites AB9]
#set_property PROHIBIT true [get_sites AA9]
#set_property PROHIBIT true [get_sites AB5]
#set_property PROHIBIT true [get_sites AA5]

#set_property PROHIBIT true [get_sites Y6]
#set_property PROHIBIT true [get_sites W6]
#set_property PROHIBIT true [get_sites Y2]
#set_property PROHIBIT true [get_sites W2]



# Unused pins
set_property PROHIBIT true [get_sites U12]
set_property PROHIBIT true [get_sites U11]
set_property PROHIBIT true [get_sites U14]
set_property PROHIBIT true [get_sites U13]
set_property PROHIBIT true [get_sites AB12]
set_property PROHIBIT true [get_sites AA12]
set_property PROHIBIT true [get_sites AB14]
set_property PROHIBIT true [get_sites AB13]
set_property PROHIBIT true [get_sites AB17]
set_property PROHIBIT true [get_sites AB16]
set_property PROHIBIT true [get_sites U18]
set_property PROHIBIT true [get_sites U17]
set_property PROHIBIT true [get_sites Y17]
set_property PROHIBIT true [get_sites W17]
set_property PROHIBIT true [get_sites U16]

#----------------------------------------------------------------------------------
# IO types
# Per bank

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]]

# AD converter
set_property IOSTANDARD LVDS [get_ports {ad_dco* ad_fco* ad_d_*}]
set_property DIFF_TERM true [get_ports {ad_dco* ad_fco* ad_d_*}]


# the rest, port 35
set_property IOSTANDARD LVCMOS18 [get_ports {DRIVER* ad_s* LVCT_OE_N PILOT_SIGNAL HW_INTERLOCK}]

# the rest, port 34:
set_property IOSTANDARD LVCMOS18 [get_ports {da_* SIG_* TEST RELAY* ENC*}]

#set_property IOSTANDARD LVCMOS18 [get_ports {XADC_AD_P* XADC_AD_N*}]

set_property IOSTANDARD LVCMOS18 [get_ports Vaux*]

#------------------------------------------------------------------------------
#  Clocks

# clk_fpga_0 is created implicitly by processor system.
create_clock -period 100000.000 [get_ports RS485_SCLK]
create_clock -period 4.000 -name AD_CLOCK [get_ports ad_dcop]
set_input_jitter AD_CLOCK 0.100

#set_clock_groups -asynchronous -group [get_clocks AD_CLOCK] -group [get_clocks clk_fpga_0]

#create_clock -period 8.000 -name mgt_refclk0_clk_p -waveform {0.000 4.000} [get_ports mgt_refclk0_clk_p]




#set_clock_groups -asynchronous -group [get_clocks mgt_refclk0_clk_p] -group [get_clocks clk_fpga_0]



#------------------------------------------------------------------------------
# Timing



#set_false_path -from */*/*regarray/*/*/register_array_write_reg*/C -to */*/internal_reset_timer*/*/reset_in_latch_reg/PRE



#  Moves to Additional__late_constrsints.xdc   Set it sProperties to processing oerder:_LATE

#set_false_path -from * -to [get_pins */*/gigabit_regarray/U0/axi_rdata_reg*/D]





set_output_delay -clock [get_clocks clk_fpga_0] -max 2.000 [get_ports {da_d da_a_b}]
set_output_delay -clock [get_clocks clk_fpga_0] -min 1.000 [get_ports {da_d da_a_b}]
set_output_delay -clock [get_clocks clk_fpga_0] -max 2.000 [get_ports {da_ab_cs da_cd_cs}]
set_output_delay -clock [get_clocks clk_fpga_0] -min 1.000 [get_ports {da_ab_cs da_cd_cs}]

#set_output_delay -clock [get_clocks clk_fpga_0] -max -3.000 [get_ports {da_ab_cs da_cd_cs}]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -6.000 [get_ports {da_ab_cs da_cd_cs}]


#set_input_delay -clock [get_clocks AD_CLOCK] -max  -2.000 [get_ports {ad_fco* }]
#set_input_delay -clock [get_clocks AD_CLOCK] -min  -10.000 [get_ports {ad_fco* }]


#set_input_delay -reference_pin [get_ports {AD_FCO_P}] -max 0.200 [get_ports ad_d_p*]
#set_input_delay -reference_pin [get_ports {AD_FCO_P}] -min -0.200 [get_ports ad_d_p*]


# set_max_delay 1.5 -from [get_pins {*/AD_block/ad_omformer_seriemottaker_0/U0/USER_LOGIC_I/akkumulator_array_reg[*][*]/C}] -to [get_pins {*/AD_block/ad_omformer_seriemottaker_0/U0/USER_LOGIC_I/clk_bus_akk_ut_array_synk1_reg[*][*]/D}] -datapath_only  # Ser ikke ut til at denne biter når det er asynkrone klokker.


#set_output_delay -clock [get_clocks clk_fpga_0] -max  7.000 [get_ports {da_* }]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -3.000 [get_ports {da_* }]


#set_output_delay -clock [get_clocks clk_fpga_0] -max  7.000 [get_ports {DRIVER*_D* DRIVER*_EN* }]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -3.000 [get_ports {DRIVER*_D* DRIVER*_EN* }]

#set_input_delay -clock [get_clocks clk_fpga_0] -max  10.000 [get_ports {DRIVER*_T* DRIVER*_OK SIG_D* ENC_P* }]
#set_input_delay -clock [get_clocks clk_fpga_0] -min -10.000 [get_ports {DRIVER*_T  DRIVER*_OK SIG_D* ENC_P* }]


#set_input_delay -clock [get_clocks clk_fpga_0] -max 50.000 [get_ports {HW_INTERLOCK}]
#set_input_delay -clock [get_clocks clk_fpga_0] -min 0.000 [get_ports {HW_INTERLOCK}]

#set_false_path -from [get_ports {HW_INTERLOCK}] -to [get_ports {DRIVER*_EN* }]


#set_input_delay -clock [get_clocks clk_fpga_0] -max  50.000 [get_ports {ENC_ERR}]
#set_input_delay -clock [get_clocks clk_fpga_0] -min -50.000 [get_ports {ENC_ERR}]



#set_output_delay -clock [get_clocks clk_fpga_0] -max  30.000 [get_ports {ENC_LED* DRIVER*_RESET LED_* TEST* RELAY* SIG_R_PU PILOT* }]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -0.000  [get_ports {ENC_LED* DRIVER*_RESET LED_* TEST* RELAY* SIG_R_PU PILOT* }]



#set_output_delay -clock [get_clocks clk_fpga_0] -max  10.000 [get_ports {gpio*}]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -0.000  [get_ports {gpio*}]

#set_input_delay -clock [get_clocks clk_fpga_0] -max  0.000 [get_ports {gpio*}]
#set_input_delay -clock [get_clocks clk_fpga_0] -min  -10.000  [get_ports {gpio*}]



#set_output_delay -clock [get_clocks clk_fpga_0] -max 9.000 [get_ports {XADC_MUX*}]
#set_output_delay -clock [get_clocks clk_fpga_0] -min -0.000 [get_ports {XADC_MUX*}]




set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks AD_CLOCK]

set_max_delay -datapath_only -from [get_clocks AD_CLOCK] -to [get_clocks clk_fpga_0] 2.000
