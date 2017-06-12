`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2016 09:40:18 AM
// Design Name: 
// Module Name: module_in
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// this is just a buffer. Gets fed either by ipbus or by hand.
// marks the begginning of the boxcar with start_frame signal
//
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module module_in(
    input clk320,
    input clk_in,  //ipbus or something like that
    
    input [31:0] data_i,
    input [9:0]addr,
    input wea,
    
    input start,   
    input reset,   
    output [31:0] data_o,
    output start_frame
    );
  parameter initfile="/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/dummyinput.dat"; 
  
  //state machine
  reg[12:0] count; //hardwired for 1024 memory depth below
                   // 3 LSB are used to divide 320 down to 40 MHz
  always @(posedge clk320) begin
    if(start | reset)
      count <= 0;
    else
      count <= count + 1;
  end

  reg [12:0] count_dly;
  always @(posedge clk320) begin
    if(start) 
      count_dly <= 13'h1FFF;
    else 
      count_dly <= count;
  end
    
  //start frame every 8 counts
  //leads the data_o by one clock in high performance mode
     
  reg start_frame_reg;
  assign start_frame = start_frame_reg;
  always @(posedge clk320) begin
    if(((~count[5:3])&count_dly[5:3])==3'b111)  //every 8 BX
      start_frame_reg <= 1;
    else
      start_frame_reg <= 0;
  end 
    
  Memory #(
  .RAM_WIDTH(32),
  .RAM_DEPTH(256),
//  .RAM_DEPTH(1024),
//  .INIT_FILE("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/module_data.hex"),
  .INIT_FILE(initfile),
  .RAM_PERFORMANCE("HIGH_PERFORMANCE")
//  .RAM_PERFORMANCE("LOW_LATENCY")
) input_tracks (
  .addra(addr),
  .clka(clk_in),
  .wea(wea),
  .dina(data_i),

  .addrb(count[12:3]),
  .clkb(clk320),
  .enb(1'b1),
  .regceb(1'b1),
  .rstb(reset),
  .doutb(data_o) 
);
  
  
  
    
endmodule
