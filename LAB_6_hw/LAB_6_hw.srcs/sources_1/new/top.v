`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 10:18:35 PM
// Design Name: 
// Module Name: top
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

module top(
    input Clk_100M,
    input INPUT_2_VALID, INPUT_1_VALID, OUTPUT_READY,
    output INPUT_1_READY, INPUT_2_READY, OUTPUT_VALID,
    input [31:0] INPUT_1_DATA, INPUT_2_DATA,
    output [31:0] OUTPUT_DATA
);

    wire sqrt_ready, log_ready, recip_ready, add1_ready;
    wire sqrt_valid, log_valid, recip_valid, add1_valid;
    wire const_ready;

    wire [31:0] sqrt_out, log_out, recip_out, add1_out;

    fp_sqrt a1(
        .aclk(Clk_100M),
        .s_axis_a_tvalid(INPUT_1_VALID),
        .s_axis_a_tready(INPUT_1_READY),
        .s_axis_a_tdata(INPUT_1_DATA),
        .m_axis_result_tvalid(sqrt_valid),
        .m_axis_result_tready(sqrt_ready),
        .m_axis_result_tdata(sqrt_out)
    );

    fp_log a2(
        .aclk(Clk_100M),
        .s_axis_a_tvalid(INPUT_2_VALID),
        .s_axis_a_tready(INPUT_2_READY),
        .s_axis_a_tdata(INPUT_2_DATA),
        .m_axis_result_tvalid(log_valid),
        .m_axis_result_tready(log_ready),
        .m_axis_result_tdata(log_out)
    );

    fp_rec a3(
        .aclk(Clk_100M),
        .s_axis_a_tvalid(log_valid),
        .s_axis_a_tready(log_ready),
        .s_axis_a_tdata(log_out),
        .m_axis_result_tvalid(recip_valid),
        .m_axis_result_tready(recip_ready),
        .m_axis_result_tdata(recip_out)
    );

    fp_add1p a4(
        .aclk(Clk_100M),
        .s_axis_a_tvalid(sqrt_valid),
        .s_axis_a_tready(sqrt_ready),
        .s_axis_a_tdata(sqrt_out),
        .s_axis_b_tvalid(1'b1),
        .s_axis_b_tready(const_ready),
        .s_axis_b_tdata(32'b00111111110000000000000000000000),
        .m_axis_result_tvalid(add1_valid),
        .m_axis_result_tready(add1_ready),
        .m_axis_result_tdata(add1_out)
    );

    fp_add a5(
        .aclk(Clk_100M),
        .s_axis_a_tvalid(add1_valid),
        .s_axis_a_tready(add1_ready),
        .s_axis_a_tdata(add1_out),
        .s_axis_b_tvalid(recip_valid),
        .s_axis_b_tready(recip_ready),
        .s_axis_b_tdata(recip_out),
        .m_axis_result_tvalid(OUTPUT_VALID),
        .m_axis_result_tready(OUTPUT_READY),
        .m_axis_result_tdata(OUTPUT_DATA)
    );

endmodule

