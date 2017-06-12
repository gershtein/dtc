`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 04:35:05 AM
// Design Name: 
// Module Name: DTC_SM
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


module DTC_SM(
    input clk320,
    input top_reset,
    output reg reset,
    output reg start,
    output reg [1:0] OFF_OUT,
    output reg reset0,
    output reg reset1,
    output reg reset2,
    output reg reset3,
    output reg hold
    );
    
    parameter LATENCY=95;  //200ns -1
    parameter START  = 10;  //wait after reset before issuing start
    
    // three 8BX boxcars result in four TMUX6 outputs
    parameter L0  = START;
    parameter L0a = L0 + 1;
    parameter L1  = L0 + LATENCY; // TMUX offset 0
    parameter L1a = L1 + 1;
    parameter L2  = L1 + 48;      // TMUX offset 1
    parameter L2a = L2 + 1;
    parameter L3  = L2 + 48;      // TMUX offset 2
    parameter L3a = L3 + 1;
    parameter L4  = L3 + 48;      // TMUX offset 3
    parameter L4a = L4 + 1;
    parameter L5  = L4 + 47;      // loop to TMUX offset 0
    
    
    //the state machine counter
    reg [9:0] count;
    always @(posedge clk320) begin
      if(top_reset) 
        count <= 0;
      else if(count == L5)
              count <= L1; //back to TMUX offset 0
           else
              count <= count + 1;
    end

    //logic
    always @(posedge clk320) begin
      if(top_reset) begin
        reset <= 0;
        start <= 0;
        OFF_OUT <= 2'b00;
        reset0 <= 0;
        reset1 <= 0;
        reset2 <= 0;
        reset3 <= 0;
        hold   <= 1;
      end
      else begin
        case(count)
        10'd1: begin  
                reset <= 1;
                reset0 <= 1;
                reset1 <= 1;
                reset2 <= 1;
                reset3 <= 1;
               end
        10'd2: begin
                reset <= 0;
                reset0 <= 0;
                reset1 <= 0;
                reset2 <= 0;
                reset3 <= 0;
               end
        L0  :   start <= 1;
        L0a :   start <= 0;
        L1  : begin
                hold  <= 0;
                OFF_OUT <= 2'b00;
                reset3 <= 1;
              end
        L1a :   reset3 <= 0;
        L2  : begin
                OFF_OUT <= 2'b01;
                reset0 <= 1;
              end
        L2a :   reset0 <= 0;
        L3  : begin
                OFF_OUT <= 2'b10;
                reset1 <= 1;
              end
        L3a :   reset1 <= 0;
        L4  : begin
                OFF_OUT <= 2'b11;
                reset2 <= 1;
              end
        L4a :   reset2 <= 0;
        endcase
      end
    end
    
endmodule
