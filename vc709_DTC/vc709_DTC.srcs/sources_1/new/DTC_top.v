`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2016 11:14:53 AM
// Design Name: 
// Module Name: DTC_top
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


module DTC_top(
    input clk320,
    input top_reset,
    
    output [35:0] TMUX0_stub,
    output [35:0] TMUX1_stub,
    output [35:0] TMUX2_stub,
    output [35:0] TMUX3_stub,
    output [35:0] TMUX4_stub,
    output [35:0] TMUX5_stub
    );
    
  wire reset;
  wire start;
  wire [31:0] M01_data;  
  wire [31:0] M02_data;  
  wire [31:0] M03_data;  
  wire M01_start;
  wire M02_start;
  wire M03_start;

  //modules
  module_in #(.initfile("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/dummyinput_m0.dat"))
  M01 (
     .clk320(clk320),
     .start (start),
     .reset (reset),
     .data_o(M01_data),
     .start_frame (M01_start)
  );
  module_in #(.initfile("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/dummyinput_m1.dat"))
  M02 (
     .clk320(clk320),
     .start (start),
     .reset (reset),
     .data_o(M02_data),
     .start_frame (M02_start)
  );
  module_in #(.initfile("/home/gerstein/Xlinix/Vivado/2014.3.1/vc709_DTC/dummyinput_m2.dat"))
  M03 (
     .clk320(clk320),
     .start (start),
     .reset (reset),
     .data_o(M03_data),
     .start_frame (M03_start)
  );
    
  //unpack  
  
  wire [17:0] M01_stub;
  wire        M01_valid;
  wire [11:0] M01_BX;
  wire  [1:0] M01_F3;
  wire  [8:0] M01_status;
  unpack  U01 (
     .clk320(clk320),
     .Din   (M01_data),
     .start (M01_start),
     .reset (reset),
     .stub  (M01_stub),
     .valid (M01_valid),
     .BX    (M01_BX),
     .F3    (M01_F3),
     .status(M01_status)
  );
  
  wire [17:0] M02_stub;
  wire        M02_valid;
  wire [11:0] M02_BX;
  wire  [1:0] M02_F3;
  wire  [8:0] M02_status;
  unpack  U02 (
     .clk320(clk320),
     .Din   (M02_data),
     .start (M02_start),
     .reset (reset),
     .stub  (M02_stub),
     .valid (M02_valid),
     .BX    (M02_BX),
     .F3    (M02_F3),
     .status(M02_status)
  );
  
  wire [17:0] M03_stub;
  wire        M03_valid;
  wire [11:0] M03_BX;
  wire  [1:0] M03_F3;
  wire  [8:0] M03_status;  
  unpack  U03 (
     .clk320(clk320),
     .Din   (M03_data),
     .start (M03_start),
     .reset (reset),
     .stub  (M03_stub),
     .valid (M03_valid),
     .BX    (M03_BX),
     .F3    (M03_F3),
     .status(M03_status)
  );
  
  //tmux gen's
  
  wire [2:0] M01_TMUX;
  wire [1:0] M01_TMUX_OFF;
  tmux_gen TMG_01 (
     .clk320  (clk320),
     .O       (M01_stub[17:15]),
     .F3      (M01_F3),
     .TMUX    (M01_TMUX),
     .TMUX_OFF(M01_TMUX_OFF)
  );   
    
  wire [2:0] M02_TMUX;
  wire [1:0] M02_TMUX_OFF;
  tmux_gen TMG_02 (
     .clk320  (clk320),
     .O       (M02_stub[17:15]),
     .F3      (M02_F3),
     .TMUX    (M02_TMUX),
     .TMUX_OFF(M02_TMUX_OFF)
  );   
    
  wire [2:0] M03_TMUX;
  wire [1:0] M03_TMUX_OFF;
  tmux_gen TMG_03 (
     .clk320  (clk320),
     .O       (M03_stub[17:15]),
     .F3      (M03_F3),
     .TMUX    (M03_TMUX),
     .TMUX_OFF(M03_TMUX_OFF)
  );   

//LtoG

   wire  [1:0] M01_sector;
   wire  [7:0] M01_r;
   wire [16:0] M01_phi;
   wire  [7:0] M01_z;
   wire  [2:0] M01_pt; 
   LtoG_L2S LG_01 (
     .clk320  (clk320),
     .stub    (M01_stub[14:0]),
     .valid   (M01_valid),
     .sector  (M01_sector),
     .r       (M01_r),
     .phi     (M01_phi),
     .z       (M01_z),
     .pt      (M01_pt)
   );

   wire  [1:0] M02_sector;
   wire  [7:0] M02_r;
   wire [16:0] M02_phi;
   wire  [7:0] M02_z;
   wire  [2:0] M02_pt; 
   LtoG_L2S LG_02 (
     .clk320  (clk320),
     .stub    (M02_stub[14:0]),
     .valid   (M02_valid),
     .sector  (M02_sector),
     .r       (M02_r),
     .phi     (M02_phi),
     .z       (M02_z),
     .pt      (M02_pt)
   );

   wire  [1:0] M03_sector;
   wire  [7:0] M03_r;
   wire [16:0] M03_phi;
   wire  [7:0] M03_z;
   wire  [2:0] M03_pt;    
   LtoG_L2S LG_03 (
     .clk320  (clk320),
     .stub    (M03_stub[14:0]),
     .valid   (M03_valid),
     .sector  (M03_sector),
     .r       (M03_r),
     .phi     (M03_phi),
     .z       (M03_z),
     .pt      (M03_pt)
   );

//linkmems

    wire reset0, reset1, reset2, reset3;

    wire [35:0] M01_gstub={M01_pt,M01_r,M01_z,M01_phi};
    wire [35:0] M01_0_gstub_out;
    wire [1:0]  M01_0_OFF_OUT;
    wire        M01_0_rd_en;
    wire        M01_0_has_data;
    link_mem #(.mySECT(0),.myTMUX(0)) 
              LM_01_0 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_0_rd_en),
         .OFF_OUT (M01_0_OFF_OUT),
         .stub_out (M01_0_gstub_out),
         .has_data(M01_0_has_data)
    );
    wire [35:0] M01_1_gstub_out;
    wire [1:0]  M01_1_OFF_OUT;
    wire        M01_1_rd_en;
    wire        M01_1_has_data;
    link_mem #(.mySECT(0),.myTMUX(1)) 
              LM_01_1 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_1_rd_en),
         .OFF_OUT (M01_1_OFF_OUT),
         .stub_out (M01_1_gstub_out),
         .has_data(M01_1_has_data)
    );
    wire [35:0] M01_2_gstub_out;
    wire [1:0]  M01_2_OFF_OUT;
    wire        M01_2_rd_en;
    wire        M01_2_has_data;
    link_mem #(.mySECT(0),.myTMUX(2)) 
              LM_01_2 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_2_rd_en),
         .OFF_OUT (M01_2_OFF_OUT),
         .stub_out (M01_2_gstub_out),
         .has_data(M01_2_has_data)
    );
    wire [35:0] M01_3_gstub_out;
    wire [1:0]  M01_3_OFF_OUT;
    wire        M01_3_rd_en;
    wire        M01_3_has_data;
    link_mem #(.mySECT(0),.myTMUX(3)) 
              LM_01_3 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_3_rd_en),
         .OFF_OUT (M01_3_OFF_OUT),
         .stub_out (M01_3_gstub_out),
         .has_data(M01_3_has_data)
    );
    wire [35:0] M01_4_gstub_out;
    wire [1:0]  M01_4_OFF_OUT;
    wire        M01_4_rd_en;
    wire        M01_4_has_data;
    link_mem #(.mySECT(0),.myTMUX(4)) 
              LM_01_4 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_4_rd_en),
         .OFF_OUT (M01_4_OFF_OUT),
         .stub_out (M01_4_gstub_out),
         .has_data(M01_4_has_data)
    );
    wire [35:0] M01_5_gstub_out;
    wire [1:0]  M01_5_OFF_OUT;
    wire        M01_5_rd_en;
    wire        M01_5_has_data;
    link_mem #(.mySECT(0),.myTMUX(5)) 
              LM_01_5 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M01_TMUX),
         .TMUX_OFF(M01_TMUX_OFF),
         .sector  (M01_sector),
         .valid   (M01_valid),
         .stub_in (M01_gstub),
         .BX      (M01_BX),
         .BX_OFF  (M01_stub[17:15]),
         .rd_en   (M01_5_rd_en),
         .OFF_OUT (M01_5_OFF_OUT),
         .stub_out (M01_5_gstub_out),
         .has_data(M01_5_has_data)
    );
    
///

    wire [35:0] M02_gstub={M02_pt,M02_r,M02_z,M02_phi};
    wire [35:0] M02_0_gstub_out;
    wire [1:0]  M02_0_OFF_OUT;
    wire        M02_0_rd_en;
    wire        M02_0_has_data;
    link_mem #(.mySECT(0),.myTMUX(0)) 
              LM_02_0 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_0_rd_en),
         .OFF_OUT (M02_0_OFF_OUT),
         .stub_out (M02_0_gstub_out),
         .has_data  (M02_0_has_data)
    );
    wire [35:0] M02_1_gstub_out;
    wire [1:0]  M02_1_OFF_OUT;
    wire        M02_1_rd_en;
    wire        M02_1_has_data;
    link_mem #(.mySECT(0),.myTMUX(1)) 
              LM_02_1 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_1_rd_en),
         .OFF_OUT (M02_1_OFF_OUT),
         .stub_out (M02_1_gstub_out),
         .has_data  (M02_1_has_data)
    );
    wire [35:0] M02_2_gstub_out;
    wire [1:0]  M02_2_OFF_OUT;
    wire        M02_2_rd_en;
    wire        M02_2_has_data;
    link_mem #(.mySECT(0),.myTMUX(2)) 
              LM_02_2 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_2_rd_en),
         .OFF_OUT (M02_2_OFF_OUT),
         .stub_out (M02_2_gstub_out),
         .has_data  (M02_2_has_data)
    );
    wire [35:0] M02_3_gstub_out;
    wire [1:0]  M02_3_OFF_OUT;
    wire        M02_3_rd_en;
    wire        M02_3_has_data;
    link_mem #(.mySECT(0),.myTMUX(3)) 
              LM_02_3 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_3_rd_en),
         .OFF_OUT (M02_3_OFF_OUT),
         .stub_out (M02_3_gstub_out),
         .has_data  (M02_3_has_data)
    );
    wire [35:0] M02_4_gstub_out;
    wire [1:0]  M02_4_OFF_OUT;
    wire        M02_4_rd_en;
    wire        M02_4_has_data;
    link_mem #(.mySECT(0),.myTMUX(4)) 
              LM_02_4 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_4_rd_en),
         .OFF_OUT (M02_4_OFF_OUT),
         .stub_out (M02_4_gstub_out),
         .has_data(M02_4_has_data)
    );
    wire [35:0] M02_5_gstub_out;
    wire [1:0]  M02_5_OFF_OUT;
    wire        M02_5_rd_en;
    wire        M02_5_has_data;
    link_mem #(.mySECT(0),.myTMUX(5)) 
              LM_02_5 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M02_TMUX),
         .TMUX_OFF(M02_TMUX_OFF),
         .sector  (M02_sector),
         .valid   (M02_valid),
         .stub_in (M02_gstub),
         .BX      (M02_BX),
         .BX_OFF  (M02_stub[17:15]),
         .rd_en   (M02_5_rd_en),
         .OFF_OUT (M02_5_OFF_OUT),
         .stub_out (M02_5_gstub_out),
         .has_data(M02_5_has_data)
    );
    
////

    wire [35:0] M03_gstub={M03_pt,M03_r,M03_z,M03_phi};
    wire [35:0] M03_0_gstub_out;
    wire [1:0]  M03_0_OFF_OUT;
    wire        M03_0_rd_en;
    wire        M03_0_has_data;
    link_mem #(.mySECT(0),.myTMUX(0)) 
              LM_03_0 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_0_rd_en),
         .OFF_OUT (M03_0_OFF_OUT),
         .stub_out (M03_0_gstub_out),
         .has_data(M03_0_has_data)
    );
    wire [35:0] M03_1_gstub_out;
    wire [1:0]  M03_1_OFF_OUT;
    wire        M03_1_rd_en;
    wire        M03_1_has_data;
    link_mem #(.mySECT(0),.myTMUX(1)) 
              LM_03_1 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_1_rd_en),
         .OFF_OUT (M03_1_OFF_OUT),
         .stub_out (M03_1_gstub_out),
         .has_data  (M03_1_has_data)
    );
    wire [35:0] M03_2_gstub_out;
    wire [1:0]  M03_2_OFF_OUT;
    wire        M03_2_rd_en;
    wire        M03_2_has_data;
    link_mem #(.mySECT(0),.myTMUX(2)) 
              LM_03_2 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_2_rd_en),
         .OFF_OUT (M03_2_OFF_OUT),
         .stub_out (M03_2_gstub_out),
         .has_data  (M03_2_has_data)
    );
    wire [35:0] M03_3_gstub_out;
    wire [1:0]  M03_3_OFF_OUT;
    wire        M03_3_rd_en;
    wire        M03_3_has_data;
    link_mem #(.mySECT(0),.myTMUX(3)) 
              LM_03_3 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_3_rd_en),
         .OFF_OUT (M03_3_OFF_OUT),
         .stub_out (M03_3_gstub_out),
         .has_data(M03_3_has_data)
    );
    wire [35:0] M03_4_gstub_out;
    wire [1:0]  M03_4_OFF_OUT;
    wire        M03_4_rd_en;
    wire        M03_4_has_data;
    link_mem #(.mySECT(0),.myTMUX(4)) 
              LM_03_4 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_4_rd_en),
         .OFF_OUT (M03_4_OFF_OUT),
         .stub_out (M03_4_gstub_out),
         .has_data(M03_4_has_data)
    );
    wire [35:0] M03_5_gstub_out;
    wire [1:0]  M03_5_OFF_OUT;
    wire        M03_5_rd_en;
    wire        M03_5_has_data;
    link_mem #(.mySECT(0),.myTMUX(5)) 
              LM_03_5 (
         .clk(clk320),
         .reset0(reset0),
         .reset1(reset1),
         .reset2(reset2),
         .reset3(reset3),
         .TMUX    (M03_TMUX),
         .TMUX_OFF(M03_TMUX_OFF),
         .sector  (M03_sector),
         .valid   (M03_valid),
         .stub_in (M03_gstub),
         .BX      (M03_BX),
         .BX_OFF  (M03_stub[17:15]),
         .rd_en   (M03_5_rd_en),
         .OFF_OUT (M03_5_OFF_OUT),
         .stub_out (M03_5_gstub_out),
         .has_data(M03_5_has_data)
    );
    
//
//    
//mergers - by TMUX
//
//

    wire   [3:0] TMUX0_sel;
    wire         TMUX0_hold;
//    wire  [35:0] TMUX0_stub;
    merge_mux    TMUX0 (
       .clk     (clk320),
       .stub00  (M01_0_gstub_out),
       .stub01  (M02_0_gstub_out),
       .stub02  (M03_0_gstub_out),
       .sel     (TMUX0_sel),
       .stub_out(TMUX0_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX0_pe (
        .clk    (clk320),
        .h00    (M01_0_has_data),
        .h01    (M02_0_has_data),
        .h02    (M03_0_has_data),
        .hold   (TMUX0_hold),
        .re00   (M01_0_rd_en),
        .re01   (M02_0_rd_en),
        .re02   (M03_0_rd_en),
        .sel    (TMUX0_sel)
    );


    wire   [3:0] TMUX1_sel;
    wire         TMUX1_hold;
//    wire  [35:0] TMUX1_stub;
    merge_mux    TMUX1 (
       .clk     (clk320),
       .stub00  (M01_1_gstub_out),
       .stub01  (M02_1_gstub_out),
       .stub02  (M03_1_gstub_out),
       .sel     (TMUX1_sel),
       .stub_out(TMUX1_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX1_pe (
        .clk    (clk320),
        .h00    (M01_1_has_data),
        .h01    (M02_1_has_data),
        .h02    (M03_1_has_data),
        .hold   (TMUX1_hold),
        .re00   (M01_1_rd_en),
        .re01   (M02_1_rd_en),
        .re02   (M03_1_rd_en),
        .sel    (TMUX1_sel)
    );


    wire   [3:0] TMUX2_sel;
    wire         TMUX2_hold;
//    wire  [35:0] TMUX2_stub;
    merge_mux    TMUX2 (
       .clk     (clk320),
       .stub00  (M01_2_gstub_out),
       .stub01  (M02_2_gstub_out),
       .stub02  (M03_2_gstub_out),
       .sel     (TMUX2_sel),
       .stub_out(TMUX2_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX2_pe (
        .clk    (clk320),
        .h00    (M01_2_has_data),
        .h01    (M02_2_has_data),
        .h02    (M03_2_has_data),
        .hold   (TMUX2_hold),
        .re00   (M01_2_rd_en),
        .re01   (M02_2_rd_en),
        .re02   (M03_2_rd_en),
        .sel    (TMUX2_sel)
    );


    wire   [3:0] TMUX3_sel;
    wire         TMUX3_hold;
//    wire  [35:0] TMUX3_stub;
    merge_mux    TMUX3 (
       .clk     (clk320),
       .stub00  (M01_3_gstub_out),
       .stub01  (M02_3_gstub_out),
       .stub02  (M03_3_gstub_out),
       .sel     (TMUX3_sel),
       .stub_out(TMUX3_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX3_pe (
        .clk    (clk320),
        .h00    (M01_3_has_data),
        .h01    (M02_3_has_data),
        .h02    (M03_3_has_data),
        .hold   (TMUX3_hold),
        .re00   (M01_3_rd_en),
        .re01   (M02_3_rd_en),
        .re02   (M03_3_rd_en),
        .sel    (TMUX3_sel)
    );


    wire   [3:0] TMUX4_sel;
    wire         TMUX4_hold;
//    wire  [35:0] TMUX4_stub;
    merge_mux    TMUX4 (
       .clk     (clk320),
       .stub00  (M01_4_gstub_out),
       .stub01  (M02_4_gstub_out),
       .stub02  (M03_4_gstub_out),
       .sel     (TMUX4_sel),
       .stub_out(TMUX4_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX4_pe (
        .clk    (clk320),
        .h00    (M01_4_has_data),
        .h01    (M02_4_has_data),
        .h02    (M03_4_has_data),
        .hold   (TMUX4_hold),
        .re00   (M01_4_rd_en),
        .re01   (M02_4_rd_en),
        .re02   (M03_4_rd_en),
        .sel    (TMUX4_sel)
    );


    wire   [3:0] TMUX5_sel;
    wire         TMUX5_hold;
//    wire  [35:0] TMUX5_stub;
    merge_mux    TMUX5 (
       .clk     (clk320),
       .stub00  (M01_5_gstub_out),
       .stub01  (M02_5_gstub_out),
       .stub02  (M03_5_gstub_out),
       .sel     (TMUX5_sel),
       .stub_out(TMUX5_stub)
    );
    merge_pe  #(.DELAY(1))
      TMUX5_pe (
        .clk    (clk320),
        .h00    (M01_5_has_data),
        .h01    (M02_5_has_data),
        .h02    (M03_5_has_data),
        .hold   (TMUX5_hold),
        .re00   (M01_5_rd_en),
        .re01   (M02_5_rd_en),
        .re02   (M03_5_rd_en),
        .sel    (TMUX5_sel)
    );

    
    
    // and the conductor of this all:
    wire sm_start;
    wire sm_reset0;
    wire sm_reset1;
    wire sm_reset2;
    wire sm_reset3;
    wire sm_hold;
    wire [1:0] sm_offset;
    DTC_SM theSM (
       .clk320(clk320),
       .top_reset(top_reset),
       .reset(reset),
       .start(sm_start),
       .reset0(sm_reset0),
       .reset1(sm_reset1),
       .reset2(sm_reset2),
       .reset3(sm_reset3),
       .hold(  sm_hold),
       .OFF_OUT(sm_offset)
    );
    assign start = sm_start;
    
    assign reset0 = sm_reset0;
    assign reset1 = sm_reset1;
    assign reset2 = sm_reset2;
    assign reset3 = sm_reset3;

    assign TMUX0_hold = sm_hold;
    assign TMUX1_hold = sm_hold;
    assign TMUX2_hold = sm_hold;
    assign TMUX3_hold = sm_hold;
    assign TMUX4_hold = sm_hold;
    assign TMUX5_hold = sm_hold;
     
    assign M01_0_OFF_OUT = sm_offset;
    assign M01_1_OFF_OUT = sm_offset;
    assign M01_2_OFF_OUT = sm_offset;
    assign M01_3_OFF_OUT = sm_offset;
    assign M01_4_OFF_OUT = sm_offset;
    assign M01_5_OFF_OUT = sm_offset;
    assign M02_0_OFF_OUT = sm_offset;
    assign M02_1_OFF_OUT = sm_offset;
    assign M02_2_OFF_OUT = sm_offset;
    assign M02_3_OFF_OUT = sm_offset;
    assign M02_4_OFF_OUT = sm_offset;
    assign M02_5_OFF_OUT = sm_offset;
    assign M03_0_OFF_OUT = sm_offset;
    assign M03_1_OFF_OUT = sm_offset;
    assign M03_2_OFF_OUT = sm_offset;
    assign M03_3_OFF_OUT = sm_offset;
    assign M03_4_OFF_OUT = sm_offset;
    assign M03_5_OFF_OUT = sm_offset;
     
     
endmodule
