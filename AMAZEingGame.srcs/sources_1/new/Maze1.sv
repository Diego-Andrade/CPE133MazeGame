`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2019 02:02:32 PM
// Design Name: 
// Module Name: Maze1
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

typedef struct packed {
    logic [12:0] WA;            // 6 row bits + 7 colm bits = rrrrrrccccccc
    logic [7:0] Colour;         // 3 red bits + 3 green bits + 2 blue bit = rrrgggbb
} Pixel;

module Maze1(
    input clk,
    input CLK_50MHz,
    input enter,
    input reset,
    input u,
    input d,
    input l,
    input r,
    output Pixel pixel,
    output WE,
    output logic start,
    output complete
    );
    
    // Temp for done drawing maze
    logic tDone = 1;        
    
    // Temporary draw variables
    logic tWE1, tWE2;
    Pixel tP1, tP2;
    
    // Player location info
    logic [5:0] tRow;
    logic [6:0] tCol;
    
    //Maze1Drawer maze1Drawer(.CLK_50MHz(CLK_50MHz), .reset(1), .pixel(tP1), .WE(tWE1), .done(tDone));    
    
    Maze1FSM maze1fsm(.clk(clk), .enter(enter), .reset(reset), .u(u), .d(d), .l(l), .r(r), .st(start), .row(tRow), .col(tCol), .done(complete));
    
    PlayerDrawer p1(.CLK_50MHz(clk), .row(tRow), .col(tCol), .p(tP2), .WE(tWE2));
    
    // Select which drawer has control of VGA output
    Mux2 #(1) weOutput(.zero(tWE1), .one(tWE2), .sel(tDone), .mux_out(WE));
    Mux2 #(21) pixelOutput(.zero(tP1), .one(tP2), .sel(tDone), .mux_out(pixel));
    
endmodule
