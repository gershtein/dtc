`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 03:52:10 AM
// Design Name: 
// Module Name: sel_max8
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


module sel_max8
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
    input [WIDTH-1:0] in4,
    input [WIDTH-1:0] in5,
    input [WIDTH-1:0] in6,
    input [WIDTH-1:0] in7,
    
    output reg [WIDTH-1:0] max,
    output reg [3:0] sel
    
    );
        
    reg [WIDTH-1:0] m01;
    always @(posedge clk) m01 <= in0>in1? in0:in1;

    reg [WIDTH-1:0] m23;
    always @(posedge clk) m23 <= in2>in3? in2:in3;
    reg [WIDTH-1:0] m45;
    always @(posedge clk) m45 <= in4>in5? in4:in5;
    reg [WIDTH-1:0] m67;
    always @(posedge clk) m67 <= in6>in7? in6:in7;

    reg [WIDTH-1:0] mh1;
    always @(posedge clk) mh1 <= m01>m23? m01:m23;
    reg [WIDTH-1:0] mh2;
    always @(posedge clk) mh2 <= m45>m67? m45:m67;

    reg [3:0] s01;
    always @(posedge clk) s01 <= in0>in1? 4'b0000:4'b0001;
    reg [3:0] s23;
    always @(posedge clk) s23 <= in2>in3? 4'b0010:4'b0011;
    reg [3:0] s45;
    always @(posedge clk) s45 <= in4>in5? 4'b0100:4'b0101;
    reg [3:0] s67;
    always @(posedge clk) s67 <= in6>in7? 4'b0110:4'b0111;

    reg [3:0] sh1;
    always @(posedge clk) sh1 <= m01>m23? s01:s23;
    reg [3:0] sh2;
    always @(posedge clk) sh2 <= m45>m67? s45:s67;
 
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
