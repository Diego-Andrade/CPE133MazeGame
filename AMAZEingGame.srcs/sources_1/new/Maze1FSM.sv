`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Created by: Diego Andrade 
// 
// Create Date: 11/27/2019 11:26:35 AM
// Design Name: Maze1FSM
// Module Name: Maze1FSM
// Project Name: AMAZEingGame
// Target Devices: Basys 3 Board
// Description: The fsm implementation of Maze 1, controlling players
//              movement threw the maze as they play
//
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Adding all states / rooms
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Maze1FSM(
    input clk,
    input enter,
    input reset,
    input u,        // Up
    input d,        // Down
    input l,        // Left
    input r,        // Right
    output logic st,
    output logic [5:0] row,
    output logic [6:0] col,
    output logic done
    );
    
    parameter [4:0] START = 5'b00000, 
        r11 = 5'b00001, r12 = 5'b00010, r13 = 5'b00011, r14 = 5'b00100, r15 = 5'b00101,
        r21 = 5'b00110, r22 = 5'b00111, r23 = 5'b01000, r24 = 5'b01001, r25 = 5'b01010,
        r31 = 5'b01011, r32 = 5'b01100, r33 = 5'b01101, r34 = 5'b01110, r35 = 5'b01111,
        r41 = 5'b10000, r42 = 5'b10001, r43 = 5'b10010, r44 = 5'b10011, r45 = 5'b10100,
        r51 = 5'b10101, r52 = 5'b10110, r53 = 5'b10111, r54 = 5'b11000, r55 = 5'b11001;
    
    logic [4:0] NS = START;
    logic [4:0] PS = START;
    
    logic tE, tU, tD, tL, tR;

    always_ff @ (posedge clk, negedge reset)
    begin
        if (!reset) begin
            PS = START;
        end
        else begin
            if ((tE == enter) & (tU == u) & (tD == d) & (tL == l) & (tR == r) ) begin   // No state changed
                PS = PS;
            end else begin 
                PS = NS;
                tE = enter; tU = u; tD = d; tL = l; tR = r;
            end
        end
    end

    always_comb 
    begin
        case (PS)
            START:
            begin
                row = 0; col = 0; done = 0; st = 0;
                if (enter)
                    NS = r11;
                else
                    NS = START;
            end

            r11:
            begin
                row = 1; col = 1; done = 0; st = 1;
                if (r & !u & !d & !l)
                    NS = r12;
                else if (d & !u & !l & !r)
                    NS = r21;
                else
                    NS = r11;
            end

            r12:
            begin
                row = 1; col = 2; done = 0; st = 1;
                if (l & !u & !d & !r)
                    NS = r11;
                else if (r & !u & !d & !l)
                    NS = r13;
                else
                    NS = r12;
            end

            r13:
            begin
                row = 1; col = 3; done = 0; st = 1;
                if (l & !u & !d & !r)
                    NS = r12;
                else if (d & !u & !l & !r)
                    NS = r23;
                else
                    NS = r13;
            end

            r14:
            begin
                row = 1; col = 4; done = 0; st = 1;
                if (d & !u & !l & !r)
                    NS = r24;
                else if (r & !u & !d & !l)
                    NS = r15;
                else 
                    NS = r14;
            end

            r15:
            begin
                row = 1; col = 5; done = 0; st = 1;
                if (l & !u & !d & !r) 
                    NS = r14;
                else if (d & !u & !l & !r) 
                    NS = r25;
                else
                    NS = r15;
            end

            r21:
            begin 
                row = 2; col = 1; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r11;
                else if (d & !u & !l & !r)
                    NS = r31;
                else 
                    NS = r21;
            end

            r22:
            begin
                row = 2; col = 2; done = 0; st = 1;
                if (d & !u & !l & !r)
                    NS = r32;
                else if (r & !u & !d & !l)
                    NS = r23;
                else 
                    NS = r22;
            end

            r23:
            begin
                row = 2; col = 3; done = 0; st = 1;
                if (u & !d & !l &!r)
                    NS = r13;
                else if (d & !u & !l & !r)
                    NS = r33;
                else if (l & !u & !l & !r)
                    NS = r22;
                else
                    NS = r24;
            end

            r24:
            begin
                row = 2; col = 4; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r14;
                else if (l & !u & !d & !r)
                    NS = r23;
                else 
                    NS = r24;
            end

            r25:
            begin
                row = 2; col = 5; done = 0; st = 1;
                if (u & !d & !l  & !r)
                    NS = r15;
                else if (d & !u & !l & !r)
                    NS = r35;
                else
                    NS = r25;
            end

            r31:
            begin
                row = 3; col = 1; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r21;
                else if (d & !u & !l & !r)
                    NS = r41;
                else if (r & !u & !d & !l)
                    NS = r32;
                else 
                    NS = r31;
            end

            r32: 
            begin 
                row = 3; col = 2; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r22;
                else if (d & !u & !l & !r)
                    NS = r42;
                else if (l & !u & !d & !r)
                    NS = r31;
                else   
                    NS = r32;
            end

            r33:
            begin 
                row = 3; col = 3; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r23;
                else if (d & !u & !l & !r)
                    NS = r43;
                else 
                    NS = r33;
            end

            r34:
            begin 
                row = 3; col = 4; done = 0; st = 1;
                if (d & !u & !l & !r)
                    NS = r44;
                else if (r & !u & !d & !l)
                    NS = r35;
                else 
                    NS = r34;
            end

            r35:
            begin
                row = 3; col = 5; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r25;
                else if (d & !u & !l & !r)
                    NS = r45;
                else if (l & !u & !d & !r)
                    NS = r34;
                else 
                    NS = r35;
            end

            r41:
            begin 
                row = 4; col = 1; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r31;
                else 
                    NS = r41;
            end

            r42:
            begin 
                row = 4; col = 2; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r32;
                else if (d & !u & !l & !r)
                    NS = r52;
                else 
                    NS = r42;
            end

            r43: 
            begin
                row = 4; col = 3; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r33;
                else if (d & !u & !l & !r)
                    NS = r53;
                else if (r & !u & !d & !l)
                    NS = r44;
                else 
                    NS = r43;
            end

            r44:
            begin
                row = 4; col = 4; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r34;
                else if (d & !u & !l & !r)
                    NS = r54;
                else if (l & !u & !d & !r)
                    NS = r43;
                else 
                    NS = r44;
            end

            r45:
            begin
                row = 4; col = 5; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r35;
                else if (d & !u & !l & !r)
                    NS = r55;
                else 
                    NS = r45;
            end

            r51:
            begin 
                row = 5; col = 1; done = 0; st = 1;
                if (r & !u & !d & !l)
                    NS = r52;
                else 
                    NS = r51;
            end

            r52:
            begin 
                row = 5; col = 2; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r42;
                else if (l & !u & !d & !r)
                    NS = r51;
                else if (r & !u & !d & !l)
                    NS = r53;
                else 
                    NS = r52;
            end

            r53:
            begin
                row = 5; col = 3; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r43;
                else if (l & !u & !d & !r)
                    NS = r52;
                else 
                    NS = r53;
            end

            r54:
            begin
                row = 5; col = 4; done = 1; st = 0;       
                NS = r54;   // Trapping in target room since maze complete
            end

            r55:
            begin
                row = 5; col = 5; done = 0; st = 1;
                if (u & !d & !l & !r)
                    NS = r45;
                else 
                    NS = r55;
            end

        endcase
    end

endmodule
