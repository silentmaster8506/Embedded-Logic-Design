`timescale 1ns / 1ps
module fft_tb();

    reg clock, resetn, c_valid, ffti_valid, ffti_last, ffto_ready;
    reg [7:0] c_data;
    reg [63:0] ffti_data;
    wire c_ready, ffti_ready, ffto_valid, ffto_last;
    wire [63:0] ffto_data;
top a1(
        .aclk(clock),
        .aresetn(resetn),
        .s_axis_config_tdata(c_data),
        .s_axis_config_tvalid(c_valid),
        .s_axis_config_tready(c_ready),
        .s_axis_data_tdata(ffti_data),
        .s_axis_data_tvalid(ffti_valid),
        .s_axis_data_tready(ffti_ready),
        .s_axis_data_tlast(ffti_last),
        .m_axis_data_tdata(ffto_data),
        .m_axis_data_tvalid(ffto_valid),
        .m_axis_data_tready(ffto_ready),
        .m_axis_data_tlast(ffto_last)
    );

    initial begin
        clock=0;
        resetn = 0;
        c_valid = 0;
        c_data = 0;
        ffti_valid = 0;
        ffti_data = 0;
        ffti_last = 0;
        ffto_ready=1;
    end
always #5 clock=~clock;
    reg [31:0] input_data_r [15:0];
    reg [31:0] input_data_im [15:0];
    reg [31:0] output_data_r [15:0];
    reg [31:0] output_data_im [15:0];

    integer i, j;

    initial begin
        input_data_r[0] = 32'h3f800000; input_data_im[0] = 32'h00000000;
        input_data_r[1] = 32'h00000000; input_data_im[1] = 32'h00000000;
        input_data_r[2] = 32'h00000000; input_data_im[2] = 32'h00000000;
        input_data_r[3] = 32'h00000000; input_data_im[3] = 32'h00000000;
        input_data_r[4] = 32'h00000000; input_data_im[4] = 32'h00000000;
        input_data_r[5] = 32'h00000000; input_data_im[5] = 32'h00000000;
        input_data_r[6] = 32'h00000000; input_data_im[6] = 32'h00000000;
        input_data_r[7] = 32'h00000000; input_data_im[7] = 32'h00000000;
        input_data_r[8] = 32'h00000000; input_data_im[8] = 32'h00000000;
        input_data_r[9] = 32'h00000000; input_data_im[9] = 32'h00000000;
        input_data_r[10] = 32'h00000000; input_data_im[10] = 32'h00000000;
        input_data_r[11] = 32'h00000000; input_data_im[11] = 32'h00000000;
        input_data_r[12] = 32'h00000000; input_data_im[12] = 32'h00000000;
        input_data_r[13] = 32'h00000000; input_data_im[13] = 32'h00000000;
        input_data_r[14] = 32'h00000000; input_data_im[14] = 32'h00000000;
        input_data_r[15] = 32'h00000000; input_data_im[15] = 32'h00000000;
    end

   
    initial begin
        #70 resetn = 1;
        c_data = 1;        
        c_valid = 1;
        while (c_ready == 0)
            #2 c_valid=1;
        #10 c_valid = 0;
    end
 
    initial begin
        #70 for (i = 15; i >= 0; i = i - 1) begin
            #10 if (i == 0)
                ffti_last = 1;
            ffti_data = {input_data_im[i], input_data_r[i]};
            ffti_valid = 1;
            while (ffti_ready == 0)
                #2 ffti_valid=1;
            #10 ffti_valid = 0;
            ffti_last = 0;
        end
    end

    initial begin
        for (j = 15; j >= 0; j = j - 1) begin
            #5 ffto_ready = 1;
            wait(ffto_valid == 1);
            {output_data_im[j], output_data_r[j]} = ffto_data;
            #10 ffto_ready = 0;
        end
        #20 $stop;
    end   
endmodule
