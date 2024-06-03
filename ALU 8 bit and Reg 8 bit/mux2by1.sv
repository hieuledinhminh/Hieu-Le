module mux2by1(D0,D1,S,Y);
  input logic D0;
  input logic D1;
  input logic S;

  output logic Y;

  wire w1,w2,w3;
  
  not(w1,S);
  and(w2,D0,w1);
  and(w3,D1,S);
  or(Y,w2,w3);

endmodule
  
