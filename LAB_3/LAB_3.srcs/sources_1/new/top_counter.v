`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 09:52:34 AM
// Design Name: 
// Module Name: top_counter
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


module top_counter(
    input clk_100m,
    input reset,
    output [3:0] count
    );
    wire clk_8m, clk_1hz;
      clk_wiz_0 c3
   (
    // Clock out ports
    .clk_8m(clk_8m),     // output clk_8m
   // Clock in ports
    .clk_100m(clk_100m));
    
    clk_div_rtl c2(.clk_8m(clk_8m),.clk_1hz(clk_1hz));
    
    counter_8bit c1(.clk_1hz(clk_1hz), .reset(reset), .count(count));
    
    
endmodule
