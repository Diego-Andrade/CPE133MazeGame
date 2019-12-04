`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 03:55:54 PM
// Design Name: 
// Module Name: MazeTop
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

module MazeTop(
    input CLK,
    input [12:0] WA,
    input r,
    input g,
    input b,
//    input [7:0] WD,
    input WE,
    output [7:0] VGA_RGB,
    output VGA_HS,
    output VGA_VS
    );
    
    Pixel p;
    
    logic [2:0] red;
    logic [2:0] green;
    logic [1:0] blue;
    
    // Divide clock by 2
    logic CLK_50MHz = 0;
    always_ff @(posedge CLK) begin
        CLK_50MHz <= ~CLK_50MHz;
    end
    
    Maze1Drawer maze1Drawer(.CLK_50MHz(CLK_50MHz), .reset(1), .pixel(p));
    
    // Display out
    vga_fb_driver_80x60 vga_out( 
        .CLK_50MHz (CLK_50MHz),
        .WA(p.WA),
//        .WD({r, 2'b00, g, 2'b00, b, 1'b0}),
        .WD(p.Colour),
        .WE(WE),
        .ROUT(red),
        .GOUT(green),
        .BOUT(blue),
        .HS(VGA_HS),
        .VS(VGA_VS));
        
        assign VGA_RGB = {red, green, blue};
    
endmodule
