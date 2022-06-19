module full_subtractor_4bit(x, y, Bin, diff, Bout, overflow);//���� ���� ����� 4bit full subtractor
   input [3:0] x, y;//4bit�� input x�� y
   input Bin;//1bit�� input Bin
   output [3:0] diff;//4bit�� output diff
   output Bout, overflow;//1bit�� output Bout�� overflow
   
   wire B1, B2, B3;//�װ��� full subtractor�� �������ֱ� ���� wire B1, B2, B3
   
   full_subtractor FS1(x[0], y[0], Bin, diff[0], B1);//full_subtractor�� ���� instance FS1
   full_subtractor FS2(x[1], y[1], B1, diff[1], B2);//full_subtractor�� ���� instance FS2
   full_subtractor FS3(x[2], y[2], B2, diff[2], B3);//full_subtractor�� ���� instance FS3
   full_subtractor FS4(x[3], y[3], B3, diff[3], Bout);//full_subtractor�� ���� instance FS4
   xor(overflow, B3, Bout);//overflow detection logic. B3�� Bout�� XOR gate�� ó��, output�� overflow
endmodule



module full_subtractor(x, y, Bin, diff, Bout);//full subtractor
   input x, y, Bin;//1bit�� input x, y, Bin
   output diff, Bout;//1bit�� output diff, Bout
   
   wire d1, B1, B2;//�� half_subtractor�� �������ֱ� ���� wire d1�� 
                   //OR gate�� �� half_subtractor�� �������ֱ� ���� wire B1, B2
   
   half_subtractor HS1(x, y, d1, B1);//half_subtractor�� ���� instance HS1
   half_subtractor HS2(d1, Bin, diff, B2);//half_subtractor�� ���� instance HS2
   or(Bout, B1, B2);//B1�� B2�� OR gate�� ó��, output�� Bout
   
endmodule



module half_subtractor(x, y, diff, borrow);//half subtractor
  input x, y;//1bit�� input x, y
  output diff, borrow;//1bit�� output diff, borrow
  wire xnot;//x�� not������ ����� ������ xnot
  
  xor(diff, x, y);//x�� y�� XOR gate�� ����, output�� diff
  not(xnot, x);//x�� NOT gate�� ����, output�� xnot
  and(borrow, xnot, y);//xnot�� y�� AND gate�� ����, output�� borrow
  
endmodule
