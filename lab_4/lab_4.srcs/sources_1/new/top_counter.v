`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2025 10:30:43 AM
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
    output [5:0] sec_count,
    output [5:0] min_count
    );
    wire clk_8m, clk_1hz;
      clk_wiz_0 c3
   (
    // Clock out ports
    .clk_8m(clk_8m),     // output clk_8m
   // Clock in ports
    .clk_100m(clk_100m));
    
    clk_div_rtl c2(.clk_8m(clk_8m),.clk_1hz(clk_1hz));
    
    dig_clk c1(.clk_1hz(clk_1hz), .reset(reset), .sec_count(sec_count), .min_count(min_count));
    
    
endmodule

