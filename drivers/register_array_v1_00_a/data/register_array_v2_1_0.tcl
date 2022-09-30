##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/register_array_v1_00_a/data/register_array_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Thu Feb 28 13:46:04 2013 
##############################################################################
#uses "xillib.tcl"

proc generate {drv_handle} {
 
  xdefine_include_file $drv_handle "xparameters.h" "register_array" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "NUMBER_OF_REGISTERS" "REGISTER_WIDTH" "REG_SIGNED"
} 
