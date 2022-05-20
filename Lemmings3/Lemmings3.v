module Lemmings3(clk, areset, bump_left, bump_right, ground, dig, walk_left, walk_right, aaah, digging);
  input clk;
  input areset;
  input bump_left;
  input bump_right;
  input ground;
  input dig;
  output walk_left;
  output walk_right;
  output aaah;
  output digging;

  localparam WALK_LEFT = 3'b000,//왼쪽으로 걷는 상태
             WALK_RIGHT = 3'b001,//오른쪽으로 걷는 상태
             FALL_LEFT = 3'b010,//왼쪽으로 걷다가 떨어지는 상태
             FALL_RIGHT = 3'b011,//오른쪽으로 걷다가 떨어지는 상태
             DIG_LEFT = 3'b100,//왼쪽으로 가며 땅을 파는 상태
             DIG_RIGHT = 3'b101;//오른쪽으로 가며 땅을 파는 상태
            
  reg [2:0] present_state, next_state;
  
  //다음 상태 결정
  always @(*) begin
    case(present_state)
      WALK_LEFT://현재 상태가 WALK_LEFT일 때
          if(!ground) next_state = FALL_LEFT;//땅이 없으면 FALL_LEFT
          else begin//땅이 있으면
            //dig가 0일 때 bump_left가 있으면 WALK_RIGHT, 없으면 현재 상태 유지
            if(!dig) next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
            else next_state = DIG_LEFT;//dig가 1일 때 DIG_LEFT
          end
      WALK_RIGHT://현재 상태가 WALK_RIGHT일 때
          if(!ground) next_state = FALL_RIGHT;//땅이 없으면 FALL_RIGHT
          else begin//땅이 있으면
            //dig가 0일 때 bump_right이 있으면 WALK_LEFT, 없으면 현재 상태 유지
            if(!dig) next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
            else next_state = DIG_RIGHT;//dig가 1일 때 DIG_RIGHT
          end
      FALL_LEFT://현재 상태가 FALL_LEFT일 때
          next_state = ground ? WALK_LEFT : FALL_LEFT;//땅이 있으면 WALK_LEFT, 없으면 상태 유지
      FALL_RIGHT://현재 상태가 FALL_RIGHT일 때
          next_state = ground ? WALK_RIGHT : FALL_RIGHT;//땅이 있으면 WALK_RIGHT, 없으면 상태 유지
      DIG_LEFT://현재 상태가 DIG_LEFT일 때
          next_state = ground ? DIG_LEFT : FALL_LEFT;//땅이 없으면 FALL_LEFT, 있으면 상태 유지
      DIG_RIGHT://현재 상태가 DIG_RIGHT일 때
          next_state = ground ? DIG_RIGHT : FALL_RIGHT;//땅이 없으면 FALL_RIGHT, 있으면 상태 유지
      default:
          next_state = WALK_LEFT;//기본 값은 WALK_LEFT
    endcase
  end
  
  //현재 상태 결정
  always @(posedge clk or negedge areset) begin
    if(!areset) present_state <= WALK_LEFT;//areset이 0이면 현재 상태 WALK_LEFT으로 초기화
    else       present_state <= next_state;//areset이 1이면 현재 상태는 다음 상태
  end
  
  //출력 계산
  assign walk_left = (present_state == WALK_LEFT);//walk_left는 현재 상태가 WALK_LEFT일 때만 1, 그 외의 경우에는 0
  assign walk_right = (present_state == WALK_RIGHT);//walk_right는 현재 상태가 WALK_RIGHT일 때만 1, 그 외의 경우에는 0
  //aaah는 현재 상태가 FALL_LEFT이거나 FALL_RIGHT일 때만 1, 그 외의 경우에는 0
  assign aaah = (present_state == FALL_LEFT) || (present_state == FALL_RIGHT);
  //digging은 현재 상태가 DIG_LEFT이거나 DIG_RIGHT일 때만 1, 그 외의 경우에는 0
  assign digging = (present_state == DIG_LEFT) || (present_state == DIG_RIGHT);
endmodule