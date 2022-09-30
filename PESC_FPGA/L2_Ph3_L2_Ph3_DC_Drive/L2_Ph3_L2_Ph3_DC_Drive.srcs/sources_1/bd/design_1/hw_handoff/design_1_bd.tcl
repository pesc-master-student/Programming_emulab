
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z030sbg485-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: extract_and_zeropad_gate_sigs
proc create_hier_cell_extract_and_zeropad_gate_sigs_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_extract_and_zeropad_gate_sigs_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 38 -to 0 dout
  create_bd_pin -dir I -from 5 -to 0 driver_signals

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconstant_7, and set properties
  set xlconstant_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_7 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_7

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create port connections
  connect_bd_net -net driver_interface_2_driver_signals [get_bd_pins driver_signals] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_7_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconstant_7/dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_4/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: extract_and_zeropad_gate_sigs
proc create_hier_cell_extract_and_zeropad_gate_sigs { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_extract_and_zeropad_gate_sigs() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 38 -to 0 dout
  create_bd_pin -dir I -from 5 -to 0 driver_signals

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconstant_7, and set properties
  set xlconstant_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_7 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_7

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create port connections
  connect_bd_net -net driver_interface_2_driver_signals [get_bd_pins driver_signals] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_7_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconstant_7/dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_4/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: converter_2
proc create_hier_cell_converter_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_converter_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AD_Filter_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AD_Integrator_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CurrentRef_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 Driver_interface_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 HysteresisCon_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 PWM_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 Sampled_Integral_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 SwitchingCounter_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 SynchSampling_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 TripLimit_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 voltage_estimator_axi


  # Create pins
  create_bd_pin -dir I -from 51 -to 0 AD
  create_bd_pin -dir O -from 51 -to 0 -type data AD_filtered
  create_bd_pin -dir O -from 119 -to 0 AD_integral
  create_bd_pin -dir I AD_signal_in_new
  create_bd_pin -dir I -from 0 -to 0 FCLK_Reset
  create_bd_pin -dir O -from 0 -to 0 Intr
  create_bd_pin -dir I -type clk S_AXI_ACLK
  create_bd_pin -dir I -type rst S_AXI_ARESETN
  create_bd_pin -dir O -from 51 -to 0 Synch_sampling
  create_bd_pin -dir O driver_enable
  create_bd_pin -dir I driver_ok
  create_bd_pin -dir O driver_reset
  create_bd_pin -dir O -from 5 -to 0 driver_signals
  create_bd_pin -dir I -from 3 -to 0 driver_status
  create_bd_pin -dir I -from 0 -to 0 hw_interlock_in
  create_bd_pin -dir O -from 41 -to 0 hysteresis_error
  create_bd_pin -dir O pilot_signal
  create_bd_pin -dir I -from 2 -to 0 pwm_sync_input
  create_bd_pin -dir I watchdog_exp_in
  create_bd_pin -dir O watchdog_expired

  # Create instance: AD_filter_block, and set properties
  set AD_filter_block [ create_bd_cell -type ip -vlnv sintef.no:user:filter_block:1.0 AD_filter_block ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {4} \
   CONFIG.SIGNAL_IN_WIDTH {13} \
   CONFIG.SIGNAL_OUT_WIDTH {13} \
 ] $AD_filter_block

  # Create instance: CurrentRef, and set properties
  set CurrentRef [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 CurrentRef ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {3} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $CurrentRef

  # Create instance: Hysteresis_control, and set properties
  set Hysteresis_control [ create_bd_cell -type ip -vlnv sintef.no:user:comparator_limiter_block:1.0 Hysteresis_control ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {3} \
   CONFIG.READ_CLIPPED_SIGNALS {0} \
   CONFIG.REGISTER_CLEAR_MASK {0x00000001} \
   CONFIG.REGISTER_SET_MASK {0x00000002} \
   CONFIG.SEPARATE_REFERENCES {0} \
   CONFIG.WIDTH_IN {14} \
   CONFIG.WIDTH_OUT {13} \
 ] $Hysteresis_control

  # Create instance: Moving_integral, and set properties
  set Moving_integral [ create_bd_cell -type ip -vlnv sintef.no:user:filter_block:1.0 Moving_integral ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {8} \
   CONFIG.OPERATION_MODE {0} \
   CONFIG.SIGNAL_IN_WIDTH {13} \
   CONFIG.SIGNAL_OUT_WIDTH {24} \
 ] $Moving_integral

  # Create instance: Tripping, and set properties
  set Tripping [ create_bd_cell -type ip -vlnv sintef.no:user:comparator_limiter_block:1.0 Tripping ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {4} \
   CONFIG.READ_CLIPPED_SIGNALS {0} \
   CONFIG.REFERENCE_SELECTOR {0} \
   CONFIG.REGISTER_CLEAR_MASK {0x00000000} \
   CONFIG.REGISTER_SET_MASK {0x00000003} \
   CONFIG.SEPARATE_REFERENCES {1} \
   CONFIG.WIDTH_IN {13} \
   CONFIG.WIDTH_OUT {13} \
 ] $Tripping

  # Create instance: blankingtimecorr_0, and set properties
  set blankingtimecorr_0 [ create_bd_cell -type ip -vlnv User_Company:SysGen:blankingtimecorr:1.0 blankingtimecorr_0 ]

  # Create instance: driver_interface, and set properties
  set driver_interface [ create_bd_cell -type ip -vlnv sintef.no:user:driver_interface:1.0 driver_interface ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_DISABLE_IN_SIGNALS {4} \
   CONFIG.NUMBER_OF_SIGNAL_SOURCES {2} \
   CONFIG.USE_WATCHDOG_TIMER {1} \
 ] $driver_interface

  # Create instance: extract_and_zeropad_gate_sigs
  create_hier_cell_extract_and_zeropad_gate_sigs_1 $hier_obj extract_and_zeropad_gate_sigs

  # Create instance: moving_integral_latch, and set properties
  set moving_integral_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 moving_integral_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {192} \
 ] $moving_integral_latch

  # Create instance: moving_integral_reg, and set properties
  set moving_integral_reg [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 moving_integral_reg ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {8} \
   CONFIG.REGISTER_WIDTH {24} \
   CONFIG.REG_SIGNED {1} \
 ] $moving_integral_reg

  # Create instance: pwm, and set properties
  set pwm [ create_bd_cell -type ip -vlnv sintef.no:user:pulse_width_modulator:1.0 pwm ]
  set_property -dict [ list \
   CONFIG.HYSTERESIS_DEFAULT_VALUE {0} \
   CONFIG.INTERRUPT_DIVISOR_WIDTH {8} \
 ] $pwm

  # Create instance: signal_operasjon_blokk_1, and set properties
  set signal_operasjon_blokk_1 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_1 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_1

  # Create instance: signal_operasjon_blokk_2, and set properties
  set signal_operasjon_blokk_2 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_2 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_2

  # Create instance: signal_operasjon_blokk_3, and set properties
  set signal_operasjon_blokk_3 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_3 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_3

  # Create instance: switching_event_counter, and set properties
  set switching_event_counter [ create_bd_cell -type ip -vlnv sintef.no:user:switching_event_counter:1.0 switching_event_counter ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {6} \
 ] $switching_event_counter

  # Create instance: synch_sampling_latch, and set properties
  set synch_sampling_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 synch_sampling_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {0000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {52} \
 ] $synch_sampling_latch

  # Create instance: synch_sampling_reg, and set properties
  set synch_sampling_reg [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 synch_sampling_reg ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {4} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $synch_sampling_reg

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_reduced_logic_0

  # Create instance: util_reduced_logic_1, and set properties
  set util_reduced_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_3

  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_4

  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_5

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_6

  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {52} \
   CONFIG.IN1_WIDTH {39} \
   CONFIG.IN2_WIDTH {13} \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_7

  # Create instance: xlconcat_8, and set properties
  set xlconcat_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_8 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_8

  # Create instance: xlconcat_10, and set properties
  set xlconcat_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_10 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_10

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {192} \
 ] $xlconstant_5

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {13} \
 ] $xlconstant_6

  # Create instance: xlconstant_7, and set properties
  set xlconstant_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_7 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {2} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_7

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {191} \
   CONFIG.DIN_TO {168} \
   CONFIG.DIN_WIDTH {192} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {95} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {192} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins voltage_estimator_axi] [get_bd_intf_pins blankingtimecorr_0/blankingtimecorr_s_axi]
  connect_bd_intf_net -intf_net TripLimit_AXI_1 [get_bd_intf_pins TripLimit_AXI] [get_bd_intf_pins Tripping/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins AD_Integrator_AXI5] [get_bd_intf_pins Moving_integral/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins Driver_interface_AXI1] [get_bd_intf_pins driver_interface/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins PWM_AXI8] [get_bd_intf_pins pwm/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins HysteresisCon_AXI7] [get_bd_intf_pins Hysteresis_control/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins CurrentRef_AXI3] [get_bd_intf_pins CurrentRef/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M16_AXI [get_bd_intf_pins SwitchingCounter_AXI4] [get_bd_intf_pins switching_event_counter/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M17_AXI [get_bd_intf_pins AD_Filter_AXI] [get_bd_intf_pins AD_filter_block/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M18_AXI [get_bd_intf_pins Sampled_Integral_AXI6] [get_bd_intf_pins moving_integral_reg/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M19_AXI [get_bd_intf_pins SynchSampling_AXI2] [get_bd_intf_pins synch_sampling_reg/S_AXI]

  # Create port connections
  connect_bd_net -net AD_filter_block_signal_out_a [get_bd_pins AD_filter_block/signal_out_a] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net AD_filter_block_signal_out_b [get_bd_pins AD_filter_block/signal_out_b] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net AD_filter_block_signal_out_c [get_bd_pins AD_filter_block/signal_out_c] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net Tripping_flipflop_out [get_bd_pins Tripping/flipflop_out] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net ad_converter_ad_signal_out [get_bd_pins AD] [get_bd_pins AD_filter_block/signal_in] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net ad_converter_serial_receiver_0_ad_signal_new_busclk [get_bd_pins AD_signal_in_new] [get_bd_pins AD_filter_block/signal_in_new] [get_bd_pins Moving_integral/signal_in_new]
  connect_bd_net -net comparator_limiter_block_0_flipflop_out [get_bd_pins Hysteresis_control/flipflop_out] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net driver_interface_1_watchdog_expired [get_bd_pins hw_interlock_in] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net driver_interface_2_driver_enable [get_bd_pins driver_enable] [get_bd_pins driver_interface/driver_enable]
  connect_bd_net -net driver_interface_2_driver_reset [get_bd_pins driver_reset] [get_bd_pins driver_interface/driver_reset]
  connect_bd_net -net driver_interface_2_driver_signals [get_bd_pins driver_signals] [get_bd_pins blankingtimecorr_0/driver_signals] [get_bd_pins driver_interface/driver_signals] [get_bd_pins extract_and_zeropad_gate_sigs/driver_signals] [get_bd_pins switching_event_counter/signal_in]
  connect_bd_net -net driver_interface_2_pilot_signal [get_bd_pins pilot_signal] [get_bd_pins driver_interface/pilot_signal]
  connect_bd_net -net driver_interface_2_watchdog_expired [get_bd_pins watchdog_expired] [get_bd_pins driver_interface/watchdog_expired]
  connect_bd_net -net driver_ok_2 [get_bd_pins driver_ok] [get_bd_pins driver_interface/driver_ok]
  connect_bd_net -net driver_status_2 [get_bd_pins driver_status] [get_bd_pins driver_interface/driver_status]
  connect_bd_net -net extract_and_zeropad_gate_sigs_dout [get_bd_pins extract_and_zeropad_gate_sigs/dout] [get_bd_pins xlconcat_7/In1]
  connect_bd_net -net filter_block_0_signal_out [get_bd_pins Moving_integral/signal_out] [get_bd_pins moving_integral_latch/D] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net filter_block_1_signal_out [get_bd_pins AD_filtered] [get_bd_pins AD_filter_block/signal_out] [get_bd_pins Tripping/signal_in] [get_bd_pins synch_sampling_latch/D]
  connect_bd_net -net moving_integral_latch_Q [get_bd_pins moving_integral_latch/Q] [get_bd_pins moving_integral_reg/register_array_read_vec]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins S_AXI_ACLK] [get_bd_pins AD_filter_block/S_AXI_ACLK] [get_bd_pins CurrentRef/S_AXI_ACLK] [get_bd_pins Hysteresis_control/S_AXI_ACLK] [get_bd_pins Moving_integral/S_AXI_ACLK] [get_bd_pins Tripping/S_AXI_ACLK] [get_bd_pins blankingtimecorr_0/clk] [get_bd_pins driver_interface/S_AXI_ACLK] [get_bd_pins moving_integral_latch/CLK] [get_bd_pins moving_integral_reg/S_AXI_ACLK] [get_bd_pins pwm/S_AXI_ACLK] [get_bd_pins switching_event_counter/S_AXI_ACLK] [get_bd_pins synch_sampling_latch/CLK] [get_bd_pins synch_sampling_reg/S_AXI_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins FCLK_Reset] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net pwm_2_intr [get_bd_pins Intr] [get_bd_pins blankingtimecorr_0/intr] [get_bd_pins pwm/intr] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net pwm_2_pwm_out [get_bd_pins pwm/pwm_out] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net pwm_sync_input_1 [get_bd_pins pwm_sync_input] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net register_array_0_register_array_write_vec [get_bd_pins CurrentRef/register_array_read_vec] [get_bd_pins CurrentRef/register_array_write_vec]
  connect_bd_net -net register_array_0_register_write_a [get_bd_pins CurrentRef/register_write_a] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net register_array_0_register_write_b [get_bd_pins CurrentRef/register_write_b] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net register_array_0_register_write_c [get_bd_pins CurrentRef/register_write_c] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins S_AXI_ARESETN] [get_bd_pins AD_filter_block/S_AXI_ARESETN] [get_bd_pins CurrentRef/S_AXI_ARESETN] [get_bd_pins Hysteresis_control/S_AXI_ARESETN] [get_bd_pins Moving_integral/S_AXI_ARESETN] [get_bd_pins Tripping/S_AXI_ARESETN] [get_bd_pins blankingtimecorr_0/blankingtimecorr_aresetn] [get_bd_pins driver_interface/S_AXI_ARESETN] [get_bd_pins moving_integral_reg/S_AXI_ARESETN] [get_bd_pins pwm/S_AXI_ARESETN] [get_bd_pins switching_event_counter/S_AXI_ARESETN] [get_bd_pins synch_sampling_reg/S_AXI_ARESETN]
  connect_bd_net -net signal_operasjon_blokk_1_ut [get_bd_pins signal_operasjon_blokk_1/ut] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net signal_operasjon_blokk_2_ut [get_bd_pins signal_operasjon_blokk_2/ut] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net signal_operasjon_blokk_3_ut [get_bd_pins signal_operasjon_blokk_3/ut] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net synch_sampling_Q [get_bd_pins Synch_sampling] [get_bd_pins synch_sampling_latch/Q] [get_bd_pins synch_sampling_reg/register_array_read_vec]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins Moving_integral/signal_load] [get_bd_pins moving_integral_latch/CE] [get_bd_pins synch_sampling_latch/CE] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins util_reduced_logic_1/Res] [get_bd_pins xlconcat_8/In1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins signal_operasjon_blokk_1/reset_h] [get_bd_pins signal_operasjon_blokk_2/reset_h] [get_bd_pins signal_operasjon_blokk_3/reset_h] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins xlconcat_8/In0]
  connect_bd_net -net watchdog_exp_in_1 [get_bd_pins watchdog_exp_in] [get_bd_pins xlconcat_8/In3]
  connect_bd_net -net xlconcat_10_dout [get_bd_pins AD_integral] [get_bd_pins xlconcat_10/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins driver_interface/driver_signal_in] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins hysteresis_error] [get_bd_pins Hysteresis_control/signal_in] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins signal_operasjon_blokk_3/inn] [get_bd_pins xlconcat_4/dout]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins signal_operasjon_blokk_2/inn] [get_bd_pins xlconcat_5/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins signal_operasjon_blokk_1/inn] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins Moving_integral/signal_in] [get_bd_pins xlconcat_7/dout]
  connect_bd_net -net xlconcat_8_dout [get_bd_pins driver_interface/disable_in] [get_bd_pins xlconcat_8/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins Hysteresis_control/new_in] [get_bd_pins Tripping/new_in] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins Moving_integral/signal_load_value] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins xlconcat_7/In2] [get_bd_pins xlconstant_6/dout]
  connect_bd_net -net xlconstant_7_dout [get_bd_pins signal_operasjon_blokk_1/pluss_minus] [get_bd_pins signal_operasjon_blokk_2/pluss_minus] [get_bd_pins signal_operasjon_blokk_3/pluss_minus] [get_bd_pins xlconstant_7/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins util_reduced_logic_1/Op1] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_8/In2] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins pwm/synch_in] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_10/In1] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_10/In0] [get_bd_pins xlslice_4/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: converter_1
proc create_hier_cell_converter_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_converter_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AD_Filter_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AD_Integrator_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CurrentRef_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 Driver_interface_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 HysteresisCon_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 PWM_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 Sampled_Integral_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 SwitchingCounter_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 SynchSampling_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 TripLimit_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 voltage_estimator_axi


  # Create pins
  create_bd_pin -dir I -from 51 -to 0 AD
  create_bd_pin -dir O -from 51 -to 0 -type data AD_filtered
  create_bd_pin -dir O -from 119 -to 0 AD_integral
  create_bd_pin -dir I AD_signal_in_new
  create_bd_pin -dir I -from 0 -to 0 FCLK_Reset
  create_bd_pin -dir O Intr
  create_bd_pin -dir I -type clk S_AXI_ACLK
  create_bd_pin -dir I -type rst S_AXI_ARESETN
  create_bd_pin -dir O -from 51 -to 0 Synch_sampling
  create_bd_pin -dir O driver_enable
  create_bd_pin -dir I driver_ok
  create_bd_pin -dir O driver_reset
  create_bd_pin -dir O -from 5 -to 0 driver_signals
  create_bd_pin -dir I -from 3 -to 0 driver_status
  create_bd_pin -dir I -from 0 -to 0 hw_interlock_in
  create_bd_pin -dir O -from 41 -to 0 hysteresis_error
  create_bd_pin -dir O pilot_signal
  create_bd_pin -dir O -from 2 -to 0 pwm_synch_out
  create_bd_pin -dir I watchdog_exp_in
  create_bd_pin -dir O watchdog_expired

  # Create instance: AD_filter_block, and set properties
  set AD_filter_block [ create_bd_cell -type ip -vlnv sintef.no:user:filter_block:1.0 AD_filter_block ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {4} \
   CONFIG.SIGNAL_IN_WIDTH {13} \
   CONFIG.SIGNAL_OUT_WIDTH {13} \
 ] $AD_filter_block

  # Create instance: CurrentRef, and set properties
  set CurrentRef [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 CurrentRef ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {3} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $CurrentRef

  # Create instance: Hysteresis_control, and set properties
  set Hysteresis_control [ create_bd_cell -type ip -vlnv sintef.no:user:comparator_limiter_block:1.0 Hysteresis_control ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {3} \
   CONFIG.READ_CLIPPED_SIGNALS {0} \
   CONFIG.WIDTH_IN {14} \
   CONFIG.WIDTH_OUT {13} \
 ] $Hysteresis_control

  # Create instance: Moving_integral, and set properties
  set Moving_integral [ create_bd_cell -type ip -vlnv sintef.no:user:filter_block:1.0 Moving_integral ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {8} \
   CONFIG.OPERATION_MODE {0} \
   CONFIG.SIGNAL_IN_WIDTH {13} \
   CONFIG.SIGNAL_OUT_WIDTH {24} \
 ] $Moving_integral

  # Create instance: Tripping, and set properties
  set Tripping [ create_bd_cell -type ip -vlnv sintef.no:user:comparator_limiter_block:1.0 Tripping ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {4} \
   CONFIG.READ_CLIPPED_SIGNALS {0} \
   CONFIG.REFERENCE_SELECTOR {0} \
   CONFIG.REGISTER_CLEAR_MASK {0x00000000} \
   CONFIG.REGISTER_SET_MASK {0x00000003} \
   CONFIG.SEPARATE_REFERENCES {1} \
   CONFIG.WIDTH_IN {13} \
   CONFIG.WIDTH_OUT {13} \
 ] $Tripping

  # Create instance: blankingtimecorr_0, and set properties
  set blankingtimecorr_0 [ create_bd_cell -type ip -vlnv User_Company:SysGen:blankingtimecorr:1.0 blankingtimecorr_0 ]

  # Create instance: driver_interface, and set properties
  set driver_interface [ create_bd_cell -type ip -vlnv sintef.no:user:driver_interface:1.0 driver_interface ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_DISABLE_IN_SIGNALS {4} \
   CONFIG.NUMBER_OF_SIGNAL_SOURCES {2} \
   CONFIG.USE_WATCHDOG_TIMER {1} \
 ] $driver_interface

  # Create instance: extract_and_zeropad_gate_sigs
  create_hier_cell_extract_and_zeropad_gate_sigs $hier_obj extract_and_zeropad_gate_sigs

  # Create instance: moving_integral_latch, and set properties
  set moving_integral_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 moving_integral_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {192} \
 ] $moving_integral_latch

  # Create instance: moving_integral_reg, and set properties
  set moving_integral_reg [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 moving_integral_reg ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {8} \
   CONFIG.REGISTER_WIDTH {24} \
   CONFIG.REG_SIGNED {1} \
 ] $moving_integral_reg

  # Create instance: pwm, and set properties
  set pwm [ create_bd_cell -type ip -vlnv sintef.no:user:pulse_width_modulator:1.0 pwm ]
  set_property -dict [ list \
   CONFIG.HYSTERESIS_DEFAULT_VALUE {0} \
   CONFIG.INTERRUPT_DIVISOR_WIDTH {8} \
 ] $pwm

  # Create instance: signal_operasjon_blokk_1, and set properties
  set signal_operasjon_blokk_1 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_1 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_1

  # Create instance: signal_operasjon_blokk_2, and set properties
  set signal_operasjon_blokk_2 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_2 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_2

  # Create instance: signal_operasjon_blokk_3, and set properties
  set signal_operasjon_blokk_3 [ create_bd_cell -type ip -vlnv sintef.no:user:signal_operasjon_blokk:2.0 signal_operasjon_blokk_3 ]
  set_property -dict [ list \
   CONFIG.BREDDE_INN {13} \
   CONFIG.BREDDE_UT {14} \
   CONFIG.FORTEGN {1} \
 ] $signal_operasjon_blokk_3

  # Create instance: switching_event_counter, and set properties
  set switching_event_counter [ create_bd_cell -type ip -vlnv sintef.no:user:switching_event_counter:1.0 switching_event_counter ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_CHANNELS {6} \
 ] $switching_event_counter

  # Create instance: synch_sampling_latch, and set properties
  set synch_sampling_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 synch_sampling_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {0000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {52} \
 ] $synch_sampling_latch

  # Create instance: synch_sampling_reg, and set properties
  set synch_sampling_reg [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 synch_sampling_reg ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {4} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $synch_sampling_reg

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_reduced_logic_0

  # Create instance: util_reduced_logic_1, and set properties
  set util_reduced_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_3

  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_4

  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_5

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_6

  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {52} \
   CONFIG.IN1_WIDTH {39} \
   CONFIG.IN2_WIDTH {13} \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_7

  # Create instance: xlconcat_8, and set properties
  set xlconcat_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_8 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_8

  # Create instance: xlconcat_9, and set properties
  set xlconcat_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_9 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_9

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {192} \
 ] $xlconstant_5

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {13} \
 ] $xlconstant_6

  # Create instance: xlconstant_8, and set properties
  set xlconstant_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_8 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {2} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_8

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {191} \
   CONFIG.DIN_TO {168} \
   CONFIG.DIN_WIDTH {192} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {95} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {192} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins voltage_estimator_axi] [get_bd_intf_pins blankingtimecorr_0/blankingtimecorr_s_axi]
  connect_bd_intf_net -intf_net TripLimit_AXI_1 [get_bd_intf_pins TripLimit_AXI] [get_bd_intf_pins Tripping/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins AD_Integrator_AXI5] [get_bd_intf_pins Moving_integral/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins Driver_interface_AXI1] [get_bd_intf_pins driver_interface/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins PWM_AXI8] [get_bd_intf_pins pwm/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins HysteresisCon_AXI7] [get_bd_intf_pins Hysteresis_control/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins CurrentRef_AXI3] [get_bd_intf_pins CurrentRef/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M16_AXI [get_bd_intf_pins SwitchingCounter_AXI4] [get_bd_intf_pins switching_event_counter/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M17_AXI [get_bd_intf_pins AD_Filter_AXI] [get_bd_intf_pins AD_filter_block/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M18_AXI [get_bd_intf_pins Sampled_Integral_AXI6] [get_bd_intf_pins moving_integral_reg/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M19_AXI [get_bd_intf_pins SynchSampling_AXI2] [get_bd_intf_pins synch_sampling_reg/S_AXI]

  # Create port connections
  connect_bd_net -net AD_filter_block_signal_out_a [get_bd_pins AD_filter_block/signal_out_a] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net AD_filter_block_signal_out_b [get_bd_pins AD_filter_block/signal_out_b] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net AD_filter_block_signal_out_c [get_bd_pins AD_filter_block/signal_out_c] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net Tripping_flipflop_out [get_bd_pins Tripping/flipflop_out] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net ad_converter_ad_signal_out [get_bd_pins AD] [get_bd_pins AD_filter_block/signal_in] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net ad_converter_serial_receiver_0_ad_signal_new_busclk [get_bd_pins AD_signal_in_new] [get_bd_pins AD_filter_block/signal_in_new] [get_bd_pins Moving_integral/signal_in_new]
  connect_bd_net -net comparator_limiter_block_0_flipflop_out [get_bd_pins Hysteresis_control/flipflop_out] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net driver_interface_1_watchdog_expired [get_bd_pins hw_interlock_in] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net driver_interface_2_driver_enable [get_bd_pins driver_enable] [get_bd_pins driver_interface/driver_enable]
  connect_bd_net -net driver_interface_2_driver_reset [get_bd_pins driver_reset] [get_bd_pins driver_interface/driver_reset]
  connect_bd_net -net driver_interface_2_driver_signals [get_bd_pins driver_signals] [get_bd_pins blankingtimecorr_0/driver_signals] [get_bd_pins driver_interface/driver_signals] [get_bd_pins extract_and_zeropad_gate_sigs/driver_signals] [get_bd_pins switching_event_counter/signal_in]
  connect_bd_net -net driver_interface_2_pilot_signal [get_bd_pins pilot_signal] [get_bd_pins driver_interface/pilot_signal]
  connect_bd_net -net driver_interface_2_watchdog_expired [get_bd_pins watchdog_expired] [get_bd_pins driver_interface/watchdog_expired]
  connect_bd_net -net driver_ok_2 [get_bd_pins driver_ok] [get_bd_pins driver_interface/driver_ok]
  connect_bd_net -net driver_status_2 [get_bd_pins driver_status] [get_bd_pins driver_interface/driver_status]
  connect_bd_net -net extract_and_zeropad_gate_sigs_dout [get_bd_pins extract_and_zeropad_gate_sigs/dout] [get_bd_pins xlconcat_7/In1]
  connect_bd_net -net filter_block_0_signal_out [get_bd_pins Moving_integral/signal_out] [get_bd_pins moving_integral_latch/D] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net filter_block_1_signal_out [get_bd_pins AD_filtered] [get_bd_pins AD_filter_block/signal_out] [get_bd_pins Tripping/signal_in] [get_bd_pins synch_sampling_latch/D]
  connect_bd_net -net moving_integral_latch_Q [get_bd_pins moving_integral_latch/Q] [get_bd_pins moving_integral_reg/register_array_read_vec]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins S_AXI_ACLK] [get_bd_pins AD_filter_block/S_AXI_ACLK] [get_bd_pins CurrentRef/S_AXI_ACLK] [get_bd_pins Hysteresis_control/S_AXI_ACLK] [get_bd_pins Moving_integral/S_AXI_ACLK] [get_bd_pins Tripping/S_AXI_ACLK] [get_bd_pins blankingtimecorr_0/clk] [get_bd_pins driver_interface/S_AXI_ACLK] [get_bd_pins moving_integral_latch/CLK] [get_bd_pins moving_integral_reg/S_AXI_ACLK] [get_bd_pins pwm/S_AXI_ACLK] [get_bd_pins switching_event_counter/S_AXI_ACLK] [get_bd_pins synch_sampling_latch/CLK] [get_bd_pins synch_sampling_reg/S_AXI_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins FCLK_Reset] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net pwm_2_intr [get_bd_pins Intr] [get_bd_pins blankingtimecorr_0/intr] [get_bd_pins pwm/intr] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net pwm_2_pwm_out [get_bd_pins pwm/pwm_out] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net pwm_synch_out [get_bd_pins pwm_synch_out] [get_bd_pins pwm/synch_out]
  connect_bd_net -net register_array_0_register_array_write_vec [get_bd_pins CurrentRef/register_array_read_vec] [get_bd_pins CurrentRef/register_array_write_vec]
  connect_bd_net -net register_array_0_register_write_a [get_bd_pins CurrentRef/register_write_a] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net register_array_0_register_write_b [get_bd_pins CurrentRef/register_write_b] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net register_array_0_register_write_c [get_bd_pins CurrentRef/register_write_c] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins S_AXI_ARESETN] [get_bd_pins AD_filter_block/S_AXI_ARESETN] [get_bd_pins CurrentRef/S_AXI_ARESETN] [get_bd_pins Hysteresis_control/S_AXI_ARESETN] [get_bd_pins Moving_integral/S_AXI_ARESETN] [get_bd_pins Tripping/S_AXI_ARESETN] [get_bd_pins blankingtimecorr_0/blankingtimecorr_aresetn] [get_bd_pins driver_interface/S_AXI_ARESETN] [get_bd_pins moving_integral_reg/S_AXI_ARESETN] [get_bd_pins pwm/S_AXI_ARESETN] [get_bd_pins switching_event_counter/S_AXI_ARESETN] [get_bd_pins synch_sampling_reg/S_AXI_ARESETN]
  connect_bd_net -net signal_operasjon_blokk_1_ut [get_bd_pins signal_operasjon_blokk_1/ut] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net signal_operasjon_blokk_2_ut [get_bd_pins signal_operasjon_blokk_2/ut] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net signal_operasjon_blokk_3_ut [get_bd_pins signal_operasjon_blokk_3/ut] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net synch_sampling_Q [get_bd_pins Synch_sampling] [get_bd_pins synch_sampling_latch/Q] [get_bd_pins synch_sampling_reg/register_array_read_vec]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins Moving_integral/signal_load] [get_bd_pins moving_integral_latch/CE] [get_bd_pins synch_sampling_latch/CE] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins util_reduced_logic_1/Res] [get_bd_pins xlconcat_8/In1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins signal_operasjon_blokk_1/reset_h] [get_bd_pins signal_operasjon_blokk_2/reset_h] [get_bd_pins signal_operasjon_blokk_3/reset_h] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins xlconcat_8/In0]
  connect_bd_net -net watchdog_exp_in_1 [get_bd_pins watchdog_exp_in] [get_bd_pins xlconcat_8/In3]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins driver_interface/driver_signal_in] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins hysteresis_error] [get_bd_pins Hysteresis_control/signal_in] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins signal_operasjon_blokk_3/inn] [get_bd_pins xlconcat_4/dout]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins signal_operasjon_blokk_2/inn] [get_bd_pins xlconcat_5/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins signal_operasjon_blokk_1/inn] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins Moving_integral/signal_in] [get_bd_pins xlconcat_7/dout]
  connect_bd_net -net xlconcat_8_dout [get_bd_pins driver_interface/disable_in] [get_bd_pins xlconcat_8/dout]
  connect_bd_net -net xlconcat_9_dout [get_bd_pins AD_integral] [get_bd_pins xlconcat_9/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins Hysteresis_control/new_in] [get_bd_pins Tripping/new_in] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins Moving_integral/signal_load_value] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins xlconcat_7/In2] [get_bd_pins xlconstant_6/dout]
  connect_bd_net -net xlconstant_8_dout [get_bd_pins signal_operasjon_blokk_1/pluss_minus] [get_bd_pins signal_operasjon_blokk_2/pluss_minus] [get_bd_pins signal_operasjon_blokk_3/pluss_minus] [get_bd_pins xlconstant_8/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins util_reduced_logic_1/Op1] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_8/In2] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_9/In1] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_9/In0] [get_bd_pins xlslice_4/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set Vaux0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0 ]

  set Vaux8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8 ]

  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  set ad_sdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ad_sdio ]

  set gpio1_d [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio1_d ]


  # Create ports
  set DRIVER1_D [ create_bd_port -dir O -from 5 -to 0 DRIVER1_D ]
  set DRIVER1_ENABLE [ create_bd_port -dir O DRIVER1_ENABLE ]
  set DRIVER1_OK [ create_bd_port -dir I DRIVER1_OK ]
  set DRIVER1_RESET [ create_bd_port -dir O DRIVER1_RESET ]
  set DRIVER1_T [ create_bd_port -dir I -from 3 -to 0 DRIVER1_T ]
  set DRIVER2_D [ create_bd_port -dir O -from 5 -to 0 DRIVER2_D ]
  set DRIVER2_ENABLE [ create_bd_port -dir O DRIVER2_ENABLE ]
  set DRIVER2_OK [ create_bd_port -dir I DRIVER2_OK ]
  set DRIVER2_RESET [ create_bd_port -dir O DRIVER2_RESET ]
  set DRIVER2_T [ create_bd_port -dir I -from 3 -to 0 DRIVER2_T ]
  set ENC_ERR [ create_bd_port -dir I -from 0 -to 0 ENC_ERR ]
  set ENC_LED [ create_bd_port -dir O -from 3 -to 0 ENC_LED ]
  set ENC_P [ create_bd_port -dir I -from 2 -to 0 ENC_P ]
  set HW_INTERLOCK [ create_bd_port -dir I -from 0 -to 0 HW_INTERLOCK ]
  set LED_ALARM [ create_bd_port -dir O LED_ALARM ]
  set LVCT_OE_N [ create_bd_port -dir O -from 0 -to 0 LVCT_OE_N ]
  set PILOT_SIGNAL [ create_bd_port -dir O PILOT_SIGNAL ]
  set RELAY [ create_bd_port -dir O -from 3 -to 0 RELAY ]
  set RS485_SCLK [ create_bd_port -dir O -type clk RS485_SCLK ]
  set RS485_SDIN [ create_bd_port -dir I -type data RS485_SDIN ]
  set RS485_SDOUT [ create_bd_port -dir O -type data RS485_SDOUT ]
  set RS485_SOEN [ create_bd_port -dir O -type ce RS485_SOEN ]
  set SIG_D [ create_bd_port -dir I -from 5 -to 0 SIG_D ]
  set SIG_R_PU [ create_bd_port -dir O -from 5 -to 0 SIG_R_PU ]
  set TEST [ create_bd_port -dir O -from 4 -to 0 TEST ]
  set XADC_MUX [ create_bd_port -dir O -from 1 -to 0 XADC_MUX ]
  set ad_d_n [ create_bd_port -dir I -from 7 -to 0 ad_d_n ]
  set ad_d_p [ create_bd_port -dir I -from 7 -to 0 ad_d_p ]
  set ad_dcon [ create_bd_port -dir I ad_dcon ]
  set ad_dcop [ create_bd_port -dir I ad_dcop ]
  set ad_fcon [ create_bd_port -dir I ad_fcon ]
  set ad_fcop [ create_bd_port -dir I ad_fcop ]
  set ad_sclk [ create_bd_port -dir O ad_sclk ]
  set ad_scsb [ create_bd_port -dir O -from 0 -to 0 ad_scsb ]
  set da_a_b [ create_bd_port -dir O da_a_b ]
  set da_ab_cs [ create_bd_port -dir O da_ab_cs ]
  set da_cd_cs [ create_bd_port -dir O da_cd_cs ]
  set da_d [ create_bd_port -dir O -from 11 -to 0 da_d ]

  # Create instance: ENDAT22_S_1, and set properties
  set ENDAT22_S_1 [ create_bd_cell -type ip -vlnv ntnu.no:user:ENDAT22_S:3.8 ENDAT22_S_1 ]

  # Create instance: ad_converter, and set properties
  set ad_converter [ create_bd_cell -type ip -vlnv sintef.no:user:ad_converter_serial_receiver:1.0 ad_converter ]
  set_property -dict [ list \
   CONFIG.AD_SIGNAL_IOBDELAY_VALUE {22} \
 ] $ad_converter

  # Create instance: array_resize_0, and set properties
  set array_resize_0 [ create_bd_cell -type ip -vlnv sintef.no:user:array_resize:1.0 array_resize_0 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_ELEMENTS {10} \
   CONFIG.SHIFT_TO_TOP {1} \
   CONFIG.WIDTH_IN {24} \
   CONFIG.WIDTH_OUT {16} \
 ] $array_resize_0

  # Create instance: array_resize_1, and set properties
  set array_resize_1 [ create_bd_cell -type ip -vlnv sintef.no:user:array_resize:1.0 array_resize_1 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_ELEMENTS {6} \
   CONFIG.SHIFT_TO_TOP {1} \
   CONFIG.WIDTH_IN {14} \
   CONFIG.WIDTH_OUT {16} \
 ] $array_resize_1

  # Create instance: array_resize_2, and set properties
  set array_resize_2 [ create_bd_cell -type ip -vlnv sintef.no:user:array_resize:1.0 array_resize_2 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_ELEMENTS {8} \
   CONFIG.SHIFT_TO_TOP {1} \
   CONFIG.WIDTH_IN {13} \
   CONFIG.WIDTH_OUT {16} \
 ] $array_resize_2

  # Create instance: array_resize_3, and set properties
  set array_resize_3 [ create_bd_cell -type ip -vlnv sintef.no:user:array_resize:1.0 array_resize_3 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_ELEMENTS {8} \
   CONFIG.SHIFT_TO_TOP {1} \
   CONFIG.WIDTH_IN {13} \
   CONFIG.WIDTH_OUT {16} \
 ] $array_resize_3

  # Create instance: array_resize_4, and set properties
  set array_resize_4 [ create_bd_cell -type ip -vlnv sintef.no:user:array_resize:1.0 array_resize_4 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_ELEMENTS {8} \
   CONFIG.SHIFT_TO_TOP {1} \
   CONFIG.WIDTH_IN {13} \
   CONFIG.WIDTH_OUT {16} \
 ] $array_resize_4

  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property -dict [ list \
   CONFIG.C_APB_NUM_SLAVES {1} \
 ] $axi_apb_bridge_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {16} \
   CONFIG.GPIO_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_1

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {39} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_interconnect_0

  # Create instance: bidir_io_port_0, and set properties
  set bidir_io_port_0 [ create_bd_cell -type ip -vlnv sintef.no:user:bidir_io_port:1.0 bidir_io_port_0 ]

  # Create instance: c_shift_ram_0, and set properties
  set c_shift_ram_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {00000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000} \
   CONFIG.Width {14} \
 ] $c_shift_ram_0

  # Create instance: c_shift_ram_1, and set properties
  set c_shift_ram_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {104} \
 ] $c_shift_ram_1

  # Create instance: c_shift_ram_2, and set properties
  set c_shift_ram_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {104} \
 ] $c_shift_ram_2

  # Create instance: converter_1
  create_hier_cell_converter_1 [current_bd_instance .] converter_1

  # Create instance: converter_2
  create_hier_cell_converter_2 [current_bd_instance .] converter_2

  # Create instance: da_converter, and set properties
  set da_converter [ create_bd_cell -type ip -vlnv sintef.no:user:da_converter_interface:1.0 da_converter ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_SIGNAL_SOURCES {48} \
   CONFIG.USE_SCALING {1} \
   CONFIG.WIDTH_IN {16} \
 ] $da_converter

  # Create instance: emu_dc_0, and set properties
  set emu_dc_0 [ create_bd_cell -type ip -vlnv PESC_NTNU:SysGen:emu_dc:5.16 emu_dc_0 ]

  # Create instance: encoder_interface, and set properties
  set encoder_interface [ create_bd_cell -type ip -vlnv sintef.no:user:incremental_encoder_interface:1.0 encoder_interface ]

  # Create instance: irq_xlconcat_0, and set properties
  set irq_xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $irq_xlconcat_0

  # Create instance: multiplexer_0, and set properties
  set multiplexer_0 [ create_bd_cell -type ip -vlnv ntnu.no:user:multiplexer:1.0 multiplexer_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {25.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_CAN1_IO {MIO 48 .. 49} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {200000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {1} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {1} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {0} \
   CONFIG.PCW_EN_SDIO1 {1} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {1} \
   CONFIG.PCW_EN_SPI1 {1} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {0} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {in} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {out} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#GPIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SPI 0#SPI 0#SPI 0#GPIO#GPIO#SPI 0#GPIO#GPIO#CAN 1#CAN 1#UART 0#UART 0#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#reset#qspi_fbclk#gpio[9]#data[0]#cmd#clk#data[1]#data[2]#data[3]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#sclk#miso#ss[0]#gpio[43]#gpio[44]#mosi#gpio[46]#gpio[47]#tx#rx#rx#tx#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.301} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.308} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.357} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.361} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.033} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.029} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.057} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.038} \
   CONFIG.PCW_PACKAGE_NAME {sbg485} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_CD_IO {<Select>} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SD0_SD0_IO {<Select>} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD1_SD1_IO {MIO 10 .. 15} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {40} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {MIO 42} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI0_SPI0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI1_SPI1_IO {EMIO} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 50 .. 51} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_UART1_IO {<Select>} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.240} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.238} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.283} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.284} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {33.621} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {73.818} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {33.621} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {73.818} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {48.166} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {73.818} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {48.166} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {73.818} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {38.200} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {78.217} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {38.692} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {70.543} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {38.778} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {76.039} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {38.635} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {96.0285} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.036} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.036} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.058} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.057} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {38.671} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {71.836} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {38.635} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {87.0105} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {38.671} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {93.232} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {38.679} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {100.6725} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 7} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
 ] $processing_system7_0

  # Create instance: register_emu_input, and set properties
  set register_emu_input [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 register_emu_input ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {1} \
   CONFIG.REGISTER_WIDTH {14} \
   CONFIG.REG_SIGNED {1} \
 ] $register_emu_input

  # Create instance: register_emu_out, and set properties
  set register_emu_out [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 register_emu_out ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {8} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $register_emu_out

  # Create instance: register_mux_out, and set properties
  set register_mux_out [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 register_mux_out ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {8} \
   CONFIG.REGISTER_WIDTH {13} \
   CONFIG.REG_SIGNED {1} \
 ] $register_mux_out

  # Create instance: relay, and set properties
  set relay [ create_bd_cell -type ip -vlnv sintef.no:user:register_array:1.0 relay ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_REGISTERS {1} \
   CONFIG.REGISTER_WIDTH {4} \
 ] $relay

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: signal_in, and set properties
  set signal_in [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 signal_in ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO2_WIDTH {6} \
   CONFIG.C_GPIO_WIDTH {6} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.GPIO_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $signal_in

  # Create instance: signalinverter, and set properties
  set signalinverter [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 signalinverter ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {6} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $signalinverter

  # Create instance: testled, and set properties
  set testled [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 testled ]
  set_property -dict [ list \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {5} \
   CONFIG.C_IS_DUAL {0} \
 ] $testled

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_2

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} \
   CONFIG.CHANNEL_ENABLE_VAUXP8_VAUXN8 {true} \
   CONFIG.CHANNEL_ENABLE_VP_VN {false} \
   CONFIG.ENABLE_EXTERNAL_MUX {true} \
   CONFIG.ENABLE_RESET {false} \
   CONFIG.EXTERNAL_MUX_CHANNEL {VAUXP0_VAUXN0} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
   CONFIG.SEQUENCER_MODE {Off} \
   CONFIG.SINGLE_CHANNEL_SELECTION {VP_VN} \
   CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} \
 ] $xadc_wiz_0

  # Create instance: xadcmuxslice, and set properties
  set xadcmuxslice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xadcmuxslice ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {2} \
 ] $xadcmuxslice

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {13} \
   CONFIG.IN1_WIDTH {13} \
   CONFIG.IN2_WIDTH {13} \
   CONFIG.IN3_WIDTH {13} \
   CONFIG.IN4_WIDTH {13} \
   CONFIG.IN5_WIDTH {13} \
   CONFIG.IN6_WIDTH {13} \
   CONFIG.IN7_WIDTH {13} \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]

  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {52} \
   CONFIG.IN1_WIDTH {52} \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_4

  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_5

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {52} \
   CONFIG.IN1_WIDTH {52} \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_6

  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {42} \
   CONFIG.IN1_WIDTH {42} \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_7

  # Create instance: xlconcat_8, and set properties
  set xlconcat_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_8 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_8

  # Create instance: xlconcat_10, and set properties
  set xlconcat_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_10 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_10

  # Create instance: xlconcat_11, and set properties
  set xlconcat_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_11 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_11

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {-1} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {3} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_4

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_5

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Vaux0_1 [get_bd_intf_ports Vaux0] [get_bd_intf_pins xadc_wiz_0/Vaux0]
  connect_bd_intf_net -intf_net Vaux8_1 [get_bd_intf_ports Vaux8] [get_bd_intf_pins xadc_wiz_0/Vaux8]
  connect_bd_intf_net -intf_net Vp_Vn_1 [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins xadc_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_pins ENDAT22_S_1/APB_S] [get_bd_intf_pins axi_apb_bridge_0/APB_M]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports gpio1_d] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins testled/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins signal_in/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins ad_converter/S_AXI] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins da_converter/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins converter_2/AD_Filter_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins converter_1/AD_Filter_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins converter_1/Driver_interface_AXI1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_interconnect_0/M09_AXI] [get_bd_intf_pins converter_2/Driver_interface_AXI1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins encoder_interface/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M12_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M12_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins axi_interconnect_0/M13_AXI] [get_bd_intf_pins converter_2/SynchSampling_AXI2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins axi_interconnect_0/M14_AXI] [get_bd_intf_pins converter_2/CurrentRef_AXI3]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins axi_interconnect_0/M15_AXI] [get_bd_intf_pins converter_2/SwitchingCounter_AXI4]
  connect_bd_intf_net -intf_net axi_interconnect_0_M16_AXI [get_bd_intf_pins axi_interconnect_0/M16_AXI] [get_bd_intf_pins converter_2/AD_Integrator_AXI5]
  connect_bd_intf_net -intf_net axi_interconnect_0_M17_AXI [get_bd_intf_pins axi_interconnect_0/M17_AXI] [get_bd_intf_pins converter_2/Sampled_Integral_AXI6]
  connect_bd_intf_net -intf_net axi_interconnect_0_M18_AXI [get_bd_intf_pins axi_interconnect_0/M18_AXI] [get_bd_intf_pins converter_2/HysteresisCon_AXI7]
  connect_bd_intf_net -intf_net axi_interconnect_0_M19_AXI [get_bd_intf_pins axi_interconnect_0/M19_AXI] [get_bd_intf_pins converter_2/PWM_AXI8]
  connect_bd_intf_net -intf_net axi_interconnect_0_M20_AXI [get_bd_intf_pins axi_interconnect_0/M20_AXI] [get_bd_intf_pins converter_1/SynchSampling_AXI2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M21_AXI [get_bd_intf_pins axi_interconnect_0/M21_AXI] [get_bd_intf_pins relay/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M22_AXI [get_bd_intf_pins axi_interconnect_0/M22_AXI] [get_bd_intf_pins converter_1/CurrentRef_AXI3]
  connect_bd_intf_net -intf_net axi_interconnect_0_M23_AXI [get_bd_intf_pins axi_interconnect_0/M23_AXI] [get_bd_intf_pins converter_1/SwitchingCounter_AXI4]
  connect_bd_intf_net -intf_net axi_interconnect_0_M24_AXI [get_bd_intf_pins axi_interconnect_0/M24_AXI] [get_bd_intf_pins converter_1/AD_Integrator_AXI5]
  connect_bd_intf_net -intf_net axi_interconnect_0_M25_AXI [get_bd_intf_pins axi_interconnect_0/M25_AXI] [get_bd_intf_pins converter_1/Sampled_Integral_AXI6]
  connect_bd_intf_net -intf_net axi_interconnect_0_M26_AXI [get_bd_intf_pins axi_interconnect_0/M26_AXI] [get_bd_intf_pins converter_1/HysteresisCon_AXI7]
  connect_bd_intf_net -intf_net axi_interconnect_0_M27_AXI [get_bd_intf_pins axi_interconnect_0/M27_AXI] [get_bd_intf_pins converter_1/PWM_AXI8]
  connect_bd_intf_net -intf_net axi_interconnect_0_M28_AXI [get_bd_intf_pins axi_interconnect_0/M28_AXI] [get_bd_intf_pins converter_1/voltage_estimator_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M29_AXI [get_bd_intf_pins axi_interconnect_0/M29_AXI] [get_bd_intf_pins converter_2/voltage_estimator_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M30_AXI [get_bd_intf_pins axi_interconnect_0/M30_AXI] [get_bd_intf_pins converter_1/TripLimit_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M31_AXI [get_bd_intf_pins axi_interconnect_0/M31_AXI] [get_bd_intf_pins converter_2/TripLimit_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M32_AXI [get_bd_intf_pins axi_interconnect_0/M32_AXI] [get_bd_intf_pins multiplexer_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M33_AXI [get_bd_intf_pins axi_interconnect_0/M33_AXI] [get_bd_intf_pins emu_dc_0/emu_dc_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M34_AXI [get_bd_intf_pins axi_interconnect_0/M34_AXI] [get_bd_intf_pins register_emu_out/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M35_AXI [get_bd_intf_pins axi_interconnect_0/M35_AXI] [get_bd_intf_pins register_mux_out/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M36_AXI [get_bd_intf_pins axi_interconnect_0/M36_AXI] [get_bd_intf_pins register_emu_input/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M37_AXI [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE] [get_bd_intf_pins axi_interconnect_0/M37_AXI]
  connect_bd_intf_net -intf_net bidir_io_port_0_p_tri [get_bd_intf_ports ad_sdio] [get_bd_intf_pins bidir_io_port_0/p_tri]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net DRIVER1_OK_1 [get_bd_ports DRIVER1_OK] [get_bd_pins converter_1/driver_ok]
  connect_bd_net -net DRIVER1_T_1 [get_bd_ports DRIVER1_T] [get_bd_pins converter_1/driver_status]
  connect_bd_net -net DRIVER2_OK_1 [get_bd_ports DRIVER2_OK] [get_bd_pins converter_2/driver_ok]
  connect_bd_net -net DRIVER2_T_1 [get_bd_ports DRIVER2_T] [get_bd_pins converter_2/driver_status]
  connect_bd_net -net ENCODER_1 [get_bd_ports ENC_P] [get_bd_pins encoder_interface/ENCODER]
  connect_bd_net -net ENDAT22_S_0_data_dv [get_bd_ports RS485_SDOUT] [get_bd_pins ENDAT22_S_1/data_dv]
  connect_bd_net -net ENDAT22_S_0_de [get_bd_ports RS485_SOEN] [get_bd_pins ENDAT22_S_1/de]
  connect_bd_net -net ENDAT22_S_0_tclk [get_bd_ports RS485_SCLK] [get_bd_pins ENDAT22_S_1/tclk]
  connect_bd_net -net HW_INTERLOCK_1 [get_bd_ports HW_INTERLOCK] [get_bd_pins converter_1/hw_interlock_in] [get_bd_pins converter_2/hw_interlock_in]
  connect_bd_net -net In0_1 [get_bd_ports ENC_ERR] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net RS485_SDIN_1 [get_bd_ports RS485_SDIN] [get_bd_pins ENDAT22_S_1/data_rc]
  connect_bd_net -net SIG_D_1 [get_bd_ports SIG_D] [get_bd_pins signalinverter/Op1]
  connect_bd_net -net ad_converter_ad_signal_a [get_bd_pins ad_converter/ad_signal_a] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net ad_converter_ad_signal_b [get_bd_pins ad_converter/ad_signal_b] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net ad_converter_ad_signal_c [get_bd_pins ad_converter/ad_signal_c] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net ad_converter_ad_signal_d [get_bd_pins ad_converter/ad_signal_d] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net ad_converter_ad_signal_e [get_bd_pins ad_converter/ad_signal_e] [get_bd_pins xlconcat_2/In4]
  connect_bd_net -net ad_converter_ad_signal_f [get_bd_pins ad_converter/ad_signal_f] [get_bd_pins xlconcat_2/In5]
  connect_bd_net -net ad_converter_ad_signal_g [get_bd_pins ad_converter/ad_signal_g] [get_bd_pins xlconcat_2/In6]
  connect_bd_net -net ad_converter_ad_signal_h [get_bd_pins ad_converter/ad_signal_h] [get_bd_pins xlconcat_2/In7]
  connect_bd_net -net ad_converter_serial_receiver_0_ad_signal_new_busclk [get_bd_pins ad_converter/ad_signal_new_busclk] [get_bd_pins converter_1/AD_signal_in_new] [get_bd_pins converter_2/AD_signal_in_new]
  connect_bd_net -net ad_d_n_1 [get_bd_ports ad_d_n] [get_bd_pins ad_converter/ad_d_n]
  connect_bd_net -net ad_d_p_1 [get_bd_ports ad_d_p] [get_bd_pins ad_converter/ad_d_p]
  connect_bd_net -net ad_dcon_1 [get_bd_ports ad_dcon] [get_bd_pins ad_converter/ad_dcon]
  connect_bd_net -net ad_dcop_1 [get_bd_ports ad_dcop] [get_bd_pins ad_converter/ad_dcop]
  connect_bd_net -net ad_fcon_1 [get_bd_ports ad_fcon] [get_bd_pins ad_converter/ad_fcon]
  connect_bd_net -net ad_fcop_1 [get_bd_ports ad_fcop] [get_bd_pins ad_converter/ad_fcop]
  connect_bd_net -net array_resize_0_array_out [get_bd_pins da_converter/signal_in_a] [get_bd_pins da_converter/signal_in_b] [get_bd_pins da_converter/signal_in_c] [get_bd_pins da_converter/signal_in_d] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net array_resize_0_array_out1 [get_bd_pins array_resize_0/array_out] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net array_resize_1_array_out [get_bd_pins array_resize_1/array_out] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net array_resize_2_array_out [get_bd_pins array_resize_2/array_out] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net array_resize_3_array_out [get_bd_pins array_resize_3/array_out] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net array_resize_4_array_out [get_bd_pins array_resize_4/array_out] [get_bd_pins xlconcat_1/In4]
  connect_bd_net -net bidir_io_port_0_p_tri_buf_i [get_bd_pins bidir_io_port_0/p_tri_buf_i] [get_bd_pins processing_system7_0/SPI1_MISO_I]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins c_shift_ram_0/Q] [get_bd_pins register_emu_input/register_array_read_vec]
  connect_bd_net -net c_shift_ram_1_Q [get_bd_pins c_shift_ram_1/Q] [get_bd_pins register_emu_out/register_array_read_vec]
  connect_bd_net -net c_shift_ram_2_Q [get_bd_pins c_shift_ram_2/Q] [get_bd_pins register_mux_out/register_array_read_vec]
  connect_bd_net -net converter_1_AD_filtered [get_bd_pins converter_1/AD_filtered] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net converter_1_AD_integral [get_bd_pins converter_1/AD_integral] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net converter_1_Intr [get_bd_pins converter_1/Intr] [get_bd_pins irq_xlconcat_0/In0] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net converter_1_Synch_sampling1 [get_bd_pins converter_1/Synch_sampling] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net converter_1_driver_enable [get_bd_pins converter_1/driver_enable] [get_bd_pins emu_dc_0/enable_con1_in] [get_bd_pins multiplexer_0/Driver_Enable_1_i] [get_bd_pins xlconcat_8/In0]
  connect_bd_net -net converter_1_driver_reset [get_bd_ports DRIVER1_RESET] [get_bd_pins converter_1/driver_reset]
  connect_bd_net -net converter_1_driver_signals [get_bd_ports DRIVER1_D] [get_bd_pins converter_1/driver_signals] [get_bd_pins emu_dc_0/gatesig1_in] [get_bd_pins xlconcat_8/In2]
  connect_bd_net -net converter_1_hysteresis_error [get_bd_pins converter_1/hysteresis_error] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net converter_1_pilot_signal [get_bd_ports PILOT_SIGNAL] [get_bd_pins converter_1/pilot_signal]
  connect_bd_net -net converter_1_synch_out [get_bd_pins converter_1/pwm_synch_out] [get_bd_pins converter_2/pwm_sync_input]
  connect_bd_net -net converter_1_watchdog_expired [get_bd_pins converter_1/watchdog_expired] [get_bd_pins converter_2/watchdog_exp_in] [get_bd_pins relay/load]
  connect_bd_net -net converter_2_AD_filtered [get_bd_pins converter_2/AD_filtered] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net converter_2_AD_integral [get_bd_pins converter_2/AD_integral] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net converter_2_Synch_sampling [get_bd_pins converter_2/Synch_sampling] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net converter_2_driver_enable [get_bd_pins converter_2/driver_enable] [get_bd_pins emu_dc_0/enable_con2_in] [get_bd_pins multiplexer_0/Driver_Enable_2_i] [get_bd_pins xlconcat_8/In1]
  connect_bd_net -net converter_2_driver_reset [get_bd_ports DRIVER2_RESET] [get_bd_pins converter_2/driver_reset]
  connect_bd_net -net converter_2_driver_signals [get_bd_ports DRIVER2_D] [get_bd_pins converter_2/driver_signals] [get_bd_pins emu_dc_0/gatesig2_in] [get_bd_pins xlconcat_8/In3]
  connect_bd_net -net converter_2_hysteresis_error [get_bd_pins converter_2/hysteresis_error] [get_bd_pins xlconcat_7/In1]
  connect_bd_net -net da_converter_interface_0_da_a_b [get_bd_ports da_a_b] [get_bd_pins da_converter/da_a_b]
  connect_bd_net -net da_converter_interface_0_da_ab_cs [get_bd_ports da_ab_cs] [get_bd_pins da_converter/da_ab_cs]
  connect_bd_net -net da_converter_interface_0_da_cd_cs [get_bd_ports da_cd_cs] [get_bd_pins da_converter/da_cd_cs]
  connect_bd_net -net da_converter_interface_0_da_d [get_bd_ports da_d] [get_bd_pins da_converter/da_d]
  connect_bd_net -net emu_dc_0_ia_dac [get_bd_pins emu_dc_0/ia_dac] [get_bd_pins xlconcat_11/In0]
  connect_bd_net -net emu_dc_0_pu_speed_dac [get_bd_pins emu_dc_0/pu_speed_dac] [get_bd_pins xlconcat_11/In7]
  connect_bd_net -net emu_dc_0_theta_el_dac [get_bd_pins emu_dc_0/theta_el_dac] [get_bd_pins xlconcat_11/In1]
  connect_bd_net -net emu_dc_0_theta_mech_dac [get_bd_pins emu_dc_0/theta_mech_dac] [get_bd_pins xlconcat_11/In2]
  connect_bd_net -net emu_dc_0_ua0_1_dac [get_bd_pins emu_dc_0/ua0_1_dac] [get_bd_pins xlconcat_11/In3]
  connect_bd_net -net emu_dc_0_uab_1_dac [get_bd_pins emu_dc_0/uab_1_dac] [get_bd_pins xlconcat_11/In4]
  connect_bd_net -net emu_dc_0_uab_2_dac [get_bd_pins emu_dc_0/uab_2_dac] [get_bd_pins xlconcat_11/In5]
  connect_bd_net -net emu_dc_0_ub0_1_dac [get_bd_pins emu_dc_0/ub0_1_dac] [get_bd_pins xlconcat_11/In6]
  connect_bd_net -net emulator_0_signalbus_out [get_bd_pins c_shift_ram_1/D] [get_bd_pins emu_dc_0/signalbus_out] [get_bd_pins multiplexer_0/emulator_out]
  connect_bd_net -net incremental_encoder_interface_0_LEDS [get_bd_ports ENC_LED] [get_bd_pins encoder_interface/LEDS]
  connect_bd_net -net irq_xlconcat_0_dout [get_bd_pins irq_xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net multiplexer_0_ADC_1 [get_bd_pins converter_1/AD] [get_bd_pins multiplexer_0/ADC_1] [get_bd_pins xlconcat_10/In0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net multiplexer_0_ADC_2 [get_bd_pins converter_2/AD] [get_bd_pins multiplexer_0/ADC_2] [get_bd_pins xlconcat_10/In1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net multiplexer_0_Driver_Enable_1_o [get_bd_ports DRIVER1_ENABLE] [get_bd_pins multiplexer_0/Driver_Enable_1_o]
  connect_bd_net -net multiplexer_0_Driver_Enable_2_o [get_bd_ports DRIVER2_ENABLE] [get_bd_pins multiplexer_0/Driver_Enable_2_o]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins ENDAT22_S_1/clk] [get_bd_pins ad_converter/S_AXI_ACLK] [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins axi_interconnect_0/M13_ACLK] [get_bd_pins axi_interconnect_0/M14_ACLK] [get_bd_pins axi_interconnect_0/M15_ACLK] [get_bd_pins axi_interconnect_0/M16_ACLK] [get_bd_pins axi_interconnect_0/M17_ACLK] [get_bd_pins axi_interconnect_0/M18_ACLK] [get_bd_pins axi_interconnect_0/M19_ACLK] [get_bd_pins axi_interconnect_0/M20_ACLK] [get_bd_pins axi_interconnect_0/M21_ACLK] [get_bd_pins axi_interconnect_0/M22_ACLK] [get_bd_pins axi_interconnect_0/M23_ACLK] [get_bd_pins axi_interconnect_0/M24_ACLK] [get_bd_pins axi_interconnect_0/M25_ACLK] [get_bd_pins axi_interconnect_0/M26_ACLK] [get_bd_pins axi_interconnect_0/M27_ACLK] [get_bd_pins axi_interconnect_0/M28_ACLK] [get_bd_pins axi_interconnect_0/M29_ACLK] [get_bd_pins axi_interconnect_0/M30_ACLK] [get_bd_pins axi_interconnect_0/M31_ACLK] [get_bd_pins axi_interconnect_0/M32_ACLK] [get_bd_pins axi_interconnect_0/M33_ACLK] [get_bd_pins axi_interconnect_0/M34_ACLK] [get_bd_pins axi_interconnect_0/M35_ACLK] [get_bd_pins axi_interconnect_0/M36_ACLK] [get_bd_pins axi_interconnect_0/M37_ACLK] [get_bd_pins axi_interconnect_0/M38_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins c_shift_ram_0/CLK] [get_bd_pins c_shift_ram_1/CLK] [get_bd_pins c_shift_ram_2/CLK] [get_bd_pins converter_1/S_AXI_ACLK] [get_bd_pins converter_2/S_AXI_ACLK] [get_bd_pins da_converter/S_AXI_ACLK] [get_bd_pins emu_dc_0/clk] [get_bd_pins encoder_interface/S_AXI_ACLK] [get_bd_pins multiplexer_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins register_emu_input/S_AXI_ACLK] [get_bd_pins register_emu_out/S_AXI_ACLK] [get_bd_pins register_mux_out/S_AXI_ACLK] [get_bd_pins relay/S_AXI_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins signal_in/s_axi_aclk] [get_bd_pins testled/s_axi_aclk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins ad_converter/ad_200MHz_delay_ref_clock] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins converter_1/FCLK_Reset] [get_bd_pins converter_2/FCLK_Reset] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net processing_system7_0_SPI1_MOSI_O [get_bd_pins processing_system7_0/SPI1_MOSI_O] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net processing_system7_0_SPI1_SCLK_O [get_bd_ports ad_sclk] [get_bd_pins processing_system7_0/SPI1_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI1_SS_O [get_bd_ports ad_scsb] [get_bd_pins processing_system7_0/SPI1_SS_O]
  connect_bd_net -net relay_register_array_write_vec [get_bd_ports RELAY] [get_bd_pins relay/register_array_read_vec] [get_bd_pins relay/register_array_write_vec]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins ad_converter/S_AXI_ARESETN] [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins axi_interconnect_0/M13_ARESETN] [get_bd_pins axi_interconnect_0/M14_ARESETN] [get_bd_pins axi_interconnect_0/M15_ARESETN] [get_bd_pins axi_interconnect_0/M16_ARESETN] [get_bd_pins axi_interconnect_0/M17_ARESETN] [get_bd_pins axi_interconnect_0/M18_ARESETN] [get_bd_pins axi_interconnect_0/M19_ARESETN] [get_bd_pins axi_interconnect_0/M20_ARESETN] [get_bd_pins axi_interconnect_0/M21_ARESETN] [get_bd_pins axi_interconnect_0/M22_ARESETN] [get_bd_pins axi_interconnect_0/M23_ARESETN] [get_bd_pins axi_interconnect_0/M24_ARESETN] [get_bd_pins axi_interconnect_0/M25_ARESETN] [get_bd_pins axi_interconnect_0/M26_ARESETN] [get_bd_pins axi_interconnect_0/M27_ARESETN] [get_bd_pins axi_interconnect_0/M28_ARESETN] [get_bd_pins axi_interconnect_0/M29_ARESETN] [get_bd_pins axi_interconnect_0/M30_ARESETN] [get_bd_pins axi_interconnect_0/M31_ARESETN] [get_bd_pins axi_interconnect_0/M32_ARESETN] [get_bd_pins axi_interconnect_0/M33_ARESETN] [get_bd_pins axi_interconnect_0/M34_ARESETN] [get_bd_pins axi_interconnect_0/M35_ARESETN] [get_bd_pins axi_interconnect_0/M36_ARESETN] [get_bd_pins axi_interconnect_0/M37_ARESETN] [get_bd_pins axi_interconnect_0/M38_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins converter_1/S_AXI_ARESETN] [get_bd_pins converter_2/S_AXI_ARESETN] [get_bd_pins da_converter/S_AXI_ARESETN] [get_bd_pins emu_dc_0/emu_dc_aresetn] [get_bd_pins encoder_interface/S_AXI_ARESETN] [get_bd_pins multiplexer_0/s_axi_aresetn] [get_bd_pins register_emu_input/S_AXI_ARESETN] [get_bd_pins register_emu_out/S_AXI_ARESETN] [get_bd_pins register_mux_out/S_AXI_ARESETN] [get_bd_pins relay/S_AXI_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins signal_in/s_axi_aresetn] [get_bd_pins testled/s_axi_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net signal_in_gpio2_io_o [get_bd_ports SIG_R_PU] [get_bd_pins signal_in/gpio2_io_i] [get_bd_pins signal_in/gpio2_io_o]
  connect_bd_net -net signalinverter_Res [get_bd_pins signal_in/gpio_io_i] [get_bd_pins signalinverter/Res]
  connect_bd_net -net testled_gpio_io_o [get_bd_ports TEST] [get_bd_pins testled/gpio_io_o]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins bidir_io_port_0/p_tri_buf_t] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins ENDAT22_S_1/nstr] [get_bd_pins c_shift_ram_0/CE] [get_bd_pins c_shift_ram_1/CE] [get_bd_pins c_shift_ram_2/CE] [get_bd_pins emu_dc_0/theta_sync_sampl] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net xadc_wiz_0_muxaddr_out [get_bd_pins xadc_wiz_0/muxaddr_out] [get_bd_pins xadcmuxslice/Din]
  connect_bd_net -net xadc_wiz_0_user_temp_alarm_out [get_bd_ports LED_ALARM] [get_bd_pins xadc_wiz_0/user_temp_alarm_out]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins encoder_interface/ENCODER_ERR] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_10_dout [get_bd_pins array_resize_4/array_in] [get_bd_pins xlconcat_10/dout]
  connect_bd_net -net xlconcat_11_dout [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_11/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins multiplexer_0/adc_conv] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins c_shift_ram_2/D] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins array_resize_2/array_in] [get_bd_pins xlconcat_4/dout]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins array_resize_0/array_in] [get_bd_pins xlconcat_5/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins array_resize_3/array_in] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins array_resize_1/array_in] [get_bd_pins xlconcat_7/dout]
  connect_bd_net -net xlconcat_8_dout [get_bd_pins c_shift_ram_0/D] [get_bd_pins xlconcat_8/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports LVCT_OE_N] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins da_converter/signal_in_new] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins converter_1/watchdog_exp_in] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins bidir_io_port_0/p_tri_buf_o] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins multiplexer_0/GND] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins ENDAT22_S_1/AHB_DEN100] [get_bd_pins ENDAT22_S_1/n_int6] [get_bd_pins ENDAT22_S_1/n_int7] [get_bd_pins ENDAT22_S_1/n_rs] [get_bd_pins xlconstant_6/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports XADC_MUX] [get_bd_pins xadcmuxslice/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/AD_filter_block/S_AXI/reg0] SEG_AD_filter_block_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/AD_filter_block/S_AXI/reg0] SEG_AD_filter_block_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43D10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/CurrentRef/S_AXI/reg0] SEG_CurrentRef_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/CurrentRef/S_AXI/reg0] SEG_CurrentRef_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43E00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ENDAT22_S_1/APB_S/endat22_apb_s] SEG_ENDAT22_S_0_endat22_apb_s
  create_bd_addr_seg -range 0x00010000 -offset 0x43D50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/Hysteresis_control/S_AXI/reg0] SEG_Hysteresis_control_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43CD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/Hysteresis_control/S_AXI/reg0] SEG_Hysteresis_control_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/Moving_integral/S_AXI/reg0] SEG_Moving_integral_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43D90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/Tripping/S_AXI/reg0] SEG_Tripping_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43DA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/Tripping/S_AXI/reg0] SEG_Tripping_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43D30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/Moving_integral/S_AXI/reg0] SEG_accumulator_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ad_converter/S_AXI/reg0] SEG_ad_converter_serial_receiver_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs testled/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs signal_in/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41230000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x43D70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/blankingtimecorr_0/blankingtimecorr_s_axi/reg0] SEG_blankingtimecorr_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43D80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/blankingtimecorr_0/blankingtimecorr_s_axi/reg0] SEG_blankingtimecorr_0_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs da_converter/S_AXI/reg0] SEG_da_converter_interface_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/driver_interface/S_AXI/reg0] SEG_driver_interface_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/driver_interface/S_AXI/reg0] SEG_driver_interface_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43DC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs emu_dc_0/emu_dc_s_axi/reg0] SEG_emu_dc_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs encoder_interface/S_AXI/reg0] SEG_incremental_encoder_interface_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43D40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/moving_integral_reg/S_AXI/reg0] SEG_moving_integral_reg_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43CC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/moving_integral_reg/S_AXI/reg0] SEG_moving_integral_reg_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43DB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs multiplexer_0/S_AXI/S_AXI_reg] SEG_multiplexer_0_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43D60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/pwm/S_AXI/reg0] SEG_pwm_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43CE0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/pwm/S_AXI/reg0] SEG_pwm_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43DD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs register_emu_out/S_AXI/reg0] SEG_register_array_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43DE0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs register_mux_out/S_AXI/reg0] SEG_register_array_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43DF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs register_emu_input/S_AXI/reg0] SEG_register_emu_input_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43D00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs relay/S_AXI/reg0] SEG_relay_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43D20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/switching_event_counter/S_AXI/reg0] SEG_switching_event_counter_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/switching_event_counter/S_AXI/reg0] SEG_switching_event_counter_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_2/synch_sampling_reg/S_AXI/reg0] SEG_synch_sampling_reg_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43CF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs converter_1/synch_sampling_reg/S_AXI/reg0] SEG_synch_sampling_reg_reg01
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


