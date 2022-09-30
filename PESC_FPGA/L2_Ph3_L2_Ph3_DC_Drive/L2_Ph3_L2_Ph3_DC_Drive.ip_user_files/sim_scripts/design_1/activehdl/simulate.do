onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+design_1 -L xilinx_vip -L xil_defaultlib -L xpm -L ad_converter_serial_receiver_v1_00_a -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_2 -L interrupt_control_v3_1_4 -L axi_gpio_v2_0_21 -L lib_pkg_v1_0_2 -L axi_timer_v2_0_21 -L bidir_io_port_v1_00_a -L da_converter_interface_v1_00_a -L incremental_encoder_interface_v1_00_a -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L register_array_v1_00_a -L proc_sys_reset_v5_0_13 -L util_vector_logic_v2_0_1 -L xlslice_v1_0_2 -L xlconcat_v2_1_3 -L xlconstant_v1_1_6 -L filter_block_v1_00_a -L driver_interface_v1_00_a -L xbip_utils_v3_0_10 -L c_reg_fd_v12_0_6 -L c_mux_bit_v12_0_6 -L c_shift_ram_v12_0_13 -L switching_event_counter_v1_00_a -L util_reduced_logic_v2_0_4 -L comparator_limiter_block_v1_00_a -L pulse_width_modulator_v1_00_a -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_6 -L xbip_dsp48_addsub_v3_0_6 -L xbip_addsub_v3_0_6 -L c_addsub_v12_0_13 -L c_gate_bit_v12_0_6 -L xbip_counter_v3_0_6 -L c_counter_binary_v12_0_13 -L generic_baseblocks_v2_1_0 -L axi_register_slice_v2_1_19 -L fifo_generator_v13_2_4 -L axi_data_fifo_v2_1_18 -L axi_crossbar_v2_1_20 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_15 -L axi_protocol_converter_v2_1_19 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.design_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {design_1.udo}

run -all

endsim

quit -force
