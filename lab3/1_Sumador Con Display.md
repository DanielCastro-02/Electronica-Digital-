# Primera Parte 
## Visualizaciòn de los numeros del 0 a F en el display 7 segmentos 
Esta practica consistio en programar la FPGA para que al momento de controlar el "Dip Switch de 4 posiciones" dependiendo de la gerarquia que le diesemos a cada uno de los switch el sistema reconociera el numero que se esta marcando y lo pudiera presentar a traves del display 7 segmentos. 

Para ello, primero se realizo la parte logica, la cual consistio en con el codigo base 

module BCDtoSSeg (BCD, SSeg, an);

  input [3:0] BCD;
  output reg [0:6] SSeg;
  output [3:0] an;
  
  assign an = 4'b1110;


always @ ( * ) begin
  case (BCD)

                         // abcdefg
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
   4'ha: SSeg = 7'b0001000;  
   4'hb: SSeg = 7'b1100000;
   4'hc: SSeg = 7'b0110001;
   4'hd: SSeg = 7'b1000010;
   4'he: SSeg = 7'b0110000;
   4'hf: SSeg = 7'b0111000;
    default:
    SSeg = 0;
  endcase
end

endmodule


Este codigo lo que hace es cogificar el numero pasado por el dip, el cual es Binario y lo transforma en codifica en BCD, esto a raiz de que para que el 7 segmentos pueda mostrar algo algun numero o letra en pantalla, se debe configurar cada uno de los 7 LEDs para que de esta formar pueda presentar la informacion que queremos. 

Despues de ello, se realiza la asignacion de pines en la FPGA, teniendo en cuenta, que los pines de entrada del Dip Switch son los pines P50, P59, P60 Y P61, los cuales en nuestro codigo corresponde a la estrada BCD. 

La salida AN en la FPGA es aqueya que da la señal al displey 7 segmentos, el cual esta compuesto por cuatro 7 segmentos en configuracion de "Anodo comun" donde dependiendo de la posicion en la cual ponemos un 0 corresponde al 7 segmento que se activa para visualizar la informaciòn. En la FPGA de la salida AN esta encargado los pines P128, P129, P132 y P133

Por ultimo los LEDs de los 7 segmentos, por practicidad estan simbolizados por letras de la A a la H, donde la H corresponde al LED que muestra el punto, y estos LEDs corresponden a los pines:

        A = P127
        B = P126
        C = P125
        D = P124
        E = P121
        F = P120
        G = P119
        H = P115

Configurando los inputs y outputs de la FPGA en el PIN PLANNER, obtuvimos lo siguiente


# Visualizaciòn de los numeros del 0 a 9 en el display 7 segmentos 
Para este ejercicio la unica modificacion realizada fue, al codigo base, no programarlo para representar en un 7 segmentos numeros superiores al 9, quedando el codigo de la siguiente manera:

module BCDtoSSeg (BCD, SSeg, an);

  input [3:0] BCD;
  output reg [0:6] SSeg;
  output [3:0] an;
  
  assign an = 4'b1110;


always @ ( * ) begin
  case (BCD)

                         // abcdefg
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
  
    default:
    SSeg = 0;
  endcase
end

endmodule

Al cargarlo en la FPGA obtuvimos el siguiente resultado: 


