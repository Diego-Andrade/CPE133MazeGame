`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2019 12:19:01 AM
// Design Name: 
// Module Name: PlayerDrawer
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


module PlayerDrawer  # (parameter RSTART = 0, parameter CSTART = 0, parameter SIZE = 5) (
    input CLK_50MHz,
    input [5:0] row,
    input [6:0] col,
    output Pixel p,
    output logic WE = 0
    );
    
    logic [1:0] dataSent = 2;           // Start by not sending data
        
    logic [5:0] tRow = 0;               // Hold past location data
    logic [6:0] tCol = 0;
    
    logic [5:0] tCurRow = 0;            // Hold updated offset pixel row to draw player
    logic [6:0] tCurCol = 0;            // .. pixel col
    
    always_ff @ (posedge CLK_50MHz) begin
        if (dataSent < 2) begin
            WE = 1;
            dataSent = dataSent + 1;
        end else begin
            WE = 0;
            tRow <= row;
            tCol <= col;
        end
        
        if ( ~(row == tRow) | ~(col == tCol)) begin
            dataSent <= 0;
        end
    end
    
    always_comb begin
        if (dataSent == 0) begin
            tCurRow = (tRow - 1) * SIZE + RSTART;                   // Calculate offset row
            tCurCol = (tCol - 1) * SIZE + CSTART;                   // .. col
            
            p = {tCurRow, tCurCol, 8'b00000000};
        end else if (dataSent == 1) begin
            tCurRow = (row - 1) * SIZE + RSTART;                   // Calculate offset row
            tCurCol = (col - 1) * SIZE + CSTART;                   // .. col
            
            p = {tCurRow, tCurCol, 8'b00001111};
        end
    end
     
endmodule
