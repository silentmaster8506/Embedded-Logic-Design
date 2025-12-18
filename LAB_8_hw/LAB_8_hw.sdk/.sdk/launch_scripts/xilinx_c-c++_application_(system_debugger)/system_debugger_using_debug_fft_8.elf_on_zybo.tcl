#If required use the below command and launch symbol server from an external shell.
#symbol_server.bat -S -s tcp::1534
connect -path [list tcp::1534 tcp:192.168.226.142:52221]
source C:/Users/User/Desktop/ELD_LAB/LAB_8_hw/LAB_8_hw.sdk/bd_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo Z7 210351A78149A"} -index 0
loadhw -hw C:/Users/User/Desktop/ELD_LAB/LAB_8_hw/LAB_8_hw.sdk/bd_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo Z7 210351A78149A"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo Z7 210351A78149A"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo Z7 210351A78149A"} -index 0
dow C:/Users/User/Desktop/ELD_LAB/LAB_8_hw/LAB_8_hw.sdk/fft_8/Debug/fft_8.elf
configparams force-mem-access 0
bpadd -addr &main
