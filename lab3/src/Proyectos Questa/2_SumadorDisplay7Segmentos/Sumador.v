module Sumador(a,b,ci,s1,c0);
    //not and or xor 
    input a;
    input b;
    input ci;
    output s1;
    output c0;

    assign xor1 = (a|b)&(~a|~b);
    assign and1 = a&b;
    assign and2 = xor1&ci;
    assign c0 = and2|and1;
    assign s1 = (xor1|ci)&(~xor1|~ci);

endmodule