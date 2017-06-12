`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2016 01:53:45 PM
// Design Name: 
// Module Name: Zbin
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


module Zbin
  #(
    parameter ZBIN   = 6'b000000,
    parameter NETA = 24
   )
   (
    input [4:0]PHIBIN,
   
    input clk,
    input reset,
    input start,
    input stop,
    
    input [31:0] track_in, //tracks are broadcast on start, stopped on stop
    
    input   [4:0] final_cluster_addr,
    output [31:0] final_cluster_out,
    output  [4:0] final_num,
    
    output reg done
    
   );
    
    parameter NETA1 = NETA-1;

    //shift register to delay sart_mux while cluster finding settles
    parameter MUX_DELAY = 3;
    reg [MUX_DELAY-1:0] start_mux_reg = {MUX_DELAY{1'b0}};
    wire start_mux = start_mux_reg[MUX_DELAY-1];

    genvar jj;
    generate  //start_mux_reg[0] is dealt with in the state machine
      for(jj=1; jj<MUX_DELAY; jj = jj+1) begin : muxreg
        always @(posedge clk) begin
          if(reset)
            start_mux_reg[jj] <= 1'b0;
          else
            start_mux_reg[jj] <= start_mux_reg[jj-1];
        end
      end
    endgenerate
    
    //little state machine
    parameter IDLE = 4'b0001; //idle
    parameter READ = 4'b0010; //reading in tracks
    parameter DONE = 4'b0100; // finish up and send a signal to priority encoder
    parameter WAIT = 4'b1000; // wait for priority encoder to finish
    
    reg [3:0] state = IDLE;
    wire all_done;
    always @(posedge clk) begin
      if(reset) begin
        done <= 1'b0;
        start_mux_reg[0] <= 1'b0;
        state<=IDLE;
      end
      else begin
        case(state) 
        IDLE : begin
          done <= done;
          start_mux_reg[0] <= 1'b0;
          if(start)
            state <= READ;
          else
            state <= IDLE;
        end
        READ : begin
          done <= 1'b0;
          start_mux_reg[0] <= 1'b0;
          if(stop)
            state <= DONE;
          else
            state <= READ;       
        end
        DONE : begin
          done <= 1'b0;
          start_mux_reg[0] <= 1'b1;
          state     <= WAIT;
        end
        WAIT : begin
          start_mux_reg[0] <= 1'b0;
          if(all_done) begin
            done <= 1'b1;
            state <= IDLE;
          end
          else begin
            done <= 1'b0;
            state <= WAIT;
          end
        end
        endcase
      end
    end
    
    
    //decoder
    reg [15:0] track_pt;
    reg [4:0] track_eta;
    reg [4:0] track_phi;
    reg [5:0] track_z;
    always @(posedge clk) begin
      track_z   <= track_in[31:26];
      track_eta <= track_in[25:21];
      track_phi <= track_in[20:16];
      track_pt  <= track_in[15:0];
    end
    
    //the matrix    
    wire [15:0] AL[NETA1:0];
    wire [15:0] AR[NETA1:0];
    wire    useAL[NETA1:0];
    wire    useAR[NETA1:0];
    
    wire [15:0] E_jet[NETA1:0];
    wire       is_jet[NETA1:0];

    wire    pe_sel[NETA1:0];
    wire  pe_valid[NETA1:0];
    wire pe_hasdat[NETA1:0];     

    wire [3:0] pe2_sel;
    reg  [3:0] pe2_valid1;
    reg  [3:0] pe2_valid2;
    wire [31:0]pe2_E_jet[3:0];
    wire [3:0] none;
    wire [3:0] hold;
    
    //hold the final mux for two clocks after the init
    reg [2:0] hold_dly;
    always @(posedge clk) begin
       hold_dly[0] <= start_mux;
       hold_dly[1] <= hold_dly[0];
    end
    
    assign hold[0] = start_mux|hold_dly[0]|hold_dly[1];   //sets priority for the order of mux cascades
    assign hold[1] = hold[0] | ~none[0];
    assign hold[2] = hold[0] | ~(none[1] & none[0]);
    assign hold[3] = hold[0] | ~(none[2] & none[1] & none[0]);

    assign all_done = (state == WAIT) && (none == 4'hf) && (start_mux_reg == 0);

    genvar i, j;
    //assume NETA = 24 = 6x4
    generate
      for(j=0; j<4; j=j+1) begin: etabin2      
        for(i=0; i<6; i=i+1) begin: etabin1

            wire add_valid = state[1] & (track_z == ZBIN) & 
                             (track_eta == (i+j*6)) & (track_phi == PHIBIN);

            jet_cand jet (
                .clk(clk), 
                .reset(reset), 
                .E_add(track_pt), 
                .add_valid(add_valid),
                .E_jet(E_jet[(i+j*6)]), 
                .is_jet(is_jet[(i+j*6)]),
                .useAL(useAR[((i+j*6)>0?(i+j*6)-1:NETA1)]),
                .useAR(useAL[((i+j*6)<NETA1?(i+j*6)+1:0)]),
                .AL(AR[((i+j*6)>0?(i+j*6)-1:NETA1)]),
                .AR(AL[((i+j*6)<NETA1?(i+j*6)+1:0)]),
                .useEL(useAL[(i+j*6)]),
                .useER(useAR[(i+j*6)]),
                .EL(AL[(i+j*6)]),
                .ER(AR[(i+j*6)]));
                
             pe_channel_used PEU (
                .clk(clk),
                .init(start_mux),
                .hold(hold[j]), //not that J! it's for the cascase
                .have_data(is_jet[(i+j*6)]),
                .sel(pe_sel[(i+j*6)]),
                .have_unused_data(pe_hasdat[(i+j*6)]),
                .valid (pe_valid[(i+j*6)])
             );
        end //i loop

        // with current memory latency, need to delay VALID two clocks (low latency)
        always @(posedge clk) begin
           pe2_valid1[j] <= pe_valid[j*6] | pe_valid[j*6+1] | pe_valid[j*6+2] | pe_valid[j*6+3] | pe_valid[j*6+4] | pe_valid[j*6+5]; 
           pe2_valid2[j] <= pe2_valid1[j];
        end
        
        wire [2:0] pe_sel_enc;
        
        wire [4:0] e0 = j*6;
        wire [4:0] e1 = j*6+1;
        wire [4:0] e2 = j*6+2;
        wire [4:0] e3 = j*6+3;
        wire [4:0] e4 = j*6+4;
        wire [4:0] e5 = j*6+5;
        
        pe_mux PEM  
         (
           .clk(clk),
           .o(pe2_E_jet[j]),
           .sel(pe_sel_enc),
           //E_jet contains et [15:0]
           //add phi [20:16], eta [25:21], z[31:26]
           .i0({ZBIN[5:0],e0,PHIBIN[4:0],E_jet[j*6]}),
           .i1({ZBIN[5:0],e1,PHIBIN[4:0],E_jet[j*6+1]}),
           .i2({ZBIN[5:0],e2,PHIBIN[4:0],E_jet[j*6+2]}),
           .i3({ZBIN[5:0],e3,PHIBIN[4:0],E_jet[j*6+3]}),
           .i4({ZBIN[5:0],e4,PHIBIN[4:0],E_jet[j*6+4]}),
           .i5({ZBIN[5:0],e5,PHIBIN[4:0],E_jet[j*6+5]})       
         );
         
        pe_encoder PE
         (
          .clk(clk),
          .has_dat00(pe_hasdat[j*6]),
          .has_dat01(pe_hasdat[j*6+1]),
          .has_dat02(pe_hasdat[j*6+2]),
          .has_dat03(pe_hasdat[j*6+3]),
          .has_dat04(pe_hasdat[j*6+4]),
          .has_dat05(pe_hasdat[j*6+5]),
       
          .sel00(pe_sel[j*6]),
          .sel01(pe_sel[j*6+1]),
          .sel02(pe_sel[j*6+2]),
          .sel03(pe_sel[j*6+3]),
          .sel04(pe_sel[j*6+4]),
          .sel05(pe_sel[j*6+5]),
       
          .sel(pe_sel_enc),
          .none(none[j])           
         );
 
        assign      pe2_sel[j] = ~none[j]   & ~hold[j]; //select which MUX to cascade
         
      end   //j loop
    endgenerate    
        
  //second layer mux'es
    reg [31:0] cluster_out;
    reg        cluster_valid;
    always @(posedge clk) begin
      case(pe2_sel) 
        4'b0001 : 
            begin
              cluster_out   <= pe2_E_jet[0];
              cluster_valid <= pe2_valid1[0];
            end      
        4'b0010 : 
            begin
              cluster_out   <= pe2_E_jet[1];
              cluster_valid <= pe2_valid1[1];
            end      
        4'b0100 : 
            begin
              cluster_out   <= pe2_E_jet[2];
              cluster_valid <= pe2_valid1[2];
            end      
        4'b1000 : 
            begin
              cluster_out   <= pe2_E_jet[3];
              cluster_valid <= pe2_valid1[3];
            end      
        default : 
            begin
              cluster_out   <= 0;
              cluster_valid <= 0;
            end      
      endcase
    end
  
  //final memory
      FoundJets fj
      (
        .clk(clk),
        .reset(start),
        .valid(cluster_valid),
        .din(cluster_out),
        
        .addr(final_cluster_addr),
        .dout(final_cluster_out),
        .num(final_num)
      );          
    
endmodule
