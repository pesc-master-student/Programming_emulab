##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/filter_block_v1_00_a/data/filter_block_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Thu Feb 28 13:46:04 2013 
##############################################################################
#uses "xillib.tcl"

proc generate {drv_handle} {
 
  xdefine_include_file $drv_handle "xparameters.h" "filter_block" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "OPERATION_MODE" "NUMBER_OF_CHANNELS" "SIGNAL_IN_WIDTH" "SIGNAL_OUT_WIDTH" "MULTIPLIER_WIDTH" "ACCUMULATOR_ADDITIONAL_BITS" "INPUT_FRACTIONAL_BITS" "INPUT_SOURCE_CONFIG" "SCALING" "COMMON_PARAMETERS" "ACCUMULATOR_WRITE"
} 
