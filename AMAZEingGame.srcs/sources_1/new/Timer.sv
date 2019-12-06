`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 08:53:18 PM
// Design Name: 
// Module Name: Timer
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


module Timer(
    input clk,
    input timeStart,
    input reset,
    output [13:0] curTime
    );
    
    logic sclk;
    // to generate a clock cycle 
    ClockDivider #(50000000) clockDivider(.clk(clk), .sclk(sclk)); 
    
    Accumulator accum(.clk(sclk), .LD(timeStart), .CLR(reset), .D(1), .Q(curTime));
    
endmodule
