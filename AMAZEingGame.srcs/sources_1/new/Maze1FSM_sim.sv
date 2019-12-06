`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2019 06:57:41 PM
// Design Name: 
// Module Name: Maze1FSM_sim
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


module Maze1FSM_sim();
    logic clk;
    logic enter, reset;
    logic u, d, l, r;
    
    logic start;
    logic [5:0] row;
    logic [6:0] col;
    logic done;
    
    Maze1FSM maze1fsm(.clk(clk), .enter(enter), .reset(reset), .u(u), .d(d), .l(l), .r(r), 
        .st(start), .row(row), .col(col), .done(done));
        
    always begin
        clk = 0; #5;
        clk = 1; #5;    
    end
    
    initial begin
        enter = 0; reset = 1; u = 0; d = 0; l = 0; r = 0;
        
        // Start maze
        enter = 0; #10;     // Move to pos: 1,1
        enter = 1; #20;
        enter = 0;
        
        // Complete maze
        r = 1; #10;         // Move to pos: 1,2
        r = 0; #10;
        
        r = 1; #10;         // Move to pos: 1,3
        r = 0; #10;
        
        d = 1; #10;         // Move to pos: 2,3
        d = 0; #10;
        
        d = 1; #10;         // Move to pos: 3,3
        d = 0; #10;
        
        d = 1; #10;         // Move to pos: 4,3
        d = 0; #10;
        
        r = 1; #10;         // Move to pos: 4,4
        r = 0; #10;
        
        d = 1; #10;         // Move to pos: 5,4
        d = 0; #10;
    end
endmodule
