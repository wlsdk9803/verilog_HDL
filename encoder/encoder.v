module encoder(deci, en, out);//���� ���� ����� encoder
                                 
  input [2:0] deci;//3bit�� input deci
  input en;//1bit�� input en
  output [2:0] out;//3bit�� output out
  wire [6:0] therm;//�� encoder�� �������ֱ� ���� wire therm
  
  decimal_to_thermometer encoder1(deci, therm);//decimal_to_thermometer�� ���� instance encoder1
  thermometer_to_gray encoder2(therm, en, out);//thermometer_to_gray�� ���� instance encoder2
endmodule


module decimal_to_thermometer(decimal, thermometer);//3bit�� decimal�� 7bit thermometer code�� ��ȯ
  input [2:0] decimal;//3bit input decimal
  output reg [6:0] thermometer;//7bit output thermometer
                               //always �� �ȿ��� �� case�� ���� ���� �������Ƿ� reg�� ����
  
  always @(*) begin
   case(decimal)//decimal ���� ���� thermometer�� case���� �̿��Ͽ� ����
     3'b000 : thermometer = 7'b0000000;//decimal�� 000�̸� thermometer�� 0000000
     3'b001 : thermometer = 7'b0000001;//decimal�� 001�̸� thermometer�� 0000001
     3'b010 : thermometer = 7'b0000011;//decimal�� 010�̸� thermometer�� 0000011
     3'b011 : thermometer = 7'b0000111;//decimal�� 011�̸� thermometer�� 0000111
     3'b100 : thermometer = 7'b0001111;//decimal�� 100�̸� thermometer�� 0001111
     3'b101 : thermometer = 7'b0011111;//decimal�� 101�̸� thermometer�� 0011111
     3'b110 : thermometer = 7'b0111111;//decimal�� 110�̸� thermometer�� 0111111
     3'b111 : thermometer = 7'b1111111;//decimal�� 111�̸� thermometer�� 1111111
   endcase
  end
endmodule


module thermometer_to_gray(thermometer, enable, OUT);//7bit thermometer code�� 3bit gray code�� ��ȯ
  input [6:0] thermometer;//7bit input thermometer
  input enable;//1bit input enable
  output reg [2:0] OUT;//3bit output OUT
  
  always @(*) begin
    if(!enable) OUT = 3'b000;//enable�� 0�̸� OUT�� 000
    else//enable�� 1�� ��
      case(thermometer)
        7'b0000000 : OUT = 3'b000;//thermometer�� 0000000�̸� OUT�� 000
        7'b0000001 : OUT = 3'b001;//thermometer�� 0000001�̸� OUT�� 001
        7'b0000011 : OUT = 3'b011;//thermometer�� 0000011�̸� OUT�� 011
        7'b0000111 : OUT = 3'b010;//thermometer�� 0000111�̸� OUT�� 010
        7'b0001111 : OUT = 3'b110;//thermometer�� 0001111�̸� OUT�� 110
        7'b0011111 : OUT = 3'b111;//thermometer�� 0011111�̸� OUT�� 111
        7'b0111111 : OUT = 3'b101;//thermometer�� 0111111�̸� OUT�� 101
        7'b1111111 : OUT = 3'b100;//thermometer�� 1111111�̸� OUT�� 100
        default: OUT = 3'bxxx;//thermometer�� �� 8���� ��쿡 ���Ե��� �ʴ� ��� xxx
      endcase
   end
endmodule
