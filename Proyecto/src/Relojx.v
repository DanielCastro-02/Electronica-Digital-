module Relojx(clock,reset,sec,an,clockLight);

input wire clock;
input wire reset;
output reg [6:0] sec;
output reg an;
output reg clockLight;
wire [15:0] bcdx;
reg [13:0] count;
reg [4:0] tiempo;
reg pulso_ms;
reg [2:0]pulso_an;
reg pulso2_an;
wire [15:0] digito4;
reg [15:0] counter;
reg [3:0] tempbcd;

//Divisor de Frecuencia
parameter DIVISOR = 50000; 

	always @(posedge clock or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pulso_ms <= 0;
        end else if (counter == DIVISOR) begin
            counter <= 0;
            pulso_ms <= ~pulso_ms;
        end else begin
            counter <= counter + 1;
        end
	end
	
// incremento del contador x milisegundo
	always @(posedge pulso_ms or posedge reset) begin
        if (reset) begin
            count <= 0;
        end
		  else if(count==14'b10111011100000)begin
				count <= 0;
				clockLight <= 0;
		  end
		  else if(count==14'b01011101110000)begin
				clockLight <= 1;
				count <= count + 1;
		  end
		  else begin
            count <= count + 1;
        end
    end
    assign digito4 = (count / 1000) ; 
	 
	 
	 
	 always @(posedge counter[10]) begin
        case (tiempo[4:0])
                         // abcdefg
         4'b0000: sec = 7'b1000000; // "0"  
			4'b0001: sec = 7'b1111001; // "1" 
			4'b0010: sec = 7'b0100100; // "2" 
			4'b0011: sec = 7'b0110000; // "3" 
			4'b0100: sec = 7'b0011001; // "4" 
			4'b0101: sec = 7'b0010010; // "5" 
			4'b0110: sec = 7'b0000010; // "6" 
			4'b0111: sec = 7'b1111000; // "7" 
			4'b1000: sec = 7'b0000000; // "8"  
			4'b1001: sec = 7'b0010000; // "9" 
			4'b1010: sec = 7'b0001000; // "10" 
			4'b1011: sec = 7'b0000011; // "11"
			4'b1100: sec = 7'b1000110; // "12" 	
           default: sec = 7'b1111110;
        endcase		  
    end
	 
	 always @(*) begin
			an <= 0;
	 end
	 
//unidad de tiempo a mostrar en base al dip
	always @(*) begin

		tiempo = digito4; // Segundos
		
    end
	
endmodule