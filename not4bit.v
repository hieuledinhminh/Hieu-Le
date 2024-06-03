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