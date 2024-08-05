# Primer Parte
## Visualizaciòn de los numeros del 0 a F en el display 7 segmentos 
Esta practica consistio en programar la FPGA para que al momento de controlar el "**Dip Switch de 4 posiciones**" dependiendo de la gerarquia que le diesemos a cada uno de los switch el sistema reconociera el numero que se esta marcando y lo pudiera presentar a traves del display 7 segmentos. 

Para ello, primero se realizo la parte logica, la cual consistio en con el codigo base 

```
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

```

Este codigo lo que hace es cogificar el numero pasado por el dip, el cual es Binario y lo transforma en codifica en BCD, esto a raiz de que para que el 7 segmentos pueda mostrar algo algun numero o letra en pantalla, se debe configurar cada uno de los 7 LEDs para que de esta formar pueda presentar la informacion que queremos. 

Despues de ello, se realiza la asignacion de pines en la FPGA, teniendo en cuenta, que los pines de entrada del **Dip Switch** son los pines *P50, P59, P60 Y P61*, los cuales en nuestro codigo corresponde a la estrada BCD. 

La salida **AN** en la FPGA es aqueya que da la señal al displey 7 segmentos, el cual esta compuesto por cuatro 7 segmentos en configuracion de "Anodo comun" donde dependiendo de la posicion en la cual ponemos un 0 corresponde al 7 segmento que se activa para visualizar la informaciòn. En la FPGA de la salida AN esta encargado los pines *P128, P129, P132 y P133*

Por ultimo los LEDs de los 7 segmentos, por practicidad estan simbolizados por letras de la *A* a la H, donde la *H* corresponde al LED que muestra el punto, y estos LEDs corresponden a los pines:

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

````
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
````

Al cargarlo en la FPGA obtuvimos el siguiente resultado: 



# Segunda Parte

Ya con la visualizacion de los digitos en el display de 7 segmentos debemos realizar una suma de 2 numeros de 3 bits, estos deben ser introducidos mediante los switch de la FPGA y el resultado debe mostrarse tanto en su forma Decimal, como en su forma hexadecimal

## Modificaciones del Codigo Original

Para la realizacion de esta parte podemos usar el codigo de la primera parte y fusionarlo con el modulo sumador que realizamos en el laboratorio anterior

### Acondicionar El Sumador

Lo primero que vamos a hacer es que las salidas del sumador no se comporten como salidas ( 5V en algun pin de la placa ) si no como una variable que vamos a procesar para realizar la salida en el display.
````
    input [2:0]A;
    input [2:0]B;
    input Ci;

    wire [3:0] S;
    wire Co;
````
La diferencia con el codigo anterior es que ahora no tenemos Output's tenemos Wire's, que vamos a usar para conectar las logicas del display.


Instanciamos los modulos necesarios para realizar las sumas
````
    Sumador sum0(.a(A[0]), .b(B[0]), .ci(1'b0), .s1(S[0]), .c0(C1));

    Sumador sum1(.a(A[1]), .b(B[1]), .ci(C1), .s1(S[1]), .c0(C2));

    Sumador sum2(.a(A[2]), .b(B[2]), .ci(C2), .s1(S[2]), .c0(S[3]));
````
y ya deberiamos tener el sumador de 3 Bits, el siguiente paso seria mostrar el resultado en el display

### Mostrar el resultado en HexaDecimal (Configuracion Incial)

Por la configuracion que tenemos en la FPGA primero tenemos que seleccionar que display vamos a usar (Esta FPGA contiene 8 Displays de 7 segmentos pero solo vamos a hacer uso de 4 displays), esto lo controlamos mediante un output que vamos a llamar AN, y lo vamos a configurar como:
````
    output [3:0] an;
    assign an = 4'b1110;
````
Aqui estamos creando la salida y dandole un valor de un digito de 4 bits con los valores 1-1-1-0, el 0 indica que vamos a tener prendido solo el ultimo display

### Mostrar el resultado en HexaDecimal (Algoritmo)

Vamos a instanciar un bloque Always() que va a ejecutar logica secuencial en la FPGA:
````
    always @(Evento) begin

    end
````
Esto quiere decir que en cada ciclo de reloj, si se cumple la condicion del evento, va a ejecutar la logica que le introduzcamos, nuestro evento va a ser * entonces cada ciclo del reloj vamos a llamar la funcion:
````
    always @ ( * ) begin

    end
````

Dentro de la logica vamos a llamar un " Case() " con el que vamos a meter el resultado de la suma y lo vamos a convertir en su representacion del display de 7 segmentos:
````
    always @ ( * ) begin
    case (S)  
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
        4'ha: SSeg = 7'b0001000; // "A"
        4'hb: SSeg = 7'b1100000; // "B"
        4'hc: SSeg = 7'b0110001; // "C"
        4'hd: SSeg = 7'b1000010; // "D"
        4'he: SSeg = 7'b0110000; // "E"
        4'hf: SSeg = 7'b0111000; // "F"
        default:
            SSeg = 0;
        endcase
    end
    endmodule
````
Este valor lo metemos directamente a SSeg que es nuestra salida en el display de 7 segmentos y con esto podemos mostrar el resultado de la suma con hexadecimales.

## Mostrar el resultado en Decimal

Tenemos un problema con la forma en la que se construye la FPGA ya que a los display's les asignamos valores mediante un Multiplexor, entonces solo podemos mostrar un digito al tiempo, esto es un problema porque una suma de dos numeros de 3 bits nos puede resultar en un numero decimal de 2 digitos distintos, digamos que si vamos a mostrar un 7 no podemos mostrar otro numero que no sea un 7 en otro display, podriamos mostrar un

    0 7 0 7

Pero nunca un 

    0 1 2 3

Lo que vamos a hacer es que vamos a prender un numero al tiempo secuencialmente, y esto nos dara la ilusion de que estamos mostrando varios digitos al mismo tiempo

    0 0 0 3 + 0 0 2 0 + 0 1 0 0 0 = 0 1 2 3

### Mostrar el resultado en Decimal (Reloj)

Siguiendo esta misma logica podriamos hacer un
````
    an = 0 0 0 1
    SSeg = (3 en binario)

    an = 0 0 1 0 
    SSeg = (2 en binario)

    an = 0 1 0 0 
    SSeg = (1 en binario)
````
y esto seria correcto, pero nos enfrentamos a un problema fisico con los displays y es que la logica cambia tan rapido que no les da tiempo a prender, entonces va a parecer que ninguno prende porque ninguno tiene el tiempo de corriente suficiente como para prender.

Lo que vamos a hacer es un delay para darle el tiempo que necesite el display para energizarse y cambiar al siguiente display entonces:
````
    localparam divisor = 50000000;
	reg [25:0] counter = 0;

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
````
En este fragmento de codigo lo que vamos a hacer es que cada vez que haya un ciclo de reloj vamos a aumentar un contador en 1, Cuando este contador llegue a 50000000, vamos a resetear el reloj y invertir una variable llamada "clock", escencialmente estamos haciendo que ejecute una accion cada 50000000 ciclos.

Luego implementamos la misma logica pero ahora dependiendo si el clock se encuentra en 0, vamos a hacer la logica del primer Display, pero si ya pasaron 50000000 ciclos hacemos la logica del segundo display efectivamente haciendo la rotacion de los digitos.
````
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
````

# Video mostrando el circuito

https://youtube.com/shorts/99IaE-0dVRM?si=fU-4SkiUcEEJ0cgY

