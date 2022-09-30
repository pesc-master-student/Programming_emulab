##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/da_converter_interface_v1_00_a/data/da_converter_interface_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Thu Jan 31 16:33:46 2008 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"
proc generate {drv_handle} {  
	xdefine_include_file $drv_handle "xparameters.h" "da_converter_interface" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "NUMBER_OF_SIGNAL_SOURCES" "WIDTH_IN" "USE_SCALING" "SCALE_SHIFTS" "CONFIG_REG_DEFAULT_VALUE" "CLOCK_PULSES_CS_LOW" "DA_CONVERTER_WIDTH" "NUMBER_OF_CHANNELS" 

}
