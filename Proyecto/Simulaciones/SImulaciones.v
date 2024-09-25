module SImulaciones(RxData,FinalCarrera1,FinalCarrera2,LuzSwitch,Luz,Sensor,Alarma,Motor1,Motor2,clockLight);

	input [3:0]RxData;
	input FinalCarrera1;
	input FinalCarrera2;
	input LuzSwitch;
	input Sensor;
	input clockLight;
	output Luz;
	output Alarma;
	output Motor1;
	output Motor2;
		
	
	assign  Alarma = ~Sensor;
	assign Luz = !RxData[2] && !clockLight && !LuzSwitch;
	assign Motor1 = !RxData[0] || FinalCarrera1 || FinalCarrera2;
	assign Motor2 = !RxData[1] || FinalCarrera1 || FinalCarrera2;
	

	
endmodule