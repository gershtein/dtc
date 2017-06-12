`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2016 05:21:39 PM
// Design Name: 
// Module Name: select_max
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


module select_max
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
    input [WIDTH-1:0] in8,
    input [WIDTH-1:0] in9,
    input [WIDTH-1:0] inA,
    input [WIDTH-1:0] inB,
    input [WIDTH-1:0] inC,
    input [WIDTH-1:0] inD,
    input [WIDTH-1:0] inE,
    input [WIDTH-1:0] inF,
    
    output reg [WIDTH-1:0] max,
    output reg [3:0] sel
    
    );
    
//    wire [WIDTH-1:0] m01 = in0>in1? in0:in1;
//    wire [WIDTH-1:0] m23 = in2>in3? in2:in3;
//    wire [WIDTH-1:0] m45 = in4>in5? in4:in5;
//    wire [WIDTH-1:0] m67 = in6>in7? in6:in7;
//    wire [WIDTH-1:0] m89 = in8>in9? in8:in9;
//    wire [WIDTH-1:0] mAB = inA>inB? inA:inB;
//    wire [WIDTH-1:0] mCD = inC>inD? inC:inD;
//    wire [WIDTH-1:0] mEF = inE>inF? inE:inF;
    
//    wire [WIDTH-1:0] m0123 = m01>m23? m01:m23;
//    wire [WIDTH-1:0] m4567 = m45>m67? m45:m67;
//    wire [WIDTH-1:0] m89AB = m89>mAB? m89:mAB;
//    wire [WIDTH-1:0] mCDEF = mCD>mEF? mCD:mEF;
    
//    wire [WIDTH-1:0] mh1 = m0123>m4567? m0123:m4567;
//    wire [WIDTH-1:0] mh2 = m89AB>mCDEF? m89AB:mCDEF;
    
//    wire [3:0] s01 = in0>in1? 4'b0000:4'b0001;
//    wire [3:0] s23 = in2>in3? 4'b0010:4'b0011;
//    wire [3:0] s45 = in4>in5? 4'b0100:4'b0101;
//    wire [3:0] s67 = in6>in7? 4'b0110:4'b0111;
//    wire [3:0] s89 = in8>in9? 4'b1000:4'b1001;
//    wire [3:0] sAB = inA>inB? 4'b1010:4'b1011;
//    wire [3:0] sCD = inC>inD? 4'b1100:4'b1101;
//    wire [3:0] sEF = inE>inF? 4'b1110:4'b1111;
    
//    wire [3:0] s0123 = m01>m23? s01:s23;
//    wire [3:0] s4567 = m45>m67? s45:s67;
//    wire [3:0] s89AB = m89>mAB? s89:sAB;
//    wire [3:0] sCDEF = mCD>mEF? sCD:sEF;
    
//    wire [3:0] sh1 = m0123>m4567? s0123:s4567;
//    wire [3:0] sh2 = m89AB>mCDEF? s89AB:sCDEF;
    
    reg [WIDTH-1:0] m01;
    always @(posedge clk) m01 <= in0>in1? in0:in1;

    reg [WIDTH-1:0] m23;
    always @(posedge clk) m23 <= in2>in3? in2:in3;
    reg [WIDTH-1:0] m45;
    always @(posedge clk) m45 <= in4>in5? in4:in5;
    reg [WIDTH-1:0] m67;
    always @(posedge clk) m67 <= in6>in7? in6:in7;
    reg [WIDTH-1:0] m89;
    always @(posedge clk) m89 <= in8>in9? in8:in9;
    reg [WIDTH-1:0] mAB;
    always @(posedge clk) mAB <= inA>inB? inA:inB;
    reg [WIDTH-1:0] mCD;
    always @(posedge clk) mCD <= inC>inD? inC:inD;
    reg [WIDTH-1:0] mEF;
    always @(posedge clk) mEF <= inE>inF? inE:inF;

    reg [WIDTH-1:0] m0123;
    always @(posedge clk) m0123 <= m01>m23? m01:m23;
    reg [WIDTH-1:0] m4567;
    always @(posedge clk) m4567 <= m45>m67? m45:m67;
    reg [WIDTH-1:0] m89AB;
    always @(posedge clk) m89AB <= m89>mAB? m89:mAB;
    reg [WIDTH-1:0] mCDEF;
    always @(posedge clk) mCDEF <= mCD>mEF? mCD:mEF;

    reg [WIDTH-1:0] mh1;
    always @(posedge clk) mh1 <= m0123>m4567? m0123:m4567;
    reg [WIDTH-1:0] mh2;
    always @(posedge clk) mh2 <= m89AB>mCDEF? m89AB:mCDEF;

    reg [3:0] s01;
    always @(posedge clk) s01 <= in0>in1? 4'b0000:4'b0001;
    reg [3:0] s23;
    always @(posedge clk) s23 <= in2>in3? 4'b0010:4'b0011;
    reg [3:0] s45;
    always @(posedge clk) s45 <= in4>in5? 4'b0100:4'b0101;
    reg [3:0] s67;
    always @(posedge clk) s67 <= in6>in7? 4'b0110:4'b0111;
    reg [3:0] s89;
    always @(posedge clk) s89 <= in8>in9? 4'b1000:4'b1001;
    reg [3:0] sAB;
    always @(posedge clk) sAB <= inA>inB? 4'b1010:4'b1011;
    reg [3:0] sCD;
    always @(posedge clk) sCD <= inC>inD? 4'b1100:4'b1101;
    reg [3:0] sEF;
    always @(posedge clk) sEF <= inE>inF? 4'b1110:4'b1111;

    reg [3:0] s0123;
    always @(posedge clk) s0123 <= m01>m23? s01:s23;
    reg [3:0] s4567;
    always @(posedge clk) s4567 <= m45>m67? s45:s67;
    reg [3:0] s89AB;
    always @(posedge clk) s89AB <= m89>mAB? s89:sAB;
    reg [3:0] sCDEF;
    always @(posedge clk) sCDEF <= mCD>mEF? sCD:sEF;

    reg [3:0] sh1;
    always @(posedge clk) sh1 <= m0123>m4567? s0123:s4567;
    reg [3:0] sh2;
    always @(posedge clk) sh2 <= m89AB>mCDEF? s89AB:sCDEF;
 
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
