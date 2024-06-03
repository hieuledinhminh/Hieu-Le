module not8bit(X,S);
  input logic [7:0] X;
  
  output logic [7:0] S;


  not(S[0],X[0]);
  not(S[1],X[1]);
  not(S[2],X[2]);
  not(S[3],X[3]);
  not(S[4],X[4]);
  not(S[5],X[5]);
  not(S[6],X[6]);
  not(S[7],X[7]);
  
endmodule