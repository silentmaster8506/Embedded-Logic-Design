`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 09:31:06 AM
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
    output reg [3:0] count
    );
    reg [3:0] count_reg=0;
    reg [3:0] count_next;
    
    always@(posedge clk_1hz or posedge reset)
    begin
    if(reset)
    count_reg<=4'd15;
    else
    count_reg<=count_next;
    end
    always@(*)begin
    case(count_reg)
            4'd15:count_next=4'd8;
            4'd8:count_next=4'd13;
            4'd13:count_next=4'd4;
            4'd4:count_next=4'd15;
            default:count_next=4'd15;
        endcase
    end
    always@(*)begin
    count=count_reg;
    end 
endmodule

