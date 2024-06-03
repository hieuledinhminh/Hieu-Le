module alu(
  input logic [3:0] a,
  input logic [3:0] b,
  input logic [2:0] op,

  output logic [3:0] result,
  output logic carry
);
  wire logic [3:0] result_add;
  wire logic [3:0] result_sub;
  wire logic [3:0] result_and;
  wire logic [3:0] result_or;
  wire logic [3:0] result_xor;
  wire logic [3:0] result_not;
  wire logic [3:0] result_shift_left;
  wire logic [3:0] result_shift_right;

  wire logic [3:0] w1;
  wire logic [2:0] not_op;
  wire logic carry_1;
  wire logic carry_out1;
  wire logic carry_2;
  wire logic not_carry_2;
  wire logic carry_out2;

  // For Add
  ripple_adder ripple1(a, b, result_add, carry_1, 1'b0);

  // For Sub
  not4bit not1(b,w1);
  ripple_adder ripple2(a, w1, result_sub, carry_2, 1'b1);

  // For AND
  and4bit and4bit(a,b,result_and);
  
  // For OR
  or4bit or4bit(a,b,result_or);
  
  // For XOR
  xor4bit xor4bit(a,b,result_xor);
  
  // For NOT
  not4bit not2(a,result_not);
  
  // For Shift Left
  shift_left shift_left(a,b,result_shift_left);
  
  // For Shift Right
  shift_right shift_right(a,b,result_shift_right);
  
  // Mux Opcode
  mux8by1 mux_bit0(result_add[0],result_sub[0],result_and[0],result_or[0],
                 result_xor[0],result_not[0],result_shift_right[0],result_shift_left[0],
                 op[0],op[1],op[2],
                 result[0]);
  mux8by1 mux_bit1(result_add[1],result_sub[1],result_and[1],result_or[1],
                   result_xor[1],result_not[1],result_shift_right[1],result_shift_left[1],
                  op[0],op[1],op[2],
                   result[1]);
  
  mux8by1 mux_bit2(result_add[2],result_sub[2],result_and[2],result_or[2],
                   result_xor[2],result_not[2],result_shift_right[2],result_shift_left[2],
                   op[0],op[1],op[2],
                   result[2]);
  mux8by1 mux_bit3(result_add[3],result_sub[3],result_and[3],result_or[3],
                   result_xor[3],result_not[3],result_shift_right[3],result_shift_left[3],
                   op[0],op[1],op[2],
                   result[3]);
  
  not(not_op[0],op[0]);
  not(not_op[1],op[1]);
  not(not_op[2],op[2]);
  not(not_carry_2,carry_2);
  and4 for_carryadd(carry_1,not_op[0],not_op[1],not_op[2],carry_out1);
  and4 for_carrysub(not_carry_2,op[0],not_op[1],not_op[2],carry_out2);
  or(carry,carry_out1,carry_out2);
endmodule
