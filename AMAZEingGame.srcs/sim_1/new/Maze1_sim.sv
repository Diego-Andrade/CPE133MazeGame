`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 04:56:33 PM
// Design Name: 
// Module Name: Maze1_sim
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


module Maze1_sim();
    logic clk, CLK_50MHz = 0;
    logic reset;
    logic enter;

    logic u, d, l, r;
    
    logic start, complete;
    Pixel pixel;
    logic WE;
    
//    Maze1Drawer maze1Drawer(.CLK_50MHz(clk), .reset(reset), .pixel(pixel));
    Maze1 maze1(.clk(clk), .CLK_50MHz(CLK_50MHz) ,.enter(enter), .reset(reset), .u(u), .d(d), .l(l), .r(r), .start(start), .complete(complete), .pixel(pixel), .WE(WE));
    
    always begin
        clk = 0; #5
        clk = 1; #5
        CLK_50MHz = ~CLK_50MHz;
    end
    
    initial begin
        reset = 1; enter = 0; u = 0; d = 0; l = 0; r = 0;
        
        #25
        enter = 1;
        #10
        enter = 0;
        
        #50
        r = 1;
        #15
        r = 0;
        
        #10
        reset = 0;
        #5
        reset = 1;
        
    end
endmodule
