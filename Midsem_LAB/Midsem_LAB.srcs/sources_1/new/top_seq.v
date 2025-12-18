`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 10:10:32 AM
// Design Name: 
// Module Name: top_seq
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


module top_seq(
    input clk_100m,
    input reset,
    input p,            
    output [5:0]count
);
    wire clk_6m, clk_6hz;

    clk_wiz_0 c1(
        .clk_100m(clk_100m),
        .clk_6m(clk_6m)
    );

    clk_div_rtl c2(
        .clk_6m(clk_6m),
        .clk_6hz(clk_6hz)
    );

    seq c3(
        .clk_6hz(clk_6hz),
        .reset(reset),
        .p(p),
        .count(count)
    );
endmodule
