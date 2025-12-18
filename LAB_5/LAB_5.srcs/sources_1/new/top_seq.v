`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2025 09:21:21 AM
// Design Name: 
// Module Name: top_seq
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


module top_seq(
    input clk_100m,
    input clr,
    input inp_0,
    input inp_1,
    output detect,
    output [2:0] fsm_state
);
    wire clk_8m;
    wire clk_1hz;
    wire clk_pb;

    clk_wiz_0 t3(
        .clk_100m(clk_100m),
        .clk_8m(clk_8m)
    );

    clk_div_rtl t1(.clk_8m(clk_8m), .clk_1hz(clk_1hz));

    pb_clk t2(.clk_1hz(clk_1hz),.inp_0(inp_0),.inp_1(inp_1),.clk_pb(clk_pb));

    fsm_1111 t4(.clk_pb(clk_pb),.clr(clr),.inp_1(inp_1),.detect(detect),.fsm_state(fsm_state));

endmodule


