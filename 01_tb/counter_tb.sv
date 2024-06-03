module counter_tb;

reg       clk;
reg       rst_n;
reg       sel_i;
wire [3:0] data_o;
 // logic ok;

  synth_wrapper counter_dut(
  .clk(clk),
  .rst_n(rst_n),
  .sel_i(sel_i),
  .data_o(data_o)
  );

  initial begin
    #0 clk = 1'b0;
    forever #50 clk = ~clk;
  end

  initial begin
    #0 rst_n = 1'b0;
    #0 sel_i = 1'b1;
    #300 rst_n = 1'b1;
    sel_i = 1'b0;
    #2000
    sel_i = 1'b1;

  end

endmodule 

