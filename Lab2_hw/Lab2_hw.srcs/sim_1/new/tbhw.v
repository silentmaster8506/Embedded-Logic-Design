`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2025 10:50:55 AM
// Design Name: 
// Module Name: tbhw
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

module tbhw();
    reg clk;
    reg reset;
    reg up;     
    wire [7:0] count;

    counter_8bit c1(
        .clk(clk),
        .reset(reset),
        .up(up),
        .count(count)
    );
    initial begin
        clk=1'b0;
    end
    always #5 clk=~clk;

    initial begin
        reset=1;
        up=1;
        #20;
        reset=0;
        
        #850;         

        up=0;
        #1000;

        up=1;
        #500;
        $stop;            
    end
endmodule

