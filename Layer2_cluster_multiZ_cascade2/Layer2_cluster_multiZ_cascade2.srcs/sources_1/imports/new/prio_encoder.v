// Priority encoder to choose the next memory block that contains data. It
// skips over empty blocks.

`timescale 1ns / 1ps

module prio_encoder(
    // Inputs:
    input clk,
    input has_dat00,
    input has_dat01,
    input has_dat02,
    input has_dat03,
    input has_dat04,
    input has_dat05,
    input has_dat06,
    input has_dat07,
    input has_dat08,
    input has_dat09,
    input has_dat10,
    input has_dat11,
    input has_dat12,
    input has_dat13,
    input has_dat14,
    input has_dat15,
    input has_dat16,
    input has_dat17,
    input has_dat18,
    input has_dat19,
    input has_dat20,
    input has_dat21,
//    input has_dat22,
    // Outputs:
    output reg sel00,
    output reg sel01,
    output reg sel02,
    output reg sel03,
    output reg sel04,
    output reg sel05,
    output reg sel06,
    output reg sel07,
    output reg sel08,
    output reg sel09,
    output reg sel10,
    output reg sel11,
    output reg sel12,
    output reg sel13,
    output reg sel14,
    output reg sel15,
    output reg sel16,
    output reg sel17,
    output reg sel18,
    output reg sel19,
    output reg sel20,
    output reg sel21,
//    output reg sel22,
    output reg [4:0] sel,   // binary encoded
    output reg none
);

//////////////////////////////////////////////////////////////////////////
// Implement a registered priority encoder
// The '00' input has the highest priority

wire wsel00, wsel01, wsel02, wsel03, wsel04, wsel05, wsel06, wsel07, wsel08, wsel09, wsel10, wsel11, wsel12, wsel13, wsel14, wsel15, wsel16, wsel17, wsel18, wsel19, wsel20, wsel21, wsel22;
assign wsel00 = has_dat00;
assign wsel01 = has_dat01 & !has_dat00;
assign wsel02 = has_dat02 & !has_dat00 & !has_dat01;
assign wsel03 = has_dat03 & !has_dat00 & !has_dat01 & !has_dat02;
assign wsel04 = has_dat04 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03;
assign wsel05 = has_dat05 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04;
assign wsel06 = has_dat06 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05;
assign wsel07 = has_dat07 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06;
assign wsel08 = has_dat08 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07;
assign wsel09 = has_dat09 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08;
assign wsel10 = has_dat10 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09;
assign wsel11 = has_dat11 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10;
assign wsel12 = has_dat12 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11;
assign wsel13 = has_dat13 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12;
assign wsel14 = has_dat14 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13;
assign wsel15 = has_dat15 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14;
assign wsel16 = has_dat16 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15;
assign wsel17 = has_dat17 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16;

assign wsel18 = has_dat18 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17;
assign wsel19 = has_dat19 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18;
assign wsel20 = has_dat20 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19;
assign wsel21 = has_dat21 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20;
//assign wsel22 = has_dat22 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 & !has_dat20 & !has_dat21;


always @ (posedge clk) begin
    sel00 <= wsel00;
    sel01 <= wsel01;
    sel02 <= wsel02;
    sel03 <= wsel03;
    sel04 <= wsel04;
    sel05 <= wsel05;
    sel06 <= wsel06;
    sel07 <= wsel07;
    sel08 <= wsel08;
    sel09 <= wsel09;
    sel10 <= wsel10;
    sel11 <= wsel11;
    sel12 <= wsel12;
    sel13 <= wsel13;
    sel14 <= wsel14;
    sel15 <= wsel15;
    sel16 <= wsel16;
    sel17 <= wsel17;
    sel18 <= wsel18;
    sel19 <= wsel19;
    sel20 <= wsel20;
    sel21 <= wsel21;
//    sel22 <= wsel22;
   // assert 'none' when all inputs are false
    none <= !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 &
            !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19 &
            !has_dat20 & !has_dat21;// & !has_dat22;
end 

//////////////////////////////////////////////////////////////////////////
// Implement an 2:5 encoder. The final mux that combines the memory streams
// works better with with an encoded select as compared to individual select signals.
always @ (posedge clk) begin
    if (wsel00) sel <= 5'b00000;
    if (wsel01) sel <= 5'b00001;
    if (wsel02) sel <= 5'b00010;
    if (wsel03) sel <= 5'b00011;
    if (wsel04) sel <= 5'b00100;
    if (wsel05) sel <= 5'b00101;
    if (wsel06) sel <= 5'b00110;
    if (wsel07) sel <= 5'b00111;
    if (wsel08) sel <= 5'b01000;
    if (wsel09) sel <= 5'b01001;
    if (wsel10) sel <= 5'b01010;
    if (wsel11) sel <= 5'b01011;
    if (wsel12) sel <= 5'b01100;
    if (wsel13) sel <= 5'b01101;
    if (wsel14) sel <= 5'b01110;
    if (wsel15) sel <= 5'b01111;
    if (wsel16) sel <= 5'b10000;
    if (wsel17) sel <= 5'b10001;
    if (wsel18) sel <= 5'b10010;
    if (wsel19) sel <= 5'b10011;
    if (wsel20) sel <= 5'b10100;
    if (wsel21) sel <= 5'b10101;
//    if (wsel22) sel <= 5'b10110;
end
           
endmodule
