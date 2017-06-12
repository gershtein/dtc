`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2016 06:29:40 AM
// Design Name: 
// Module Name: tb_fifo
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


module tb_fifo(
    );
    
    reg clk;
    always begin
      #1 clk <= ~clk;
         DI  <= DI + 1; 
    end
    
    reg [9:0]DI;
    reg reset;
    reg we, re;
        
    wire has_data;
    wire [9:0] DO;
    Fifo U(
       .clk(clk),
       .we(we),
       .re(re),
       .reset(reset),
       .DI(DI),
       .DO(DO),
       .has_data(has_data)
    );
    
  initial begin
    clk = 1;
    we = 0;
    re = 0;
    DI = 0;
    reset = 0;

    #2 reset = 1;
    #2 reset = 0;
 
    #10 we = 1;
    #6  re = 1;
    #2  we = 0;
    #2  re = 0;
    #4  we = 1;
    #2  re = 1;
    #2  we = 0;  
    
    #10 re = 0;
    #2  we = 1;
    #2  we = 0;
    #10 re = 1;
    #10 we = 1;
    #4  we = 0;
    
  end
    
    
    
    
endmodule
