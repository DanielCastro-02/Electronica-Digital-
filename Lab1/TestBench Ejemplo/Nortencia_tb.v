`timescale 1ns / 1ns
`include "Nortencia.v"

module Nortencia_tb;
    reg A;
    reg B;
    reg C;

    wire S1;
    wire C0;

    Nortencia uut(A,B,C,S1,C0);

    initial begin
        $dumpfile("nortena_tb.vcd");
        $dumpvars(0,Nortencia_tb);

        A=0;
        B=0;
        C=0;
        #20;

        A=0;
        B=0;
        C=1;
        #20;

        A=0;
        B=1;
        C=0;
        #20;

        A=0;
        B=1;
        C=1;
        #20;

        A=1;
        B=0;
        C=0;
        #20;

        A=1;
        B=0;
        C=1;
        #20;

        A=1;
        B=1;
        C=0;
        #20;

        A=1;
        B=1;
        C=1;
        #20;
        $display("Test complete");
    end

endmodule