`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2016 03:37:30 PM
// Design Name: 
// Module Name: merge_jet
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


module merge_jet(
    input clk,
    input reset,

    input [20:0] Jet,
    input jet_valid,
    
    output [4:0]  jet_n,
    input  [4:0]  jet_addr,
    output [20:0] jet_out
    );
    
    //
    reg [15:0] last_et;    //last jet et
    reg  [4:0] last_phi;   //last jet phi
    reg  [4:0] next_phi;  //next phi bin 
    
    reg [4:0] addra; //address to write next jet
    
    //logic
    wire  [4:0] jet_phi = Jet[20:16];
    wire [15:0] jet_et  = Jet[15:0];
    wire merge = (jet_phi == next_phi);
    wire shift = (jet_et  >  last_et);
    
    //   
    always @(posedge clk) begin
      if(reset) begin
        addra <= 5'b0;
        last_phi <= 5'b0;
        last_et  <= 16'b0;
        next_phi <= 5'b11111;
      end
      else begin
        if(jet_valid) begin 
           next_phi<= jet_phi + 1; 
           if(~merge) begin //new jet
              last_et <= jet_et;
              last_phi<= jet_phi;
              addra <= addra + 1;
           end
           else begin  //still in a cluster, add to existing
             addra <= addra;
             last_et <= last_et + jet_et;
             if(shift)  
               last_phi <= jet_phi; //cluster moves
             else 
               last_phi <= last_phi;//cluster stays
           end           
        end //endif jet_valid
      end
    end
    assign jet_n = addra;
    
    //jet is written into memory on the next clock
    reg jet_valid_dly;
    always @(posedge clk)
      jet_valid_dly <= jet_valid;
    //re-assemble the jet
    wire [22:0] last_jet = {last_phi, last_et}; 
    Memory #(
      .RAM_WIDTH(21),
      .RAM_DEPTH(32),
      .RAM_PERFORMANCE("LOW_LATENCY")
    ) jet_mem
    (
      .clka(clk),
      .clkb(clk),
      .addra(addra),
      .dina(last_jet),
      .wea (jet_valid_dly),
      
      .rstb(reset),
      .enb(1'b1),
      .regceb(1'b1),
      .addrb(jet_addr),
      .doutb(jet_out)
    );
  
endmodule
