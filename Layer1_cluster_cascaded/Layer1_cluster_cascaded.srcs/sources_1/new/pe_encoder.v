`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2016 02:30:21 PM
// Design Name: 
// Module Name: pe_encoder
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


module pe_encoder(
   // Inputs:
    input clk,
    input has_dat00,
    input has_dat01,
    input has_dat02,
    input has_dat03,
    input has_dat04,
    input has_dat05,

    // Outputs:
    output reg sel00,
    output reg sel01,
    output reg sel02,
    output reg sel03,
    output reg sel04,
    output reg sel05,

    output reg [2:0] sel,   // binary encoded
    output reg none
);

//////////////////////////////////////////////////////////////////////////
// Implement a registered priority encoder
// The '00' input has the highest priority

wire wsel00, wsel01, wsel02, wsel03, wsel04, wsel05;
assign wsel00 = has_dat00;
assign wsel01 = has_dat01 & !has_dat00;
assign wsel02 = has_dat02 & !has_dat00 & !has_dat01;
assign wsel03 = has_dat03 & !has_dat00 & !has_dat01 & !has_dat02;
assign wsel04 = has_dat04 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03;
assign wsel05 = has_dat05 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04;

always @ (posedge clk) begin
    sel00 <= wsel00;
    sel01 <= wsel01;
    sel02 <= wsel02;
    sel03 <= wsel03;
    sel04 <= wsel04;
    sel05 <= wsel05;
   // assert 'none' when all inputs are false
    none <= !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05;
end 

//////////////////////////////////////////////////////////////////////////
// Implement sel encoder. The final mux that combines the memory streams
// works better with with an encoded select as compared to individual select signals.
always @ (posedge clk) begin
    if (wsel00) sel <= 3'b000;
    if (wsel01) sel <= 3'b001;
    if (wsel02) sel <= 3'b010;
    if (wsel03) sel <= 3'b011;
    if (wsel04) sel <= 3'b100;
    if (wsel05) sel <= 3'b101;
end
           

endmodule
