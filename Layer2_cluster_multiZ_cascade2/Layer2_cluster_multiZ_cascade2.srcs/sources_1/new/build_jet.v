`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2016 03:05:49 PM
// Design Name: 
// Module Name: build_jet
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


module build_jet
 #(
   parameter NPHI1 = 27
  )
  (
    input clk,
    input reset,
    input start,
    
    input [15:0] Center,
    input [15:0] Left,
    input [15:0] Right,
    
    input [15:0] Em2,
    input [15:0] Em1,
    input [15:0] Ep1,
    input [15:0] Ep2,
    output  [15:0] Etom2,
    output  [15:0] Etom1,
    output  [15:0] Etop1,
    output  [15:0] Etop2,
    
    output reg [4:0] addr, //request phi bin
    
    output [20:0] Jet, //output
    output jet_valid,   //valid output
    output reg done
  );
  
  //lagging addr: 4 clocks delay from algorithm and 2 more from memory latency
  reg [4:0] addr1=0;
  reg [4:0] addr2=0;
  reg [4:0] addr3=0;
  reg [4:0] addr4=0;
  reg [4:0] addr5=0;
  reg [4:0] addr6=0;
  always @(posedge clk) begin
    addr1 <= addr;
    addr2 <= addr1;
    addr3 <= addr2;
    addr4 <= addr3;
    addr5 <= addr4;
    addr6 <= addr5;
  end
  
  //
  reg Jvalid = 0;
  reg [4:0] Jphi;
  reg [15:0] Ecl;
  reg [15:0] Ecl_out;
  reg [15:0] E0;
  reg [15:0] E1;
  reg [15:0] E2;
  assign jet_valid = Jvalid;
  assign Jet = {Jphi[4:0],Ecl[15:0]}; 
 
  reg [15:0] Ec;
  reg [15:0] En;  
  wire [15:0] El;  
  wire [15:0] Er; 
  assign El = (Ecl > Em2)? Left  : 0;
  assign Er = (Ecl > Ep2)? Right : 0;
  always @(posedge clk) begin
    if(reset) begin
      Ec <= 0;
      En <= 0;
    end
    else begin
      Ec <= Center;
      En <= El + Er;
    end
  end
  
  assign Etom2 = Ecl_out;
  assign Etom1 = Ecl_out;
  assign Etop1 = Ecl_out;
  assign Etop2 = Ecl_out;
  
  //state machine 
  parameter IDLE= 8'b00000001;
  parameter S0  = 8'b00000010;
  parameter S00 = 8'b00000100;
  parameter S01 = 8'b00001000;
  parameter S1  = 8'b00010000;
  parameter S11 = 8'b00100000;
  parameter S2  = 8'b01000000;
  parameter S22 = 8'b10000000;
    
  reg [7:0] state = S0;  
  always @(posedge clk) begin
     if(reset) begin
        state <= IDLE;
        Jvalid <=0;
        Jphi   <=0;
        addr   <=0;
        done   <=0;
        E0  <= 0;
        E1  <= 0;
        E2  <= 0;
        Ecl     <= 0;
        Ecl_out <= 0;
     end
     else
       case (state)
         IDLE: begin
           Jvalid <=0;
           done   <=0;
           if(start) begin
             addr  <= 1;
             state <= S0;
           end
           else begin
             addr  <= 0;
             state <= IDLE;
           end
         end
         S0  : begin
           Jvalid <=0;
           E1 <=0;
           E2 <=0;
           if(addr == NPHI1) begin
             done <=1;
             state<= IDLE;
           end
           else if(Ec > 0 && Em1==0 && Ep1 == 0) begin
             E0  <= Ec;
             Ecl     <= Ec;
             Ecl_out <= Ec;
             state <= S01;
           end
           else begin
             E0  <= 0;
             Ecl     <= 0;
             Ecl_out <= 0;
             state <= S00;
           end
         end
         S00 : begin
           addr <= addr + 1;
           Jvalid <=0;
           state <= S0;
         end
         S01 : begin
           addr <= addr + 1;
           Jvalid <=0;
           state <= S1;
         end
         S1  : begin
           Jvalid <=0;
           E2 <= 0;
           if(addr == NPHI1) begin
             done <=1;
             state<= IDLE;
           end
           else if(Ec >0 ) 
             E1 <= Ec;
           else
             E1 <= En;
           state <= S11; 
         end
         S11 : begin
           addr <= addr + 1;
           Ecl     <= E0 + E1;
           if(E1 < E0) begin
              Ecl_out <= 0;
              Jphi    <= addr4;
              Jvalid  <= 1;
              state   <= S0;
           end
           else begin
              Ecl_out <= E0 + E1;
              Jvalid <=0;
              state   <= S2;
           end
         end
         S2 : begin
           Jvalid <=0;
           Ecl     <= E0 + E1;
           Ecl_out <= E0 + E1;
           if(addr == NPHI1) begin
             done <=1;
             state<= IDLE;
           end
           else begin
             if(Ec > 0)
               E2 <= Ec;
             else
               E2 <= En;
           state <= S22; 
           end
         end
         S22 : begin
           addr <= addr + 1;
           if( E2 < E1) begin
              Ecl     <= Ecl + E2;
              Ecl_out <= 0;
              Jphi   <= addr4;
              Jvalid <= 1;
              state  <= S0;
           end
           else begin
              Ecl    <= E0;
              Ecl_out<= E0;
              E0     <= E1;
              E1     <= E2;
              Jphi   <= addr6;
              Jvalid <= 1;
              state  <= S2;
           end
         end
       endcase
  end
    
endmodule
