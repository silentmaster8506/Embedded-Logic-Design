`timescale 1ns / 1ps

module top(
    input clock,
    input resetn,
    input c_valid,
    input [7:0] c_data,
    input ffti_valid,
    input ffti_last,
    input [63:0] ffti_data,
    input ffto_ready,
    output c_ready,
    output ffti_ready,
    output ffto_valid,
    output ffto_last,
    output [63:0] ffto_data
);

    //-------------------------------
    // FFT (8bit)
    //-------------------------------
    wire [63:0] fft_out_data;
    wire fft_out_valid, fft_out_last, fft_out_ready;

    xfft_0 a1(
        .aclk(clock),
        .aresetn(resetn),

        .s_axis_config_tdata(c_data),
        .s_axis_config_tvalid(c_valid),
        .s_axis_config_tready(c_ready),

        .s_axis_data_tdata(ffti_data),
        .s_axis_data_tvalid(ffti_valid),
        .s_axis_data_tlast(ffti_last),
        .s_axis_data_tready(ffti_ready),

        .m_axis_data_tdata(fft_out_data),
        .m_axis_data_tvalid(fft_out_valid),
        .m_axis_data_tlast(fft_out_last),
        .m_axis_data_tready(fft_out_ready)
    );

    //-------------------------------
    // Width Converter (Splitter)
    //-------------------------------
    wire [31:0] split_data;
    wire split_valid, split_last, split_ready;

    splitter a2(
        .aclk(clock),
        .aresetn(resetn),
        .s_axis_tdata(fft_out_data),
        .s_axis_tvalid(fft_out_valid),
        .s_axis_tlast(fft_out_last),
        .s_axis_tready(fft_out_ready),

        .m_axis_tdata(split_data),
        .m_axis_tvalid(split_valid),
        .m_axis_tlast(split_last),
        .m_axis_tready(split_ready)
    );

    //-------------------------------
    // Floating Point Adder (+1.5)
    //-------------------------------
    wire [31:0] add_data;
    wire add_valid, add_ready, add_last;

    adder add_real(
        .aclk(clock),
        .s_axis_a_tvalid(split_valid),
        .s_axis_a_tready(split_ready),
        .s_axis_a_tdata(split_data),
        .s_axis_a_tlast(split_last),
        .s_axis_b_tvalid(1'b1),
        .s_axis_b_tdata(32'h3FC00000), // +1.5
        .s_axis_b_tready(),
        .s_axis_b_tlast(),
        .m_axis_result_tvalid(add_valid),
        .m_axis_result_tready(1'b1),
        .m_axis_result_tdata(add_data),
        .m_axis_result_tlast(add_last)
    );

    //-------------------------------
    // Simple Logic to Recombine Real/Imag
    //-------------------------------
    reg [31:0] real_part, imag_part;
    reg valid_d, last_d;

    always @(posedge clock) begin
        if (!resetn) begin
            real_part <= 0;
            imag_part <= 0;
            valid_d <= 0;
            last_d <= 0;
        end else begin
            if (add_valid) begin
                if (!valid_d) begin
                    // First value ? real part
                    real_part <= add_data;
                    valid_d <= 1'b1;
                end else begin
                    // Second value ? imag part
                    imag_part <= add_data;
                    valid_d <= 1'b0;
                    last_d <= add_last;
                end
            end
        end
    end

    assign ffto_data  = {imag_part, real_part};
    assign ffto_valid = add_valid & ~valid_d; // valid when imag is ready
    assign ffto_last  = last_d;
    assign ffto_ready = 1'b1;

endmodule
