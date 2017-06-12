`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2016 03:38:57 AM
// Design Name: 
// Module Name: tmux_gen
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


module tmux_gen(
    input clk320,
    input [2:0] O,
    input [1:0] F3,
    output [2:0] TMUX,
    output [1:0] TMUX_OFF
    );
    
  reg [2:0] TMUX_reg;
  reg [1:0] TMUX_OFF_reg;
  assign TMUX = TMUX_reg;
  assign TMUX_OFF = TMUX_OFF_reg;
  
  always @(posedge clk320) begin  
     TMUX_reg[0] <= O[0];
     case(F3)
     2'b00: begin
              TMUX_reg[1] <= ~O[2] & O[1];
              TMUX_reg[2] <=  O[2] & ~O[1];
              TMUX_OFF_reg[0] <= O[2] & O[1];
              TMUX_OFF_reg[1] <= 1'b0;
            end
     2'b01: begin
              TMUX_reg[1] <=  O[2] ^~ O[1];
              TMUX_reg[2] <=  ~O[2] & O[1];
              TMUX_OFF_reg[0] <= ~O[2];
              TMUX_OFF_reg[1] <= O[2];
            end
     2'b10: begin
              TMUX_reg[1] <=  O[2] & ~O[1];
              TMUX_reg[2] <=  O[2] ^~ O[1];
              TMUX_OFF_reg[0] <= O[2] | O[1];
              TMUX_OFF_reg[1] <= 1'b1;
            end
     endcase
  end  
endmodule
