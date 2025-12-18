// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Sep 16 09:50:04 2025
// Host        : DESKTOP-85HP5LG running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/User/Desktop/ELD
//               LAB/LAB_5/LAB_5.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v}
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_8m, clk_100m)
/* synthesis syn_black_box black_box_pad_pin="clk_8m,clk_100m" */;
  output clk_8m;
  input clk_100m;
endmodule
