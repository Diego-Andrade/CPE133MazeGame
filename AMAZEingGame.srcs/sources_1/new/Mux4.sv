`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2019 02:16:31 PM
// Design Name: 
// Module Name: Mux4
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


module Mux4 # (parameter WIDTH = 4) (
    input [WIDTH-1:0] zero, one, two, three,
    input sel,
    output logic [WIDTH -1:0] mux_out
    );
        
    always_comb begin
        case (sel)
            0: mux_out = zero;
            1: mux_out = one;
            2: mux_out = two;
            3: mux_out = three;
        endcase
    end
endmodule
