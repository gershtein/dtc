`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2016 12:49:42 PM
// Design Name: 
// Module Name: jet_cand
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


module jet_cand(
    input clk,
    input reset,
    input useAL,
    input useAR,
    input [15:0] AL,
    input [15:0] AR,
    input [15:0] E_add,
    input add_valid,
    output reg useEL,
    output reg useER,
    output reg [15:0] EL,
    output reg [15:0] ER,
    output reg [15:0] E_jet,
    output reg is_jet
    );
    
    //registers for high performance
    reg       useAAL;
    reg       useAAR;
    reg [15:0] AAL;
    reg [15:0] AAR;
    reg       add_valid_reg;
    reg [15:0] E_add_reg;
    always @(posedge clk) begin
       useAAL <= useAL;
       useAAR <= useAR;
       AAL <= AL;
       AAR <= AR;
       E_add_reg <= E_add;
       add_valid_reg <= add_valid;
    end
    
    
    //the center of this 3x3 jet
    reg [15:0] E;
    always @(posedge clk) begin
       if(reset)
          E <= 0;
       else if(add_valid_reg)
          E <= E + E_add_reg;
    end
    
    //true if this is a local maximum
    wire J;
    assign J = E>AAL & E>AAR;
    
    //report to neighbor if it is the highest of our neighbors
    always @(posedge clk) begin
       useEL <= AAL>AAR; 
       useER <= AAR>AAL; 
       EL <= E;
       ER <= E;
    end
    
    //cluster sum 
    reg [15:0] D;
    always @(posedge clk) begin
        D <= (useAAL ? AAL:0) + (useAAR ? AAR:0);
    end
    
    //output
    always @(posedge clk) begin
        if(J) begin
            E_jet <= E + D;
            is_jet <= 1;
        end    
        else begin
            E_jet <= 0;
            is_jet <= 0;
        end    
    end
    
    
endmodule
