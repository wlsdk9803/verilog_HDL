module encoder(deci, en, out);//가장 상위 모듈인 encoder
                                 
  input [2:0] deci;//3bit의 input deci
  input en;//1bit의 input en
  output [2:0] out;//3bit의 output out
  wire [6:0] therm;//두 encoder를 연결해주기 위한 wire therm
  
  decimal_to_thermometer encoder1(deci, therm);//decimal_to_thermometer에 대한 instance encoder1
  thermometer_to_gray encoder2(therm, en, out);//thermometer_to_gray에 대한 instance encoder2
endmodule


module decimal_to_thermometer(decimal, thermometer);//3bit의 decimal를 7bit thermometer code로 변환
  input [2:0] decimal;//3bit input decimal
  output reg [6:0] thermometer;//7bit output thermometer
                               //always 문 안에서 각 case에 따라 값이 정해지므로 reg로 선언
  
  always @(*) begin
   case(decimal)//decimal 값에 따른 thermometer를 case문을 이용하여 정함
     3'b000 : thermometer = 7'b0000000;//decimal이 000이면 thermometer는 0000000
     3'b001 : thermometer = 7'b0000001;//decimal이 001이면 thermometer는 0000001
     3'b010 : thermometer = 7'b0000011;//decimal이 010이면 thermometer는 0000011
     3'b011 : thermometer = 7'b0000111;//decimal이 011이면 thermometer는 0000111
     3'b100 : thermometer = 7'b0001111;//decimal이 100이면 thermometer는 0001111
     3'b101 : thermometer = 7'b0011111;//decimal이 101이면 thermometer는 0011111
     3'b110 : thermometer = 7'b0111111;//decimal이 110이면 thermometer는 0111111
     3'b111 : thermometer = 7'b1111111;//decimal이 111이면 thermometer는 1111111
   endcase
  end
endmodule


module thermometer_to_gray(thermometer, enable, OUT);//7bit thermometer code를 3bit gray code로 변환
  input [6:0] thermometer;//7bit input thermometer
  input enable;//1bit input enable
  output reg [2:0] OUT;//3bit output OUT
  
  always @(*) begin
    if(!enable) OUT = 3'b000;//enable이 0이면 OUT은 000
    else//enable이 1일 때
      case(thermometer)
        7'b0000000 : OUT = 3'b000;//thermometer이 0000000이면 OUT은 000
        7'b0000001 : OUT = 3'b001;//thermometer이 0000001이면 OUT은 001
        7'b0000011 : OUT = 3'b011;//thermometer이 0000011이면 OUT은 011
        7'b0000111 : OUT = 3'b010;//thermometer이 0000111이면 OUT은 010
        7'b0001111 : OUT = 3'b110;//thermometer이 0001111이면 OUT은 110
        7'b0011111 : OUT = 3'b111;//thermometer이 0011111이면 OUT은 111
        7'b0111111 : OUT = 3'b101;//thermometer이 0111111이면 OUT은 101
        7'b1111111 : OUT = 3'b100;//thermometer이 1111111이면 OUT은 100
        default: OUT = 3'bxxx;//thermometer이 위 8가지 경우에 포함되지 않는 경우 xxx
      endcase
   end
endmodule
