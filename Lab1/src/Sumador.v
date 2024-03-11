module Sumador(A,B,C,S1,C0);
    //not and or xor 
    input A;
    input B;
    input C;
    output S1;
    output C0;

    assign xor1 = (A|B)&(~A|~B);
    assign and1 = A&B;
    assign and2 = xor1&C;
    assign C0 = and2|and1;
    assign S1 = (xor1|C)&(~xor1|~C);;
    




endmodule
