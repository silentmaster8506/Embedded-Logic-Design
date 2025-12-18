`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2025 09:09:17 AM
// Design Name: 
// Module Name: clk_div_rtl
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


module clk_div_rtl(
    input clk_8m,
    output clk_1hz
    );
    reg [22:0] count_reg=0;
    reg [22:0] count_next=0;
    always @(posedge clk_8m) begin
    count_reg<=count_next;
    end
    always@(*) begin
    count_next<=count_reg+1;
    end
    assign clk_1hz=count_reg[22];
endmodule

