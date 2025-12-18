`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2022 16:15:12
// Design Name: 
// Module Name: top_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Unsigned 4-bit Adder with Overflow (Carry-out) Detection
// 
// Dependencies: full_adder_1bit
// 
// Revision:
// Revision 0.02 - Added overflow output for unsigned addition
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_adder(
    input  [3:0] InA,
    input  [3:0] InB,
    output [3:0] OutSum,
    output Overflow   // carry out of MSB
    );
    
    wire carry1 , carry2, carry3;
    
    full_adder_1bit in0(.FA1_InA(InA[0]) , .FA1_InB(InB[0]) , .FA1_InC(1'b0) , .FA1_OutSum(OutSum[0]) , .FA1_OutC(carry1));
    full_adder_1bit in1(.FA1_InA(InA[1]) , .FA1_InB(InB[1]) , .FA1_InC(carry1) , .FA1_OutSum(OutSum[1]) , .FA1_OutC(carry2));
    full_adder_1bit in2(.FA1_InA(InA[2]) , .FA1_InB(InB[2]) , .FA1_InC(carry2) , .FA1_OutSum(OutSum[2]) , .FA1_OutC(carry3));
    full_adder_1bit in3(.FA1_InA(InA[3]) , .FA1_InB(InB[3]) , .FA1_InC(carry3) , .FA1_OutSum(OutSum[3]) , .FA1_OutC(Overflow));

endmodule
