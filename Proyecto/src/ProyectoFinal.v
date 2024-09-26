module ProyectoFinal(
    	Clk                     ,
    	Rst_n                   ,   
   	Rx                      ,    
    	Tx                      ,
	RxData		        ,
	Light,
	Sensor,
	Beeper,
	rClk,
	secClk,
	anClk,
	lightSwitch,
	finalcarrera1,
	finalcarrera2,
	motor1,
	motor2
	
	);

/////////////////////////////////////////////////////////////////////////////////////////
input           Clk             ; // Clock
input           Rst_n           ; // Reset
input           Rx              ; // RS232 RX line.
input lightSwitch;
output          Tx              ; // RS232 TX line.
output [7:0]    RxData          ; // Received data
output			 Light;
input Sensor;
output Beeper;
input wire rClk;
output [6:0] secClk;
output anClk;
input finalcarrera1;
input finalcarrera2;
output motor1;
output motor2;
/////////////////////////////////////////////////////////////////////////////////////////
wire [7:0]    	TxData     	; // Data to transmit.
wire          	RxDone          ; // Reception completed. Data is valid.
wire          	TxDone          ; // Trnasmission completed. Data sent.
wire            tick		; // Baud rate clock
wire          	TxEn            ;
wire 		RxEn		;
wire [3:0]      NBits    	;
wire [15:0]    	BaudRate        ; //328; 162 etc... (Read comment in baud rate generator file)

wire clockLight;
/////////////////////////////////////////////////////////////////////////////////////////

assign 		RxEn = 1'b1	;
assign 		TxEn = 1'b1	;
assign 		BaudRate = 16'd325; 	//baud rate set to 9600 for the HC-06 bluetooth module. Why 325? (Read comment in baud rate generator file)
assign 		NBits = 4'b1000	;	//We send/receive 8 bits
/////////////////////////////////////////////////////////////////////////////////////////


//Make connections between Rx module and TOP inputs and outputs and the other modules
UART_rs232_rx I_RS232RX(
    	.Clk(Clk)             	,
   	.Rst_n(Rst_n)         	,
    	.RxEn(RxEn)           	,
    	.RxData(RxData)       	,
    	.RxDone(RxDone)       	,
    	.Rx(Rx)               	,
    	.Tick(tick)           	,
    	.NBits(NBits)				,
		.Light(Light),
		.Sensor(Sensor),
		.Beeper(Beeper),
		.clockLight(clockLight),
		.lightSwitch(lightSwitch),
		.finalcarrera1(finalcarrera1),
		.finalcarrera2(finalcarrera2),
		.motor1(motor1),
		.motor2(motor2),
    );

//Make connections between Tx module and TOP inputs and outputs and the other modules
UART_rs232_tx I_RS232TX(
   	.Clk(Clk)            	,
    	.Rst_n(Rst_n)         	,
    	.TxEn(TxEn)           	,
    	.TxData(TxData)      	,
   	.TxDone(TxDone)      	,
   	.Tx(Tx)               	,
   	.Tick(tick)           	,
   	.NBits(NBits)
    );

//Make connections between tick generator module and TOP inputs and outputs and the other modules
UART_BaudRate_generator I_BAUDGEN(
    	.Clk(Clk)               ,
    	.Rst_n(Rst_n)           ,
    	.Tick(tick)             ,
    	.BaudRate(BaudRate)
    );

Relojx Reloj(
	.clock(Clk),
	.reset(rClk),
	.sec(secClk),
	.an(anClk),
	.clockLight(clockLight)
);

endmodule
