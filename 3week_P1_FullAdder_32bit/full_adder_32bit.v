module full_adder_32bit(x, y, c_in, sum, c_out);//가장 상위 모듈인 32bit full adder
   input [31:0] x, y;//32bit의 input x와 y
   input c_in;//1bit의 input c_in
   output [31:0] sum;//32bit의 output sum
   output c_out;//1bit의 output c_out
   
   wire carry;//두 16bit full adder를 연결해주기 위한 wire carry
   
   full_adder_16bit FA_16bit_1 (x[15:0], y[15:0], c_in, sum[15:0], carry);//full_adder_16bit에 대한 instance FA_16bit_1
   full_adder_16bit FA_16bit_2 (x[31:16], y[31:16], carry, sum[31:16], c_out);//full_adder_16bit에 대한 instance FA_16bit_2
endmodule



module full_adder_16bit(x, y, c_in, sum, c_out);//16bit full adder
   input [15:0] x, y;//16bit의 input x와 y
   input c_in;//1bit의 input c_in
   output [15:0] sum;//16bit의 output sum
   output c_out;//1bit의 output c_out
   
   wire c1, c2, c3;//네개의 4bit full adder를 연결해주기 위한 wire c1, c2, c3
   
   full_adder_4bit FA_4bit_1 (x[3:0], y[3:0], c_in, sum[3:0], c1);//full_adder_4bit에 대한 instance FA_4bit_1
   full_adder_4bit FA_4bit_2 (x[7:4], y[7:4], c1, sum[7:4], c2);//full_adder_4bit에 대한 instance FA_4bit_2
   full_adder_4bit FA_4bit_3 (x[11:8], y[11:8], c2, sum[11:8], c3);//full_adder_4bit에 대한 instance FA_4bit_3
   full_adder_4bit FA_4bit_4 (x[15:12], y[15:12], c3, sum[15:12], c_out);//full_adder_4bit에 대한 instance FA_4bit_4
endmodule



module full_adder_4bit(x, y, c_in, sum, c_out);//4bit full adder
   input [3:0] x, y;//4bit의 input x와 y
   input c_in;//1bit의 input c_in
   output [3:0] sum;//4bit의 output sum
   output c_out;//1bit의 output c_out
   
   wire c1, c2, c3;//네개의 full adder를 연결해주기 위한 wire c1, c2, c3
   
   full_adder FA1(x[0], y[0], c_in, sum[0], c1);//full_adder에 대한 instance FA1
   full_adder FA2(x[1], y[1], c1, sum[1], c2);//full_adder에 대한 instance FA2
   full_adder FA3(x[2], y[2], c2, sum[2], c3);//full_adder에 대한 instance FA3
   full_adder FA4(x[3], y[3], c3, sum[3], c_out);//full_adder에 대한 instance FA4
endmodule



module full_adder(x, y, cin, s, cout);//full adder
   input x, y, cin;//1bit의 input x, y, cin
   output s, cout;//1bit의 output s, cout
   
   wire s1, c1, c2;//두 half_adder를 연결해주기 위한 wire s1과 
                   //OR gate와 두 half_adder를 연결해주기 위한 wire c1, c2
   
   half_adder HA1(x, y, s1, c1);//half_adder에 대한 instance HA1
   half_adder HA2(cin, s1, s, c2);//half_adder에 대한 instance HA2
   or(cout, c1, c2);//c1과 c2를 OR gate로 처리, output은 cout
   
endmodule




module half_adder(x, y, s, c);//half adder
   input x, y;//1bit의 input x, y
   output s, c;//1bit의 output s, c
   
   xor(s, x, y);//x와 y를 XOR gate로 연산, output은 s
   and(c, x, y);//x와 y를 AND gate로 연산, output은 c
   
endmodule
