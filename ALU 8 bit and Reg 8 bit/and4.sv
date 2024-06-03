module and4(X0,X1,X2,X3,Y);
  input logic X0;
  input logic X1;
  input logic X2;
  input logic X3;

  output logic Y;

  wire logic w1,w2;
  
  and(w1,X0,X1);
  and(w2,w1,X2);
  and(Y,w2,X3);

endmodule
