`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 10:07:44 PM
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
    input  wire aclk,
    input  wire aresetn,

    input  wire [7:0] s_axis_config_tdata,
    input  wire s_axis_config_tvalid,
    output wire s_axis_config_tready,

    input  wire [63:0]s_axis_data_tdata,
    input  wire s_axis_data_tvalid,
    output wire s_axis_data_tready,
    input  wire s_axis_data_tlast,

    output wire [63:0]m_axis_data_tdata,
    output wire m_axis_data_tvalid,
    input  wire m_axis_data_tready,
    output wire m_axis_data_tlast
);

    wire [63:0] fft_out_tdata;
    wire fft_out_tvalid;
    wire fft_out_tready;
    wire fft_out_tlast;

    xfft_0 a0(
        .aclk(aclk),
        .aresetn(aresetn),

        .s_axis_config_tdata(s_axis_config_tdata),
        .s_axis_config_tvalid(s_axis_config_tvalid),
        .s_axis_config_tready(s_axis_config_tready),

        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tvalid(s_axis_data_tvalid),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tlast(s_axis_data_tlast),

        .m_axis_data_tdata(fft_out_tdata),
        .m_axis_data_tvalid(fft_out_tvalid),
        .m_axis_data_tready(fft_out_tready),
        .m_axis_data_tlast(fft_out_tlast)
    );

 
    wire [31:0] width_m_tdata;
    wire width_m_tvalid;
    wire width_m_tready;
    wire width_m_tlast;

    splitter a1(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(fft_out_tdata),
        .s_axis_tvalid(fft_out_tvalid),
        .s_axis_tready(fft_out_tready),
        .s_axis_tlast(fft_out_tlast),

        .m_axis_tdata(width_m_tdata),
        .m_axis_tvalid(width_m_tvalid),
        .m_axis_tready(width_m_tready),
        .m_axis_tlast(width_m_tlast)
    );

    wire [31:0] adder_result_tdata;
    wire adder_result_tvalid;
    wire adder_result_tready;
    wire adder_result_tlast;

    adder a2(
        .aclk(aclk),
        .s_axis_a_tvalid(width_m_tvalid),
        .s_axis_a_tready(width_m_tready),
        .s_axis_a_tdata(width_m_tdata),
        .s_axis_a_tlast(width_m_tlast),

        .s_axis_b_tvalid(1'b1),
        .s_axis_b_tdata(32'h3FC00000),  
        .s_axis_b_tready(),
        .s_axis_b_tlast(),

        .m_axis_result_tvalid(adder_result_tvalid),
        .m_axis_result_tready(adder_result_tready),
        .m_axis_result_tdata(adder_result_tdata),
        .m_axis_result_tlast(adder_result_tlast)
    );

    reg [63:0] data_buffer;
    reg [1:0]  count;
    reg output_valid;
    reg output_last;

    assign adder_result_tready=1'b1;

    always @(posedge aclk) begin
        if (!aresetn) begin
            data_buffer <=64'd0;
            count <=0;
            output_valid <=0;
            output_last <=0;
        end else begin
            if (adder_result_tvalid) begin
                if (count==0)
                    data_buffer[63:32] <= adder_result_tdata;  // Real
                else begin
                    data_buffer[31:0] <= adder_result_tdata;   // Imag
                    output_valid <=1'b1;
                    output_last <=adder_result_tlast;
                end
                count <= count+1;
            end
            if (m_axis_data_tready && output_valid)
                output_valid <= 0;
        end
    end

    assign m_axis_data_tdata  =data_buffer;
    assign m_axis_data_tvalid =output_valid;
    assign m_axis_data_tlast  =output_last;

endmodule

