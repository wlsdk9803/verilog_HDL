`timescale 1ns / 1ps

module tb_encoder();
  reg [2:0] decimal;
  reg enable;
  wire [2:0] out;

  encoder myencoder(decimal, enable, out);

  initial begin
    decimal = 3'b011; enable = 0;
    #10 decimal = 3'b001; enable = 1;
    #10 decimal = 3'b110;
    #10 decimal = 3'b010;
    #10 decimal = 3'b101;
    #10 decimal = 3'b000;
    #10 decimal = 3'b011;
    #10 decimal = 3'b111; enable = 0;
    #10 decimal = 3'b111; enable = 1;
    #10 $finish;
  end
endmodule
