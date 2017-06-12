`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 12:52:04 AM
// Design Name: 
// Module Name: M2Z
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


module M2Z
   #(
     parameter Z1 = 0,
     parameter NPHI = 28,
     parameter NETA = 22,
     parameter MZ = 4,
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
    parameter MZ1 = MZ-1;
    
    reg reset_reg;
    reg start_reg;
    reg stop_reg;
    reg [31:0] cluster_in_reg;
    always @(posedge clk) begin
       reset_reg <= reset;
       start_reg <= start;
       stop_reg  <= stop;
       cluster_in_reg <= cluster_in;
    end
    
    //wire in the cluster finding
    wire         done[MZ1:0];
    wire [MZ1:0] all_done;// defined as a bus instead of vector so that's easy to 
                               // code when all is done
    wire [15:0]  ht[MZ1:0];
    wire [31:0]  jet_out[MZ1:0];
    wire [4:0]   num[MZ1:0];   
    
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
      for(i=0; i<MZ; i = i + 1) begin
       M1Z #(.Z1(Z1+i*NZ), .NZ(NZ), .NPHI(NPHI), .NETA(NETA)) Module1Z
         (
           .clk(clk),
           .reset(reset_reg),//i
           .start(start_reg),//i
           .stop(stop_reg),//i
           .cluster_in(cluster_in_reg),//i
        
           .done_max(done[i]),//o
           .all_done_max(all_done[i]),
        
           .jet_addr(jet_addr),//i     
           .HTmax(ht[i]),      //o
           .JETmax(jet_out[i]),    //o
           .Nmax(num[i])         //o  
         );
            
        end
      endgenerate

   wire [3:0] SELmax;
//   sel_max4 #(.WIDTH(16)) Smax 
   sel_max8 #(.WIDTH(16)) Smax 
      (
      .clk(clk),
      .reset(done_max),
      
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
