proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "emu_dc" "NUM_INSTANCES" "DEVICE_ID" "C_EMU_DC_S_AXI_BASEADDR" "C_EMU_DC_S_AXI_HIGHADDR" 
    xdefine_config_file $drv_handle "emu_dc_g.c" "emu_dc" "DEVICE_ID" "C_EMU_DC_S_AXI_BASEADDR" 
    xdefine_canonical_xpars $drv_handle "xparameters.h" "emu_dc" "DEVICE_ID" "C_EMU_DC_S_AXI_BASEADDR" "C_EMU_DC_S_AXI_HIGHADDR" 

}