##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/switching_event_counter_v1_00_a/data/switching_event_counter_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue May 18 09:18:38 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "switching_event_counter" "NUM_INSTANCES" "NUMBER_OF_CHANNELS" "WIDTH_OUT" "CHANNEL_NR_OUT" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
