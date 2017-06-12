`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 03:56:50 AM
// Design Name: 
// Module Name: prio_mux8
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


module prio_mux8
 #(
  parameter WIDTH = 32
)
(
   input clk,
   input [2:0] sel,
   input [WIDTH-1:0] i0,
   input [WIDTH-1:0] i1,
   input [WIDTH-1:0] i2,
   input [WIDTH-1:0] i3,
   input [WIDTH-1:0] i4,
   input [WIDTH-1:0] i5,
   input [WIDTH-1:0] i6,
   input [WIDTH-1:0] i7,
   
   output reg [WIDTH-1:0] o
   );
   
   always @(posedge clk) begin
     case(sel)
       3'b000: o <= i0;
       3'b001: o <= i1;
       3'b010: o <= i2;
       3'b011: o <= i3;
       3'b100: o <= i4;
       3'b101: o <= i5;
       3'b110: o <= i6;
       3'b111: o <= i7;
       default: o <= 32'hxxxxxx;
     endcase
   end

endmodule
