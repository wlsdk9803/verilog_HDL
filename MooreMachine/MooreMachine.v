module MooreMachine(//출력이 현재 state에 의해서만 결정
clk, rst_n, x, y
    );
    input clk, rst_n;
    input x;
    output y;
    
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;
    reg [1:0] present_state, next_state;
    
    always @(present_state or x) begin
      case(present_state)
        S0: if(x) next_state = S2;
            else next_state = S1;
        S1: if(x) next_state = S2;
            else next_state = S0;
        S2: if(x) next_state = S3;
            else next_state = S2;
        S3: if(x) next_state = S1;
            else next_state = S3;
        default: next_state = S0;
      endcase    
    end
    
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) present_state <= S0;
      else       present_state <= next_state;
    end
    
    assign y = (present_state == S1 || present_state == S2);
endmodule
