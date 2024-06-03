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