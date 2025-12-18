`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2025 10:11:06 AM
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
    input up,     
    output reg[7:0] count
);
    reg[7:0] count_reg=0;   
    reg[7:0] count_next=0;  

    always @(posedge clk_1hz or posedge reset) begin
        if (reset)
            count_reg<=8'b0;
        else
            count_reg<=count_next;
    end

    always @(*) begin
        if (up) begin
            if (count_reg==8'd85)
                count_next=8'd0;        
            else
                count_next=count_reg+1'b1;
        end
        else begin
            if (count_reg==8'd0)
                count_next=8'd85;        
            else
                count_next=count_reg-1'b1;
        end
    end
    always @(*) begin
        count=count_reg;
    end
endmodule

