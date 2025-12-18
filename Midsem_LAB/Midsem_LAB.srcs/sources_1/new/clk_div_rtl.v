`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 09:59:07 AM
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
    input clk_6m,
    output clk_6hz //(5.722hz) 6m/2^20
);
    reg [22:0] count_reg=0;
    reg [22:0] count_next=0;

    always @(posedge clk_6m) begin
        count_reg<=count_next;
    end
    always @(*)begin
        count_next=count_reg+1;
    end
    assign clk_6hz=count_reg[22];
endmodule
