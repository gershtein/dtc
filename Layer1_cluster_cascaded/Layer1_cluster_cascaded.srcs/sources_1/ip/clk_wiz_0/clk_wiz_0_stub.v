// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3.1 (lin64) Build 1056140 Thu Oct 30 16:30:39 MDT 2014
// Date        : Tue May 24 08:32:02 2016
// Host        : localhost running 64-bit Scientific Linux release 6.5 (Carbon)
// Command     : write_verilog -force -mode synth_stub
//               /home/gerstein/Xlinix/Vivado/2014.3.1/vc709_sc/vc709_sc.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(sysclk, clk, reset, locked)
/* synthesis syn_black_box black_box_pad_pin="sysclk,clk,reset,locked" */;
  input sysclk;
  output clk;
  input reset;
  output locked;
endmodule
