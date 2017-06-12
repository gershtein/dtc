`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 03:10:09 AM
// Design Name: 
// Module Name: merge_mux
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


module merge_mux(
    input clk,
    input [35:0] stub00,
    input [35:0] stub01,
    input [35:0] stub02,
    input [35:0] stub03,
    input [35:0] stub04,
    input [35:0] stub05,
    input [35:0] stub06,
    input [35:0] stub07,
    input [35:0] stub08,
    input [35:0] stub09,
    input [35:0] stub10,
    input [35:0] stub11,
    input [35:0] stub12,
    input [35:0] stub13,
    input [35:0] stub14,
    input [35:0] stub15,
    input [3:0] sel,
    output reg [35:0] stub_out
    );
  
   always @(posedge clk) begin
     stub_out <= 0;
     case(sel) 
     4'b0000: stub_out <= stub00;
     4'b0001: stub_out <= stub01;
     4'b0010: stub_out <= stub02;
     4'b0011: stub_out <= stub03;
     4'b0100: stub_out <= stub04;
     4'b0101: stub_out <= stub05;
     4'b0110: stub_out <= stub06;
     4'b0111: stub_out <= stub07;
     4'b1000: stub_out <= stub08;
     4'b1001: stub_out <= stub09;
     4'b1010: stub_out <= stub10;
     4'b1011: stub_out <= stub11;
     4'b1100: stub_out <= stub12;
     4'b1101: stub_out <= stub13;
     4'b1110: stub_out <= stub14;
     4'b1111: stub_out <= stub15;
     endcase
   end 
endmodule
