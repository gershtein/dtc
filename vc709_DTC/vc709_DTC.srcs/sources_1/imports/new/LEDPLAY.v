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

    reg n1, n2;
    always @(posedge clk) begin
       n1 <= sw_north;
       n2 <= n1;
    end
    assign next = n1 & (~n2);
    
    //top module
    
    wire [35:0] TMUX0_stub;
    wire [35:0] TMUX1_stub;
    wire [35:0] TMUX2_stub;
    wire [35:0] TMUX3_stub;
    wire [35:0] TMUX4_stub;
    wire [35:0] TMUX5_stub;
    DTC_top UU (
      .clk320(clk),
      .top_reset(reset),   
      .TMUX0_stub(TMUX0_stub),
      .TMUX1_stub(TMUX1_stub),
      .TMUX2_stub(TMUX2_stub),
      .TMUX3_stub(TMUX3_stub),
      .TMUX4_stub(TMUX4_stub),
      .TMUX5_stub(TMUX5_stub)
    );
    
    //multiplex the output
    reg [2:0]iout;
    always @(posedge clk) begin
      if(reset)
        iout <= 0;
      else if(start)
        iout <= iout + 1;
    end
    reg [35:0] stub;
    always @(posedge clk) begin
      case(iout)
      3'b000: stub <= TMUX0_stub;
      3'b001: stub <= TMUX1_stub;
      3'b010: stub <= TMUX2_stub;
      3'b011: stub <= TMUX3_stub;
      3'b100: stub <= TMUX4_stub;
      3'b101: stub <= TMUX5_stub;
      3'b110: stub <= 0;
      3'b111: stub <= 0;
      endcase
    end
    
    
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
    
    parameter S_IDLE = 6'b000001;
    parameter S_NEXT = 6'b000010;
    parameter S_00   = 6'b000100;
    parameter S_01   = 6'b001000;
    parameter S_10   = 6'b010000;
    parameter S_11   = 6'b100000;
    reg [5:0] state = S_IDLE;
    
    always @(posedge clk) begin
      if(reset) begin
        state <= S_IDLE;
        ledout <= 8'h00;
      end
      else begin
        case (state)
          S_IDLE : begin
            ledout[7] <= blinker[34];
            ledout[6] <= blinker[1];
            if(next) begin
              state <= S_NEXT;
            end
            else begin
              state <= S_IDLE;
            end
          end
          S_NEXT : begin
              ledout <= {iout[2:0],1'b1,stub[35:32]};
              if(next) begin
                state <= S_00;
              end
              else begin
                state <= S_NEXT;
              end
          end
          S_00   : begin
              ledout <= stub[31:24];
              if(next) begin
                 state <= S_01;
              end
              else begin
                 state <= S_00;
              end
          end
          S_01   : begin
              ledout <= stub[23:16];
              if(next) begin
                 state <= S_10;
              end
              else begin
                 state <= S_01;
              end
          end
          S_10   : begin
              ledout <= stub[15:8];
              if(next) begin
                 state <= S_11;
              end
              else begin
                 state <= S_10;
              end
          end
          S_11   : begin
              ledout <= stub[7:0];
              if(next) begin
                state <= S_NEXT;
              end
              else begin
                state <= S_11;
              end
          end
        endcase
      end
    end
    
    
endmodule
