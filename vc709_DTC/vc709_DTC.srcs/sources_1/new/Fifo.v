`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2016 06:11:19 AM
// Design Name: 
// Module Name: Fifo
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


module Fifo(
    input clk,
    input we,
    input [35:0] DI,
    input reset,
    input re,
    output [35:0] DO,
    output has_data
    );
    
    
  reg [3:0] cnt; //number of items in fifo
  assign has_data = ~(cnt==0);
  
  always @(posedge clk) begin
    if(reset)
      cnt <= 0;
    else 
      if(we & ~re & cnt != 4'hF)
        cnt <= cnt + 1;
      else 
        if(~we & re & cnt != 4'h0)
           cnt <= cnt - 1;
  end 
    
  wire [35:0] RAM_O;
  reg  [35:0] DO_reg;
  always @(posedge clk)
     DO_reg <= RAM_O;
  
  assign DO = DO_reg;
  
  reg [3:0] addr_I;
  always @(posedge clk) begin
    if(reset) 
       addr_I <= 4'h0;
    else
       if(we) 
          addr_I <= addr_I+1;
  end
    
  reg [3:0] addr_O;
  always @(posedge clk) begin
    if(reset) 
       addr_O <= 4'h0;
    else
       if(re & has_data) 
          addr_O <= addr_O+1;
  end
      
  Memory #(
  .RAM_WIDTH(36),
  .RAM_DEPTH(16),
  .RAM_PERFORMANCE("HIGH_PERFORMANCE")
//  .RAM_PERFORMANCE("LOW_LATENCY")
) Fifo_mem (
  .addra(addr_I),
  .clka(clk),
  .wea(we),
  .dina(DI),

  .addrb(addr_O),
  .clkb(clk),
  .enb(1'b1),
  .regceb(1'b1),
  .rstb(reset),
  .doutb(RAM_O) 
);
    
    
endmodule
