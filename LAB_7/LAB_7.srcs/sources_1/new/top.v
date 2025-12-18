`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 06:24:05 PM
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
    input aclk,
    input aresetn,
    input [7:0] s_axis_config_tdata,
    input s_axis_config_tvalid,
    output s_axis_config_tready,

    input [63:0] s_axis_data_tdata,
    input s_axis_data_tvalid,
    output s_axis_data_tready,
    input s_axis_data_tlast,

    output [63:0] m_axis_data_tdata,
    output m_axis_data_tvalid,
    input m_axis_data_tready,
    output m_axis_data_tlast
);

    
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
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_data_tready(m_axis_data_tready),
        .m_axis_data_tlast(m_axis_data_tlast)
    );

endmodule
