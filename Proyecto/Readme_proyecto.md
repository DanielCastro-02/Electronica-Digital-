# Proyecto prototipo de control y seguridad hogar inteligente

## Implementación en Verilog

Para el desarrollo de este proyecto, primero se tuvo que desarrollar la conxion entre el modulo Bluetooth y la FPGA, esto con el fin de lograr una comunicacion entre una aplicacion de telefono que controla ciertas salidas del sistema, para poder "comunicarse" entre si se debe tener en consideracion que la velocidad de transmision de datos (baudios) entre la FPGA y el modulo Bluetooth debe ser el la misma, ya que si esta no es igual no se puede lograr una conexion. Para este caso se utilizo un modulo bluetooht HC-05, el cual tabaja a unos ***9600 baudios***, ademas sabemos que el *Clock* de la FPGA trabaja a ***50 MHz***; gracias a estos datos se realiza un divisor de frecuencia, el cual, sirve para saber a que velocidada debemos trasmitir los datos de la FPGA, para este caso da como resultado que ***50MHz/9600 baudios = 5208 baudios***, valor el cual es demasiado grande, por lo que se toma la desicion de hacerlo 16 veces mas rapido, con el objetivo de acceder a intervalos de timepo mas pequeños, de esta manera nuestro divisor de frecuencia cambia a la forma de ***50MHz/(9600 baudios * 16) = 325 baudios***. 

Transmision de datos:
````

module UART_BaudRate_generator(
    Clk                   ,
    Rst_n                 ,
    Tick                  ,
    BaudRate
    );

````
Se declaran los puertos de salida y entrada del modulo:

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
*Baudrate* es la velocidad a la cual se desea que vaya los datos de la FPGA, que en este caso corresponde a los ***325 baudios*** calculados anteriormente; la variable *Rst_n* funciona como un reset el cual reinicia la variable *baudRateReg* a *16'b1*, cuando esto no ocurre, a este variable se le suma un contador hasta lograr que esta variable sea igual a nuestro Baudrate. 

### UART_Rx

El modulo de *rx*, es el segmento con el cual configuramos la recepcion de datos desde el modulo bluetooth;

Primero se crea una maquina de estado, la cual verifica una señal de reset y en el caso de que este activada, se pone el estado del circuito en el modo necesario (Almacenado en *State*), en caso de que este en bajo se deja el circuito en espera.


    always @ (posedge Clk or negedge Rst_n)
    begin
    if (!Rst_n)	State <= IDLE;
    else 		State <= Next;
    end

Ahora se realiza distintas logicas para comprobar el estado en que deberia estar el circuito

Si esta a la espera pero *RxEnable* esta activo, entonces se pone el circuito en modo de lectura y si ya se esta en lectura pero el circuito ya termino, *RxDone*, se pone otra vez el circuito a la espera de otra entrada:

    always @ (State or Rx or RxEn or RxDone)
    begin
        case(State)	
        IDLE:	if(!Rx & RxEn)		Next = READ;
            else			Next = IDLE;
        READ:	if(RxDone)		Next = IDLE;
            else			Next = READ;
        default 			Next = IDLE;
        endcase
    end

Dependiendo del estado en el que se encontre vamos a habilitar un bit llamado *Read_Enable* el cual se utiliza para saber cuando el circuito esta listo para empezar las lecturas:

    always @ (State or RxDone)
    begin
        case (State)
        READ: begin
            read_enable <= 1'b1;
            end
        
        IDLE: begin
            read_enable <= 1'b0;
            end
        endcase
    end

