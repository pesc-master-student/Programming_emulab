proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "testing_clk" "NUM_INSTANCES" "DEVICE_ID" "C_TESTING_CLK_S_AXI_BASEADDR" "C_TESTING_CLK_S_AXI_HIGHADDR" 
    xdefine_config_file $drv_handle "testing_clk_g.c" "testing_clk" "DEVICE_ID" "C_TESTING_CLK_S_AXI_BASEADDR" 
    xdefine_canonical_xpars $drv_handle "xparameters.h" "testing_clk" "DEVICE_ID" "C_TESTING_CLK_S_AXI_BASEADDR" "C_TESTING_CLK_S_AXI_HIGHADDR" 

}