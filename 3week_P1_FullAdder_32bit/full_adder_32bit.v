module full_adder_32bit(x, y, c_in, sum, c_out);//���� ���� ����� 32bit full adder
   input [31:0] x, y;//32bit�� input x�� y
   input c_in;//1bit�� input c_in
   output [31:0] sum;//32bit�� output sum
   output c_out;//1bit�� output c_out
   
   wire carry;//�� 16bit full adder�� �������ֱ� ���� wire carry
   
   full_adder_16bit FA_16bit_1 (x[15:0], y[15:0], c_in, sum[15:0], carry);//full_adder_16bit�� ���� instance FA_16bit_1
   full_adder_16bit FA_16bit_2 (x[31:16], y[31:16], carry, sum[31:16], c_out);//full_adder_16bit�� ���� instance FA_16bit_2
endmodule



module full_adder_16bit(x, y, c_in, sum, c_out);//16bit full adder
   input [15:0] x, y;//16bit�� input x�� y
   input c_in;//1bit�� input c_in
   output [15:0] sum;//16bit�� output sum
   output c_out;//1bit�� output c_out
   
   wire c1, c2, c3;//�װ��� 4bit full adder�� �������ֱ� ���� wire c1, c2, c3
   
   full_adder_4bit FA_4bit_1 (x[3:0], y[3:0], c_in, sum[3:0], c1);//full_adder_4bit�� ���� instance FA_4bit_1
   full_adder_4bit FA_4bit_2 (x[7:4], y[7:4], c1, sum[7:4], c2);//full_adder_4bit�� ���� instance FA_4bit_2
   full_adder_4bit FA_4bit_3 (x[11:8], y[11:8], c2, sum[11:8], c3);//full_adder_4bit�� ���� instance FA_4bit_3
   full_adder_4bit FA_4bit_4 (x[15:12], y[15:12], c3, sum[15:12], c_out);//full_adder_4bit�� ���� instance FA_4bit_4
endmodule



module full_adder_4bit(x, y, c_in, sum, c_out);//4bit full adder
   input [3:0] x, y;//4bit�� input x�� y
   input c_in;//1bit�� input c_in
   output [3:0] sum;//4bit�� output sum
   output c_out;//1bit�� output c_out
   
   wire c1, c2, c3;//�װ��� full adder�� �������ֱ� ���� wire c1, c2, c3
   
   full_adder FA1(x[0], y[0], c_in, sum[0], c1);//full_adder�� ���� instance FA1
   full_adder FA2(x[1], y[1], c1, sum[1], c2);//full_adder�� ���� instance FA2
   full_adder FA3(x[2], y[2], c2, sum[2], c3);//full_adder�� ���� instance FA3
   full_adder FA4(x[3], y[3], c3, sum[3], c_out);//full_adder�� ���� instance FA4
endmodule



module full_adder(x, y, cin, s, cout);//full adder
   input x, y, cin;//1bit�� input x, y, cin
   output s, cout;//1bit�� output s, cout
   
   wire s1, c1, c2;//�� half_adder�� �������ֱ� ���� wire s1�� 
                   //OR gate�� �� half_adder�� �������ֱ� ���� wire c1, c2
   
   half_adder HA1(x, y, s1, c1);//half_adder�� ���� instance HA1
   half_adder HA2(cin, s1, s, c2);//half_adder�� ���� instance HA2
   or(cout, c1, c2);//c1�� c2�� OR gate�� ó��, output�� cout
   
endmodule




module half_adder(x, y, s, c);//half adder
   input x, y;//1bit�� input x, y
   output s, c;//1bit�� output s, c
   
   xor(s, x, y);//x�� y�� XOR gate�� ����, output�� s
   and(c, x, y);//x�� y�� AND gate�� ����, output�� c
   
endmodule
