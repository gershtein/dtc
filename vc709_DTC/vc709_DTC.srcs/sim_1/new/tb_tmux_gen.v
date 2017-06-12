`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 03:27:44 AM
// Design Name: 
// Module Name: tb_tmux_gen
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


module tb_tmux_gen(

    );
    
    reg clk;
    always begin
      #1 clk <= ~clk;
    end
    reg clk8;
    always begin
      #4 clk8 <= ~clk8;
    end
    
    reg enable;
    reg [2:0] offset;
    reg [1:0] F3;
     
    wire [2:0] TMUX;
    wire [1:0] TMUX_OFF;
     
    reg w00, w01, w10, w11;
    initial begin
      clk = 1;
      clk8 = 1;
      enable = 0;
      w00 = 0 ^~ 0;
      w01 = 0 ^~ 1;
      w10 = 1 ^~ 0;
      w11 = 1 ^~ 1;
      
      #6 enable = 1;
    end 
          
    always @(posedge clk8) begin
      if(!enable)
        offset <= 3'b000;
      else
        offset <= offset + 1;
    end
    always @(posedge clk8) begin
      if(!enable)
        F3 <= 2'b00;
      else 
        if(offset == 3'b111) begin
           case(F3)
           2'b00: F3 <= 2'b01;
           2'b01: F3 <= 2'b10;
           2'b10: F3 <= 2'b00;
           endcase
        end
    end
     
    tmux_gen U(
        .clk320(clk),
        .O(offset),
        .F3(F3),
        .TMUX(TMUX),
        .TMUX_OFF(TMUX_OFF)
     );
    
    
endmodule
