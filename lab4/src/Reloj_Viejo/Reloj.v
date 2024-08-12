module Reloj(clock,reset,dip_switch,sec,an);

input wire clock;
input wire reset;
input wire [1:0] dip_switch;
output reg [6:0] sec;
output [3:0] an;

reg [13:0] count;
reg [3:0] tiempo;
reg pulso_ms;
wire [3:0] digito1, digito2, digito3, digito4;
reg [15:0] counter;

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
        end else if (count == 9999) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
	 
// Dividir cada digito del contador 
    assign digit1 = count % 10;
    assign digit2 = (count / 10) % 10;
    assign digit3 = (count / 100) % 10;
    assign digit4 = (count / 1000) % 10;

// Codificacion del 7 segmentos	 
	always @(*) begin
        case (tiempo)
                         // abcdefg
         4'b0000: sec = 7'b0000001; // "0"  
			4'b0001: sec = 7'b1001111; // "1" 
			4'b0010: sec = 7'b0010010; // "2" 
			4'b0011: sec = 7'b0000110; // "3" 
			4'b0100: sec = 7'b1001100; // "4" 
			4'b0101: sec = 7'b0100100; // "5" 
			4'b0110: sec = 7'b0100000; // "6" 
			4'b0111: sec = 7'b0001111; // "7" 
			4'b1000: sec = 7'b0000000; // "8"  
			4'b1001: sec = 7'b0000100; // "9" 
           default: sec = 7'b1111111;
        endcase
    end
	 
//unidad de tiempo a mostrar en base al dip
	always @(*) begin
        case (dip_switch)
            2'b0000: tiempo = digito1; // Milésimas de segundo
            2'b0001: tiempo = digito2; // Centésimas de segundo
            2'b0010: tiempo = digito3; // Décimas de segundo
            2'b0011: tiempo = digito4; // Segundos
            default: tiempo = digito1;
        endcase
    end
	assign an = 4'b1110;

endmodule