`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2016 03:34:18 PM
// Design Name: 
// Module Name: Layer1
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


module Layer1
  #(
     parameter NZ = 64,
     parameter NETA = 24
   )
   (
    input [4:0] PHIBIN,
   
    input clk,
    input reset,
    input start,
    input stop,

    input [31:0] track_in, //tracks are broadcast on start, stopped on stop

    input   [5:0] final_zbin,
    input   [4:0] final_cluster_addr,
    output [31:0] final_cluster_out,
    output  [4:0] final_num,
    
    output reg all_done
    );
    parameter NZ1 = NZ-1;
  
  wire [31:0] cluster[NZ1:0];  
  wire [4:0] num[NZ1:0];  

  wire [NZ1:0]done;
  always @(posedge clk) begin
    if(reset)
      all_done <= 0;
    else
      all_done <= (done == {NZ{1'b1}});
  end
    
  genvar i;
  generate
    for(i=0; i<NZ; i = i+1) begin : zzz
       Zbin #( .ZBIN(i), .NETA(NETA)) UZ
          (
          
             .PHIBIN(PHIBIN),
          
             .clk(clk),
             .reset(reset),
             .start(start),
             .stop(stop),
             .track_in(track_in),
             
             .final_num(num[i]),
             .final_cluster_out(cluster[i]),
             .final_cluster_addr(final_cluster_addr),
             
             .done(done[i])
          );
    end
  endgenerate  
    
    
  //cascading mux'es to get out 64 bins of Z
  wire [31:0] mux_clust[7:0];
  genvar j;
  generate
    for(j=0; j<8; j = j+1) begin : muxbins
      prio_mux8 mu1 (
        .clk(clk),
        .sel(final_zbin[2:0]),
        .i0(cluster[j*8]),
        .i1(cluster[j*8+1]),
        .i2(cluster[j*8+2]),
        .i3(cluster[j*8+3]),
        .i4(cluster[j*8+4]),
        .i5(cluster[j*8+5]),
        .i6(cluster[j*8+6]),
        .i7(cluster[j*8+7]),
        .o(mux_clust[j])
      );
    end
  endgenerate
  prio_mux8 mu2 (
     .clk(clk),
     .sel(final_zbin[5:3]),
     .i0(mux_clust[0]),
     .i1(mux_clust[1]),
     .i2(mux_clust[2]),
     .i3(mux_clust[3]),
     .i4(mux_clust[4]),
     .i5(mux_clust[5]),
     .i6(mux_clust[6]),
     .i7(mux_clust[7]),
     .o (final_cluster_out)
  );  
 
  wire [4:0] mux_num[7:0];
  genvar k;
  generate
    for(k=0; k<8; k = k+1) begin : muxbinsN
      prio_mux8 #(.WIDTH(5)) muN1 (
        .clk(clk),
        .sel(final_zbin[2:0]),
        .i0(num[k*8]),
        .i1(num[k*8+1]),
        .i2(num[k*8+2]),
        .i3(num[k*8+3]),
        .i4(num[k*8+4]),
        .i5(num[k*8+5]),
        .i6(num[k*8+6]),
        .i7(num[k*8+7]),
        .o(mux_num[k])
      );
    end
  endgenerate
  prio_mux8 #(.WIDTH(5)) muN2 (
     .clk(clk),
     .sel(final_zbin[5:3]),
     .i0(mux_num[0]),
     .i1(mux_num[1]),
     .i2(mux_num[2]),
     .i3(mux_num[3]),
     .i4(mux_num[4]),
     .i5(mux_num[5]),
     .i6(mux_num[6]),
     .i7(mux_num[7]),
     .o (final_num)
  );  
    
endmodule
