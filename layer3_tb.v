`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/21 22:27:12
// Design Name:
// Module Name: layer3_tb
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


module layer3_tb;
  reg clk;
  reg rst;
  reg conv1_en;
  wire conv_3_finish;

  layer3_top #(
               .DATA_SIZE (16)
             )
             u_layer3_top(
               .clk(clk),
               .rst(rst),
               .conv_1_en(conv1_en),
               .conv_3_finish(conv_3_finish)
             );

  initial
  begin
    clk=0;
    rst=1;
    #10 rst=0;
    conv1_en=1;
    $display("========done========");
    //$monitor("mem=%h",bias_weight_bram.mem[0]);
    //$display("mem=%h",bias_weight_bram.mem[0]);
  end

  always #5 clk=~clk;
endmodule
