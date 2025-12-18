#If required use the below command and launch symbol server from an external shell.
#symbol_server.bat -S -s tcp::1534
connect -path [list tcp::1534 tcp:192.168.226.142:64378]
source D:/ELD_final_prac/proj_one_div_1p5_plus_fft_x_sub_1p5/proj_one_div_1p5_plus_fft_x_sub_1p5.sdk/fft_8pt_bd_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248722679"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248722679" && level==0} -index 1
fpga -file D:/ELD_final_prac/proj_one_div_1p5_plus_fft_x_sub_1p5/proj_one_div_1p5_plus_fft_x_sub_1p5.sdk/fft_8pt_bd_wrapper_hw_platform_0/fft_8pt_bd_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248722679"} -index 0
loadhw -hw D:/ELD_final_prac/proj_one_div_1p5_plus_fft_x_sub_1p5/proj_one_div_1p5_plus_fft_x_sub_1p5.sdk/fft_8pt_bd_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248722679"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248722679"} -index 0
dow D:/ELD_final_prac/proj_one_div_1p5_plus_fft_x_sub_1p5/proj_one_div_1p5_plus_fft_x_sub_1p5.sdk/gomu/Debug/gomu.elf
configparams force-mem-access 0
bpadd -addr &main
