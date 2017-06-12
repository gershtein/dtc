`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 01:55:59 AM
// Design Name: 
// Module Name: link_mem
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

//holds four fifos corresponding to the four TMUX6 offsets for data in 3 boxcars
//multiplexes the output of the four
//read out by setting rd_en and OFF_OUT to the desired offset (set by state machine) 

module link_mem(
    input clk,
    input reset0,
    input reset1,
    input reset2,
    input reset3,
    input [2:0] TMUX,
    input [1:0] TMUX_OFF,
    input [1:0] sector,
    input valid,
    input [35:0] stub_in,
    input [11:0] BX,
    input [2:0] BX_OFF,
    input rd_en,         //read enable
    input [1:0] OFF_OUT, 
    output [35:0] stub_out,
    output has_data
    );
    
    parameter myTMUX = 0;
    parameter mySECT = 0;
    
    reg valid1, valid2;
    always @(posedge clk) begin
       valid1 <= valid;
       valid2 <= valid1;
    end
    
    reg [3:0] re_dly;
    always @(posedge clk) begin
      re_dly[0] <= rd_en;
      re_dly[1] <= re_dly[0];
      re_dly[2] <= re_dly[1];
      re_dly[3] <= re_dly[2];
    end
    reg [2:0] hd_dly;
    always @(posedge clk) begin
      hd_dly[0] <= has_data;
      hd_dly[1] <= hd_dly[0];
      hd_dly[2] <= hd_dly[1];
    end
    //these delays change depending on the Fifo latency
    wire valid_out = re_dly[2]&hd_dly[1];
    //delay OFF_OUT by 2 clocks (the fifo latency!)
    reg [1:0] OFF_OUT1;
    reg [1:0] OFF_OUT2;
    always @(posedge clk) begin
      OFF_OUT1 <= OFF_OUT;
      OFF_OUT2 <= OFF_OUT1;
    end
    
    
    wire wehere = (TMUX == myTMUX) & (sector == mySECT) & valid2;
    wire we0 = (TMUX_OFF==0) & wehere;
    wire we1 = (TMUX_OFF==1) & wehere;
    wire we2 = (TMUX_OFF==2) & wehere;
    wire we3 = (TMUX_OFF==3) & wehere;
    
    wire re0, re1, re2, re3;
    assign re0 = rd_en & (OFF_OUT==0);
    assign re1 = rd_en & (OFF_OUT==1);
    assign re2 = rd_en & (OFF_OUT==2);
    assign re3 = rd_en & (OFF_OUT==3);
    
    wire [35:0] stub0;
    wire [35:0] stub1;
    wire [35:0] stub2;
    wire [35:0] stub3;
    reg  [35:0] stub_out_reg;
    assign stub_out = stub_out_reg;
        
    always @(posedge clk) begin
      if(valid_out)
        case(OFF_OUT2)
        2'b00: stub_out_reg <= stub0;
        2'b01: stub_out_reg <= stub1;
        2'b10: stub_out_reg <= stub2;
        2'b11: stub_out_reg <= stub3;
        endcase
      else
        stub_out_reg <= 0;
    end

    wire has_data0, has_data1, has_data2, has_data3;
    reg has_data_reg;
    assign has_data = has_data_reg;
    always @(posedge clk) begin
      case(OFF_OUT)
      2'b00: has_data_reg <= has_data0;
      2'b01: has_data_reg <= has_data1;
      2'b10: has_data_reg <= has_data2;
      2'b11: has_data_reg <= has_data3;
      endcase
    end
    
    BetterFifo M0 (
       .clk(clk),
       .reset(reset0),
       .we(we0),
       .DI(stub_in),
       .DO(stub0),
       .re(re0),
       .has_data(has_data0)
    );
    BetterFifo M1 (
       .clk(clk),
       .reset(reset1),
       .we(we1),
       .DI(stub_in),
       .DO(stub1),
       .re(re1),
       .has_data(has_data1)
    );
    BetterFifo M2 (
       .clk(clk),
       .reset(reset2),
       .we(we2),
       .DI(stub_in),
       .DO(stub2),
       .re(re2),
       .has_data(has_data2)
    );
    BetterFifo M3 (
       .clk(clk),
       .reset(reset3),
       .we(we3),
       .DI(stub_in),
       .DO(stub3),
       .re(re3),
       .has_data(has_data3)
    );
    
    
endmodule
