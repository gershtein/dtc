`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2016 11:47:17 AM
// Design Name: 
// Module Name: rowclust
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


module rowclust
 #( 
    parameter ZBIN = 6'b000000,
    parameter NPHI = 28,
    parameter NETA = 22
  )
  (
    input clk,
    input reset,
    input start, //start of broadcasting clusters
    input stop,  //stop of broadcasting clusters  
    input     [31:0] cluster_in,   //from BRAM
    
    output reg done,
    
    input   [4:0]  final_jet_addr,
    output [31:0]  final_jet_out,
    output  [4:0]  final_num,
    
    output  [15:0] all_ht,
    output         all_done
  );
  parameter NETA1 = NETA-1;
  parameter NETA2 = NETA-2;
  parameter NPHI1 = NPHI-1;  
  // fields in input cluster
  // [31:27] -> phi bin
  // [26:22] -> eta bin
  // [17:0]  -> energy 
  reg [5:0] zbin;
  reg [4:0] phibin;
  reg [4:0] etabin;
  reg [15:0] etclus;
  
  always @(posedge clk) begin
    if(reset) begin
      phibin <= 5'h1f;
      etabin <= 5'h1f;
      zbin   <= 6'h3f;
      etclus <= 0;
    end
    else begin
      zbin   <= cluster_in[31:26];
      etabin <= cluster_in[25:21];
      phibin <= cluster_in[20:16];
      etclus <= cluster_in[15:0];
    end
  end  
  
  //generate input memories 
  wire [4:0]     addr[NETA1:0];          
  wire [15:0]   etbin[NETA1:0];
  wire [4:0]    jet_n[NETA1:0];
  //21 bits for 5 phi and 16 eT bits
  wire [20:0]     Jet[NETA1:0];
  wire [20:0] pe_jets[NETA1:0];
  wire [4:0] jet_addr[NETA1:0];          
  wire         pe_sel[NETA1:0];
  wire       pe_valid[NETA1:0];
  wire      pe_hasdat[NETA1:0];
  wire      jet_valid[NETA1:0];
  wire       bin_done[NETA1:0];
  wire       row_done[NETA1:0];
  
  wire [15:0]   Etom2[NETA1:0];
  wire [15:0]   Etom1[NETA1:0];
  wire [15:0]   Etop1[NETA1:0];
  wire [15:0]   Etop2[NETA1:0];
  
  //reader
  parameter IDLE     = 3'b001;
  parameter READING  = 3'b010;
  parameter FINISHED = 3'b100;
  reg [2:0] state = IDLE;
  
  reg start_clust;
  always @(posedge clk) begin
    if(reset) begin
       start_clust  <= 0;
       state <= IDLE;
    end
    else 
      case (state) 
         IDLE: begin
           start_clust  <= 0;
           if(start)
             state <= READING;
           else
             state <= IDLE;
         end
         READING : begin
           start_clust  <= 0;
           if(stop)
             state <= FINISHED;
           else
             state <= READING;
         end
         FINISHED : begin
           start_clust  <= 1;
           state <= IDLE;
         end
      endcase
  end
  
  wire my_z = (zbin == ZBIN);
  
  genvar i;
  generate
    for(i=0; i< NETA; i = i+1) begin : etabins_input
       
       //enable writing only if correct eta bin, correct z bin, and state is READING
       wire wen = (etabin == i) & my_z & state[1];
       Memory #(
         .RAM_WIDTH(18),
         .RAM_DEPTH(32),
         .RAM_PERFORMANCE("LOW_LATENCY")
       ) input_mem
       (
         .clka(clk),
         .clkb(clk),
         .addra(phibin), // address is phi
         .dina(etclus),
         .wea(wen),     
         .rstb(reset),
         .enb(1'b1),
         .regceb(1'b1),
         .addrb(addr[i]),                   // all bins read out at the same time
         .doutb(etbin[i])
       );
    
       build_jet pre_jet //first pass for clustering
        (
         .clk(clk),
         .reset(reset),
         .start(start_clust),
         
         .Center(etbin[i]),
         .Left ( i>0    ? etbin[i-1] : 16'b0),
         .Right( i<NETA1? etbin[i+1] : 16'b0),
         
         .Etom2  (Etom2[i]),
         .Etom1  (Etom1[i]),
         .Etop1  (Etop1[i]),
         .Etop2  (Etop2[i]),
         .Em2(i > 1 ? Etom2[i-2] : 16'b0),
         .Em1(i > 0 ? Etom1[i-1] : 16'b0),
         .Ep1(i < NETA1 ? Etop1[i+1] : 16'b0),
         .Ep2(i > NETA2 ? Etop2[i+2] : 16'b0),
         
         .addr(addr[i]),
         .Jet(Jet[i]),
         .jet_valid(jet_valid[i]),
         .done(row_done[i])
        );

        merge_jet jet //second pass
         (
           .clk(clk),
           .reset(reset),
         
           .Jet(Jet[i]),
           .jet_valid(jet_valid[i]),
         
           .jet_n (jet_n[i]),
           .jet_addr(jet_addr[i]),
           .jet_out(pe_jets[i])
         );

        wire start_pe = row_done[0];
        prio_support pe_support //support circuit for priority encoder readout
         (
           .clk(clk),
           .initial_count(jet_n[i]),
           .init(start_pe),
           .sel(pe_sel[i]),
           .addr(jet_addr[i]),
           .has_dat(pe_hasdat[i]),
           .valid  (pe_valid[i])
         ); 

    end
  endgenerate

  //encoder to read out all the cluster memories
  wire [4:0] pe_sel_enc;
  wire none;

  // with current memory latency, need to delay VALID two clocks
  reg valid_1=0;
  reg valid_2=0;
  wire all_jet_valid;
  assign all_jet_valid = valid_2;
  always @(posedge clk) begin
   valid_1 <= pe_valid[ 0] | pe_valid[ 1] | pe_valid[ 2] | pe_valid[ 3] | pe_valid[ 4] | pe_valid[ 5] | pe_valid[ 6] | pe_valid[ 7] | pe_valid[ 8] | pe_valid[ 9] | 
              pe_valid[10] | pe_valid[11] | pe_valid[12] | pe_valid[13] | pe_valid[14] | pe_valid[15] | pe_valid[16] | pe_valid[17] | pe_valid[18] | pe_valid[19] |
              pe_valid[20] | pe_valid[21] ;
   valid_2 <= valid_1;
  end

//accumulator to calculate ht
  reg [15:0] ht;
  assign all_ht = ht;
  
  wire [31:0] all_jet_out;
  wire rst = reset | start;
  always @(posedge clk) begin
     if(rst) 
        ht <= 0;
     else 
        if(all_jet_valid) ht <= ht + all_jet_out[15:0];
  end

  //final memory
    FoundJets fj
    (
      .clk(clk),
      .reset(rst),
      .valid(all_jet_valid),
      .din(all_jet_out),
      .addr(final_jet_addr),
      
      .dout(final_jet_out),
      .num(final_num)
    );        
  

  prio_mux pe_mux
    (
      .clk(clk),
      .o(all_jet_out),
      .sel(pe_sel_enc),
      //pe_jets contain phi [20:16] and et [15:0]
      //add eta [25:21] add z[31:26]
      .i0({ZBIN,5'b00000,pe_jets[0]}),
      .i1({ZBIN,5'b00001,pe_jets[1]}),
      .i2({ZBIN,5'b00010,pe_jets[2]}),
      .i3({ZBIN,5'b00011,pe_jets[3]}),
      .i4({ZBIN,5'b00100,pe_jets[4]}),
      .i5({ZBIN,5'b00101,pe_jets[5]}),
      .i6({ZBIN,5'b00110,pe_jets[6]}),
      .i7({ZBIN,5'b00111,pe_jets[7]}),
      .i8({ZBIN,5'b01000,pe_jets[8]}),
      .i9({ZBIN,5'b01001,pe_jets[9]}),
      .i10({ZBIN,5'b01010,pe_jets[10]}),
      .i11({ZBIN,5'b01011,pe_jets[11]}),
      .i12({ZBIN,5'b01100,pe_jets[12]}),
      .i13({ZBIN,5'b01101,pe_jets[13]}),
      .i14({ZBIN,5'b01110,pe_jets[14]}),
      .i15({ZBIN,5'b01111,pe_jets[15]}),
      .i16({ZBIN,5'b10000,pe_jets[16]}),
      .i17({ZBIN,5'b10001,pe_jets[17]}),
      .i18({ZBIN,5'b10010,pe_jets[18]}),
      .i19({ZBIN,5'b10011,pe_jets[19]}),
      .i20({ZBIN,5'b10100,pe_jets[20]}),
      .i21({ZBIN,5'b10101,pe_jets[21]})
    );

  prio_encoder pe_encoder
    (
      .clk(clk),
      .has_dat00(pe_hasdat[0]),
      .has_dat01(pe_hasdat[1]),
      .has_dat02(pe_hasdat[2]),
      .has_dat03(pe_hasdat[3]),
      .has_dat04(pe_hasdat[4]),
      .has_dat05(pe_hasdat[5]),
      .has_dat06(pe_hasdat[6]),
      .has_dat07(pe_hasdat[7]),
      .has_dat08(pe_hasdat[8]),
      .has_dat09(pe_hasdat[9]),
      .has_dat10(pe_hasdat[10]),
      .has_dat11(pe_hasdat[11]),
      .has_dat12(pe_hasdat[12]),
      .has_dat13(pe_hasdat[13]),
      .has_dat14(pe_hasdat[14]),
      .has_dat15(pe_hasdat[15]),
      .has_dat16(pe_hasdat[16]),
      .has_dat17(pe_hasdat[17]),
      .has_dat18(pe_hasdat[18]),
      .has_dat19(pe_hasdat[19]),
      .has_dat20(pe_hasdat[20]),
      .has_dat21(pe_hasdat[21]),

      .sel00(pe_sel[0]),
      .sel01(pe_sel[1]),
      .sel02(pe_sel[2]),
      .sel03(pe_sel[3]),
      .sel04(pe_sel[4]),
      .sel05(pe_sel[5]),
      .sel06(pe_sel[6]),
      .sel07(pe_sel[7]),
      .sel08(pe_sel[8]),
      .sel09(pe_sel[9]),
      .sel10(pe_sel[10]),
      .sel11(pe_sel[11]),
      .sel12(pe_sel[12]),
      .sel13(pe_sel[13]),
      .sel14(pe_sel[14]),
      .sel15(pe_sel[15]),
      .sel16(pe_sel[16]),
      .sel17(pe_sel[17]),
      .sel18(pe_sel[18]),
      .sel19(pe_sel[19]),
      .sel20(pe_sel[20]),
      .sel21(pe_sel[21]),

      .sel(pe_sel_enc),
      .none(all_done)
    
    );


  always @(posedge clk) begin
    done     <= row_done[0];
  end
    
endmodule
