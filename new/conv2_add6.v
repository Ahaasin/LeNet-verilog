module conv2_add6#(
    DATA_SIZE = 16
  )
  (
    input clk,
    input rst,
    input ena,
    input signed [DATA_SIZE-1:0] din1,
    input signed [DATA_SIZE-1:0] din2,
    input signed [DATA_SIZE-1:0] din3,
    input signed [DATA_SIZE-1:0] din4,
    input signed [DATA_SIZE-1:0] din5,
    input signed [DATA_SIZE-1:0] din6,
    input signed [DATA_SIZE-1:0] bias,
    output signed [DATA_SIZE-1:0] dout
  );

  reg signed [DATA_SIZE+2:0] temp;
  reg signed [DATA_SIZE-1:0] result;
  wire signed [DATA_SIZE-1:0] relu_result;
  relu u1_relu (
         //ports
         .din(result),
         .dout(relu_result)
       );
  always @(posedge clk )
  begin
    if (ena)
    begin
      temp <= din1+din2+din3+din4+din5+din6+bias;
      result <= {temp[DATA_SIZE+2],temp[14:0]};
    end
    else begin
        temp <= 0;
    end
  end

  assign dout = relu_result;

endmodule
