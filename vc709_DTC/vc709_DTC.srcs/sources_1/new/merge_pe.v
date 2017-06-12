`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 02:21:41 AM
// Design Name: 
// Module Name: merge_pe
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

// individual enable latency is 1 cycle, used to request data from memories
// encoded enable is used to mux the output, latency is 2 plus DELAY (parameter)
// hold suppresses the outputs

module merge_pe(
    input clk,
    input h00,
    input h01,
    input h02,
    input h03,
    input h04,
    input h05,
    input h06,
    input h07,
    input h08,
    input h09,
    input h10,
    input h11,
    input h12,
    input h13,
    input h14,
    input h15,
    input hold,
    output reg re00,
    output reg re01,
    output reg re02,
    output reg re03,
    output reg re04,
    output reg re05,
    output reg re06,
    output reg re07,
    output reg re08,
    output reg re09,
    output reg re10,
    output reg re11,
    output reg re12,
    output reg re13,
    output reg re14,
    output reg re15,
    output reg none,
    output [3:0] sel
    );
    
    parameter DELAY = 0; 
        
    always @(posedge clk) begin
      re00 <= !hold & h00;
      re01 <= !hold & h01 & !h00;
      re02 <= !hold & h02 & !h00 & !h01;
      re03 <= !hold & h03 & !h00 & !h01 & !h02;
      re04 <= !hold & h04 & !h00 & !h01 & !h02 & !h03;
      re05 <= !hold & h05 & !h00 & !h01 & !h02 & !h03 & !h04;
      re06 <= !hold & h06 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05;
      re07 <= !hold & h07 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06;
      re08 <= !hold & h08 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07;
      re09 <= !hold & h09 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08;
      re10 <= !hold & h10 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09;
      re11 <= !hold & h11 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10;
      re12 <= !hold & h12 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10 & !h11;
      re13 <= !hold & h13 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10 & !h11 & !h12;
      re14 <= !hold & h14 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10 & !h11 & !h12 & !h13;
      re15 <= !hold & h15 & !h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10 & !h11 & !h12 & !h13 & !h14;
      none <= hold | (!h00 & !h01 & !h02 & !h03 & !h04 & !h05 & !h06 & !h07 & !h08 &!h09 & !h10 & !h11 & !h12 & !h13 & !h14 & !h15);
    end
    
    //hopefully synthesizes as LUT
    reg [3:0] sel_reg[DELAY:0];
    always @(posedge clk) begin
      if(re00) sel_reg[0] <= 4'b0000;    
      if(re01) sel_reg[0] <= 4'b0001;    
      if(re02) sel_reg[0] <= 4'b0010;    
      if(re03) sel_reg[0] <= 4'b0011;    
      if(re04) sel_reg[0] <= 4'b0100;    
      if(re05) sel_reg[0] <= 4'b0101;    
      if(re06) sel_reg[0] <= 4'b0110;    
      if(re07) sel_reg[0] <= 4'b0111;    
      if(re08) sel_reg[0] <= 4'b1000;    
      if(re09) sel_reg[0] <= 4'b1001;    
      if(re10) sel_reg[0] <= 4'b1010;    
      if(re11) sel_reg[0] <= 4'b1011;    
      if(re12) sel_reg[0] <= 4'b1100;    
      if(re13) sel_reg[0] <= 4'b1101;    
      if(re14) sel_reg[0] <= 4'b1110;    
      if(re15) sel_reg[0] <= 4'b1111;    
    end
    
    //pipe
   genvar c;
    generate
       for (c = 0; c < DELAY; c = c + 1) begin: test
           always @(posedge clk) begin
              sel_reg[c+1] <= sel_reg[c];
           end
       end
    endgenerate 
    
    assign sel = sel_reg[DELAY];
    
    
endmodule
