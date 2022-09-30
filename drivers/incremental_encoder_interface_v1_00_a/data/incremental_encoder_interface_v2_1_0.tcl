##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/incremental_encoder_interface_v1_00_a/data/incremental_encoder_interface_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Thu Jan 31 11:11:29 2008 (by Create and Import Peripheral Wizard)
##############################################################################
#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "incremental_encoder_interface" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "C_SPLB_CLK_PERIOD_PS" "EDGE_CLOCK_TIMEOUT_TIME" "CONFIG_REG_DEFAULT_VALUE" "FILTER_HYSTERESIS_DEFAULT_VALUE"
}
