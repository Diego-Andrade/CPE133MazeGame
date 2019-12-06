`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 2:52:41 PM
// Design Name: 
// Module Name: 2_1mux
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


module Mux2 # (parameter WIDTH = 4)(
    input [WIDTH -1:0] zero, one,
    input sel,
    output logic [WIDTH -1:0] mux_out
    );
    
        
    always_comb begin
        if (sel == 1)
            mux_out = one;
        else
            mux_out = zero;
    end
endmodule