`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2025 09:45:40 AM
// Design Name: 
// Module Name: testbench
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


module testbench(
    );
    reg clk_1hz=0;
    reg reset=1;
    wire [7:0] count;
    counter_8bit c1(.clk_1hz(clk_1hz), .reset(reset), .count(count));
    always
    #5 clk_1hz=~clk_1hz;
    initial
    begin
    reset=1;
    #50 reset=0;
    #1000 $stop;
    end
endmodule
