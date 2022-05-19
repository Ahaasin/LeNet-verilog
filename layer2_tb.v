`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 11:42:23
// Design Name: 
// Module Name: layer1_tb
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


module layer2_tb;

    reg clk;
    reg rst;
    reg conv1_en;
    reg pool1_en;
    wire pool_2_finish;

    layer2_top #(
        .DATA_SIZE (16)
    )
    u_layer2_top(
        .clk(clk),
        .rst(rst),
        .conv_1_en(conv1_en),
        .pool_2_finish(pool_2_finish)
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