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
    input clk,
    input enter,
    input reset,
    input u,
    input d,
    input l,
    input r,
    output [7:0] segs,
    output [3:0] an,
    output [7:0] VGA_RGB,
    output VGA_HS,
    output VGA_VS
    );
    
    // Variables for Timer
    logic tTimeStart;
    logic [13:0] curTime;
    
    // Variables for mazeDrawer
    Pixel tP1;
    logic tWE1;
    logic tComplete;
    
    logic [2:0] red;        // Helpers to store output returned from VGA_driver
    logic [2:0] green;      // ..
    logic [1:0] blue;       // ..
    
    // Divide clock by 2
    logic CLK_50MHz = 0;
    always_ff @(posedge clk) begin
        CLK_50MHz <= ~CLK_50MHz;
    end

    Maze1 MAZE1(.clk(clk), .CLK_50MHz(CLK_50MHz), .enter(enter), .reset(reset), .u(u), .d(d), .l(l), .r(r), .start(tTimeStart), .pixel(tP1), .WE(tWE1), .complete(tComplete));
    
    Timer t1(.clk(clk), .timeStart(tTimeStart), .reset(reset), .curTime(curTime));


//****** Outputs ******
    // Seven segment out
    univ_sseg sseg(.clk(clk), .cnt1(curTime), .valid(1'b1), .ssegs(segs), .disp_en(an));
    
    // Display out
    vga_fb_driver_80x60 vga_out( 
        .CLK_50MHz (CLK_50MHz),
        .WA(tP1.WA),                  // get Address from pixel
        .WD(tP1.Colour),              // get Colour from pixel
        .WE(tWE1),
        .ROUT(red),
        .GOUT(green),
        .BOUT(blue),
        .HS(VGA_HS),
        .VS(VGA_VS));
        
    assign VGA_RGB = {red, green, blue};
    
endmodule
