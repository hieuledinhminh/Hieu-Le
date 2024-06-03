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