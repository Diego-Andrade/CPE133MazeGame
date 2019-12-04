`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 08:46:23 PM
// Design Name: 
// Module Name: ClockDivider
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



module ClockDivider #(parameter MAXCOUNT = 1)(
    input clk, 
    output logic sclk = 0
    
    );     
   
    logic [29:0] count = 0;    
    
    always_ff @ (posedge clk)
    begin
        count = count + 1;
        if (count == MAXCOUNT)
        begin
            count = 0;
            sclk = ~sclk;
        end
             
    end
    
endmodule
