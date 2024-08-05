module Segmentos (A,B,Ci, SSeg, an);


	localparam divisor = 50000000;
	reg [25:0] counter = 0;
	reg clock = 0;


	input [2:0]A;
	input [2:0]B;
	input Ci;
	wire [3:0] S;
	wire Co;
  
	wire C1;
	wire C2;

	 
	Sumador sum0(.a(A[0]), .b(B[0]), .ci(1'b0), .s1(S[0]), .c0(C1));
	Sumador sum1(.a(A[1]), .b(B[1]), .ci(C1), .s1(S[1]), .c0(C2));
	Sumador sum2(.a(A[2]), .b(B[2]), .ci(C2), .s1(S[2]), .c0(S[3]));

 
  output reg [0:6] SSeg;
  output reg [3:0] an;

  
always@(*) begin
if (counter < divisor) 
	begin
		counter <= counter + 1;
	end
else
	begin
		counter <= 0;
		clock <= ~clock; 
	end
end




always@(clock) begin
	if(clock==1) begin
		an <= 4'b1110;
		  case (S)

                    //abcdegf      
    4'b0000: SSeg = 7'b0000001; // "0"  
	 4'b0001: SSeg = 7'b1001111; // "1" 
	4'b0010: SSeg = 7'b0010010; // "2" 
	4'b0011: SSeg = 7'b0000110; // "3" 
	4'b0100: SSeg = 7'b1001100; // "4" 
	4'b0101: SSeg = 7'b0100100; // "5" 
	4'b0110: SSeg = 7'b0100000; // "6" 
	4'b0111: SSeg = 7'b0001111; // "7" 
	4'b1000: SSeg = 7'b0000000; // "8"  
	4'b1001: SSeg = 7'b0000100; // "9" 
  4'ha: SSeg = 7'b0000001;  
  4'hb: SSeg = 7'b1001111;
  4'hc: SSeg = 7'b0010010;
  4'hd: SSeg = 7'b0000110;
  4'he: SSeg = 7'b1001100;
  4'hf: SSeg = 7'b0100100;
    default:
    SSeg <= 0;
  endcase
		end
	else begin
		an <= 4'b1101;
		  case (S)

                    //abcdegf      
	4'b0000: SSeg = 7'b0000001; // "0"  
	4'b0001: SSeg = 7'b0000001; // "0" 
	4'b0010: SSeg = 7'b0000001; // "0" 
	4'b0011: SSeg = 7'b0000001; // "0" 
	4'b0100: SSeg = 7'b0000001; // "0" 
	4'b0101: SSeg = 7'b0000001; // "0" 
	4'b0110: SSeg = 7'b0000001; // "0" 
	4'b0111: SSeg = 7'b0000001; // "0" 
	4'b1000: SSeg = 7'b0000001; // "0"  
	4'b1001: SSeg = 7'b0000001; // "0" 
	4'ha: SSeg = 7'b1001111; // "1" 
	4'hb: SSeg = 7'b1001111; // "1" 
	4'hc: SSeg = 7'b1001111; // "1" 
	4'hd: SSeg = 7'b1001111; // "1" 
	4'he: SSeg = 7'b1001111; // "1" 
	4'hf: SSeg = 7'b1001111; // "1" 
    default:
    SSeg <= 0;
  endcase
	end
	
end


endmodule