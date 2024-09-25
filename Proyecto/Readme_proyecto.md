# Proyecto prototipo de control y seguridad hogar intelignete

Para el desarrollo de este proyecto, lo primero que se tuvo que desarrollar era la conxion entre el modulo bluetooth y la FPGA, estas dos para poder "comunicarse" entre si deben estar manejando la misma velocidad de transmision de datos (baudios), ya que si esta no es igual no se puede lograr una conexion. Para este caso se utilizo un modulo bluetooht HC-05, el cual tabaja a unos 9600 baudios, tambien sabemos que la freceuncia que maneja la FPGA es de 50 MHz, gracias a estos dos datos podemos realizar un divisor de frecuencia el cual nos va ayudar a saber a que velocidada debemos trasmitir los datos de la FPGA, nos da como resultado que 50MHz/9600 baudios = 5208 baudios, este valor es demasiado grande, por lo que decidimos hacerlo 16 veces mas rapido, con el objetivo de acceder a intervalos de timepo mas pequeños, por lo tanto nuestro divisor de frecuencia cambia a la forma de 50MHz/(9600 baudios * 16) = 325 baudios. 

// Transmision de datos.
````

module UART_BaudRate_generator(
    Clk                   ,
    Rst_n                 ,
    Tick                  ,
    BaudRate
    );

````
// Se declaran los puertos de salida y entrada del modulo

````
input           Clk                 ; // Clock input
input           Rst_n               ; // Reset input
input [15:0]    BaudRate            ; // Value to divide the generator by
output          Tick                ; // Each "BaudRate" pulses we create a tick pulse
reg [15:0]      baudRateReg         ; // Register used to count


always @(posedge Clk or negedge Rst_n)
    if (!Rst_n) baudRateReg <= 16'b1;
    else if (Tick) baudRateReg <= 16'b1;
         else baudRateReg <= baudRateReg + 1'b1;
assign Tick = (baudRateReg == BaudRate);
endmodule
````
// Baudrate es la velocidad a la cual deseamos que vaya los datos de la FPGA, la cual corresponde a los 325 baudios. La variable Rst_n funciona como un reset el cual reinicia la variable baudRateReg a 16'b1, cuando esto no ocurre a este variable se le suma un contador hasta que esta variable sea igual a nuestro Baudrate. 

Para la implementacion del control de bombillo con el cual prende y apaga, y el detector de precensia nos vamos al apartado de Rx  donde se encuentra el siguiente fragmento,

````
Beeper = !Sensor;
Light = RxData[2] || clockLight || lightSwitch;
motor1 = !RxData[0] && !finalcarrera1 && !finalcarrera2;
motor2 = !RxData[1] && !finalcarrera1 && !finalcarrera2;
````
// De esta manera cunado el sensor se active, el sistema va utilizar la alarma de la FPGA la cual esta descrita como Bell y es el pin 141, y sonara siempre y cuando algo este enfrente suyo. El encargado de prender y apagar el bombillo es el comando lightSwitch, este va poder apagar y prender el bombillo siempre y cuando el panel tenga un numero menor que 6. El motor 1 y 2, hacen referencia al momento en que la persiana tiene que terminar de subir y bajar respectivamnete.

# Clock

Utilizando el clock de la practica de laboratorio #4, se medofico ligeramente para que estu pudiera acoplarse y cumplr los requisitos de este proyecto, el clock en este caso va funcionar de la siuigente manera:

// Divisor de frecuencia

````
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
````

