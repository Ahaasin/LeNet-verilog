`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/10 16:15:25
// Design Name:
// Module Name: conv2
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


module conv2#(
    parameter conv2_weights_base = 0,
    parameter conv2_bias_base = 9,
    parameter conv2_result_base = 0,
    parameter DATA_SIZE=16,
    parameter CONV2_OUTPUT=8,
    parameter IMAGE_SIZE = 12,
    parameter CONV2_DEEP = 16,
    parameter CONV2_SIZE = 5
  )
  (
    input clk,
    input rst,
    input conv_2_en,

    //读取参数
    input [DATA_SIZE-1:0] bias_weights_bram_douta,
    output reg bias_weights_bram_ena,
    output reg [11:0] bias_weights_bram_addra,
    //读取输入数据
    input [DATA_SIZE-1:0] input_bram_douta,
    output reg input_bram_ena,
    output reg [9:0] input_bram_addra,
    //写入卷积结果
    //output reg result_bram_ena,
    output reg result_bram_wea,
    output reg [9:0] result_bram_addra,
    output reg [DATA_SIZE-1:0] result_bram_dina,

    output reg conv_2_finish
  );
  integer
    S_IDLE          = 7'b1000000,
    S_CHECK         = 7'b0100000,
    S_LOAD_WEIGHTS  = 7'b0010000,
    S_LOAD_BIAS     = 7'b0001000,
    S_LOAD_DATA     = 7'b0000100,
    S_CONVOLUTE     = 7'b0000010,
    S_STORE_RESULT  = 7'b0000001,
    filter = 0,
    row = 0,
    column = 0,
    count = 0,
    image_cnt = 0,
    channel=0,
    data_begin = 0,
    data_end=0,
    circle = 0;

  reg [DATA_SIZE*IMAGE_SIZE*IMAGE_SIZE-1:0] data_input [5:0];
  reg [DATA_SIZE*CONV2_SIZE*CONV2_SIZE-1:0] weight_input [5:0];
  wire [DATA_SIZE*CONV2_OUTPUT*CONV2_OUTPUT-1:0] result [5:0];
  wire [DATA_SIZE-1:0] result1 [63:0];
  reg signed [31:0] result_max;
  wire [DATA_SIZE-1:0] bias [15:0];
  reg relu_1_en;
  wire [DATA_SIZE-1:0] dout;
  reg [6:0] state;
  reg load_data_finish;
  reg ena;
  assign bias[0] = 16'b1111111111111101;
  assign bias[1] = 16'b1111111111111100;
  assign bias[2] = 16'b0000000000000100;
  assign bias[3] = 16'b0000000000000000;
  assign bias[4] = 16'b0000000000000011;
  assign bias[5] = 16'b0000000000000011;
  assign bias[6] = 16'b1111111111111010;
  assign bias[7] = 16'b1111111111111101;
  assign bias[8] = 16'b0000000000000000;
  assign bias[9] = 16'b0000000000000011;
  assign bias[10] = 16'b1111111111110100;
  assign bias[11] = 16'b0000000000000011;
  assign bias[12] = 16'b0000000000000000;
  assign bias[13] = 16'b1111111111111000;
  assign bias[14] = 16'b1111111111111100;
  assign bias[15] = 16'b1111111111111111;

  initial
  begin
    load_data_finish<=1'b0;
    ena <= 1'b0;
    //temp1 = 0;
  end

  always@(posedge clk)
  begin
    if(rst == 1'b1)
    begin
      state <= S_IDLE;
      bias_weights_bram_ena <= 1'b0;
      result_bram_wea <= 1'b0;
      input_bram_ena <= 1'b0;
    end
    else
    begin
      if(conv_2_en == 1'b1)
      begin
        case(state)
          S_IDLE:
          begin
            filter <= 0;
            //channel<=0;
            row <= 0;
            column <= 0;
            //data_input <= 0;
            //weight_input <= 0;
            relu_1_en <= 1'b0;
            //result <= 0;
            conv_2_finish <= 1'b0;
            state <= S_CHECK;
          end
          S_CHECK:
          begin
            if(filter == CONV2_DEEP)
            begin
              bias_weights_bram_ena <= 1'b0;
              result_bram_wea <= 1'b0;
              input_bram_ena <= 1'b0;
              conv_2_finish <= 1'b1;
              //state <= S_IDLE;
            end
            else
            begin
              if(load_data_finish == 1'b1)
              begin
                state <= S_LOAD_WEIGHTS;
              end
              else
              begin
                state <= S_LOAD_DATA;
              end
            end
          end
          S_LOAD_WEIGHTS:
          begin
            if(image_cnt < 6)//输入尺寸6*12*12
            begin
              if(count < CONV2_SIZE * CONV2_SIZE)
              begin
                if(circle == 0)
                begin
                  bias_weights_bram_ena <= 1'b1;
                  bias_weights_bram_addra <=filter * 150 + image_cnt * 25 + count;
                  circle <= circle + 1;
                end
                else if(circle == 3)
                begin
                  data_begin = DATA_SIZE * (CONV2_SIZE * CONV2_SIZE - count) - 1;
                  weight_input[image_cnt][data_begin-:DATA_SIZE] <= bias_weights_bram_douta;
                  count <= count + 1;
                  circle <= 0;
                end
                else
                begin
                  circle <= circle + 1;
                end
              end
              else
              begin
                circle <= 0;
                count <= 0;
                image_cnt <= image_cnt + 1;
                bias_weights_bram_ena <= 1'b0;
              end
            end
            else
            begin
              input_bram_ena <= 1'b0;
              image_cnt <= 0;
              circle <= 0;
              count <= 0;
              state <= S_CONVOLUTE;
            end
          end
          S_LOAD_BIAS:
          begin
            circle <= 0;
          end
          S_LOAD_DATA:
          begin
            if(image_cnt < 6)//输入尺寸6*12*12
            begin
              if(count < IMAGE_SIZE * IMAGE_SIZE)
              begin
                if(circle == 0)
                begin
                  input_bram_ena <= 1'b1;
                  input_bram_addra <= image_cnt * 144 + count;
                  circle <= circle + 1;
                end
                else if(circle == 3)
                begin
                  data_begin = DATA_SIZE * (IMAGE_SIZE * IMAGE_SIZE - count) - 1;
                  data_input[image_cnt][data_begin-:DATA_SIZE] <= input_bram_douta;
                  count <= count + 1;
                  circle <= 0;
                end
                else
                begin
                  circle <= circle + 1;
                end
              end
              else
              begin
                circle <= 0;
                count <= 0;
                image_cnt <= image_cnt + 1;
                input_bram_ena <= 1'b0;
                //relu_1_en <= 1'b0;
                //state <= S_CONVOLUTE;
              end
            end
            else
            begin
              load_data_finish <= 1'b1;
              input_bram_ena <= 1'b0;
              circle <= 0;
              count <= 0;
              state <= S_LOAD_WEIGHTS;
              image_cnt <= 0;
            end
          end
          S_CONVOLUTE:
          begin
            if (circle==400)
            begin
              ena <= 1'b0;
              circle <= 0;
              state <= S_STORE_RESULT;
            end
            else
            begin
              ena <= 1'b1;
              circle <= circle + 1;
            end
          end
          S_STORE_RESULT:
          begin
            if(count < 64)
            begin
              if(circle == 0)
              begin
                //result_bram_ena <= 1'b1;
                result_bram_wea <= 1'b1;
                result_bram_addra <= filter * CONV2_OUTPUT * CONV2_OUTPUT + count;
                //result_bram_addra <= 0;
                result_bram_dina <= result1[63-count];
                circle <= circle + 1;
              end
              else if(circle == 3)
              begin
                //result_bram_ena <= 1'b0;
                //result_bram_wea <= 1'b0;
                circle <= 0;
                count <= count + 1;
              end
              else
              begin
                circle <= circle + 1;
              end
            end
            else
            begin
              filter <= filter + 1;
              state <= S_CHECK;
            end
          end
          default:
          begin
            state <= S_IDLE;
            bias_weights_bram_ena <= 1'b0;
            //result_bram_ena <= 1'b0;
            result_bram_wea <= 1'b0;
            input_bram_ena <= 1'b0;
          end
        endcase
      end
    end
  end

  wire pe_finish [5:0];
  genvar i;
  generate
    for(i=0;i<6;i=i+1)
    begin : U
      conv2_PE PE1(
                 .clk (clk),
                 .rst (rst),
                 .ena (ena),
                 .din1 (data_input[i]),
                 .din2 (weight_input[i]),
                 .finish (pe_finish[i]),
                 .douta (result[i])
               );
    end
  endgenerate

  genvar k;
  generate
    for(k=63;k>=0;k=k-1)
    begin : U1
      conv2_add6 add6(
                   .clk (clk),
                   .rst (rst),
                   .ena (pe_finish[0]),
                   .din1 (result[0][k*16+15:k*16]),
                   .din2 (result[1][k*16+15:k*16]),
                   .din3 (result[2][k*16+15:k*16]),
                   .din4 (result[3][k*16+15:k*16]),
                   .din5 (result[4][k*16+15:k*16]),
                   .din6 (result[5][k*16+15:k*16]),
                   .bias (bias[filter]),
                   .dout (result1[k])
                 );

    end
  endgenerate
endmodule
