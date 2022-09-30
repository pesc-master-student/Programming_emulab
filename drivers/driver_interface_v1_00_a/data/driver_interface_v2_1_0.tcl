##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/vekselretter_pwm_v1_00_a/data/driver_interface_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue Feb 03 10:49:23 2009 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "driver_interface" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "NUMBER_OF_SIGNAL_SOURCES" "SEPARATE_SIGNALS_FOR_LOWER_DRIVERS" "CONFIG_REG_DEFAULT_VALUE" "SIGNAL_SOURCE_REG_DEFAULT_VALUE"  "USE_WATCHDOG_TIMER" "PILOT_SIGNAL_BITNR" "NUMBER_OF_DISABLE_IN_SIGNALS"
  }
  