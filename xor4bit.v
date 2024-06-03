////////////// xor1bit   ///////////////////
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