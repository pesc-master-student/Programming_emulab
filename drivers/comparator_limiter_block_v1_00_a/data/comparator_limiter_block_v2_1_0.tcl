##############################################################################
## Filename:          J:\DOK\12\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/komparator_begrenser_blokk_v1_00_a/data/komparator_begrenser_blokk_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue Oct 13 09:21:51 2009 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "comparator_limiter_block" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "WIDTH_IN" "WIDTH_OUT" "NUMBER_OF_CHANNELS" "NUMBER_OF_COMPARATORS" "FLIPFLOP_DEFAULT_VALUE" "COMPARATOR_FUNCTION_GREATER_THAN" "COMPARATOR_FUNCTION_LESS_THAN" "COMPARATOR_FUNCTION_EQUAL" "REGISTER_SET_MASK" "REGISTER_CLEAR_MASK" "READ_CLIPPED_SIGNALS" "READ_REFERENCES" "REFERENCE_SELECTOR" "SEPARATE_REFERENCES"}
