    //`timescale 1ns/10ps 
  module reg_file_tb;
   logic            clk_i;
   logic            rst_ni;
   logic            rd_wren_i;  
   logic [2:0]      rs1_addr_i;
   logic [2:0]      rs2_addr_i;
   logic [2:0]      rd_addr_i;
   logic [7:0]     rd_data_i;
   logic [7:0]     rs1_data_o;
   logic [7:0]     rs2_data_o;
  
  reg_file dut(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .rd_wren_i(rd_wren_i),
  .rs1_addr_i(rs1_addr_i),
  .rs2_addr_i(rs2_addr_i),
  .rd_data_i(rd_data_i),
  .rd_addr_i(rd_addr_i),
  .rs1_data_o(rs1_data_o),
  .rs2_data_o(rs2_data_o)
  ); 
   always #5 clk_i=~clk_i;
    
   task tk_expect(
    input logic [7:0]   rs1_data_o_x,
    input logic [7:0]   rs2_data_o_x
     );
      $display("[%3d] clk_i=%1b,rst_ni=%1b,rd_addr_i = %3d, rd_data_i = %8d,
                      rs1_addr_i = %3d, rs2_addr_i =%3d,
                      rs1_data_o = %8d, rs2_data_o=%8d,
                      rs1_data_o_x = %8d, rs2_data_o_x = %8d", 
      $time,clk_i,rst_ni,rd_addr_i[2:0], rd_data_i[7:0], rs1_addr_i[2:0], rs2_addr_i[2:0], rs1_data_o[7:0],rs2_data_o[7:0],rs1_data_o_x[7:0],rs2_data_o_x[7:0]);
      
      assert(( rs1_data_o==rs1_data_o_x)&&(rs2_data_o==rs2_data_o_x)) 
      begin
        $display("TEST PASSED");
      end
      else begin
        $display("TEST FAILED"); 
        $stop;
      end
    endtask 
    
      initial begin
   rst_ni=1'b0;
   clk_i=1'b0;
   rd_wren_i=1'b1;
   rd_data_i=8'd0;
   rd_addr_i=3'd0;
   rs1_addr_i = 3'd0;
   rs2_addr_i = 3'd0;
   #10
   rst_ni = 1'b1;
   //testcase1
   rd_data_i= 8'd4;
   rd_addr_i = 3'b010;
   #20
   rs1_addr_i = 3'b010;
   rs2_addr_i = 3'b010; #49 tk_expect(8'd4,8'd4);
   #20
      //testcase2
   rd_data_i= 8'd0;
   rd_addr_i = 3'b111;
   #20
   rs1_addr_i = 3'b111;
   rs2_addr_i = 3'b111; #49 tk_expect(8'd0,8'd0);
   #20
   //testcase3
   rd_data_i= 3'd7;
   rd_addr_i = 3'b010;
   #20
   rs1_addr_i = 3'b001;
   rs2_addr_i = 3'b001; #49 tk_expect(8'd0,8'd0);
      #20
      //testcase4
   rd_data_i= 8'd5;
   rd_addr_i = 3'b101;
   #20
   rs1_addr_i = 3'b101;
   rs2_addr_i = 3'b101; #49 tk_expect(8'd5,8'd5);
      #20
      //testcase5
   rd_data_i= 8'd255;
   rd_addr_i = 3'b011;
   #20
   rs1_addr_i = 3'b011;
   rs2_addr_i = 3'b101; #49 tk_expect(8'd255,8'd5);
      #10
   #49 $display("TEST PASSED"); $finish;

end
endmodule

