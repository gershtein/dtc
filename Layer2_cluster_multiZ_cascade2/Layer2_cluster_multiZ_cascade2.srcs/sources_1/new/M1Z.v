`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2016 11:30:57 PM
// Design Name: 
// Module Name: M1Z
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


module M1Z
 #(  
   parameter Z1 = 0,
   parameter NPHI = 28,
   parameter NETA = 22,
   parameter NZ = 4
  )
  (
    input clk,
    input reset,
    input start,
    input stop,
    input [31:0] cluster_in,
    
    input   [4:0] jet_addr,
    output [15:0] HTmax, 
    output [31:0] JETmax,
    output  [4:0] Nmax,
    output        done_max,
    output        all_done_max
  );

   parameter NZ1 = NZ-1; 

   wire        done[NZ1:0];
   wire [NZ1:0]all_done;   // defined as a bus instead of vector so that's easy to 
                           // code when all is done
   wire [31:0] jet_out[NZ1:0];
   wire [15:0] ht_wire[NZ1:0];
   wire  [4:0] num[NZ1:0];

//attempt to improve timing
   reg [15:0] ht[NZ1:0];

   reg  done_dly;
   always @(posedge clk) 
     done_dly <= done[0];
   assign done_max = done_dly;
  
   reg  all_done_reg;
   always @(posedge clk) 
      all_done_reg <= (all_done == {NZ{1'b1}});
   assign all_done_max = all_done_reg;
   
   genvar i;
   generate   
     for(i=0; i<NZ; i = i+1) begin : Zbins
       rowclust #(.NPHI(NPHI),.NETA(NETA), .ZBIN(i+Z1)) Uclust
        (
          .clk(clk),    //i
          .reset(reset),//i
          .start(start),//i
          .stop(stop),//i
    
          .cluster_in(cluster_in),//i
    
          .done (done[i]),             //o
          .all_done(all_done[i]),      //o

          .all_ht(ht_wire[i]),               //o
          .final_jet_addr(jet_addr), //i     
          .final_jet_out(jet_out[i]),   //o
          .final_num(num[i])            //o     
        );
     
        always @(posedge clk) 
          ht[i] <= ht_wire[i];
     
     end   
   endgenerate     

   wire [3:0] SELmax;
//   sel_max4 #(.WIDTH(16)) Smax 
   sel_max8 #(.WIDTH(16)) Smax 
      (
      .clk(clk),
      .reset(done_dly),
      
      .in0(ht[0]),
      .in1(ht[1]),
      .in2(ht[2]),
      .in3(ht[3]),
      .in4(ht[4]),
      .in5(ht[5]),
      .in6(ht[6]),
      .in7(ht[7]),
//      .in8(ht[8]),
//      .in9(ht[9]),
//      .inA(ht[10]),
//      .inB(ht[11]),
//      .inC(ht[12]),
//      .inD(ht[13]),
//      .inE(ht[14]),
//      .inF(ht[15]),
      
      .max(HTmax),
      .sel(SELmax)
      );

//   prio_mux4 muxD
   prio_mux8 muxD
   (
      .clk(clk),
      .sel({1'b0,SELmax}),
      .i0(jet_out[0]),
      .i1(jet_out[1]),
      .i2(jet_out[2]),
      .i3(jet_out[3]),
      .i4(jet_out[4]),
      .i5(jet_out[5]),
      .i6(jet_out[6]),
      .i7(jet_out[7]),
//      .i8(jet_out[8]),
//      .i9(jet_out[9]),
//      .i10(jet_out[10]),
//      .i11(jet_out[11]),
//      .i12(jet_out[12]),
//      .i13(jet_out[13]),
//      .i14(jet_out[14]),
//      .i15(jet_out[15]),
      .o(JETmax)
   );
   
//   prio_mux4 #(.WIDTH(5)) muxN 
   prio_mux8 #(.WIDTH(5)) muxN 
      (
      .clk(clk),
      .sel({1'b0,SELmax}),
      .i0(num[0]),
      .i1(num[1]),
      .i2(num[2]),
      .i3(num[3]),
      .i4(num[4]),
      .i5(num[5]),
      .i6(num[6]),
      .i7(num[7]),
//      .i8(num[8]),
//      .i9(num[9]),
//      .i10(num[10]),
//      .i11(num[11]),
//      .i12(num[12]),
//      .i13(num[13]),
//      .i14(num[14]),
//      .i15(num[15]),
      .o(Nmax)
      );
    
endmodule
