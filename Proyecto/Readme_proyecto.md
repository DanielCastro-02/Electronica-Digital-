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
\\ Baudrate es la velocidad a la cual deseamos que vaya los datos de la FPGA, la cual corresponde a los 325 baudios. La variable Rst_n funciona como un reset el cual reinicia la variable baudRateReg a 16'b1, cuando esto no ocurre a este variable se le suma un contador hasta que esta variable sea igual a nuestro Baudrate. 

