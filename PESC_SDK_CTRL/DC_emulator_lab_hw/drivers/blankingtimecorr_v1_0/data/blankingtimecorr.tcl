proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "blankingtimecorr" "NUM_INSTANCES" "DEVICE_ID" "C_BLANKINGTIMECORR_S_AXI_BASEADDR" "C_BLANKINGTIMECORR_S_AXI_HIGHADDR" 
    xdefine_config_file $drv_handle "blankingtimecorr_g.c" "blankingtimecorr" "DEVICE_ID" "C_BLANKINGTIMECORR_S_AXI_BASEADDR" 
    xdefine_canonical_xpars $drv_handle "xparameters.h" "blankingtimecorr" "DEVICE_ID" "C_BLANKINGTIMECORR_S_AXI_BASEADDR" "C_BLANKINGTIMECORR_S_AXI_HIGHADDR" 

}