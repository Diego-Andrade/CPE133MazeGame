`timescale 1ns / 1ps
//----------------------------------------------------------------------------
//- Verilog Model: univ_sseg.sv
//-
//- Company: Ratface Engineering
//- Engineer: James Ratner
//- 
//- Description: Special seven segment display driver. This file 
//-  interprets the input(s) as an unsigned binary number
//-  and displays the result on the four seven-segment
//-  displays on the development board. This module implements 
//-  the required multiplexing of the display based
//-  upon the CLK input. For this module, the CLK frequency 
//-  is expected to be in 100MHz but will work for other 
//-  relatively fast frequencies. The CLK input connects to a
//-  clock signal from the development board; you may need to 
//-  adjust the clock divider if there are display issues.  
//-
//-  The description below describe's the devices control inputs: 
//- 
//-    valid:   if valid = 0, four dashes are displayed
//-             if valid = 1, decimal number appears on display
//- 
//-    dp_en:   if dp_oe = 0, no decimal point is displayed 
//-             if dp_oe = 1, displays one dp according to dp_sel inputs
//-      
//-    dp_sel:  if dp = 00, dp displayed on right-most 7-seg display
//-             if dp = 01, dp displayed on middle-right 7-seg display
//-             if dp = 10, dp displayed on middle-left 7-seg display
//-             if dp = 11, dp displayed on left-most 7-seg display
//-             NOTE: only one dp is active at any given time
//-
//-    mod_sel: if sel = 00, displays one count [0,255] with optional '-' sign
//-             if sel = 01, displays two counts [0,99] (no sign)
//-             if sel = 10, displays one count [0,9999] (no sign) 
//-             if sel = 11, displays average academic administrator IQ 
//-
//-    sign:    if sign = 0, no minus sign appears
//-             if sign = 1, minus sign appears on left-most display
//-
//-    cnt1:    count for mod_sel = 00 ([0,255]) & mod_sel = 10 [0,9999] 
//-             count for left-most 2-digit count mod sel = 01 mode([0,99]) 
//-             NOTE: 14-bit count
//-
//-    cnt2:    right-most 2-digit count ([0,99]) for mod_sel = 01 
//-             ignored in all other mod_sel values 
//-
//-  Revision History:
//------------------------------------------------------------------------------- 
//-  Created: 07-01-2018  v1.00
//-           10-17-2018  v1.01  fixed system verilog conversion error
//- 
//////////////////////////////////////////////////////////////////////////////////


module univ_sseg(
    input [13:0] cnt1,
    input [6:0] cnt2,
    input valid,
    input dp_en,
    input [1:0] dp_sel,
    input [1:0] mod_sel,
    input sign,
    input clk,
    output reg [7:0] ssegs,
    output reg [3:0] disp_en
    ); 
   
    wire [3:0] c1_d3;  // nodes for cnt1 convert results
    wire [3:0] c1_d2; 
    wire [3:0] c1_d1; 
    wire [3:0] c1_d0; 
 
    wire [3:0] c2_d1;   // nodes for cnt2 convert results
    wire [3:0] c2_d0; 
    
    reg [3:0] A_1000_digit; // final digit-based BCD values
    reg [3:0] B_100_digit; 
    reg [3:0] C_10_digit; 
    reg [3:0] D_1_digit; 
    
    reg [3:0] final_BCD; 
    reg [1:0] m_cnt;        // multiplex counter output

    reg [7:0] seg_val;      // intermediate segment value

    // instantiate 14-bit code converter
    cnt_convert_14b CC_14(cnt1, mod_sel, c1_d3, c1_d2, c1_d1, c1_d0); 
    
    // instantiate 7-bit code converter
    cnt_convert_7b CC_7(cnt2, c2_d1, c2_d0); 
      
    // clock divider
    clk_divder CLK_DIV (clk,sclk); 
        
    //- handle 1000's digit
    //- mode 0: case 0 & 4
    //- mode 1: case 1 & 5
    //- mode 2: case 2 & 6
    //- mode 3: case 3 & 7
    always @ (sign,mod_sel,c1_d1,c1_d3)
    begin
       case ({sign,mod_sel})
          0: A_1000_digit = 'hF;
          1: A_1000_digit = c1_d1; 
          2: A_1000_digit = c1_d3;
          3: A_1000_digit = 0;
          4: A_1000_digit = 'hA;  // dash
          5: A_1000_digit = c1_d1; 
          6: A_1000_digit = c1_d3;
          7: A_1000_digit = 0;
          default A_1000_digit = 'hA; 
       endcase 
    end 
 
    //- handle 100's digit
    always @ (mod_sel,c1_d2,c1_d0)
    begin
       case (mod_sel)
          0: B_100_digit = c1_d2; 
          1: B_100_digit = c1_d0; 
          2: B_100_digit = c1_d2;
          3: B_100_digit = 0;
          default B_100_digit = 0; 
       endcase 
    end 
 
    //- handle 10's digit
    always @ (mod_sel,c1_d1,c2_d1)
    begin
       case (mod_sel)
          0: C_10_digit = c1_d1; 
          1: C_10_digit = c2_d1; 
          2: C_10_digit = c1_d1;
          3: C_10_digit = 0;
          default C_10_digit = 0; 
       endcase 
    end 

    //- handle 1's digit
    always @ (mod_sel,c1_d0,c2_d0)
    begin
       case (mod_sel)
          0: D_1_digit = c1_d0; 
          1: D_1_digit = c2_d0; 
          2: D_1_digit = c1_d0;
          3: D_1_digit = 0;
          default D_1_digit = 0; 
       endcase 
    end 

    //- MUX to handle digits 
    always @ (m_cnt, A_1000_digit, B_100_digit, C_10_digit, D_1_digit)
    begin
       case (m_cnt)
          3: final_BCD = D_1_digit; 
          2: final_BCD = C_10_digit; 
          1: final_BCD = B_100_digit;
          0: final_BCD = A_1000_digit;
          default final_BCD = 0; 
       endcase 
    end 
    
    //- standard decoder for display multiplex 
    always @ (m_cnt)
    begin
       case (m_cnt)
          0: disp_en = 4'b1110;  
          1: disp_en = 4'b1101; 
          2: disp_en = 4'b1011;
          3: disp_en = 4'b0111;
          default disp_en = 0; 
       endcase 
    end 
    
    //- 7 seg decoder for display multiplex
    always @ (final_BCD)
    begin
       case (final_BCD)
          0: seg_val  = 'h03;  // one
          1: seg_val  = 'h9F;  // two
          2: seg_val  = 'h25;  // three
          3: seg_val  = 'h0D;
          4: seg_val  = 'h99;  
          5: seg_val  = 'h49;  
          6: seg_val  = 'h41;  
          7: seg_val  = 'h1F;  
          8: seg_val  = 'h01;  
          9: seg_val  = 'h09;  
          10: seg_val = 'hFD;   // dash
          15: seg_val = 'hFF;   // off  
          default seg_val = 0; 
       endcase 
    end 

    //- handle the decimal point stuff
    always @ (dp_sel, m_cnt, dp_en, seg_val, valid)
    begin
       if (valid == 0)     //- handles valid
          ssegs = 'hFD; 
       else 
          begin
          if (dp_sel == m_cnt)
             ssegs = {seg_val[7:1],~dp_en}; 
          else 
             ssegs = seg_val;
          end          
    end

         
    //- counter that drives the mulitplexed display 
    always @ (posedge sclk)
    begin 
       m_cnt <= m_cnt + 1'b1;
    end 

endmodule


//--------------------------------------------------------------------
//- Module: clk_divider
//-
//- Description: parameterized clock divder
//- 
//- USAGE:  (example overrides width default)
//- 
//-      rca_nb #(16) MY_RCA (
//-          .clockin (my_clk_in), 
//-          .clockout (my_clk_out)
//-          );  
//--------------------------------------------------------------------
module clk_divder(clockin, clockout); 
    input clockin; 
    output wire clockout; 

    parameter n = 13; 
    reg [n:0] count; 

    always@(posedge clockin) 
    begin 
        count <= count + 1; 
    end 

    assign clockout = count[n]; 
endmodule 


//- converts 14-bit binary to 4 digit decimal
module cnt_convert_14b(
    input [13:0] cnt,
    input [1:0] sel,
    output reg [3:0] c1_d3,
    output reg [3:0] c1_d2,
    output reg [3:0] c1_d1,
    output reg [3:0] c1_d0
    );
    reg [13:0] cnt_new;      // working value  
    reg [13:0] cnt_new_w;    // working value 
   
    //- BCD intermediates for digits  
    reg [3:0] d3;     // 1000's digit  
    reg [3:0] d2;     // 100's digit
    reg [3:0] d1;     // 10's digit
    reg [3:0] d0;     // 1's digit
    
    //- clear unused bits on per mode basis
    always @ (cnt,sel)
       case(sel)
          0: cnt_new = {6'b000000,cnt[7:0]};   // clear zeros for [0,255] mode
          1: cnt_new = {7'b00000000,cnt[6:0]}; // clear zeros for [0,99] mode  
          2: cnt_new = cnt;                    // 14-bit mode
          3: cnt_new = cnt;                    // unused mode
          default cnt_new = cnt; 
       endcase
    
    always @ (cnt_new)
    begin
       d3=0;  d2=0;  d1=0;  d0=0;    // pre-assign digits 
       cnt_new_w = cnt_new;          // copy value
       
       //- find 1000's digit
       if      (cnt_new_w > 8999) begin   d3=9;   cnt_new_w = cnt_new_w - 9000;  end
       else if (cnt_new_w > 7999) begin   d3=8;   cnt_new_w = cnt_new_w - 8000;  end 
       else if (cnt_new_w > 6999) begin   d3=7;   cnt_new_w = cnt_new_w - 7000;  end 
       else if (cnt_new_w > 5999) begin   d3=6;   cnt_new_w = cnt_new_w - 6000;  end 
       else if (cnt_new_w > 4999) begin   d3=5;   cnt_new_w = cnt_new_w - 5000;  end 
       else if (cnt_new_w > 3999) begin   d3=4;   cnt_new_w = cnt_new_w - 4000;  end 
       else if (cnt_new_w > 2999) begin   d3=3;   cnt_new_w = cnt_new_w - 3000;  end 
       else if (cnt_new_w > 1999) begin   d3=2;   cnt_new_w = cnt_new_w - 2000;  end 
       else if (cnt_new_w > 999)  begin   d3=1;   cnt_new_w = cnt_new_w - 1000;  end 
       else                       begin   d3=0;   end 

       //- find 100's digit
       if      (cnt_new_w > 899) begin   d2=9;   cnt_new_w = cnt_new_w - 900;  end
       else if (cnt_new_w > 799) begin   d2=8;   cnt_new_w = cnt_new_w - 800;  end 
       else if (cnt_new_w > 699) begin   d2=7;   cnt_new_w = cnt_new_w - 700;  end 
       else if (cnt_new_w > 599) begin   d2=6;   cnt_new_w = cnt_new_w - 600;  end 
       else if (cnt_new_w > 499) begin   d2=5;   cnt_new_w = cnt_new_w - 500;  end 
       else if (cnt_new_w > 399) begin   d2=4;   cnt_new_w = cnt_new_w - 400;  end 
       else if (cnt_new_w > 299) begin   d2=3;   cnt_new_w = cnt_new_w - 300;  end 
       else if (cnt_new_w > 199) begin   d2=2;   cnt_new_w = cnt_new_w - 200;  end 
       else if (cnt_new_w > 99)  begin   d2=1;   cnt_new_w = cnt_new_w - 100;  end 
       else                      begin   d2=0;   end 

       //- find 10's digit
       if      (cnt_new_w > 89) begin   d1=9;   cnt_new_w = cnt_new_w - 90;  end
       else if (cnt_new_w > 79) begin   d1=8;   cnt_new_w = cnt_new_w - 80;  end 
       else if (cnt_new_w > 69) begin   d1=7;   cnt_new_w = cnt_new_w - 70;  end 
       else if (cnt_new_w > 59) begin   d1=6;   cnt_new_w = cnt_new_w - 60;  end 
       else if (cnt_new_w > 49) begin   d1=5;   cnt_new_w = cnt_new_w - 50;  end 
       else if (cnt_new_w > 39) begin   d1=4;   cnt_new_w = cnt_new_w - 40;  end 
       else if (cnt_new_w > 29) begin   d1=3;   cnt_new_w = cnt_new_w - 30;  end 
       else if (cnt_new_w > 19) begin   d1=2;   cnt_new_w = cnt_new_w - 20;  end 
       else if (cnt_new_w > 9)  begin   d1=1;   cnt_new_w = cnt_new_w - 10;  end 
       else                     begin   d1=0;   end 

       //- assign 1's digit 
       d0 = cnt_new_w[3:0]; 

    end
    
    //- handles the lead zero blanking
    always @ (cnt_new, d3,d2,d1,d0)
    begin
       if (cnt_new < 1000) // 1000's digit 
          c1_d3 = 'hF; 
       else 
          c1_d3 = d3; 
 
       if (cnt_new < 100)  // 100's digit
          c1_d2 = 'hF; 
       else 
          c1_d2 = d2; 

       if (cnt_new < 10)  // 10's digit
          c1_d1 = 'hF; 
       else 
          c1_d1 = d1;
          
       c1_d0 = d0;        // 1's digit never blank
    end 
    
endmodule


//- converts 7-bit binary to 2 digit decimal
module cnt_convert_7b(
    input [6:0] cnt,
    output reg [3:0] c2_d1,
    output reg [3:0] c2_d0
    );
    
    reg [7:0] cnt_new;      // working value  
    reg [7:0] cnt_new_w;    // working value 
   
    // BCD intermediates   
    reg [3:0] d1;     // 10's digit
    reg [3:0] d0;     // 1's digit
      
    //- decimal (2 digit) to BCD conversion 
    always @ (cnt_new)
    begin
       d1=0;  d0=0; 
        
       cnt_new_w = cnt; 

       // handle 10's digit
       if      (cnt_new_w > 89) begin   d1=9;   cnt_new_w = cnt_new_w - 90;  end
       else if (cnt_new_w > 79) begin   d1=8;   cnt_new_w = cnt_new_w - 80;  end 
       else if (cnt_new_w > 69) begin   d1=7;   cnt_new_w = cnt_new_w - 70;  end 
       else if (cnt_new_w > 59) begin   d1=6;   cnt_new_w = cnt_new_w - 60;  end 
       else if (cnt_new_w > 49) begin   d1=5;   cnt_new_w = cnt_new_w - 50;  end 
       else if (cnt_new_w > 39) begin   d1=4;   cnt_new_w = cnt_new_w - 40;  end 
       else if (cnt_new_w > 29) begin   d1=3;   cnt_new_w = cnt_new_w - 30;  end 
       else if (cnt_new_w > 19) begin   d1=2;   cnt_new_w = cnt_new_w - 20;  end 
       else if (cnt_new_w > 9)  begin   d1=1;   cnt_new_w = cnt_new_w - 10;  end 
       else                     begin   d1=0;   end 

       // handle 1's digit 
       d0 = cnt_new_w[3:0]; 
    end
    

    // handles the lead zero blanking
    always @ (cnt, d1, d0)
    begin
       if (cnt < 10)  // 10's digit
          c2_d1 = 'hF; 
       else 
          c2_d1 = d1;
          
       c2_d0 = d0;       // 1's digit never blank
    end 
    
endmodule
