`timescale 1ns / 1ps

module ReLU(d_in, d_out);
  parameter Z = 10;
  input signed [Z-1:0] d_in;
  output [Z-1:0] d_out;
  
  assign d_out = (d_in[Z-1] == 0) ? d_in : 0;//d_in이 음수면 d_out은 0, 아니면 그대로 d_in 출력
endmodule
