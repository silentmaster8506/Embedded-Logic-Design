`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2025 10:34:58 AM
// Design Name: 
// Module Name: vio_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vio_wrapper(
    input clk_100m
    );
    wire reset;
    wire [5:0] min_count;
    wire [5:0] sec_count; // extremely imp to define because output will become 1 bit o/w.
    vio_0 T2 (
  .clk(clk_100m),                // input wire clk
  .probe_in0(sec_count),
  .probe_in1(min_count),    // input wire [7 : 0] probe_in0
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);
    top_counter T1(.clk_100m(clk_100m),.reset(reset),.sec_count(sec_count), .min_count(min_count));
    
endmodule
