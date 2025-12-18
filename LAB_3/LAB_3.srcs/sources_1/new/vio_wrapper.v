`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 10:26:05 AM
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
    wire [3:0] count; // extremely imp to define because output will become 1 bit o/w.
    vio_0 T2 (
  .clk(clk_100m),                // input wire clk
  .probe_in0(count),    // input wire [7 : 0] probe_in0
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);
    top_counter T1(.clk_100m(clk_100m),.reset(reset),.count(count));
    
endmodule
