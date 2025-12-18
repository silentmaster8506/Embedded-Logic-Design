`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 09:42:58 AM
// Design Name: 
// Module Name: seq
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


module seq(
    input clk_6hz,
    input reset,
    input p,                
    output reg [5:0]count    
);
    reg [5:0] count_reg, count_next;

    always @(posedge clk_6hz or posedge reset) begin
        if (reset)
            count_reg<=5'd2;
        else if (!p)        
            count_reg<=count_next;
        else
            count_reg<=count_reg; 
    end
    always @(*) begin
        case(count_reg)
            5'd2:count_next=5'd20;
            5'd20:count_next=5'd3;
            5'd3:count_next=5'd30;
            5'd30:count_next=5'd4;
            5'd4:count_next=5'd40;
            5'd40:count_next=5'd5;
            5'd5:count_next=5'd50;
            5'd50:count_next=5'd2;
            default:count_next=5'd2;
        endcase
    end
    always @(*) begin
        count=count_reg;
    end
endmodule

