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
    logic [12:0] WA;
    logic [7:0] Colour;         // rrrgggbb formate
} Pixel;

module Maze1Drawer(
    input CLK_50MHz,
    input reset,
    output Pixel pixel
    );
    
    Pixel pixels [0:4][0:4];
    logic [5:0] row = 0;
    logic [6:0] col = 0;
    logic done = 0;
    
    initial begin 
        pixels <= '{
                     '{{6'b000010, 7'b0000010, 8'b11111111}, {6'b000011, 7'b0000010, 8'b11111111}, {6'b000100, 7'b0000010, 8'b11111111}, {6'b000101, 7'b0000010, 8'b11111111}, {6'b000110, 7'b0000010, 8'b11111111}},     
                     '{{6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}},  
                     '{{6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}},
                     '{{6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}},
                     '{{6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00000000}} 
                };
    end
    
    always_ff @(posedge CLK_50MHz) begin
        if (!reset) begin
           
        end
        else if (!done) begin
            if (col < 5 - 1)
                col = col + 1;
            else begin 
                col = 0;
                if (row < 5 - 1)
                    row = row + 1;
                else begin 
                    done = 1;
                    row = 0;
                end 
            end
            
        end
    end
    
    always_comb begin
        pixel <= pixels[row][col];
    end
    
endmodule
