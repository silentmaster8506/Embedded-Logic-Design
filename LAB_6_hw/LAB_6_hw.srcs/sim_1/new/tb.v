`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 10:18:56 PM
// Design Name: 
// Module Name: tb
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


module tb();
    reg Clk_100M, INPUT_1_VALID, INPUT_2_VALID, OUTPUT_READY;
    reg [31:0] INPUT_1_DATA, INPUT_2_DATA;
    wire OUTPUT_VALID, INPUT_1_READY, INPUT_2_READY;
    wire [31:0] OUTPUT_DATA;

    top t1(
        .Clk_100M(Clk_100M),
        .INPUT_1_VALID(INPUT_1_VALID),
        .INPUT_1_READY(INPUT_1_READY),
        .INPUT_1_DATA(INPUT_1_DATA),
        .INPUT_2_VALID(INPUT_2_VALID),
        .INPUT_2_READY(INPUT_2_READY),
        .INPUT_2_DATA(INPUT_2_DATA),
        .OUTPUT_VALID(OUTPUT_VALID),
        .OUTPUT_READY(OUTPUT_READY),
        .OUTPUT_DATA(OUTPUT_DATA)
    );

    initial begin
        Clk_100M = 0;
        INPUT_1_VALID = 0;
        INPUT_2_VALID = 0;
        INPUT_1_DATA = 0;
        INPUT_2_DATA = 0;
        OUTPUT_READY = 1;
    end

    always #5 Clk_100M = ~Clk_100M;

    initial begin
        // first test case
        INPUT_1_DATA = 32'b01000000101000000000000000000000;
        INPUT_2_DATA = 32'b01000000101000000000000000000000;
        INPUT_1_VALID = 1;
        INPUT_2_VALID = 1;
        OUTPUT_READY = 1;

        while ((INPUT_1_READY == 0) || (INPUT_2_READY == 0)) begin
            INPUT_1_VALID = 1;
            INPUT_2_VALID = 1;
        end

        #5 INPUT_1_VALID = 0;
        #5 INPUT_2_VALID = 0;

        @(posedge OUTPUT_VALID);
        //#5 OUTPUT_READY = 1;

        // second test case
        #50;
        INPUT_1_DATA = 32'b01000001110010000000000000000000;
        INPUT_2_DATA = 32'b01000001110010000000000000000000;
        INPUT_1_VALID = 1;
        INPUT_2_VALID = 1;
        OUTPUT_READY = 1;

        while ((INPUT_1_READY == 0) || (INPUT_2_READY == 0)) begin
            INPUT_1_VALID = 1;
            INPUT_2_VALID = 1;
        end

        #5 INPUT_1_VALID = 0;
        #5 INPUT_2_VALID = 0;

        @(posedge OUTPUT_VALID);
        #20 $stop;
    end

endmodule

