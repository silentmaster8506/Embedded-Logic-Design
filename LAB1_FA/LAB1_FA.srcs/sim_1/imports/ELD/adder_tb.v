`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2022 16:31:23
// Design Name: 
// Module Name: adder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for Unsigned 4-bit Adder with Overflow
// 
// Dependencies: top_adder
// 
// Revision:
// Revision 0.02 - Updated for overflow output
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_tb;  
    reg  [3:0] InA ,InB;
    wire [3:0] OutSum;
    wire Overflow;   
    top_adder tb0(
        .InA(InA), 
        .InB(InB), 
        .OutSum(OutSum), 
        .Overflow(Overflow)
    );  
    initial begin
        // Test cases
        InA = 4'b0000; InB = 4'b0000;  // 0 + 0 = 0, Overflow = 0
        #5 InA = 4'b0100; InB = 4'b0110; // 4 + 6 = 10, Overflow = 0
        #5 InA = 4'b0101; InB = 4'b0111; // 5 + 7 = 12, Overflow = 0
        #5 InA = 4'b0111; InB = 4'b0111; // 7 + 7 = 14, Overflow = 0
        #5 InA = 4'b1111; InB = 4'b0000; // 15 + 0 = 15, Overflow = 0
        #5 InA = 4'b0111; InB = 4'b0001; // 7 + 1 = 8, Overflow = 0
        #5 InA = 4'b1111; InB = 4'b0001; // 15 + 1 = 0, Overflow = 1
        #5 InA = 4'b1111; InB = 4'b1111; // 15 + 15 = 14 (carry out), Overflow = 1
    end
endmodule
