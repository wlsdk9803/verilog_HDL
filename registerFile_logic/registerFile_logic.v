module registerFile_logic(
clk,
rst,
start,
ReadRegA1, ReadRegA2, WriteRegA, WriteEnA, WriteDataA,
ReadRegB, WriteRegB, WriteEnB, WriteDataB,
out1, 
out2);

  input clk, rst;
  input start;
  output [3:0] out1;
  output reg [3:0] out2;
    
  input WriteEnA;
  input [3:0] WriteDataA;
  input [2:0] ReadRegA1, ReadRegA2;
  input [2:0] WriteRegA;
  wire [3:0] ReadDataA1, ReadDataA2;
  
  input WriteEnB;
  input [7:0] WriteDataB;
  input [3:0] ReadRegB;
  input [3:0] WriteRegB;
  wire [7:0] ReadDataB;
  
  wire [3:0] sum;
  wire c_out;
  
  registerFile_A registerA(clk, rst, ReadRegA1, ReadRegA2, WriteRegA, WriteEnA, WriteDataA, ReadDataA1, ReadDataA2);
  registerFile_B registerB(clk, rst, ReadRegB, WriteRegB, WriteEnB, WriteDataB, ReadDataB);
  halfAdder_4bit HA(start, ReadDataA1[3:0], ReadDataB[7:4], c_out, sum);//halfAdder_4bit(start, in1,in2, c_out, sum)
  
  assign out1 = c_out? {c_out, sum[3:1]} : sum;//c_out이 1이면 out1은 {c_out, sum[3:1]}, 0이면 sum
  always @(start, ReadDataA2, ReadDataB) begin//out2는 ReadDataA2와 ReadDataB[3:0] 중 큰 수 출력
    if(start) begin
      if(ReadDataA2 > ReadDataB[3:0]) out2 = ReadDataA2;
      else out2 = ReadDataB[3:0]; end
    else out2 = 4'bxxxx;//start가 0이면 unknown으로 초기화
  end
endmodule


module registerFile_A(
clk, rst, 
ReadRegA1, ReadRegA2, 
WriteRegA, 
WriteEnA, 
WriteDataA, 
ReadDataA1, ReadDataA2);//8X4bit register file A

  input clk, rst;
  input WriteEnA;
  input [3:0] WriteDataA;
  input [2:0] ReadRegA1, ReadRegA2;
  input [2:0] WriteRegA;
  output [3:0] ReadDataA1, ReadDataA2;
  
  reg [3:0] reg_file1 [0:7];//8x4bit
  
  assign ReadDataA1=reg_file1[ReadRegA1];//ReadDataA1은 reg_file1에서 ReadRegA1번째에 적혀있는 것
  assign ReadDataA2=reg_file1[ReadRegA2];
  
  always @(posedge clk or posedge rst) begin
    if(rst) $readmemh("memory1.mem", reg_file1);//reset이 1이면 reg_file1에 "memory1.mem"의 내용을 적는다.
    else if(WriteEnA) reg_file1[WriteRegA] <= WriteDataA;//reset이 0일 때 WriteEnA가 1이면
                                                         //reg_file1에서 WriteRegA번째에 적혀있는 것은 WriteDataA
  end
endmodule


module registerFile_B(
clk, rst, 
ReadRegB, 
WriteRegB, 
WriteEnB, 
WriteDataB, 
ReadDataB);//16X8bit register file B

  input clk, rst;
  input WriteEnB;
  input [7:0] WriteDataB;
  input [3:0] ReadRegB;
  input [3:0] WriteRegB;
  output [7:0] ReadDataB;
  
  reg [7:0] reg_file2 [0:15];//16x8bit
  
  assign ReadDataB=reg_file2[ReadRegB];//ReadDataB는 reg_file2에서 ReadRegA1번째에 적혀있는 것
  
  always @(posedge clk or posedge rst) begin
    if(rst) $readmemh("memory2.mem", reg_file2);//reset이 1이면 
                                                   //reg_file2에 "memory2.mem"의 내용을 적는다.
    else if(WriteEnB) reg_file2[WriteRegB] <= WriteDataB;//reset이 0일 때 WriteEnB가 1이면
                                                         //reg_file2에서 WriteRegB번째에 적혀있는 것은 WriteDataB
  end
endmodule


module halfAdder_4bit(start, in1,in2, c_out, sum);//4bit half adder
  input start;
  input [3:0] in1;
  input [3:0] in2;
  output reg c_out;
  output reg [3:0] sum;
  
  reg c1, c2, c3;//1개의 1bit half adder과 3개의 1bit full adder을 이어주는 reg c1, c2, c3

 always @(*) begin
   if(start) begin//start가 1일 때
     sum[0] = in1[0] ^ in2[0];//LSB의 1bit half adder
     c1 = in1[0] & in2[0];
     
     {c2, sum[1]} = in1[1] + in2[1] + c1;//1bit full adder
     {c3, sum[2]} = in1[2] + in2[2] + c2;
     {c_out, sum[3]} = in1[3] + in2[3] + c3;
   end
   else begin//start가 0일 때
     c_out=1'bx;//unknown 값으로 초기화
     sum = 4'bxxxx;
   end
  end
endmodule
