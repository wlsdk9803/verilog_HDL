`timescale 1ns / 1ps

module tb_Nbit_PRPG();
  reg [3:0] seed;
  reg reset, load, clk;
  wire [3:0] count, num;
  wire sequence, valid;
  
  Nbit_PRPG #(.n(4)) PRPG(seed, reset, load, clk, count, num, sequence, valid);
  
  initial begin
    seed = 4'b1111; reset = 1; load = 1; clk = 0;
    #5              reset = 0; load = 1;
    #10             reset = 0; load = 0;
  end
  
  always #6 clk = ~clk;//clk аж╠Б 12ns
  
endmodule

