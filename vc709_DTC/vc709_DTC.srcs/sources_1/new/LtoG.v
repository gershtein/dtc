`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2016 05:06:44 AM
// Design Name: 
// Module Name: LtoG
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


module LtoG_L2S(  //for SS modules in the barrel
    input clk320,
    input [14:0] stub,
    input valid,
    output [1:0] sector,
    output [7:0] r,
    output [16:0] phi,
    output [7:0] z,
    output [2:0] pt
    );
    
  wire [34:0]data_o;
  assign    phi = data_o[34:18];
  assign      r = data_o[17:10];
  assign      z = data_o[9:2];
  assign sector = data_o[1:0];
  
  reg [2:0] pt_reg;
  assign pt = pt_reg;
  always @(posedge clk320)
     pt_reg <= stub[3:1];    //need to implement correct LUT from Savvas
  
  Memory #(
    .RAM_WIDTH(35),
    .RAM_DEPTH(2048), 
    .INIT_FILE("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/LtoG_L2S.hex"),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE")
  //  .RAM_PERFORMANCE("LOW_LATENCY")
  ) geom (  
    .addrb(stub[14:4]), //that includes chip ID and strip #
    .clkb(clk320),
    .enb(1'b1),
    .regceb(1'b1),
    .rstb(1'b0),
    .doutb(data_o) 
  );
    
endmodule
