`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2016 09:33:12 AM
// Design Name: 
// Module Name: tb_merge
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


module tb_merge(
    input  clk,

    input          TMUX_hold,      
    input  reset0, reset1, reset2, reset3,

    input  [1:0]ALL_TMUX_OFF,
    
    input  [1:0]ALL_OFF_OUT,
  
    input  [35:0] M01_gstub,
    input  [35:0] M02_gstub,
    input  [35:0] M03_gstub,
    input  [35:0] M04_gstub,
    
    input         M01_valid,
    input         M02_valid,
    input         M03_valid,
    input         M04_valid,
    
    output reg [35:0]stub_out
    );
    
  wire clk320 = clk;
  
  wire [35:0] TMUX_stub;
  always @(posedge clk) begin
     stub_out <= TMUX_stub;
  end

  wire [1:0]  M01_TMUX_OFF = ALL_TMUX_OFF;
  wire [1:0]  M02_TMUX_OFF = ALL_TMUX_OFF;
  wire [1:0]  M03_TMUX_OFF = ALL_TMUX_OFF;
  wire [1:0]  M04_TMUX_OFF = ALL_TMUX_OFF;
  
  wire [1:0]  M01_OFF_OUT = ALL_OFF_OUT;
  wire [1:0]  M02_OFF_OUT = ALL_OFF_OUT;
  wire [1:0]  M03_OFF_OUT = ALL_OFF_OUT;
  wire [1:0]  M04_OFF_OUT = ALL_OFF_OUT;
  
  wire [35:0] M01_gstub_out;
  wire        M01_rd_en;
  wire        M01_has_data;
  link_mem #(.mySECT(0),.myTMUX(0)) 
            LM_01 (
       .clk(clk320),
       .reset0(reset0),
       .reset1(reset1),
       .reset2(reset2),
       .reset3(reset3),
       .TMUX    (2'b00),
       .TMUX_OFF(M01_TMUX_OFF),
       .sector  (2'b00),
       .valid   (M01_valid),
       .stub_in (M01_gstub),
       
       .rd_en   (M01_rd_en),
       .OFF_OUT (M01_OFF_OUT),
       .stub_out(M01_gstub_out),
       .has_data(M01_has_data)
  );
      
  wire [35:0] M02_gstub_out;
  wire        M02_rd_en;
  wire        M02_has_data;
  link_mem #(.mySECT(0),.myTMUX(0)) 
            LM_02 (
       .clk(clk320),
       .reset0(reset0),
       .reset1(reset1),
       .reset2(reset2),
       .reset3(reset3),
       .TMUX    (2'b00),
       .TMUX_OFF(M02_TMUX_OFF),
       .sector  (2'b00),
       .valid   (M02_valid),
       .stub_in (M02_gstub),
       
       .rd_en   (M02_rd_en),
       .OFF_OUT (M02_OFF_OUT),
       .stub_out(M02_gstub_out),
       .has_data(M02_has_data)
  );
      
  wire [35:0] M03_gstub_out;
  wire        M03_rd_en;
  wire        M03_has_data;
  link_mem #(.mySECT(0),.myTMUX(0)) 
            LM_03 (
       .clk(clk320),
       .reset0(reset0),
       .reset1(reset1),
       .reset2(reset2),
       .reset3(reset3),
       .TMUX    (2'b00),
       .TMUX_OFF(M03_TMUX_OFF),
       .sector  (2'b00),
       .valid   (M03_valid),
       .stub_in (M03_gstub),
       
       .rd_en   (M03_rd_en),
       .OFF_OUT (M03_OFF_OUT),
       .stub_out(M03_gstub_out),
       .has_data(M03_has_data)
  );
  
  
  wire [35:0] M04_gstub_out;
  wire        M04_rd_en;
  wire        M04_has_data;
  link_mem #(.mySECT(0),.myTMUX(0)) 
            LM_04 (
       .clk(clk320),
       .reset0(reset0),
       .reset1(reset1),
       .reset2(reset2),
       .reset3(reset3),
       .TMUX    (2'b00),
       .TMUX_OFF(M04_TMUX_OFF),
       .sector  (2'b00),
       .valid   (M04_valid),
       .stub_in (M04_gstub),
       
       .rd_en   (M04_rd_en),
       .OFF_OUT (M04_OFF_OUT),
       .stub_out(M04_gstub_out),
       .has_data(M04_has_data)
  );
      
 ///////////////////////////
 
  wire   [3:0] TMUX_sel;
  merge_mux    TMUX (
    .clk     (clk320),
    .stub00  (M01_gstub_out),
    .stub01  (M02_gstub_out),
    .stub02  (M03_gstub_out),
    .stub03  (M04_gstub_out),
    .sel     (TMUX_sel),
    .stub_out(TMUX_stub)
  );
  merge_pe  #(.DELAY(3))
   TMUX_pe (
     .clk    (clk320),
     .h00    (M01_has_data),
     .h01    (M02_has_data),
     .h02    (M03_has_data),
     .h03    (M04_has_data),
     .hold   (TMUX_hold),
     .re00   (M01_rd_en),
     .re01   (M02_rd_en),
     .re02   (M03_rd_en),
     .re03   (M04_rd_en),
     .sel    (TMUX_sel)
  );
     
          
endmodule
