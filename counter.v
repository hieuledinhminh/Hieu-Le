module counter(clk, rst_n, sel_i, data_o);
  input	clk;
  input	rst_n;
  input	sel_i;
  output [3:0] data_o;

	reg [3:0] counter_q;
	wire [3:0] counter_up;
	wire [3:0] counter_down;
	wire [3:0] counter_d;

	ripple_adder count_up (.X(counter_q), .Y(4'b0000), .Cin(1'b1), .Co(), .S(counter_up));
	ripple_adder count_down (.X(counter_q), .Y(4'b1111), .Cin(1'b0), .Co(), .S(counter_down));
	mux2by1_4bit mux (.in0(counter_down), .in1(counter_up), .sel(sel_i), .out(counter_d));

 always@(posedge clk) begin
	if (!rst_n)
		counter_q <= 4'b0000;
	else 
      counter_q <= counter_d; 
	end
assign data_o = counter_q;
endmodule 

//////////////         module mux 4 bit from mux 2 input 3 bit        ////////////
module mux2by1_4bit(in0, in1, sel, out);
	input [3:0]in0;
   input [3:0]in1;
   input sel;
   output [3:0]out;
   // sel =1 lay in1
   mux2by1 mux0(in0[0],in1[0],sel,out[0]);
   mux2by1 mux1(in0[1],in1[1],sel,out[1]);
   mux2by1 mux2(in0[2],in1[2],sel,out[2]);
   mux2by1 mux3(in0[3],in1[3],sel,out[3]);
endmodule // mux2to1_8

/////////////////    module mux 2 - 1 bit         ////////////
module mux2by1(D0,D1,S,Y);
  input D0;
  input D1;
  input S;
  output Y;

  wire w1,w2,w3;
  
  assign w1 = ~S;
  assign w2 = D0 & w1;
  assign w3 = D1 & S;
  assign Y = w2 | w3;
endmodule 

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
