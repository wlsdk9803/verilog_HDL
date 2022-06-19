module MealyMachine(//출력이 현재 state와 입력에 의해 결정
clk, rst_n, x, y
    );
    input clk, rst_n;
    input x;
    output reg y;
    
    localparam S0=2'b00,
               S1=2'b01,
               S2=2'b10,
               S3=2'b11;
               
    reg [1:0] present_state, next_state;
    
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) present_state <= S0;
      else       present_state <= next_state;    
    end
    
    always @(present_state or x) begin
      y=0;
      next_state=S0;
      case(present_state)
        S0: if(x) begin
              y=1;
              next_state=S2;
            end
            else begin
              y=0;
              next_state=S0;
            end
        S1: if(x) begin
              y=0;
              next_state=S2;
            end
            else begin
              y=0;
             next_state=S0;
            end
        S2: if(x) begin
              y=0;
              next_state=S3;
            end
            else begin
              y=1;
              next_state=S2;
            end
        S3: if(x) begin
              y=1;
              next_state=S1;
            end
            else begin
              y=0;
              next_state=S3;
            end
      endcase
    end
endmodule
