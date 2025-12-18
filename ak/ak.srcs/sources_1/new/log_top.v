`timescale 1ns / 1ps

module log_top(
    input clk,
    input [31:0] y,
    input y_val,
    output y_ready,
    input [31:0] x,
    input x_val,
    output x_ready,
    input [31:0] c,  
    output [31:0] z_data,
    output z_valid,
    input z_ready
);

    // Signals between IPs
    wire mv_log, mv_inv, mv_sqrt, mv_add1, mv_add2;
    wire mr_log, mr_inv, mr_sqrt, mr_add1, mr_add2;
    wire [31:0] md_log, md_inv, sqrt_x, sum1, sum2;
    wire aclk = clk;

    // Logarithmic IP instance (logarithm of y)
    floating_point_0 log_inst (
      .aclk(aclk),                                  // input wire aclk
      .s_axis_a_tvalid(y_val),                      // input wire s_axis_a_tvalid
      .s_axis_a_tready(y_ready),                    // output wire s_axis_a_tready
      .s_axis_a_tdata(y),                           // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(mv_log),                // output wire m_axis_result_tvalid
      .m_axis_result_tready(mr_log),                // input wire m_axis_result_tready
      .m_axis_result_tdata(md_log)                  // output wire [31 : 0] m_axis_result_tdata
    );

    // Reciprocal IP instance (1 / log(y))
    floating_point_inverse inv_inst (
      .aclk(aclk),                                  // input wire aclk
      .s_axis_a_tvalid(mv_log),                     // input wire s_axis_a_tvalid
      .s_axis_a_tready(mr_log),                     // output wire s_axis_a_tready
      .s_axis_a_tdata(md_log),                      // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(mv_inv),                // output wire m_axis_result_tvalid
      .m_axis_result_tready(mr_inv),                // input wire m_axis_result_tready
      .m_axis_result_tdata(md_inv)                  // output wire [31 : 0] m_axis_result_tdata
    );

    // Square Root IP instance (sqrt(x))
    floating_point_root sqrt_inst (
      .aclk(aclk),                                  // input wire aclk
      .s_axis_a_tvalid(x_val),                      // input wire s_axis_a_tvalid
      .s_axis_a_tready(x_ready),                    // output wire s_axis_a_tready
      .s_axis_a_tdata(x),                           // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(mv_sqrt),               // output wire m_axis_result_tvalid
      .m_axis_result_tready(mr_sqrt),               // input wire m_axis_result_tready
      .m_axis_result_tdata(sqrt_x)                  // output wire [31 : 0] m_axis_result_tdata
    );

    // Floating-point adder for sum1 = sqrt(x) + 1/log(y)
    floating_point_adder add1_inst (
      .aclk(aclk),                                  // input wire aclk
      .s_axis_a_tvalid(mv_sqrt),                    // input wire s_axis_a_tvalid
      .s_axis_a_tready(mr_sqrt),                    // output wire s_axis_a_tready
      .s_axis_a_tdata(sqrt_x),                      // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(mv_inv),                     // input wire s_axis_b_tvalid
      .s_axis_b_tready(mr_inv),                     // output wire s_axis_b_tready
      .s_axis_b_tdata(md_inv),                      // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(mv_add1),               // output wire m_axis_result_tvalid
      .m_axis_result_tready(mr_add1),               // input wire m_axis_result_tready
      .m_axis_result_tdata(sum1)                    // output wire [31 : 0] m_axis_result_tdata
    );

    // Floating-point adder for sum2 = sum1 + c
    floating_point_adder add2_inst (
      .aclk(aclk),                                  // input wire aclk
      .s_axis_a_tvalid(mv_add1),                    // input wire s_axis_a_tvalid
      .s_axis_a_tready(mr_add1),                    // output wire s_axis_a_tready
      .s_axis_a_tdata(sum1),                        // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(1'b1),                       // input wire s_axis_b_tvalid (constant is always valid)
      .s_axis_b_tready(mr_add2),                    // output wire s_axis_b_tready
      .s_axis_b_tdata(c),                           // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(mv_add2),               // output wire m_axis_result_tvalid
      .m_axis_result_tready(mr_add2),               // input wire m_axis_result_tready
      .m_axis_result_tdata(z_data)                  // output wire [31 : 0] z_data
    );

    assign z_valid = mv_add2;  // Output z_valid when result is valid

endmodule
