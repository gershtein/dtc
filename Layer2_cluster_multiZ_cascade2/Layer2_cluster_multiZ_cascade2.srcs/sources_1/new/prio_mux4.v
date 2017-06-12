`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 01:37:45 AM
// Design Name: 
// Module Name: prio_mux4
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


module prio_mux4
 #(
  parameter WIDTH = 32
  )
(
   input clk,
   input [4:0] sel,
   input [WIDTH-1:0] i0,
   input [WIDTH-1:0] i1,
   input [WIDTH-1:0] i2,
   input [WIDTH-1:0] i3,
   
   output reg [WIDTH-1:0] o
   );
   
   always @(posedge clk) begin
     case(sel)
       5'b00000: o <= i0;
       5'b00001: o <= i1;
       5'b00010: o <= i2;
       5'b00011: o <= i3;
       default: o <= 32'hxxxxxxxx;
     endcase
   end
   

endmodule
