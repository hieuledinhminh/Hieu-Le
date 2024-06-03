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

	mux2by1 mux1_1(.in1(in1), .in2(in2), .op(op[2]), .result(w_mux1_1));
	mux2by1 mux1_2(.in1(in3), .in2(in4), .op(op[2]), .result(w_mux1_2));
	mux2by1 mux1_3(.in1(in5), .in2(in6), .op(op[2]), .result(w_mux1_3));
	mux2by1 mux1_4(.in1(in7), .in2(in8), .op(op[2]), .result(w_mux1_4));
	mux2by1 mux2_1(.in1(w_mux1_1), .in2(w_mux1_2), .op(op[1]), .result(w_mux2_1));
	mux2by1 mux2_2(.in1(w_mux1_3), .in2(w_mux1_4), .op(op[1]), .result(w_mux2_2));
	mux2by1 mux3_1(.in1(w_mux2_1), .in2(w_mux2_2), .op(op[0]), .result(carry));

endmodule 


/////////////////////////////////////
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