module full_subtractor_4bit(x, y, Bin, diff, Bout, overflow);//가장 상위 모듈인 4bit full subtractor
   input [3:0] x, y;//4bit의 input x와 y
   input Bin;//1bit의 input Bin
   output [3:0] diff;//4bit의 output diff
   output Bout, overflow;//1bit의 output Bout과 overflow
   
   wire B1, B2, B3;//네개의 full subtractor를 연결해주기 위한 wire B1, B2, B3
   
   full_subtractor FS1(x[0], y[0], Bin, diff[0], B1);//full_subtractor에 대한 instance FS1
   full_subtractor FS2(x[1], y[1], B1, diff[1], B2);//full_subtractor에 대한 instance FS2
   full_subtractor FS3(x[2], y[2], B2, diff[2], B3);//full_subtractor에 대한 instance FS3
   full_subtractor FS4(x[3], y[3], B3, diff[3], Bout);//full_subtractor에 대한 instance FS4
   xor(overflow, B3, Bout);//overflow detection logic. B3와 Bout을 XOR gate로 처리, output은 overflow
endmodule



module full_subtractor(x, y, Bin, diff, Bout);//full subtractor
   input x, y, Bin;//1bit의 input x, y, Bin
   output diff, Bout;//1bit의 output diff, Bout
   
   wire d1, B1, B2;//두 half_subtractor를 연결해주기 위한 wire d1과 
                   //OR gate와 두 half_subtractor를 연결해주기 위한 wire B1, B2
   
   half_subtractor HS1(x, y, d1, B1);//half_subtractor에 대한 instance HS1
   half_subtractor HS2(d1, Bin, diff, B2);//half_subtractor에 대한 instance HS2
   or(Bout, B1, B2);//B1과 B2를 OR gate로 처리, output은 Bout
   
endmodule



module half_subtractor(x, y, diff, borrow);//half subtractor
  input x, y;//1bit의 input x, y
  output diff, borrow;//1bit의 output diff, borrow
  wire xnot;//x를 not연산한 결과를 전달할 xnot
  
  xor(diff, x, y);//x와 y를 XOR gate로 연산, output은 diff
  not(xnot, x);//x를 NOT gate로 연산, output은 xnot
  and(borrow, xnot, y);//xnot과 y를 AND gate로 연산, output은 borrow
  
endmodule
