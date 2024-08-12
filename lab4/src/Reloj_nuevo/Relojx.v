module Relojx(clock,reset,dip_switch,sec,an,test_led);

input wire clock;
input wire reset;
input wire [1:0] dip_switch;
output reg [6:0] sec;
output reg[3:0] an;
output reg [3:0] test_led;
wire [15:0] bcdx;
reg [13:0] count;
reg [15:0] tiempo;
reg pulso_ms;
reg [2:0]pulso_an;
reg pulso2_an;
wire [15:0] digito1;
wire [15:0] digito2;
wire [15:0] digito3;
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
        end else begin
            count <= count + 1;
        end
    end
	 
	 //always @(posedge count[9]) begin
	//	test_led = ~test_led;
	 //end
// Dividir cada digito del contador 
    assign digito1 = count ;
    assign digito2 = (count / 10) ;
    assign digito3 = (count / 100) ;
    assign digito4 = (count / 1000) ;

// Codificacion del 7 segmentos	 
	always @(posedge counter[10]) begin
		  test_led = bcdx[3:0];
		  case(pulso_an)
			2'b00: tempbcd = bcdx[3:0];
			2'b01: tempbcd = bcdx[7:4];
			2'b10: tempbcd = bcdx[11:8];
			2'b11: tempbcd = bcdx[15:12];
		  endcase
        case (tempbcd[3:0])
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
           default: sec = 7'b1111110;
        endcase
		  pulso_an <= pulso_an + 1;
		  
		  
    end
	 
	 always @(*) begin
		
		if(pulso_an==3'b001)
			an <= 4'b1110;
		else if (pulso_an==3'b010)
			an <= 4'b1101;
		else if (pulso_an==3'b011)
			an <= 4'b1011;
		else if (pulso_an==3'b100)
			an <= 4'b0111;
		
		
		
	 end
	 
//unidad de tiempo a mostrar en base al dip
	always @(*) begin
			

        case (dip_switch)
            2'b00: tiempo = digito1; // Milésimas de segundo
            2'b01: tiempo = digito2; // Centésimas de segundo
            2'b10: tiempo = digito3; // Décimas de segundo
            2'b11: tiempo = digito4; // Segundos
            default: tiempo = digito1;
        endcase
    end
	bcd2bin b(.bin(tiempo[15:0]), .bcd(bcdx[15:0]));
	
endmodule

