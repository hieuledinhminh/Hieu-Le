module synth_wrapper(rst_n,clk,a,b,op,result,carry);

	input [3:0] a;
	input [3:0] b;
	input [2:0] op;
	input rst_n;
	input clk;

	output reg [3:0] result;
	output reg carry;
 
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [2:0] op_reg;
	wire [3:0] result_reg;
	wire carry_reg;

always@(posedge clk, posedge rst_n) begin
    if(rst_n) begin
       a_reg <= 4'h0;
       b_reg <= 4'h0;
       op_reg <= 3'h0;
       result <= 4'h0;
       carry <= 1'b0;
    end
	 
    else begin
       a_reg <= a;
       b_reg <= b;
       op_reg <= op;
       result <= result_reg;
       carry <= carry_reg;
    end
end 
	 alu u1(.a(a_reg), .b(b_reg), .op(op_reg), .result(result_reg), .carry(carry_reg));


endmodule

module alu(a,b,op,result,carry);

	input	[3:0]a;
	input	[3:0]b;
	input	[2:0]op;

	output [3:0]result;
	output carry;

	wire wire_carry1;
	wire wire_carry2;	
	wire wire_carry3;
	
	assign wire_carry3 = ~wire_carry2;
	
	wire [3:0]wire_in1;
	wire [3:0]wire_in2;
	wire [3:0]wire_in3;
	wire [3:0]wire_in4;
	wire [3:0]wire_in5;
	wire [3:0]wire_in6;
	wire [3:0]wire_in7;
	wire [3:0]wire_in8;

	ripple_adder 	add_t1 	(.a(a), .b(b), .s(wire_in1), .Co(wire_carry1), .Cin(1'b0));
	ripple_subtr 	sub_t2 	(.a(a), .b(b), .s(wire_in2), .Co(wire_carry2), .Cin(1'b1));
	and4bit 			and_t3 	(.a(a), .b(b), .s(wire_in3));
	or4bit 			or_t4 	(.a(a), .b(b), .s(wire_in4));
	xor4bit 			xor_t5 	(.a(a), .b(b), .s(wire_in5));
	not4bit 			not_t6 	(.a(a), .s(wire_in6));
	shift_left 		left_t7 	(.a(a), .b(b), .s(wire_in7));
	shift_right 	right_t8 (.a(a), .b(b), .s(wire_in8));
	mux8by1 mux_t9 (	
							.in1(wire_in1),
							.in2(wire_in2), 
							.in3(wire_in3), 
							.in4(wire_in4), 
							.in5(wire_in5),
							.in6(wire_in6),
							.in7(wire_in7),
							.in8(wire_in8),
							.op(op),
							.result(result)
							);
	mux8by1_1bit mux_t10 (	
							.in1(wire_carry1),
							.in2(wire_carry3), 
							.in3(1'b0), 
							.in4(1'b0), 
							.in5(1'b0),
							.in6(1'b0),
							.in7(1'b0),
							.in8(1'b0),
							.op(op),
							.carry(carry)
							);
endmodule 

////////////////  mux8by1 - 4bit  ///////////////////////////////////
module mux8by1 (in1,in2,in3,in4,in5,in6,in7,in8,op,result);

	input [3:0]in1;
	input [3:0]in2;
	input [3:0]in3;
	input [3:0]in4;
	input [3:0]in5;
	input [3:0]in6;
	input [3:0]in7;
	input [3:0]in8;
	input [2:0]op;
	output [3:0]result;

	wire [3:0]w_mux1_1;
	wire [3:0]w_mux1_2;
	wire [3:0]w_mux1_3;
	wire [3:0]w_mux1_4;
	wire [3:0]w_mux2_1;
	wire [3:0]w_mux2_2;

	mux2by1_4bit mux1_1(.in1(in1), .in2(in2), .op(op[0]), .result(w_mux1_1));
	mux2by1_4bit mux1_2(.in1(in3), .in2(in4), .op(op[0]), .result(w_mux1_2));
	mux2by1_4bit mux1_3(.in1(in5), .in2(in6), .op(op[0]), .result(w_mux1_3));
	mux2by1_4bit mux1_4(.in1(in7), .in2(in8), .op(op[0]), .result(w_mux1_4));
	mux2by1_4bit mux2_1(.in1(w_mux1_1), .in2(w_mux1_2), .op(op[1]), .result(w_mux2_1));
	mux2by1_4bit mux2_2(.in1(w_mux1_3), .in2(w_mux1_4), .op(op[1]), .result(w_mux2_2));
	mux2by1_4bit mux3_1(.in1(w_mux2_1), .in2(w_mux2_2), .op(op[2]), .result(result));

endmodule 

///////////////// mux8by1 - 1bit   //////////////////////////
module mux8by1_1bit (in1,in2,in3,in4,in5,in6,in7,in8,op,carry);

	input in1;
	input in2;
	input in3;
	input in4;
	input in5;
	input in6;
	input in7;
	input in8;
	input [2:0]op;
	output carry;

	wire w_mux1_1;
	wire w_mux1_2;
	wire w_mux1_3;
	wire w_mux1_4;
	wire w_mux2_1;
	wire w_mux2_2;

	mux2by1 mux1_1(.in1(in1), .in2(in2), .op(op[0]), .result(w_mux1_1));
	mux2by1 mux1_2(.in1(in3), .in2(in4), .op(op[0]), .result(w_mux1_2));
	mux2by1 mux1_3(.in1(in5), .in2(in6), .op(op[0]), .result(w_mux1_3));
	mux2by1 mux1_4(.in1(in7), .in2(in8), .op(op[0]), .result(w_mux1_4));
	mux2by1 mux2_1(.in1(w_mux1_1), .in2(w_mux1_2), .op(op[1]), .result(w_mux2_1));
	mux2by1 mux2_2(.in1(w_mux1_3), .in2(w_mux1_4), .op(op[1]), .result(w_mux2_2));
	mux2by1 mux3_1(.in1(w_mux2_1), .in2(w_mux2_2), .op(op[2]), .result(carry));

endmodule 



////////////////     module mux2by1 - 4bit       ///////////////////
module mux2by1_4bit(in1, in2, op, result);
	input [3:0]in1;
   input [3:0]in2;
   input op;
   output [3:0]result;
	
   mux2by1 mux0(.in1(in1[0]), .in2(in2[0]), .op(op), .result(result[0]));
   mux2by1 mux1(.in1(in1[1]), .in2(in2[1]), .op(op), .result(result[1]));
   mux2by1 mux2(.in1(in1[2]), .in2(in2[2]), .op(op), .result(result[2]));
   mux2by1 mux3(.in1(in1[3]), .in2(in2[3]), .op(op), .result(result[3]));
endmodule

/////////////////    module mux2by1 - 1bit         ////////////
module mux2by1(in1,in2,op,result);
	input in1;
	input in2;
	input op;
	output result;

	wire w1,w2,w3;
  
	assign w1 = ~op;
	assign w2 = in1 & w1;
	assign w3 = in2 & op;
	assign result = w2 | w3;
endmodule 


/////////////// ripple_adder ////////////
module ripple_adder(a, b, s, Co, Cin);
	input [3:0] a, b;
	input Cin;
	output [3:0] s;
	output Co;

	wire w1,w2,w3;
 
	fulladder u1(.a(a[0]), .b(b[0]), .Ci(Cin), .s(s[0]), .Co(w1));
	fulladder u2(.a(a[1]), .b(b[1]), .Ci(w1), .s(s[1]), .Co(w2));
	fulladder u3(.a(a[2]), .b(b[2]), .Ci(w2), .s(s[2]), .Co(w3));
	fulladder u4(.a(a[3]), .b(b[3]), .Ci(w3), .s(s[3]), .Co(Co));
endmodule 

/////////////// ripple_subtractor ////////////
module ripple_subtr(a, b, s, Co, Cin);
	input [3:0] a, b;
	input Cin;
	output [3:0] s;
	output Co;
	
	wire [3:0]not_b;
	assign not_b = ~b;
	wire w1,w2,w3;
 
	fulladder u1(.a(a[0]), .b(not_b[0]), .Ci(Cin), .s(s[0]), .Co(w1));
	fulladder u2(.a(a[1]), .b(not_b[1]), .Ci(w1), .s(s[1]), .Co(w2));
	fulladder u3(.a(a[2]), .b(not_b[2]), .Ci(w2), .s(s[2]), .Co(w3));
	fulladder u4(.a(a[3]), .b(not_b[3]), .Ci(w3), .s(s[3]), .Co(Co));
endmodule 

/////////////// fulladder //////////////
module fulladder(a,b,Ci,s,Co);
	input a, b, Ci;
	output s, Co;
  
	assign s = a ^ b ^ Ci;
	assign Co = (a&b)|(a&Ci)|(b&Ci);
	
endmodule 

//////////// and 4bit   ////////////////
module and4bit(a,b,s);

input	[3:0]a,b;
output [3:0]s;

	and1bit and_u3(.a(a[3]), .b(b[3]), .s(s[3]));
	and1bit and_u2(.a(a[2]), .b(b[2]), .s(s[2]));
	and1bit and_u1(.a(a[1]), .b(b[1]), .s(s[1]));
	and1bit and_u0(.a(a[0]), .b(b[0]), .s(s[0]));

endmodule 
////////////// and 1bit
module and1bit(a,b,s);

	input a,b;
	output s;

	assign s = a & b;
	
endmodule 


////////////  or 4bit   ////////////////////
module or4bit(a,b,s);

	input	[3:0]a,b;
	output [3:0]s;

	or1bit or_u3(.a(a[3]), .b(b[3]), .s(s[3]));
	or1bit or_u2(.a(a[2]), .b(b[2]), .s(s[2]));
	or1bit or_u1(.a(a[1]), .b(b[1]), .s(s[1]));
	or1bit or_u0(.a(a[0]), .b(b[0]), .s(s[0]));

endmodule 

////////////   or1bit   /////////////////
module or1bit(a,b,s);

	input a,b;
	output s;

	assign s = a | b;

endmodule 

////////////// xor4bit   ///////////////////
module xor4bit(a,b,s);

	input	[3:0]a,b;
	output [3:0]s;

	xor1bit xor_u3(.a(a[3]), .b(b[3]), .s(s[3]));
	xor1bit xor_u2(.a(a[2]), .b(b[2]), .s(s[2]));
	xor1bit xor_u1(.a(a[1]), .b(b[1]), .s(s[1]));
	xor1bit xor_u0(.a(a[0]), .b(b[0]), .s(s[0]));

endmodule 

////////////   xor1bit   /////////////////
module xor1bit(a,b,s);

	input a,b;
	output s;

	assign s = ((~a) & b) | (a & (~b));

endmodule 

////////////// not4bit   ///////////////////
module not4bit(a,s);

	input	[3:0]a;
	output [3:0]s;

	not1bit not_u3(.a(a[3]), .s(s[3]));
	not1bit not_u2(.a(a[2]), .s(s[2]));
	not1bit not_u1(.a(a[1]), .s(s[1]));
	not1bit not_u0(.a(a[0]), .s(s[0]));

endmodule 

////////////   not1bit   /////////////////
module not1bit(a,s);

	input a;
	output s;

	assign s = ~a;

endmodule 

////////////// shift left bit - theo gia tri cua b   ///////////////////
module shift_left(a,b,s);

	input	[3:0]a,b;
	output [3:0]s;

	wire [3:0]wire_mux4_1;
	wire [3:0]wire_mux4_2;
	wire [3:0]wire_mux4_3;
	
	mux2by1_4bit mux4_1(.in1(a), .in2({a[2:0],1'b0}), .op(b[0]), .result(wire_mux4_1));
	mux2by1_4bit mux4_2(.in1(wire_mux4_1), .in2({wire_mux4_1[1:0],2'b00}), .op(b[1]), .result(wire_mux4_2));
	mux2by1_4bit mux4_3(.in1(wire_mux4_2), .in2(4'b0000), .op(b[2]), .result(wire_mux4_3));
	mux2by1_4bit mux4_4(.in1(wire_mux4_3), .in2(4'b0000), .op(b[3]), .result(s));

endmodule 


////////////// shift right b bit   ///////////////////
module shift_right(a,b,s);

	input	[3:0]a,b;
	output [3:0]s;

	wire [3:0]wire_mux4_1;
	wire [3:0]wire_mux4_2;
	wire [3:0]wire_mux4_3;
	
	mux2by1_4bit mux4_1(.in1(a), .in2({1'b0,a[3:1]}), .op(b[0]), .result(wire_mux4_1));
	mux2by1_4bit mux4_2(.in1(wire_mux4_1), .in2({2'b00,wire_mux4_1[3:2]}), .op(b[1]), .result(wire_mux4_2));
	mux2by1_4bit mux4_3(.in1(wire_mux4_2), .in2(4'b0000), .op(b[2]), .result(wire_mux4_3));
	mux2by1_4bit mux4_4(.in1(wire_mux4_3), .in2(4'b0000), .op(b[3]), .result(s));

endmodule   