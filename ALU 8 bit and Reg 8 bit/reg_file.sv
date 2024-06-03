module reg_file(

  input logic         clk_i,
  input logic         rst_ni,
  
  input logic         rd_wren_i,   // write enable
  input logic [2:0]   rs1_addr_i,
  input logic [2:0]   rs2_addr_i,
  input logic [2:0]   rd_addr_i,        // rsW,rsR1,rsR2
  input logic [7:0]  rd_data_i,                 // data to write 

  
  output logic [7:0]  rs1_data_o,
  output logic [7:0]  rs2_data_o   // data R1, data R2
);

  logic [7:0]	 registers[0:7];
  // creation of memory

  // read functionality

  always_ff@(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      begin
        for (int i=0; i < 8; i++)
          registers[i] <= 8'd0;
      end
    else begin if (rd_wren_i)
      registers[rd_addr_i] <= rd_data_i;
    end
  end
  
  // output
   assign  rs1_data_o =  registers[rs1_addr_i];
   assign  rs2_data_o =  registers[rs2_addr_i];
 
endmodule : reg_file





