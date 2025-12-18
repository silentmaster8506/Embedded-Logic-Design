`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 10:18:31 AM
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
    wire p;
    wire [5:0] count;

    vio_0 a1(
        .clk(clk_100m),
        .probe_in0(count),   
        .probe_out0(reset),
        .probe_out1(p)     
    );

    top_seq a2(
        .clk_100m(clk_100m),
        .reset(reset),
        .p(p),
        .count(count)
    );
endmodule

