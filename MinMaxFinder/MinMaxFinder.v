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
    if(!WriteEn) begin//WriteEn이 0이면
      countRed <= 4'b0000;//countRed는 0으로 초기화
      start <= 1'b0;//start도 0으로 초기화
    end
    else begin//WriteEn이 1이면
      if(countRed == 4'b1000) start <= 1'b1;//countRed가 8이면 start는 1
                                            //countRed는 값 유지
      else countRed <= countRed + 1;//countRed가 8이 아니면, 즉 8보다 작으면
                                    //countRed는 1증가, start는 값 유지
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
    else begin//start가 1일 때
      if(ReadRegEven < 6) ReadRegEven <= ReadRegEven + 2; //ReadRegEven가 6보다 작으면 2 증가
                                                           //6이 되면 값 유지
      if(ReadRegOdd < 7) ReadRegOdd <= ReadRegOdd + 2; //ReadRegOdd가 7보다 작으면 2 증가
                                                        //7이 되면 값 유지
    end
  end
endmodule


module MinMax(clk, start, ReadDataEven, ReadDataOdd, Min, Max, Valid);
  input clk;
  input start;
  input [15:0] ReadDataEven;
  input [15:0] ReadDataOdd;
  output reg [15:0] Min, Max;//계산이 끝났을 때 출력
  output reg Valid;
  
  reg [15:0] min_even, max_even;//짝수 주소에서의 최솟값, 최댓값
  reg [15:0] min_odd, max_odd;//홀수 주소에서의 최솟값, 최댓값
  reg [15:0] Min_store, Max_store;//최댓값과 최솟값을 계속 계산하며 저장
  reg [2:0] countNum;//계산이 끝나는 지점을 count하기 위해 사용
  
  always @(posedge clk) begin
    if(!start) begin//start가 0이면
      min_even <= {16{1'b1}};//최솟값을 출력할 것이므로 제일 큰 값으로 초기화
                             //이후 값을 비교하며 더 작은 값을 min_even에 대입
      max_even <= 16'b0;//최댓값을 출력할 것이므로 제일 작은 값으로 초기화
                        //이후 값을 비교하며 더 큰 값을 max_even에 대입
      min_odd <= {16{1'b1}};
      max_odd <= 16'b0;
    end
      else begin//if(start)
        if(min_even > ReadDataEven) min_even <= ReadDataEven;
        //min_even이 ReadDataEven보다 크면 min_even에 ReadDataEven 값 넣고 크지 않으면 min_even은 값 유지
                                                         
        if(ReadDataEven > max_even) max_even <= ReadDataEven;
        //ReadDataEven이 max_even보다 크면 max_even에 ReadDataEven 값 넣고 크지 않으면 max_even은 값 유지
          
        if(min_odd > ReadDataOdd) min_odd <= ReadDataOdd;
        if(ReadDataOdd > max_odd) max_odd <= ReadDataOdd;
      end//else
  end//always
  
  always @(posedge clk) begin
    if(start) begin
        if(min_even > min_odd) Min_store <= min_odd;
          //min_even이 min_odd보다 크면 Min_store은 min_odd
        else Min_store <= min_even;//min_even이 min_odd보다 작거나 같으면 Min_store은 min_odd
        if(max_even > max_odd) Max_store <= max_even;
        else Max_store <= max_odd;
    end//if(start)
  end//always
  
  always @(posedge clk) begin
    if(!start) begin//start가 0일 때 값 초기화
      countNum <= 3'b0; 
      Valid <= 1'b0;
      Min <= 16'b0;
      Max <= 16'b0;
    end
    else begin//if(start)
      if(countNum == 3'b101) begin//countNum이 4+1가 되면 Min, Max 출력
                                  //clock 반영을 고려하여 여유있게 잡는다.
        Min <= Min_store;//저장해 놓은 Min_store을 Min에 출력
        Max <= Max_store;
        Valid <= 1'b1;//Valid는 1
      end
      else  countNum <= countNum + 1;//countNum이 4+1이 아니면 
                                     //즉 5보다 작으면 Min, Max 출력
    end//if(start)
  end//always
endmodule
