`timescale 1ns / 1ps

module fft_tb();

    // -------------------------------
    // Signal Declarations
    // -------------------------------
    reg clock, resetn, c_valid, ffti_valid, ffti_last, ffto_ready;
    reg [63:0] ffti_data;
    reg [7:0]  c_data;
    wire c_ready, ffti_ready, ffto_valid, ffto_last;
    wire [63:0] ffto_data;

    // Splitter monitoring signals
    wire [31:0] split_data;
    wire split_valid, split_last, split_ready;

    // -------------------------------
    // Instantiate TOP
    // -------------------------------
    top t1(
        .clock(clock),
        .resetn(resetn),
        .c_valid(c_valid),
        .c_data(c_data),
        .ffti_valid(ffti_valid),
        .ffti_last(ffti_last),
        .ffti_data(ffti_data),
        .ffto_ready(ffto_ready),
        .c_ready(c_ready),
        .ffti_ready(ffti_ready),
        .ffto_valid(ffto_valid),
        .ffto_last(ffto_last),
        .ffto_data(ffto_data)
    );

    // Tap internal splitter signals (via hierarchical reference)
    assign split_data  = t1.split_data;
    assign split_valid = t1.split_valid;
    assign split_last  = t1.split_last;
    assign split_ready = t1.split_ready;

    // -------------------------------
    // Initial Conditions
    // -------------------------------
    initial begin
        clock = 0;
        resetn = 0;
        c_valid = 0;
        c_data = 0;
        ffti_valid = 0;
        ffti_data = 0;
        ffti_last = 0;
        ffto_ready = 1;
    end

    always #5 clock = ~clock; // 100 MHz Clock

    // -------------------------------
    // Config Phase
    // -------------------------------
    initial begin
        #70 resetn = 1;
        c_data = 1;
        c_valid = 1;
        while (c_ready == 0)
            #2 c_valid = 1;
        #10 c_valid = 0;
    end

    // -------------------------------
    // FFT Input Samples
    // -------------------------------
    reg [31:0] input_data_r [7:0];
    reg [31:0] input_data_im [7:0];

    initial begin
        input_data_r[0] = 32'h3f800000; // 1.0
        input_data_im[0] = 32'h00000000;
        input_data_r[1] = 32'h00000000;
        input_data_im[1] = 32'h00000000;
        input_data_r[2] = 32'h00000000;
        input_data_im[2] = 32'h00000000;
        input_data_r[3] = 32'h00000000;
        input_data_im[3] = 32'h00000000;
        input_data_r[4] = 32'h00000000;
        input_data_im[4] = 32'h00000000;
        input_data_r[5] = 32'h00000000;
        input_data_im[5] = 32'h00000000;
        input_data_r[6] = 32'h00000000;
        input_data_im[6] = 32'h00000000;
        input_data_r[7] = 32'h00000000;
        input_data_im[7] = 32'h00000000;
    end

    // -------------------------------
    // Send FFT Input Sequence
    // -------------------------------
    integer i;
    initial begin
        #100;
        for (i = 7; i >= 0; i = i - 1) begin
            if (i == 0)
                ffti_last = 1;
            ffti_data = {input_data_im[i], input_data_r[i]};
            ffti_valid = 1;
            while (ffti_ready == 0)
                #2 ffti_valid = 1;
            #10 ffti_valid = 0;
            ffti_last = 0;
        end
    end

    // -------------------------------
    // Monitor key signals
    // -------------------------------
    initial begin
        $display("Time\tclk\tresetn\tffti_valid\tsplit_valid\tsplit_ready\tffto_valid\tffto_last");
        $monitor("%0t\t%b\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b",
                 $time, clock, resetn, ffti_valid, split_valid, split_ready, ffto_valid, ffto_last);
    end

endmodule