Se realiza la lectura:

    always @ (posedge Tick)

        begin
        if (read_enable)
        begin
        RxDone <= 1'b0;							
        counter <= counter+1;						
        //Si la lectura esta habilitada vamos a poner RXDone en 0 porque este solo se activa cuando termina la lectura y en cada tick del baudrate aumentamos un contador en 1
        

        if ((counter == 4'b1000) & (start_bit)) // Si el contador esta al maximo de una ultima lectura lo inicializamos en 0 y tambien con el bit de inicio
        begin
        start_bit <= 1'b0;
        counter <= 4'b0000;
        end

        if ((counter == 4'b1111) & (!start_bit) & (Bit < NBits))	
        //Vamos iterando metiendo los datos que llegan en ReadData
        begin
        Bit <= Bit+1;
        Read_data <= {Rx,Read_data[7:1]};
        counter <= 4'b0000;
        end
        
        if ((counter == 4'b1111) & (Bit == NBits)  & (Rx))
        //Cuando termine de meter los datos ponemos RxDone en alto, reseteamos el counter y los valores para la proxima lectura
        begin
        Bit <= 4'b0000;
        RxDone <= 1'b1;
        counter <= 4'b0000;
        start_bit <= 1'b1;						
        end
        end
        end

Finalmente se ingresan los datos en otros registros *RxData*, para finalmente ser usados en la aplicacion requerida.

    always @ (posedge Clk)
    begin

    if (NBits == 4'b1000)
    begin
    RxData[7:0] <= Read_data[7:0];	
    end

    if (NBits == 4'b0111)
    begin
    RxData[7:0] <= {1'b0,Read_data[7:1]};	
    end

    if (NBits == 4'b0110)
    begin
    RxData[7:0] <= {1'b0,1'b0,Read_data[7:2]};	
    end
    Beeper = !Sensor;
    Light = !RxData[2] && !clockLight && !lightSwitch;
    motor1 = !RxData[0] || finalcarrera1 || finalcarrera2;
    motor2 = !RxData[1] || finalcarrera1 || finalcarrera2;

    end

            
Para la implementacion del control de bombillo, con el cual prende y apaga el led, y el detector de proximidad, se ingresa al apartado de Rx, en el cual se encuentra el siguiente fragmento de codigo:

````
Beeper = !Sensor;
Light = RxData[2] || clockLight || lightSwitch;
motor1 = !RxData[0] && !finalcarrera1 && !finalcarrera2;
motor2 = !RxData[1] && !finalcarrera1 && !finalcarrera2;
````
De esta manera cuando el sensor se active, el sistema va utilizar la alarma de la FPGA la cual esta descrita como Bell, y sonara siempre y cuando el sensor identifique algo frente a el. El encargado de prender y apagar el bombillo es el comando lightSwitch, este va poder apagar y prender el bombillo siempre y cuando el panel tenga un numero menor que 6 (tiempo que simula la hora configurada por el usuario para programar las luces de su casa). El motor 1 y 2, hacen referencia al sentido de giro del motor de la persiana, el cual tambien depende de la lectura de los finanes de carrera.

### Clock

Utilizando como base el clock de la practica del ***laboratorio #4***, se modifica ligeramente para que este pudiera acoplarse y cumplir los requisitos de este proyecto, el clock en este caso va funcionar de la siguiente manera:

Divisor de frecuencia

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
Se da la condicion de que si el contador de segundos llega a 6, el bombillo se mantiene prendido hasta que es este contador se reinicie, en el momento que se reinicie, el bombillo vuelve a su estado natural, es decir estar apagado.

````
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
````
Se divide el *count* en 1000, con el fin de mostrar el tiempo en segundos con la variable *digito4*
````
 assign digito4 = (count / 1000) ; 
````
Se hace uso del dsiplay de 7 segmentos, para observar y contar el tiempo con mayor facilidad
````
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
````
Se le asigna al tiempo la variable *digito4*, para usar el display de 7 segmentos y asi contar el tiempo
````
always @(*) begin

		tiempo = digito4; // Segundos
		
    end
	
endmodule

````
## Simulacion
Al simular el sistema para comprobar el correcto funcionamiento del mismo se obtuvo:
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Proyecto/img/Simulacion.jpg)
En esta simulacion se puede evidenciar:
* las señales recibidas por el modulo Bluetooth *RxData* y su correlacion con los motores donde vemos que *motor1* depende de *RxData[0]* y *motor2* depende de *RxData[1]* 
* La correlacion entre la señal leida por el *Sensor* y la *Alarma*, donde se evidencia que la lectura del sensor genera que la alarma se prenda o apague.
* la señal *ClockÑight* simula los tiempos programados para el encendido o apagado del bombillo.
* El correcto funcionamiento del prendido y apagado del bombillo, *LuzSwitch*, a traves del swicht.
* La correlacion del bombillo *Luz* con el *RxData[2]*.
  
## Montaje en Fisico 

### Lista de Materiales 
* **FPGA:** Cyclone IV 
* **Motor:** DC de 5V
* **Puente H:** L298N
* **Fuente de alimentación:** 5V
* **Finales de carrera:** 2 unidades
* **Sensor de distancia:** SHARP 2Y0A21
* **Buzzer:** 1 unidad (Buzzer de la FPGA)
* **LED:** 1 unidad
* **Módulo Bluetooth:** HC-05
* **Resistencia:** 360 Ohm 

### Conexiones:

La FPGA Cyclone IV será el cerebro de este sistema y para ello se debe interconectar con los demás componentes de la siguiente manera:

* **Buzzer:** Conectado al PIN 141 (pin propio del Buzzer de la FPGA) para generar sonidos de alarma.
* **Reloj:** Conectado al PIN 23 (Clock de la FPGA) para sincronizar el sistema.
* **LED:** Conectado al PIN 32 con una resistencia de 360 Ohm para limitar la corriente.
* **Reset:** Conectado al PIN 67 para reiniciar el sistema si es necesario.
* **Bluetooth:**
    * Recepción (Rx): Conectado al PIN 38.
Nota: se puede comprobrar  
* **Sensor de distancia:** Conectado al PIN 46 para detectar objetos cercanos.
* **Finales de carrera:**
    * Final carrera 1: Conectado al PIN 59.
    * Final carrera 2: Conectado al PIN 65.
* **Motor:** El motor esta conectado al puente H y es controlado mediante los pines IN1 y IN2 del puente H, los cuales están conectadas a los PIN 64 y PIN 58 de la FPGA.
* **Switch de luces:** Conectado al PIN 60 para controlar manualmente el encendido/apagado de la luz.
* **Reloj secundario:** Para mostrar la "hora" a traves del primer display del 7 segmentos del la FPGA, realizando uso de los pines 119, 120, 121, 124, 125, 126, y 127.

Al configurar el PinPlanner, este queda de la siguiente manera:
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Proyecto/img/Pinplanner.jpg)

### Consideraciones adicionales:

* **Alimentación:** El sensor de distancia y el puente H requieren una alimentación externa de 5V. Es fundamental realizar un acople de tierras entre esta fuente y la FPGA para garantizar un funcionamiento estable.

### Implementación fisica:
En el siguiente video se puede observar la implementación del circuito
[![Video implementacion en Cyclone IV](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Proyecto/img/Montajefisico.png)](https://youtu.be/x3SsoC8LdlU)
