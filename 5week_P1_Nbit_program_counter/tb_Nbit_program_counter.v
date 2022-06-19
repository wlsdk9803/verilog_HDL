`timescale 1ns / 1ps

module tb_Nbit_program_counter();
  reg [7:0] PCdata;
  reg clk, rst_n, PCload, PCinc;
  wire [7:0] PCout;
  
  Nbit_program_counter #(.n(8)) myProgramCounter(PCdata, clk, rst_n, PCload, PCinc, PCout);

  initial begin
    PCdata = 8'b0011_0001; clk = 0; rst_n = 0; PCload = 1; PCinc = 1;
    #3                              rst_n = 1;
    #3                                         PCload = 0;
    #6                                                     PCinc = 0;
    #10                                                    PCinc = 1;
    #20 $finish;
  end

  always #5 clk = ~clk;

endmodule
