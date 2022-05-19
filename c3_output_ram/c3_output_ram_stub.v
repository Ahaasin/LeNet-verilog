// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Apr 23 22:28:16 2022
// Host        : Ahaasin-ASUS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/t1327/Desktop/lenet2.0/lenet2.0.srcs/sources_1/ip/c3_output_ram/c3_output_ram_stub.v
// Design      : c3_output_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z035ffv676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module c3_output_ram(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[9:0],dina[15:0],clkb,enb,addrb[9:0],doutb[15:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [9:0]addra;
  input [15:0]dina;
  input clkb;
  input enb;
  input [9:0]addrb;
  output [15:0]doutb;
endmodule
