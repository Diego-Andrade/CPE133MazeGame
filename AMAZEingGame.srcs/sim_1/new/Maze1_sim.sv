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
    logic clk = 0;
    logic reset = 1;
    logic [20:0] test = {6'h10, 7'b10, 8'b11111111};
    Pixel pixel;
    
    Maze1Drawer maze1Drawer(.CLK_50MHz(clk), .reset(reset), .pixel(pixel));

    always begin
        #5
        clk = 0;
        #5
        clk = 1;
    end
    
    initial begin
    
    end
endmodule
