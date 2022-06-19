`timescale 1ns / 1ps

module tb_updown_counter();
  reg [3:0] D;
  reg rst_n, clk, E, L, S;
  wire [3:0] O;
  
  updown_counter mycounter(clk, rst_n, D, L, E, S, O);
  
  initial begin
       D = 4'b0111; rst_n = 0; E = 1; L = 1; S = 1; clk = 0; 
    #3 D = 4'b0101; rst_n = 1;
    #3                         E = 0; L = 0; S = 0;
    #3 D = 4'b1001;            E = 1; 
    #3                                       S = 1;
    #6                                       S = 0;
    #15                                      S = 1;
    #8                                       S = 0;
    #20 $finish;
  end

always #5 clk = ~clk;//clock period 10ns

endmodule
