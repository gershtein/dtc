`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2016 01:01:08 PM
// Design Name: 
// Module Name: tb_topmergetest
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


module tb_topmergetest(

    );
    
    reg clk;
    always begin
      #1 clk <= ~clk;
    end
    
    reg reset;
    reg start;
    wire [35:0] stub;
        
    tb_mergesm UUSM(
       .clk(clk),
      .reset(reset),
       .start(start),
       .stub_out(stub)
    );
    
  initial begin
    clk = 1;
    start = 0;
    reset = 0;
    
    #10 reset = 1;
    #2  reset = 0;
    
    #10.1 start = 1;
    #2  start = 0;
  end
   
endmodule
