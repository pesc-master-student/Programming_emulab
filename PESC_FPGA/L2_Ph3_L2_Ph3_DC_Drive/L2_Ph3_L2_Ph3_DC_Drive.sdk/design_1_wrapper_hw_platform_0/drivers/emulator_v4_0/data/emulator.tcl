proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "emulator" "NUM_INSTANCES" "DEVICE_ID" "C_EMULATOR_S_AXI_BASEADDR" "C_EMULATOR_S_AXI_HIGHADDR" 
    xdefine_config_file $drv_handle "emulator_g.c" "emulator" "DEVICE_ID" "C_EMULATOR_S_AXI_BASEADDR" 
    xdefine_canonical_xpars $drv_handle "xparameters.h" "emulator" "DEVICE_ID" "C_EMULATOR_S_AXI_BASEADDR" "C_EMULATOR_S_AXI_HIGHADDR" 

}