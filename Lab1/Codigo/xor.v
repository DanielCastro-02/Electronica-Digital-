module xor(A,B,S);
    //not and or xor 
    input A;
    input B;
    output S;

    assign S= (A|B)&(~A|~B) ;


endmodule
