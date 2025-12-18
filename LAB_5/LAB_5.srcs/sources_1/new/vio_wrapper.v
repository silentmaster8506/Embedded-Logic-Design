`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2025 10:17:58 AM
// Design Name: 
// Module Name: vio_wrapper
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


module vio_wrapper(
    input  clk_100m
);
    wire clr;
    wire inp_0;
    wire inp_1;
    wire detect;
    wire [2:0] fsm_state;

    top_seq a1 (.clk_100m(clk_100m),.clr(clr),.inp_0(inp_0),.inp_1(inp_1),.detect(detect),.fsm_state(fsm_state));

    vio_0 a2 (
        .clk(clk_100m),
        .probe_in0(detect),
        .probe_in1(fsm_state),
        .probe_out0(clr),
        .probe_out1(inp_0),
        .probe_out2(inp_1)
    );

endmodule
