`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2016 04:38:59 PM
// Design Name: 
// Module Name: FoundJets
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


module FoundJets(
    input clk,
    input reset,
    input valid,
    input [31:0] din,
    input [4:0]  addr,
    
    output [31:0] dout,
    output [4:0]  num

    );
    
    reg [4:0] addra; //increments with each valid
    always @(posedge clk) begin
      if(reset) 
        addra <= 0;
      else
        if(valid)
          addra <= addra + 1;
    end
    reg [4:0] num_reg;
    always @(posedge clk)
      num_reg <= addra + 1;
    assign num = num_reg;
    
    Memory #(   
        .RAM_WIDTH(32),
        .RAM_DEPTH(32),
        .RAM_PERFORMANCE("LOW_LATENCY")
      ) jet_mem
      (
        .clka(clk),
        .clkb(clk),
        .addra(addra),
        .dina(din),
        .wea (valid),
        
        .rstb(reset),
        .enb(1'b1),
        .regceb(1'b1),
        .addrb(addr),
        .doutb(dout)
      );
     
endmodule
