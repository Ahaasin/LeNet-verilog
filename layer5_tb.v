`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/23 12:59:15
// Design Name: 
// Module Name: layer5_tb
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


module layer5_tb;

reg clk;
reg rst;
reg conv1_en;
wire fc_2_finish;
wire [3:0] ans;

layer5_top #(
             .DATA_SIZE (16)
           )
           u_layer5_top(
             .clk(clk),
             .rst(rst),
             .conv_1_en(conv1_en),
             .fc_2_finish(fc_2_finish),
             .ans(ans)
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

