module Sumador(a,b,c,s1,co);
    //not and or xor 
    input a;
    input b;
    input c;
    output s1;
    output co;

    assign xor1 = (a|b)&(~a|~b);
    assign and1 = a&b;
    assign and2 = xor1&c;
    assign co = and2|and1;
    assign s1 = (xor1|c)&(~xor1|~c);;
    




endmodule
