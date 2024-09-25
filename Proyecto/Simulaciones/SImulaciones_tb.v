module SImulaciones_tb;

	integer i;
	integer ix;
	reg FinalCarrera1,	FinalCarrera2,	LuzSwitch,	Sensor,clockLight;
    reg [3:0]RxData;
	wire Luz,Alarma, Motor1,Motor2;


    SImulaciones SImulaciones(
    .Luz(Luz),
	.Alarma(Alarma),
	.Motor1(Motor1),
	.Motor2(Motor2),
	.RxData(RxData),
	.FinalCarrera1(FinalCarrera1),
	.FinalCarrera2(FinalCarrera2),
	.LuzSwitch(LuzSwitch),
	.Sensor(Sensor),
	.clockLight(clockLight));

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0,SImulaciones_tb);
		
		
		for(ix=0;ix<31;ix=ix+1)begin
			FinalCarrera1 <= ix[0] ;
			FinalCarrera2 <= ix[1] ;
			LuzSwitch <= ix[2] ;
			clockLight <= ix[3] ;
			Sensor<= ix[4] ;
			for(i=0;i<15;i=i+1)begin
				RxData <=i;
				# 1;
			end
		end	
		
	end
endmodule