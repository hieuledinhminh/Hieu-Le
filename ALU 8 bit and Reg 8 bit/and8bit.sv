module and8bit(X,Y,S);
  input logic [7:0] X;
  input logic [7:0] Y;

  output logic [7:0] S; 

  and(S[0],Y[0],X[0]);
  and(S[1],Y[1],X[1]);
  and(S[2],Y[2],X[2]);
  and(S[3],Y[3],X[3]);
  and(S[4],Y[4],X[4]);
  and(S[5],Y[5],X[5]);
  and(S[6],Y[6],X[6]);
  and(S[7],Y[7],X[7]);
  
endmodule
