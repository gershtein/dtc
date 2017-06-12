`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2015 10:56:04 PM
// Design Name: 
// Module Name: LEDPLAY
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


module LEDPLAY(
    input clk_p,
    input clk_n,
    input sw_north,
    input sw_east,
    input sw_south,
    input sw_west,
    input sw_center, 
    
    input [4:0] PHIBIN,
    
    input  [4:0] IO_addr,
    input [31:0] IO_din,
    input        IO_wen,
    
    
    input dip_0,
    input dip_1,
    input dip_2,
    output reg led_0,
    output reg led_1,
    output reg led_2,
    output reg led_3,
    output reg led_4,
    output reg led_5,
    output reg led_6,
    output reg led_7
    );

    wire sysclk; //clock out of differential clock
    IBUFGDS #(
      .DIFF_TERM    ("TRUE"),
      .IBUF_LOW_PWR ("FALSE")
    ) diff_clk_200 (
      .I    (clk_p  ),
      .IB   (clk_n  ),
      .O    (sysclk )  
    );
    
    //derive processing clock
    wire clk, locked;
    wire clk_reset;    
    assign clk_reset = sw_center; 
    clk_wiz_0 proc_clk (
      .sysclk(sysclk),
      .clk(clk),
      .reset(clk_reset),
      .locked(locked)
    );
        
    //convert input buttons into single-clock signals
    wire start, reset, next;
    reg s1, s2;
    always @(posedge clk) begin
       s1 <= sw_south;
       s2 <= s1;
    end
    assign start = s1 & (~s2);
    
    reg r1, r2;
    always @(posedge clk) begin
       r1 <= sw_west;
       r2 <= r1;
    end
    assign reset = r1 & (~r2);

    reg z1, z2;
    always @(posedge clk) begin
       z1 <= sw_east;
       z2 <= z1;
    end
    wire nextZ = z1 & (~z2);

//for this one, need to make sure there is no multi-click.
// Veto further clicks for a second or so.
    reg n1, n2;
    wire n3;
    assign n3 = n1 & (~n2);
    always @(posedge clk) begin
       n1 <= sw_north;
       n2 <= n1;
    end
    reg [28:0] n_veto_count;
    reg        n_veto;
    parameter N_IDLE  = 3'b001;
    parameter N_COUNT = 3'b010;
    parameter N_DONE  = 3'b100;
    reg [3:0] n_state;
    always @(posedge clk) begin
      if(reset) begin
        n_veto <=0;
        n_veto_count <= 0;
        n_state <= N_IDLE;
      end
      else begin
        case(n_state) 
          N_IDLE : begin
            n_veto <=0;
            n_veto_count <= 0;
            if(n1)      
              n_state <= N_COUNT;
            else
              n_state <= N_IDLE;
          end
          N_COUNT : begin
            n_veto_count <= n_veto_count + 1;
            n_veto <= 1;
//            if(n_veto_count[28]) begin
//            if(n_veto_count[9]) begin
            if(n_veto_count[3]) begin
               n_state <= N_DONE;
            end
            else begin
               n_state <= N_COUNT;
            end
          end
          N_DONE  : begin
               n_veto <= 0;
               n_veto_count <= 0;
               n_state <= N_IDLE;
          end
        endcase
      end
    end
    
    assign next = n3 & (!n_veto);
        
    
    //main body
    
    
    //on start signal read from the memory and broadcast
    //stop when get zero
    reg [7:0] cluster_addr=0;
    reg        r_stop = 0;
    wire [31:0]cluster_in;
    
    parameter R_IDLE = 2'b01;
    parameter R_SEND = 2'b10;
    reg [1:0]r_state; 
    
    always @(posedge clk) begin
        if(reset) begin
            cluster_addr <=0;
            r_stop <= 0;
            r_state<=R_IDLE;
        end
        else begin
            case(r_state) 
            R_IDLE: begin
                cluster_addr <=0;
                r_stop <= 0;
                if(start)
                  r_state <= R_SEND;
                else
                  r_state <= R_IDLE;
              end
            R_SEND: begin
                cluster_addr <= cluster_addr + 1;
                if(cluster_in == 0) begin
                  r_stop <= 1;                
                  r_state <= R_IDLE;
                end
                else begin
                  r_stop <= 0;                
                  r_state <= R_SEND;
                end
              end
            endcase
        end
    end
    
    //start and stop need to be delayed two clocks
    reg start1, start2;
    reg r_stop1, r_stop2;
    always @(posedge clk) begin
      if(reset) begin
       start2 <= 0;
       start1 <= 0;
       r_stop2 <= 0;
       r_stop1 <= 0;
      end
      else begin
       start2 <= start1;
       start1 <= start;
       r_stop2 <= r_stop1;
       r_stop1 <= r_stop;
      end
    end
          
    Memory  //input clusters
      #( 
         .RAM_WIDTH(32),
         .RAM_DEPTH(256),
         .RAM_PERFORMANCE("LOW_LATENCY"),
         .INIT_FILE("/home/gerstein/Xlinix/Vivado/2014.3.1/Layer1_cluster/testbuf.dat")
       ) input_clusters
       (
          .clka(clk),
          .addra(IO_addra),
          .dina(IO_din),
          .wea(IO_wen),
       
          .clkb(clk),
          .addrb(cluster_addr),
          .enb(1'b1),
          .rstb(reset),
          .regceb(1'b1),
          .doutb(cluster_in)
       );
    
    
    //wire in the cluster finding
    wire done;
    reg  [4:0] jet_addr;
    reg  [5:0] jet_zbin;
    wire [31:0] jet_out;
    wire [4:0]  jet_num;
    Layer1 #(.NZ(64), .NETA(24)) UL1
      (
        .PHIBIN(PHIBIN),
      
        .clk(clk),
        .reset(reset),//i
        .start(start2),//i
        .stop(r_stop),//i
        .track_in(cluster_in),//i
        
        .all_done(done),//o
        
        .final_cluster_addr(jet_addr),//i     
        .final_zbin(jet_zbin),        //i     
        .final_cluster_out(jet_out),  //o    
        .final_num(jet_num)           //o    
      );
    
        
    //led blinkin'
    reg [35:0] blinker;
    always @(posedge clk)
       if(reset)
         blinker <= 0;
       else
         blinker <= blinker + 1;
    reg [7:0] ledout;
    always @(posedge clk) begin
       led_0 <= ledout[0];
       led_1 <= ledout[1];
       led_2 <= ledout[2];
       led_3 <= ledout[3];
       led_4 <= ledout[4];
       led_5 <= ledout[5];
       led_6 <= ledout[6];
       led_7 <= ledout[7];
    end
    
    parameter S_IDLE    = 10'b0000000001;
    parameter S_WAIT    = 10'b0000000010;
    parameter S_NEXT_ZB = 10'b0000000100;
    parameter S_ZB      = 10'b0000001000;
    parameter S_ZB1     = 10'b0000010000;
    parameter S_NEXT    = 10'b0000100000;
    parameter S_00      = 10'b0001000000;
    parameter S_01      = 10'b0010000000;
    parameter S_10      = 10'b0100000000;
    parameter S_11      = 10'b1000000000;
    reg [9:0] state = S_IDLE;
    
    always @(posedge clk) begin
      if(reset) begin
        jet_addr <= 0;
        jet_zbin <= 0;
        state <= S_IDLE;
        ledout <= 8'h00;
      end
      else begin
        case (state)
          S_IDLE : begin
            jet_addr <= 5'b11111;
            jet_zbin <= 6'b111111;
            ledout[7] <= blinker[34];
            ledout[6] <= blinker[2];
            ledout[5] <= 0;
            ledout[4:0] <= jet_num;
            if(done) begin
              state <= S_WAIT;
            end
            else begin
              state <= S_IDLE;
            end
          end
          S_WAIT : begin
            jet_addr <= 5'b11111;
            jet_zbin <= 6'b111111;
            ledout[7] <= blinker[34];
            ledout[6] <= blinker[2];
            ledout[5] <= 0;
            ledout[4:0] <= jet_num;
            if(done & next) begin
              state <= S_NEXT_ZB;
            end
            else begin
              state <= S_WAIT;
            end           
          end
          S_NEXT_ZB  : begin
            jet_zbin <= jet_zbin + 1;
            jet_addr <= 5'b11111;
            state <= S_ZB;
          end
          S_ZB   : begin
             ledout <= {2'b00,jet_zbin[5:0]};
             if(next)
               state <= S_ZB1;
             else
               state <= S_ZB;
          end
          S_ZB1  : begin
             ledout <= {3'b000,jet_num[4:0]};
             if(next)
               state <= S_NEXT;
             else
               state <= S_ZB1;
          end
          S_NEXT : begin
            jet_addr <= jet_addr + 1;
            state <= S_00;
          end
          S_00   : begin
              ledout <= jet_out[31:24];
              if(next) begin
                 state <= S_01;
              end
              else if (nextZ) begin
                 state <= S_NEXT_ZB;
              end
              else begin
                 state <= S_00;
              end
          end
          S_01   : begin
              ledout <= jet_out[23:16];
              if(next) begin
                 state <= S_10;
              end
              else if (nextZ) begin
                 state <= S_NEXT_ZB;
              end
              else begin
                 state <= S_01;
              end
          end
          S_10   : begin
              ledout <= jet_out[15:8];
              if(next) begin
                 state <= S_11;
              end
              else if (nextZ) begin
                 state <= S_NEXT_ZB;
              end
              else begin
                 state <= S_10;
              end
          end
          S_11   : begin
              ledout <= jet_out[7:0];
              if(next) begin
                state <= S_NEXT;
              end
              else if (nextZ) begin
                 state <= S_NEXT_ZB;
              end
              else begin
                state <= S_11;
              end
          end
        endcase
      end
    end
    
    
endmodule
