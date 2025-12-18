// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Dec  3 13:16:34 2025
// Host        : DESKTOP-OO0S615 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/ELD_final_prac/proj_one_div_1p5_plus_fft_x_sub_1p5/proj_one_div_1p5_plus_fft_x_sub_1p5.srcs/sources_1/bd/fft_8pt_bd/ip/fft_8pt_bd_floating_point_1_0/fft_8pt_bd_floating_point_1_0_stub.v
// Design      : fft_8pt_bd_floating_point_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_8,Vivado 2019.1" *)
module fft_8pt_bd_floating_point_1_0(aclk, aresetn, s_axis_a_tvalid, 
  s_axis_a_tready, s_axis_a_tdata, s_axis_a_tlast, s_axis_b_tvalid, s_axis_b_tready, 
  s_axis_b_tdata, m_axis_result_tvalid, m_axis_result_tready, m_axis_result_tdata, 
  m_axis_result_tlast)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],s_axis_a_tlast,s_axis_b_tvalid,s_axis_b_tready,s_axis_b_tdata[31:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0],m_axis_result_tlast" */;
  input aclk;
  input aresetn;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [31:0]s_axis_b_tdata;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
  output m_axis_result_tlast;
endmodule
