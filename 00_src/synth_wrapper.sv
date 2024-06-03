module synth_wrapper(sel_i,rst_n,clk,data_o);
	input	sel_i;
	input	rst_n;
	input	clk;
	output reg [3:0] data_o;
	reg	sel_i_reg;
	wire	[3:0] temp1;

always@(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		sel_i_reg <= 1'b0;
		data_o <= 4'b0000;
	end
	else begin
		sel_i_reg <= sel_i;
		data_o <= temp1;
	end
end

counter	u1 (.clk(clk), .rst_n(rst_n), .sel_i(sel_i_reg), .data_o(temp1));
endmodule

