`timescale 1ns / 1ps

module tb_full_subtractor_4bit();
   reg [3:0] x, y;
   reg B_in;
   wire [3:0] Diff;
   wire B_out, overflow;
   
   full_subtractor_4bit FS4bit(x, y, B_in, Diff, B_out, overflow);
   
   initial begin
      x = 4'b0011; y = 4'b0110; B_in = 1'b0;
      #10 x = 4'b0110;
      #10 y = 4'b0101;
      #10 x = 4'b1010;
      #10 y = 4'b0001;
      #10 $finish;
   end
endmodule

