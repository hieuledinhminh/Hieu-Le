//////////////////   ripple_adder  /////////////////
module ripple_adder(X, Y, S, Co, Cin);
	input [3:0] X, Y;// Two 4-bit inputs
	input Cin;
	output [3:0] S;
	output Co;

	wire w1,w2,w3;
 // instantiating 4 1-bit full adders in Verilog
	fulladder u1(.X(X[0]), .Y(Y[0]), .Ci(Cin), .S(S[0]), .Co(w1));
	fulladder u2(.X(X[1]), .Y(Y[1]), .Ci(w1), .S(S[1]), .Co(w2));
	fulladder u3(.X(X[2]), .Y(Y[2]), .Ci(w2), .S(S[2]), .Co(w3));
	fulladder u4(.X(X[3]), .Y(Y[3]), .Ci(w3), .S(S[3]), .Co(Co));
endmodule 

///////////////// full adder   ///////////////
module fulladder(X,Y,Ci,S,Co);
	input X, Y, Ci;
	output S, Co;
  
	assign S = X ^ Y ^ Ci;
	assign Co = (X&Y)|(X&Ci)|(Y&Ci);
	
endmodule 