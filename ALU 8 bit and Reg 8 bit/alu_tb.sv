module alu_tb;
  logic clk_i;
  logic rst_n;
  
  logic [7:0] result;
  logic carry_flag;
  logic negative_flag;
  logic zero_flag;
  logic overflow_flag;
  
  reg [7:0] result_reg;
  reg carry_reg;
  reg negative_reg;
  reg zero_reg;
  reg overflow_reg;
  
  logic [7:0] result_expect;
  logic carry_expect;
  logic negative_expect;
  logic zero_expect;
  logic overflow_expect;
  
  int i = 0;
  int j = 0;
  int k = 0; 
  
  alu alu(
  .a(i),
  .b(j),
  .op(k),
  .result(result),
  .carry_flag(carry_flag),
  .negative_flag(negative_flag),
  .zero_flag(zero_flag),
  .overflow_flag(overflow_flag)
  );
  
  
  always@(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
      result_reg <= 7'd0;
      carry_reg <= 1'b0;
      negative_reg <= 1'b0;
      zero_reg <= 1'b0;
      overflow_reg <= 1'b0;
      end
      else begin
      result_reg <= result;
      carry_reg <= carry_flag;
      negative_reg <= negative_flag;
      zero_reg <= zero_flag;
      overflow_reg <= overflow_flag;
      
      end
  
  end

      task alu_expect(
        input logic [7:0] a_test,
        input logic [7:0] b_test,
        input logic [2:0] op_test,
        input logic [7:0] result_test,
        input logic carry_test,
        input logic negative_test,
        input logic zero_test,
        input logic overflow_test
        );
          case (op_test)
            3'b000: begin
            {carry_expect,result_expect} = a_test + b_test;
            negative_expect = result_expect[7];
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = (a_test[7] != result_expect[7]);
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (negative_test  == negative_expect)  &
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b001: begin
            {carry_expect,result_expect} = a_test - b_test;
            negative_expect = result_expect[7];
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = (a_test[7] != result_expect[7]);
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
	           assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (negative_test  == negative_expect)  &
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b010: begin
            result_expect = a_test << b_test;
            negative_expect = result_expect[7];
            carry_expect = 1'b0;
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b011: begin
            result_expect = a_test >> b_test;
            negative_expect = result_expect[7];
            carry_expect = 1'b0;
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b100: begin
            result_expect = a_test & b_test;
            negative_expect = result_expect[7];
            carry_expect = 1'b0;
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b101: begin
            result_expect = a_test | b_test;
            carry_expect = 1'b0;
            negative_expect = result_expect[7];
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b110: begin
            result_expect = ~a_test;
            carry_expect = 1'b0;
            negative_expect = result_expect[7];
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            3'b111:  begin
            result_expect = a_test;
            carry_expect = 1'b0;
            negative_expect = result_expect[7];
            zero_expect = (result_expect == 8'd0)? 1'b1 : 1'b0;
            overflow_expect = 1'b0;
            
         	  $display("[%3d] op = %3b, a = %8d, b = %8d, 
         	   result = %8d, 	result_expect= %8d, 
	           carry = %b, 		carry_expect= %b, 	
	           negative=%b, 		negative_expect=%b, 
	           zero = %b, 		zero_expect = %b, 
	           overflow = %b, 	overflow_expect = %b", 

	         $time, op_test[2:0], a_test[7:0], b_test[7:0], result_test[7:0], 	result_expect[7:0], 
	           carry_test, 		carry_expect, 
	           negative_test, 		negative_expect, 
	           zero_test, 		zero_expect, 
	           overflow_test, 		overflow_expect);
	           
            assert ((result_test    == result_expect)    &
                    (carry_test     == carry_expect)     & 
                    (zero_test      == zero_expect)      &
                    (overflow_test  == overflow_expect)) else begin
                    $display("TEST FAILED");
                    $stop;
                  end
                end
            default: $display("TEST FAILED");
          endcase
          $display("TEST PASSED");
  endtask
  
  initial begin  
  for (i = 0; i <= 255; i++) begin
      for (j= 0; j <= 255; j++) begin
          for ( k = 0; k <= 7; k++) begin
            #50;
            alu_expect(i, j, k, result_reg, carry_reg, negative_reg, zero_reg, overflow_reg);
            #85;
          end
      end
  end
    
  end
  
  initial begin
  #1;
  rst_n = 1'b0;
  clk_i = 1'b0;
  #5;
  rst_n = 1'b1;
end
  always #10 clk_i = ~clk_i;
  endmodule
    