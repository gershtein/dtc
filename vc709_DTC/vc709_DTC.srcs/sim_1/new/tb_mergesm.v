`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2016 11:06:35 AM
// Design Name: 
// Module Name: tb_mergesm
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


module tb_mergesm(
     input clk,
     input reset,
     input start,
     output [35:0] stub_out
    );
    
    
  reg state;
  always @(posedge clk) begin
     if(reset)
       state <= 2'b00;
     else begin
       case(state)
       1'b0: begin
          if(start)
            state <= 1;
          else
            state <= 0;
       end
       1'b1: begin
            state <= 1;
       end
       endcase
     end
  end
    
  wire [3:0] data_in;
  reg  [7:0] addr;
  
  Memory #(
  .RAM_WIDTH(4),
  .RAM_DEPTH(256),
  .INIT_FILE("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/merger_test.dat"),
//  .RAM_PERFORMANCE("HIGH_PERFORMANCE")
  .RAM_PERFORMANCE("LOW_LATENCY")
) inputs (
  .addrb(addr),
  .clkb(clk),
  .enb(state),
  .regceb(1'b1),
  .rstb(reset),
  .doutb(data_in) 
);

  always @(posedge clk) begin
    if(reset)
      addr <= 0;
    else
      if(state)
         addr <= addr + 1;
  end
  
  reg [1:0] OFF_IN;
  reg [1:0] OFF_OUT;
  reg       hold;
  reg       reset0;
  reg       reset1;
  reg       reset2;
  reg       reset3;
  
  always @(posedge clk) begin
    if(reset) begin
      OFF_IN  <= 2'b00;
      reset0 <= 1;
      reset1 <= 1;
      reset2 <= 1;
      reset3 <= 1;
    end
    else begin
      case(addr)
      8'd0:  begin
        reset0 <= 0;
        reset1 <= 0;
        reset2 <= 0;
        reset3 <= 0;
      end
      8'd11: begin
               reset3 <= 1;
      end
      8'd12: begin
               reset3  <= 0;
               OFF_IN  <= 2'b01;
      end
      8'd23: begin
               reset0 <= 1;
      end
      8'd24: begin
               reset0  <= 0;
               OFF_IN  <= 2'b10;
      end
      8'd35: begin
               reset1 <= 1;
      end
      8'd36: begin
               reset1  <= 0;
               OFF_IN  <= 2'b11;
      end
      8'd47: begin
               reset2 <= 1;
      end
      8'd48: begin
               reset2  <= 0;
               OFF_IN  <= 2'b00;
      end
      8'd59: begin
               reset3 <= 1;
      end
      8'd60: begin
               reset3  <= 0;
               OFF_IN  <= 2'b01;
      end
      endcase
    end
  end  
  
  always @(posedge clk) begin
    if(reset) begin
      OFF_OUT <= 2'b11;
      hold    <= 1'b1;
    end
    else begin
      case(addr)
      8'd4: begin
              hold <= 0;
              OFF_OUT <= 2'b00;
      end
      8'd16:  OFF_OUT <= 2'b01;
      8'd28:  OFF_OUT <= 2'b10;
      8'd40:  OFF_OUT <= 2'b11;
      8'd52:  OFF_OUT <= 2'b00;
      endcase
    end
  end
  
  

  reg [35:0] M01_gstub1;
  reg        M01_valid;
  reg [35:0] M02_gstub1;
  reg        M02_valid;
  reg [35:0] M03_gstub1;
  reg        M03_valid;
  reg [35:0] M04_gstub1;
  reg        M04_valid;

  always @(posedge clk) begin
    M01_valid <= data_in[0];
    M02_valid <= data_in[1];
    M03_valid <= data_in[2];
    M04_valid <= data_in[3];
  
    M01_gstub1 <= {{data_in&4'h1},2'b00,OFF_IN[1:0],2'b00,OFF_OUT[1:0],addr,{16{1'b0}}};
    M02_gstub1 <= {{data_in&4'h2},2'b00,OFF_IN[1:0],2'b00,OFF_OUT[1:0],addr,{16{1'b0}}};
    M03_gstub1 <= {{data_in&4'h4},2'b00,OFF_IN[1:0],2'b00,OFF_OUT[1:0],addr,{16{1'b0}}};
    M04_gstub1 <= {{data_in&4'h8},2'b00,OFF_IN[1:0],2'b00,OFF_OUT[1:0],addr,{16{1'b0}}};
  end
  
  reg [35:0] M01_gstub;
  reg [35:0] M01_gstub2;
  reg [35:0] M02_gstub;
  reg [35:0] M02_gstub2;
  reg [35:0] M03_gstub;
  reg [35:0] M03_gstub2;
  reg [35:0] M04_gstub;
  reg [35:0] M04_gstub2;
  always @(posedge clk) begin
    M01_gstub  <= M01_gstub2;
    M01_gstub2 <= M01_gstub1;
    M02_gstub  <= M02_gstub2;
    M02_gstub2 <= M02_gstub1;
    M03_gstub  <= M03_gstub2;
    M03_gstub2 <= M03_gstub1;
    M04_gstub  <= M04_gstub2;
    M04_gstub2 <= M04_gstub1;
  end
  

   tb_merge TB_UU (
    .clk(clk),

    .TMUX_hold(hold),      
    .reset0(reset0), 
    .reset1(reset1),
    .reset2(reset2),
    .reset3(reset3),

    .ALL_TMUX_OFF(OFF_IN),
    .ALL_OFF_OUT(OFF_OUT),
  
    .M01_gstub(M01_gstub),
    .M02_gstub(M02_gstub),
    .M03_gstub(M03_gstub),
    .M04_gstub(M04_gstub),
    
    .M01_valid(M01_valid),
    .M02_valid(M02_valid),
    .M03_valid(M03_valid),
    .M04_valid(M04_valid),
    
    .stub_out(stub_out)
    );
    
    
    
    
endmodule
