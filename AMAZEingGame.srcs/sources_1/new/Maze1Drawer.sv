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

module Maze1Drawer(
    input CLK_50MHz,
    input reset,
    output Pixel pixel,         // The pixel is currently selected to be displayed
    output logic WE             // Send out we are drawing a pixel
    );
    
    Pixel pixels [0:24];       // 450 in a list
    
    logic [12:0] currentPixel = 0;        // to keep track of which pixel to draw during clock pulse
    logic done = 0;                       // Wether maze is done drawing, avoid writting on memory over and over
    
    initial begin 
        // Below creates a single room
        pixels <= '{
            {6'b000000, 7'b0000010, 8'b11100000}, {6'b000000, 7'b0000011, 8'b11111111}, {6'b000000, 7'b0000100, 8'b11111111}, {6'b000000, 7'b0000101, 8'b11111111}, {6'b000000, 7'b0000110, 8'b11111111},{6'b000001, 7'b0000010, 8'b00000011}, {6'b000001, 7'b0000011, 8'b00000000}, {6'b000001, 7'b0000100, 8'b00000000}, {6'b000001, 7'b0000101, 8'b00000000}, {6'b000001, 7'b0000110, 8'b00000000}, {6'b000010, 7'b0000010, 8'b00011100}, {6'b000010, 7'b0000011, 8'b00000000}, {6'b000010, 7'b0000100, 8'b00000000}, {6'b000010, 7'b0000101, 8'b00000000}, {6'b000010, 7'b0000110, 8'b00000000}, {6'b000011, 7'b0000010, 8'b00000000}, {6'b000011, 7'b0000011, 8'b00000000}, {6'b000011, 7'b0000100, 8'b00000000}, {6'b000011, 7'b0000101, 8'b00000000}, {6'b000011, 7'b0000110, 8'b00000000}, {6'b000100, 7'b0000010, 8'b11100000}, {6'b000100, 7'b0000011, 8'b00000000}, {6'b000100, 7'b0000100, 8'b00000000}, {6'b000100, 7'b0000101, 8'b00000000}, {6'b000100, 7'b0000110, 8'b00000000}
        };
    end
    
    always_ff @(posedge CLK_50MHz) begin        // Handles change row and column every clock count to change pixel out being drawn
        if (!reset) begin
           // TODO Is there a reset needed?
        end
        else if (!done) begin
            if (currentPixel < 25 - 1)
                currentPixel = currentPixel + 1;
            else begin 
                currentPixel = 0;
                
                done = 1;
            end 
        end
    end
    
    always_comb begin                       // Set output to current pixel being drawn
        if (!done) begin                    
            WE = 1;                         // Send out new pixel is being drawn
            pixel <= pixels[currentPixel];
        end
        else
            WE = 0;
    end
    
endmodule
