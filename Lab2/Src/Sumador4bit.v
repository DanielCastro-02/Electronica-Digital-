 `include "sumador.v"

 module sum4bit (A,B,Ci,S,Co);

 input [4:0]A;
 input [4:0]B;
 input Ci;
 output[4:0] S;
 output Co;

 wire C1;
 wire C2;
 wire C3;
 


 sumador sum0(.a(A[0]), .b(B[0]), .ci(1'b0), .s1(S[0]), .c0(C1));
 sumador sum1(.a(A[1]), .b(B[1]), .ci(C1), .s1(S[1]), .c0(C2));
 sumador sum2(.a(A[2]), .b(B[2]), .ci(C2), .s1(S[2]), .c0(C3));
 sumador sum3(.a(A[3]), .b(B[3]), .ci(C3), .s1(S[3]), .c0(Co));
 


