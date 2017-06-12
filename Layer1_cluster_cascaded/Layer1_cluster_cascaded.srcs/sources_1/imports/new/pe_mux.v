`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2015 03:12:51 PM
// Design Name: 
// Module Name: pe_mux
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


module pe_mux(
    input clk,
    input [2:0] sel,
    input [31:0] i0,
    input [31:0] i1,
    input [31:0] i2,
    input [31:0] i3,
    input [31:0] i4,
    input [31:0] i5,
    
    output reg [31:0] o
    );
    
    always @(posedge clk) begin
      case(sel)
        3'b000: o <= i0;
        3'b001: o <= i1;
        3'b010: o <= i2;
        3'b011: o <= i3;
        3'b100: o <= i4;
        3'b101: o <= i5;
        default: o <= 32'hxxxxxxxx;
      endcase
    end
    
endmodule
