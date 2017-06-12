`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 01:33:56 AM
// Design Name: 
// Module Name: sel_max4
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


module sel_max4
 #(
   parameter WIDTH = 32
 )
 (
   input clk,
   input reset,
   
   input [WIDTH-1:0] in0,
   input [WIDTH-1:0] in1,
   input [WIDTH-1:0] in2,
   input [WIDTH-1:0] in3,
   
   output reg [WIDTH-1:0] max,
   output reg [3:0] sel
   
   );
   
   
   reg [WIDTH-1:0] mh1;
   always @(posedge clk) mh1 <= in0>in1? in0:in1;
   reg [WIDTH-1:0] mh2;
   always @(posedge clk) mh2 <= in2>in3? in2:in3;

   reg [3:0] sh1;
   always @(posedge clk) sh1 <= in0>in1? 4'b0000:4'b0001;
   reg [3:0] sh2;
   always @(posedge clk) sh2 <= in2>in3? 4'b0010:4'b0011;

   always @(posedge clk) begin
     if(reset) begin
       sel <= 0;
       max <= 0;
     end
     else begin
       max <= mh1 > mh2? mh1 : mh2;
       sel <= mh1 > mh2? sh1 : sh2;
     end
   end

endmodule
