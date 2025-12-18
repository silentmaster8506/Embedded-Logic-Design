`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2025 09:22:07 AM
// Design Name: 
// Module Name: fsm_1111
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


module fsm_1111(
input clk_pb,
input clr,
input inp_1,
output reg detect,
output [2:0] fsm_state
    );
    parameter s0=3'b000, s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100;
    reg[2:0] present_state=s0;
    reg[2:0]next_state;
always@(posedge clk_pb or posedge clr)
begin
if(clr)
present_state<=s0;
else
present_state<=next_state;
end
always@(*)
begin
case(present_state)
s0:if(inp_1==1)
    next_state=s1;
    else
    next_state=s0;
s1:if(inp_1==1)
    next_state=s2;
    else
    next_state=s0;
s2:if(inp_1==1)
    next_state=s3;
    else
    next_state=s0;
s3:if(inp_1==1)
    next_state=s4;
    else
    next_state=s0;
s4:if(inp_1==1)
    next_state=s4;
    else
    next_state=s0;
default:next_state=s0;
endcase
end
always@(*)
begin
if(present_state==s4)
detect=1;
else
detect=0;
end
assign fsm_state=present_state;
endmodule
