`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2016 09:36:02 AM
// Design Name: 
// Module Name: tb_DTC_top
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


module tb_DTC_top(

    );
    
    reg clk, reset;
    always begin
      #1.5 clk <= ~clk;
//      #1.5625 clk <= ~clk;
    end

    initial begin
      clk = 1;    
      reset = 0;  
      #48 reset = 1;
      #3 reset = 0;
//      #3.125 reset = 0;
    end 
    
    DTC_top U(
      .clk320(clk),
      .top_reset(reset)
    );
    
endmodule
