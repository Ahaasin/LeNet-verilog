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


module layer1_tb;

    reg clk;
    reg rst;
    reg conv1_en;
    reg pool1_en;
    wire pool1_finish;

    layer1_top #(
        .DATA_ZIZE (16)
    )
    u_layer1_top(
        .clk(clk),
        .rst(rst),
        .conv_1_en(conv1_en),
        .pool_1_finish(pool1_finish)
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
  
    initial
    begin
      //$readmemb("./weigth_test.txt",bias_weight_bram.mem);
      //$readmemb("./weigth_test.txt",u_layer1_top.bias_weight_bram.mem);
      //$readmemb("./image_test.txt",u_layer1_top.input_bram.mem);
    //   $display("mem=%b",u_layer1_top.input_bram.mem[0]);
    //   $display("mem=%b",u_layer1_top.input_bram.mem[1]);
    //   $display("mem=%b",u_layer1_top.input_bram.mem[2]);
    //   // $display("mem=%h",bias_weight_bram.mem[2]);
    //   $monitor("state=%b,\nmatrix2=%b,\nmatrix1=%b,\nbias_addr=%d,bias=%d\nproduct1=%d,product2=%d\nrow=%d,colum=%d\nresult=%b\nfilter=%d\n%b,dout=%b\n"
    //            ,u_layer1_top.u_conv1.state
    //            ,u_layer1_top.u_conv1.conv_1_ma.matrix2,u_layer1_top.u_conv1.conv_1_ma.matrix1
    //            ,u_layer1_top.u_conv1.bias_weights_bram_addra,u_layer1_top.u_conv1.bias
    //            ,u_layer1_top.u_conv1.conv_1_ma.product1,u_layer1_top.u_conv1.conv_1_ma.product2
    //            ,u_layer1_top.u_conv1.row,u_layer1_top.u_conv1.column
    //            ,u_layer1_top.result_bram.mem[9],u_layer1_top.u_conv1.filter,u_layer1_top.result_bram.mem[2],u_layer1_top.u_conv1.conv_1_ma.temp);
      //$readmemh("./weight_image/out_conv1_32.hex",bias_weight_bram.mem);
    end
  
endmodule
