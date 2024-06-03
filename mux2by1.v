/////////////////    module mux 2 - 1 bit         ////////////
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