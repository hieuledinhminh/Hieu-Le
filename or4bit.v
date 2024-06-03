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