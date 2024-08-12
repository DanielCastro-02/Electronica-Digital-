# Contador de Segundos, Centesimas de segundo y Milesimas de segundo 
Esta practica de laboratorio consistio en mediante el uso del *Clock* de la FPGA utilizarlo para realizar un contador de tiempo en unidades de segundo, especificamente en segundos, centecimas y milesimas, y que dicho resultado sea presentado a travez del display del *7 segmentos* y mediante el *Dip Swicht* puedan cambiar entre dichas unidades de tiempo. Para ello, primero debemos tener en cuenta que el *Clock* opera en MHz especificamente trabaja a 50000 MHz, por locual debemos realizar la conversion de MHz a milisegundos, para que en base a ello realicemos las pertinentes divisiones con el fin de poder pasar entre las diferentes unidades de tiempo, este procedimiento se puede ver en el siguiente codigo 

//Divisor de Frecuencia
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
	
// incremento del contador x milisegundo
````
	always @(posedge pulso_ms or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (count == 9999) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
````	 
// Dividir cada digito del contador 
````
    assign digit1 = count % 10;
    assign digit2 = (count / 10) % 10;
    assign digit3 = (count / 100) % 10;
    assign digit4 = (count / 1000) % 10;
````
Luego de ello se procede a presentar estos datos en el display, esto teniendo en cuenta que se debe considerar la configurarion binaria del anodo de los 7 segmentos y que para activar mas de un display se debe realizar una conmutacion entre los display de tal manera que se enciendan y apagen los displays y presenten los digitos en pantalla, pero teniendo en cuenta que dicha conmutacion se debe realizar de tal manera que no sea perseptible a la vista humana. El resultado de este laboratorio, con todo lo mencionado anteriormente podemos observarlo en el siguiente video:   


