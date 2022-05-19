`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/10 16:15:25
// Design Name:
// Module Name: conv1
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


// `define INPUT_NODE 28
// `define IMAGE_SIZE 28
// `define CONV1_DEEP 1
// `define CONV1_SIZE 5
// `define CONV1_OUTPUT 24
// `define DATA_SIZE 16


module conv1 #(
    parameter
    conv1_weights_base = 0,
    conv1_bias_base = 9,
    conv1_result_base = 0,
    DATA_SIZE=16,
    CONV1_OUTPUT=24,
    IMAGE_SIZE = 28,
    CONV1_DEEP = 6,
    CONV1_SIZE = 5
  )
  (
    input clk,
    input rst,
    input conv_1_en,

    //读取参数
    input signed[DATA_SIZE-1:0] bias_weights_bram_douta,
    output reg bias_weights_bram_ena,
    output reg [7:0] bias_weights_bram_addra,
    //读取输入数据
    input signed [DATA_SIZE-1:0] input_bram_douta,
    output reg input_bram_ena,
    output reg [9:0] input_bram_addra,
    //写入卷积结果
    output reg result_bram_wea,
    output reg [11:0] result_bram_addra,
    output reg signed[DATA_SIZE-1:0] result_bram_dina,

    output reg conv_1_finish
  );
  integer filter = 0,
          count = 0,
          count2 = 0,
          S_IDLE          = 7'b1000000,
          S_CHECK         = 7'b0100000,
          S_LOAD_WEIGHTS  = 7'b0010000,
          S_LOAD_BIAS     = 7'b0001000,
          S_LOAD_DATA     = 7'b0000100;


  reg signed [DATA_SIZE-1:0] data2 [24:0];
  wire signed [31:0] result_mul [24:0];
  reg signed [31:0] result_temp;
  reg signed [31:0] result_max;
  reg relu_1_en;
  wire signed[DATA_SIZE-1:0] dout;
  reg signed[DATA_SIZE-1:0] result;
  reg [6:0] state;
  wire signed[DATA_SIZE-1:0] bias [0:5];
  reg load_data;
  reg load_weights;
  reg ans_ena;

  integer count_ans = 0;
  integer circle_datain = 0;
  integer count_now = 0;
  integer count_now1 = 0;

  initial
  begin
    load_data <= 1'b0;
    load_weights <= 1'b0;
    ans_ena <= 1'b0;
    //result_max <= 0;
  end
  assign bias[0] = 16'b1111111111111001;
  assign bias[1] = 16'b0000000000000011;
  assign bias[2] = 16'b0000000000000011;
  assign bias[3] = 16'b1111111111111100;
  assign bias[4] = 16'b1111111111111111;
  assign bias[5] = 16'b1111111111111110;




  genvar i;
  generate for(i=0;i<25;i=i+1)
    begin : U
      multi_16  c1_multi_16 (
                  .CLK                     ( clk   ),
                  .A                       ( data_win[i]     ),
                  .B                       ( data2[i]    ),
                  .P                       ( result_mul[i]     )
                );

    end
  endgenerate

  wire signed [15:0] reg0_out;
  wire signed [15:0] reg1_out;
  wire signed [15:0] reg2_out;
  wire signed [15:0] reg3_out;
  wire signed [15:0] reg4_out;
  reg signed [15:0] data_win [24:0];
  c1_shift_ram_0  u0_c1_shift_ram_0 (.D(input_bram_douta),.CLK(clk),.SCLR(rst),.CE(load_data),.Q(reg0_out));
  c1_shift_ram_0  u1_c1_shift_ram_0 (
                    .D                       ( reg0_out      ),
                    .CLK                     ( clk    ),
                    .SCLR                    ( rst   ),
                    .CE (load_data),
                    .Q                       ( reg1_out      )
                  );
  c1_shift_ram_0  u2_c1_shift_ram_0 (
                    .D                       ( reg1_out      ),
                    .CLK                     ( clk    ),
                    .SCLR                    ( rst   ),
                    .CE (load_data),
                    .Q                       ( reg2_out      )
                  );
  c1_shift_ram_0  u3_c1_shift_ram_0 (
                    .D                       ( reg2_out      ),
                    .CLK                     ( clk    ),
                    .SCLR                    ( rst   ),
                    .CE (load_data),
                    .Q                       ( reg3_out      )
                  );
  c1_shift_ram_0  u4_c1_shift_ram_0 (
                    .D                       ( reg3_out      ),
                    .CLK                     ( clk    ),
                    .SCLR                    ( rst   ),
                    .CE (load_data),
                    .Q                       ( reg4_out      )
                  );
  //卷积窗数据更新
  always@(posedge clk)
  begin
    if(rst)
    begin
      data_win[0]<=0;
      data_win[1]<=0;
      data_win[2]<=0;
      data_win[3]<=0;
      data_win[4]<=0;
      data_win[5]<=0;
      data_win[6]<=0;
      data_win[7]<=0;
      data_win[8]<=0;
      data_win[9]<=0;
      data_win[10]<=0;
      data_win[11]<=0;
      data_win[12]<=0;
      data_win[13]<=0;
      data_win[14]<=0;
      data_win[15]<=0;
      data_win[16]<=0;
      data_win[17]<=0;
      data_win[18]<=0;
      data_win[19]<=0;
      data_win[20]<=0;
      data_win[21]<=0;
      data_win[22]<=0;
      data_win[23]<=0;
      data_win[24]<=0;
    end
    else
    begin
      if(conv_1_en&&load_data)
      begin
        data_win[0]<=data_win[1];
        data_win[1]<=data_win[2];
        data_win[2]<=data_win[3];
        data_win[3]<=data_win[4];
        data_win[4]<=reg4_out;
        data_win[5]<=data_win[6];
        data_win[6]<=data_win[7];
        data_win[7]<=data_win[8];
        data_win[8]<=data_win[9];
        data_win[9]<=reg3_out;
        data_win[10]<=data_win[11];
        data_win[11]<=data_win[12];
        data_win[12]<=data_win[13];
        data_win[13]<=data_win[14];
        data_win[14]<=reg2_out;
        data_win[15]<=data_win[16];
        data_win[16]<=data_win[17];
        data_win[17]<=data_win[18];
        data_win[18]<=data_win[19];
        data_win[19]<=reg1_out;
        data_win[20]<=data_win[21];
        data_win[21]<=data_win[22];
        data_win[22]<=data_win[23];
        data_win[23]<=data_win[24];
        data_win[24]<=reg0_out;
      end
    end
  end

  //移位寄存器数据更新

  always @(posedge clk)
  begin
    if (rst)
    begin
      input_bram_ena <= 1'b0;
      circle_datain <= 0;
    end
    else
    begin
      if(state == S_CHECK)
      begin
        if(filter == CONV1_DEEP)
        begin
          input_bram_ena <= 1'b0;
        end
        else
        begin
          circle_datain <= 0;
        end
      end
      if(load_data)
      begin
        if(count_now < 784)
        begin
          if(circle_datain==0)
          begin
            input_bram_ena <= 1'b1;
            input_bram_addra <= count;
            circle_datain <= circle_datain + 1;
          end
          else if(circle_datain==3)
          begin
            input_bram_addra <= count;
            if(state == S_CHECK)
            begin
              count_now <= 0;
              count_now1 <= 0;
            end
            else if(state == S_LOAD_WEIGHTS)
            begin
              count_now <= count_now +1;
              if(count_now1 == 145)
                count_now1 <= 0;
              else
                count_now1 <= count_now1 +1;
            end
            else if(state == S_LOAD_BIAS)
            begin
              count_now <= count_now +1;
              if(count_now1 == 23)
                count_now1 <= 0;
              else
                count_now1 <= count_now1 +1;
            end
            else if(state == S_LOAD_DATA)
            begin
              count_now <= count_now + 1;
              if(count_now1 == 3)
                count_now1 <= 0;
              else
                count_now1 <= count_now1 + 1;
            end
          end
          else
          begin
            input_bram_addra <= count;
            circle_datain <= circle_datain + 1;
          end
        end
        else if(count_now<812)
        begin
          if(state == S_CHECK)
          begin
            count_now <= 0;
            count_now1 <= 0;
          end
          else if(state == S_LOAD_WEIGHTS)
          begin
            count_now <= count_now +1;
            if(count_now1 == 145)
              count_now1 <= 0;
            else
              count_now1 <= count_now1 +1;
          end
          else if(state == S_LOAD_BIAS)
          begin
            count_now <= count_now +1;
            if(count_now1 == 23)
              count_now1 <= 0;
            else
              count_now1 <= count_now1 +1;
          end
          else if(state == S_LOAD_DATA)
          begin
            count_now <= count_now + 1;
            if(count_now1 == 3)
              count_now1 <= 0;
            else
              count_now1 <= count_now1 + 1;
          end
        end
        else if(count_now == 812)
        begin
          //filter <= filter + 1;
          count_now <= 0;
          //state <= S_CHECK;
        end
      end
    end
  end

  //weights数据更新
  integer circle_weights = 0;
  always @(posedge clk)
  begin
    if (rst)
    begin
      bias_weights_bram_ena <= 1'b0;
      circle_weights <= 0;
    end
    else
    begin
      if(state == S_CHECK)
      begin
        if(filter == CONV1_DEEP)
        begin
          bias_weights_bram_ena <= 1'b0;
        end
        else
        begin
          circle_weights <= 0;
        end
      end
      if(load_weights)
      begin
        if (state == S_CHECK)
          count <= 0;
        else
          count <= count + 1;
        if(count_now < 25)
        begin
          if(circle_weights==0)
          begin
            bias_weights_bram_ena <= 1'b1;
            bias_weights_bram_addra <= filter * 25 + count;
            circle_weights <= circle_weights + 1;
          end
          else if(circle_weights==3)
          begin
            data2[count_now] <= bias_weights_bram_douta;
            bias_weights_bram_addra <= filter * 25 + count;
          end
          else
          begin
            bias_weights_bram_addra <= filter * 25 + count;
            circle_weights <= circle_weights + 1;
          end
        end
      end
    end
  end

  //计算结果
  always @(posedge clk )
  begin
    if(state == S_IDLE)
      result <= 0;
    else if(state == S_CHECK)
    begin
      if(filter <= CONV1_DEEP)
      begin
        count_ans <= 0;
      end
    end
    if(ans_ena)
    begin
      result_temp = result_mul[0]+result_mul[1]+result_mul[2]+result_mul[3]+result_mul[4]+
                  result_mul[5]+result_mul[6]+result_mul[7]+result_mul[8]+result_mul[9]+
                  result_mul[10]+result_mul[11]+result_mul[12]+result_mul[13]+result_mul[14]+
                  result_mul[15]+result_mul[16]+result_mul[17]+result_mul[18]+result_mul[19]+
                  result_mul[20]+result_mul[21]+result_mul[22]+result_mul[23]+result_mul[24]+bias[filter];

      // if(result_temp>result_max)
      //   result_max = result_temp;
      result = (result_temp[31] == 1'b1) ? 16'b0 : {result_temp[31],result_temp[14:0]};
      count_ans = count_ans+1;
    end
  end
  //数据存储


  always @(posedge clk )
  begin
    if (rst)
    begin
      result_bram_wea <= 1'b0;
    end
    else
    begin
      if(state == S_CHECK)
      begin
        if(filter == CONV1_DEEP)
        begin
          result_bram_wea <= 1'b0;
        end
      end
      if(load_data)
      begin
        if(load_data)
        begin
          result_bram_wea <= 1'b1;
          result_bram_addra <= filter*576 + count_ans-1;
          result_bram_dina <= result;
        end
      end
    end
  end

  always@(posedge clk)
  begin
    if(rst == 1'b1)
    begin
      state <= S_IDLE;
    end
    else
    begin
      if(conv_1_en == 1'b1)
      begin
        case(state)
          S_IDLE:
          begin
            filter <= 0;
            relu_1_en <= 1'b1;
            //result <= 0;
            conv_1_finish <= 1'b0;
            state <= S_CHECK;
          end
          S_CHECK:
          begin
            if(filter == CONV1_DEEP)
            begin
              //bias_weights_bram_ena <= 1'b0;
              //result_bram_wea <= 1'b0;
              //input_bram_ena <= 1'b0;
              conv_1_finish <= 1'b1;
              load_data <= 1'b0;
              load_weights <= 1'b0;
              ans_ena <= 1'b0;
            end
            else
            begin
              load_data <= 1'b1;
              load_weights <= 1'b1;
              //circle_datain <= 0;
              //circle_weights <= 0;
              //count <= 0;
              //count_ans <= 0;
              //count_now <= 0;
              //count_now1 <= 0;
              state <= S_LOAD_WEIGHTS;
              ans_ena <= 1'b0;
            end
          end
          S_LOAD_WEIGHTS:
          begin
            if(count_now1 == 145)
            begin
              state <= S_LOAD_BIAS;
              ans_ena <= 1'b1;
              //count_now1 <= 0;
            end
          end
          S_LOAD_BIAS:
          begin
            if(count_now1 == 23)
            begin
              state <= S_LOAD_DATA;
              ans_ena <= 1'b0;
              //count_now1 <= 0;
            end
            else if(count_now == 812)
            begin
              state <= S_CHECK;
              filter <= filter + 1;
            end
          end
          S_LOAD_DATA:
          begin
            if(count_now1 == 3)
            begin
              //count_now1 <= 0;
              state <= S_LOAD_BIAS;
              ans_ena <= 1'b1;
            end
          end
          default:
          begin
            state <= S_IDLE;
          end
        endcase
      end
    end
  end
endmodule
