`timescale 1ns / 1ps

module tb_full_adder_32bit();
   reg [31:0] x, y;
   reg c_in;
   wire [31:0] sum;
   wire c_out;
   
   full_adder_32bit FA_32bit(x, y, c_in, sum, c_out);
   
   initial begin
      x = 32'b01001100100111110110000010100011; 
      y = 32'b00000101110000010111100000001100; 
      c_in = 1'b0;
      #10 x = 32'b01100000110100110101110001111010;
      #10 y = 32'b11001111100000011010001101001001;
      #10 $finish;
   end
endmodule

