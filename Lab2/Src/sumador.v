module sumador(A0,B0,S0,Cout0,A1,B1,S1,Cout1,A2,B2,S2,Cout2,A3,B3,S3,Cout3);
    //not and or xor 
    input A0,A1,A2,A3;
    input B0,B1,B2,B3;
    assign Cin0 = 0;
    output S0,S1,S2,S3;
    output Cout0,Cout1,Cout2,Cout3;

    
    assign xor1_0 = (A0|B0)&(~A0|~B0);
    assign and1_0 = A0&B0;
    assign and2_0 = xor1_0&Cin0;
    assign Cout0 = and2_0|and1_0;
    assign S0 = (xor1_0|Cin0)&(~xor1_0|~Cin0);
	 
    assign xor1_1 = (A1|B1)&(~A1|~B1);
    assign and1_1 = A1&B1;
    assign and2_1 = xor1_1&Cout0;
    assign Cout1 = and2_1|and1_1;
    assign S1 = (xor1_1|Cout0)&(~xor1_1|~Cout0);
	
    assign xor1_2 = (A2|B2)&(~A2|~B2);
    assign and1_2 = A2&B2;
    assign and2_2 = xor1_2&Cout1;
    assign Cout2 = and2_2|and1_2;
    assign S2 = (xor1_2|Cout1)&(~xor1_2|~Cout1);
	
    assign xor1_3 = (A3|B3)&(~A3|~B3);
    assign and1_3 = A3&B3;
    assign and2_3 = xor1_3&Cout2;
    assign Cout3 = and2_3|and1_3;
    assign S3 = (xor1_3|Cout2)&(~xor1_3|~Cout2);	
	 
endmodule
