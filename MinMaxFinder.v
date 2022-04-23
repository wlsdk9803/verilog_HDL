module MinMaxFinder(
clk,
WriteEn,
WriteReg,
WriteData,
Max,
Min,
Valid);

  input clk;
  input WriteEn;
  input [2:0] WriteReg;
  input [15:0] WriteData;
  output [15:0] Max;
  output [15:0] Min;
  output Valid;
  
  wire start;
  wire [2:0] ReadRegEven, ReadRegOdd;
  wire [15:0] ReadDataEven, ReadDataOdd;
  
  registerFile RF(clk, WriteEn, WriteReg, WriteData, ReadRegEven, ReadRegOdd, ReadDataEven, ReadDataOdd);
  counterRed CR(clk, WriteEn, start);
  counterBlue CB(clk, start, ReadRegEven, ReadRegOdd);
  MinMax minmax_find(clk, start, ReadDataEven, ReadDataOdd, Min, Max, Valid);
endmodule


module registerFile(//8x16bit
clk,
WriteEn, 
WriteReg, 
WriteData, 
ReadRegEven, ReadRegOdd, 
ReadDataEven, ReadDataOdd);

  input clk;
  input WriteEn;
  input [2:0] WriteReg;
  input [15:0] WriteData;
  input [2:0] ReadRegEven, ReadRegOdd;
  output [15:0] ReadDataEven, ReadDataOdd;
  
  reg [15:0] reg_file [0:7];

  assign ReadDataEven = reg_file[ReadRegEven];
  assign ReadDataOdd = reg_file[ReadRegOdd];
  
  always @(posedge clk)
  begin : MEM_WRITE
    if(WriteEn) reg_file[WriteReg] <= WriteData;
  end
 
endmodule


module counterRed(clk, WriteEn, start);
  input clk;
  input WriteEn;
  output reg start;
  
  reg [3:0] countRed;
  
  always @ (posedge clk) begin
    if(!WriteEn) begin//WriteEn�� 0�̸�
      countRed <= 4'b0000;//countRed�� 0���� �ʱ�ȭ
      start <= 1'b0;//start�� 0���� �ʱ�ȭ
    end
    else begin//WriteEn�� 1�̸�
      if(countRed == 4'b1000) start <= 1'b1;//countRed�� 8�̸� start�� 1
                                            //countRed�� �� ����
      else countRed <= countRed + 1;//countRed�� 8�� �ƴϸ�, �� 8���� ������
                                    //countRed�� 1����, start�� �� ����
    end
  end//always
endmodule


module counterBlue(clk, start, ReadRegEven, ReadRegOdd);
  input clk;
  input start;
  output reg [2:0] ReadRegEven;
  output reg [2:0] ReadRegOdd;
  
  always @ (posedge clk) begin
    if(!start) begin
      ReadRegEven <= 3'b000;
      ReadRegOdd <= 3'b001;
    end
    else begin//start�� 1�� ��
      if(ReadRegEven < 6) ReadRegEven <= ReadRegEven + 2; //ReadRegEven�� 6���� ������ 2 ����
                                                           //6�� �Ǹ� �� ����
      if(ReadRegOdd < 7) ReadRegOdd <= ReadRegOdd + 2; //ReadRegOdd�� 7���� ������ 2 ����
                                                        //7�� �Ǹ� �� ����
    end
  end
endmodule


module MinMax(clk, start, ReadDataEven, ReadDataOdd, Min, Max, Valid);
  input clk;
  input start;
  input [15:0] ReadDataEven;
  input [15:0] ReadDataOdd;
  output reg [15:0] Min, Max;//����� ������ �� ���
  output reg Valid;
  
  reg [15:0] min_even, max_even;//¦�� �ּҿ����� �ּڰ�, �ִ�
  reg [15:0] min_odd, max_odd;//Ȧ�� �ּҿ����� �ּڰ�, �ִ�
  reg [15:0] Min_store, Max_store;//�ִ񰪰� �ּڰ��� ��� ����ϸ� ����
  reg [2:0] countNum;//����� ������ ������ count�ϱ� ���� ���
  
  always @(posedge clk) begin
    if(!start) begin//start�� 0�̸�
      min_even <= {16{1'b1}};//�ּڰ��� ����� ���̹Ƿ� ���� ū ������ �ʱ�ȭ
                             //���� ���� ���ϸ� �� ���� ���� min_even�� ����
      max_even <= 16'b0;//�ִ��� ����� ���̹Ƿ� ���� ���� ������ �ʱ�ȭ
                        //���� ���� ���ϸ� �� ū ���� max_even�� ����
      min_odd <= {16{1'b1}};
      max_odd <= 16'b0;
    end
      else begin//if(start)
        if(min_even > ReadDataEven) min_even <= ReadDataEven;
        //min_even�� ReadDataEven���� ũ�� min_even�� ReadDataEven �� �ְ� ũ�� ������ min_even�� �� ����
                                                         
        if(ReadDataEven > max_even) max_even <= ReadDataEven;
        //ReadDataEven�� max_even���� ũ�� max_even�� ReadDataEven �� �ְ� ũ�� ������ max_even�� �� ����
          
        if(min_odd > ReadDataOdd) min_odd <= ReadDataOdd;
        if(ReadDataOdd > max_odd) max_odd <= ReadDataOdd;
      end//else
  end//always
  
  always @(posedge clk) begin
    if(start) begin
        if(min_even > min_odd) Min_store <= min_odd;
          //min_even�� min_odd���� ũ�� Min_store�� min_odd
        else Min_store <= min_even;//min_even�� min_odd���� �۰ų� ������ Min_store�� min_odd
        if(max_even > max_odd) Max_store <= max_even;
        else Max_store <= max_odd;
    end//if(start)
  end//always
  
  always @(posedge clk) begin
    if(!start) begin//start�� 0�� �� �� �ʱ�ȭ
      countNum <= 3'b0; 
      Valid <= 1'b0;
      Min <= 16'b0;
      Max <= 16'b0;
    end
    else begin//if(start)
      if(countNum == 3'b101) begin//countNum�� 4+1�� �Ǹ� Min, Max ���
                                  //clock �ݿ��� ����Ͽ� �����ְ� ��´�.
        Min <= Min_store;//������ ���� Min_store�� Min�� ���
        Max <= Max_store;
        Valid <= 1'b1;//Valid�� 1
      end
      else  countNum <= countNum + 1;//countNum�� 4+1�� �ƴϸ� 
                                     //�� 5���� ������ Min, Max ���
    end//if(start)
  end//always
endmodule