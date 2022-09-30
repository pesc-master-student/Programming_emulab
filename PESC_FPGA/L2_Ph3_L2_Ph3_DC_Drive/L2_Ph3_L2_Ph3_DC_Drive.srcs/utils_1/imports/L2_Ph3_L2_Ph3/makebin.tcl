#**********************************************************************************************
# Company      : NTNU
# Date         : 02/06/2019
# Author       : Anirudh Budnar Acharya and Prof. Roy Nilsen
#
#**********************************************************************************************


write_cfgmem -force -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0x0 design_1_wrapper.bit" design_1_wrapper.bin

set scriptDir [file dirname [info script]]

set proj_name [file tail $scriptDir]

file mkdir -force ../../output
file copy -force design_1_wrapper.bin ../../output/${proj_name}_DC_DRIVE.bin
file copy -force design_1_wrapper.bit ../../output/${proj_name}_DC_DRIVE.bit

#file copy -force [glob -directory [get_property DIRECTORY [get_runs impl_1]] *sysdef] ../SDK/design_1_wrapper.hdf
