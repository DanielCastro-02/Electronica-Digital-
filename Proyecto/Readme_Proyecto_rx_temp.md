## UART_Rx

El modulo de rx es la parte de codigo donde vamos a recibir los datos desde nuestro modulo bluetooth;

Primero creamos una maquina de estado que verifica una señal de reset, en el caso de que este activada, ponemos el estado del circuito en el modo necesario (Almacenado en State), en caso de que este en bajo dejamos el circuito en espera.


    always @ (posedge Clk or negedge Rst_n)
    begin
    if (!Rst_n)	State <= IDLE;
    else 		State <= Next;
    end

Ahora hacemos distintas logicas para comprobar en que estado deberia estar nuestro circuito

Si esta a la espera pero RxEnable esta activo, entonces ponemos el circuito en modo de lectura, si ya estamos en lectura pero el circuit ya termino (RxDone) ponemos otra vez el circuito a la espera de otra entrada

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

Dependiendo del estado en el que nos encontremos vamos a habilitar un bit llamado "Read_Enable" que vamos a utilizar para saber cuando nuestro circuito esta listo para empezar las lecturas

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

Vamos a realizar la lectura

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

Finalmente metemos los datos en otros registros (RxData), para finalmente usarlos en lo que necesitemos

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

            

    