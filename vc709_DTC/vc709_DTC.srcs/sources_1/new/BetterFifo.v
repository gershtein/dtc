`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2016 03:41:53 PM
// Design Name: 
// Module Name: BetterFifo
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


module BetterFifo(
    input clk,
    input we,
    input [35:0] DI,
    input reset,
    input re,
    output [35:0] DO,
    output has_data
    );
    
    
  reg [3:0] cnt; //number of items in fifo
  reg has_data_reg;
  assign has_data = has_data_reg;

  
  always @(posedge clk) begin
    if(reset) begin
      cnt <= 0;
      has_data_reg <= 0;
    end
    else 
      if(we & ~re) begin
         if(cnt != 4'hF) 
            cnt <= cnt + 1;
         has_data_reg <= 1;
      end
      else if (~we & re) begin
         if(cnt != 4'h0)
            cnt <= cnt - 1;
         if((cnt == 4'h0) ||(cnt == 4'h1))
            has_data_reg <= 0;
      end
      else if (we  & re) begin
         has_data_reg <= 1;
      end      
  end 
    
  reg  valid;
  reg  valid1;
  reg  valid2;  //delay re by the latency of the memory, in order to read zeroes from empty fifo
  always @(posedge clk) begin
     valid <= re & has_data;
     valid1 <= valid;
     valid2 <= valid1;
  end
  
  wire [35:0] RAM_O;
  reg  [35:0] DO_reg;
  always @(posedge clk)
     DO_reg <= RAM_O;
  
  assign DO = (valid2) ? DO_reg : 36'h000000000; //only send non-zeroes if the fifo is not empty
  
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
