module synth_wrapper(rst_n,clk,a,b,op,result,carry);

	input [3:0] a;
	input [3:0] b;
	input [2:0] op;
	input rst_n;
	input clk;

	output reg [3:0] result;
	output reg carry;
 
	reg [3:0] a_reg;
	reg [3:0] b_reg;
	reg [2:0] op_reg;
	wire [3:0] result_reg;
	wire carry_reg;

always@(posedge clk, posedge rst_n) begin
    if(rst_n) begin
       a_reg <= 4'h0;
       b_reg <= 4'h0;
       op_reg <= 3'h0;
       result <= 4'h0;
       carry <= 1'b0;
    end
	 
    else begin
       a_reg <= a;
       b_reg <= b;
       op_reg <= op;
       result <= result_reg;
       carry <= carry_reg;
    end
end 
	 alu u1(.a(a_reg), .b(b_reg), .op(op_reg), .result(result_reg), .carry(carry_reg));


endmodule