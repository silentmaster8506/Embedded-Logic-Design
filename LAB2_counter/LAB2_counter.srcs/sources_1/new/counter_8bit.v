`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2025 08:15:29 AM
// Design Name: 
// Module Name: counter_8bit
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


module counter_8bit(
    input clk_1hz,
    input reset,
    output reg [7:0] count
    );
    reg [7:0] count_reg=0;
    reg [7:0] count_next=0;
    
    always@(posedge clk_1hz or posedge reset)
    begin
    if(reset)
    count_reg<=8'b0;
    else
    count_reg<=count_next;
    end
    always@(*)begin
    count_next=count_reg+8'b1;
    end
    always@(*)begin
    count=count_reg;
    end
    
    
    
endmodule
