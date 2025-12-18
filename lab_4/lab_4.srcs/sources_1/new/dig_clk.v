`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2025 09:59:31 AM
// Design Name: 
// Module Name: dig_clk
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


module dig_clk(
input clk_1hz,
input reset,
output wire [5:0] sec_count,
output wire [5:0] min_count);

reg [5:0] sec_count_next;
reg [5:0] sec_count_reg=0;
reg [5:0] min_count_next;
reg [5:0] min_count_reg=0;

always@(posedge clk_1hz or posedge reset)
    begin
    if(reset)
    sec_count_reg<=6'd0;
    else
    sec_count_reg<=sec_count_next;
    end

always@(*)begin
    if(sec_count_reg==6'd59)
    sec_count_next=6'd0;
    else
    sec_count_next=sec_count_reg+1'b1;
end

always@(posedge clk_1hz or posedge reset) 
    begin 
    if(reset) 
        min_count_reg<=8'b0; 
    else 
        min_count_reg<=min_count_next; 
    end 
always@(*)
    begin 
    if(sec_count_reg==6'd59) 
        if(min_count_reg==6'd59) 
            min_count_next=6'd0; 
        else 
            min_count_next=min_count_reg+1'b1;
    else 
    min_count_next=min_count_reg; 
    end
assign sec_count=sec_count_reg; 
assign min_count=min_count_reg; 
endmodule
