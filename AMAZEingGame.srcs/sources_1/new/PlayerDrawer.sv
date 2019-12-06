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


module PlayerDrawer  # (parameter RSTART = 18, parameter CSTART = 24, parameter SIZE = 5) (
    input CLK_50MHz,
    input reset,
    input [5:0] row,
    input [6:0] col,
    output Pixel p,
    output logic WE = 0
    );
    
    logic [3:0] dataSent = 2;           // Start by not sending data
        
    logic [5:0] tOldRow = 0;               // Hold past location data
    logic [6:0] tOldCol = 0;
    
    logic [5:0] tAdjOldRow = 0;               // Hold past location data
    logic [6:0] tAdjOldCol = 0;
    
    logic [5:0] tAdjRow = 0;            // Hold updated offset pixel row to draw player
    logic [6:0] tAdjCol = 0;            // .. pixel col
    
    Pixel tPOld;
    Pixel tPNew;
    
    always_ff @ (posedge CLK_50MHz) begin
//        if (!reset) begin
//            WE = 1;
//            p = {tAdjOldRow, tAdjOldCol, 8'b00000000};
//        end else 
        
        if (dataSent == 0 ) begin
            WE = 1;
            dataSent = 1; 
            tAdjOldRow = tAdjRow;
            tAdjOldCol = tAdjCol;       
        end else if (dataSent == 1) begin
            dataSent = 2;
            WE = 0;
        end else if ((~(tAdjOldRow == tAdjRow) | ~(tAdjOldCol == tAdjCol)) & row > 0 & col > 0) begin
            dataSent = 0;
            WE = 1;
        end
    end
    
    always_comb begin
        tPOld = {tAdjOldRow, tAdjOldCol, 8'b00000000};
        
        tAdjRow = (row - 1) * SIZE + RSTART + 2'b10;                   // Calculate offset row
        tAdjCol = (col - 1) * SIZE + CSTART + 2'b10;                   // .. col
                
        tPNew = {tAdjRow, tAdjCol, 8'b11100000};
        
        if (dataSent == 0)
            p = tPOld;
        if (dataSent == 1)
            p = tPNew;
    end
     
endmodule
