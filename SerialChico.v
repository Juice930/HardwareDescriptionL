//Controlador del circuito integrado ADS7822
//Pablo Velázquez, 7 de julio de 2017
//ICN
module SerialChico(
	CLK50,		//Entrada de reloj de 50 MHz
	DIN,		//Entrada en serial del ADC
	CLK,		//Reloj para el ADC y la ASM
	CS,			//Chip Select
	SerialBit,	//Salida en serial del valor digital
	LEDS		//LEDs que muestran los 8 bits más significativos
);
//Asignamos a los puertos de qué tipo son
input CLK50;
input DIN;
output reg SerialBit;			//la palabra reservada reg indica que la señal o puerto conserva su valor
output reg CLK;
output reg CS;
output reg [7:0] LEDS;

reg [9:0] 	OutB1,OutB2,OutB3;
reg [5:0]	CSer;
reg [8:0]	Bits;
reg [11:0] 	C;
reg [1:0] 	Estados;

//Estados de la ASM
parameter Inicio=2'd0;
parameter Flag=2'd1;
parameter Conv=2'd2;
parameter Transf=2'd3;

//Divisor de frecuencia
always @(negedge CLK50)
	if (C==0) begin
		C=2603;	//9600 Hz //No recomiendo utilizar un baudrate mayor a este, la computadora crashea
		//C=433;//57600 Hz
		//C=216;		//115200Hz
		CLK=!CLK;
	end
	else
		C=C-1;
		
//ASM
always @(negedge CLK)
case (Estados)
	//En el estado inicio se carga una A para sacarla en el puerto serial
	Inicio:
	begin
		CS<=1;
		CSer=0;
		SerialBit<=1;
		OutB3=10'd96;//0001100000, 0 en ASCII
		Estados<=Flag;
	end
	
	//En el estado Flag se saca el 0 con el CS todavía encendido, hasta que la A sale completamente
	//se apaga el CS, se dejan transcurrir 2 tiempos para empezar la captura de datos
	Flag:
	begin
		CSer<=CSer+1;
		//Sacar el 0
		if (CSer<10) begin
			SerialBit<=OutB3[0];
			OutB3={1'b0,OutB3[9:1]};
		end
		//Esperar un tiempo de Sample
		else if (CSer<13) begin
			SerialBit<=1;
			CS<=0;
		end
		else
			Estados<=Conv;
	end
	
	//Se capturan los datos del DIN y se van recorriendo en Bits, cuando han llegado 8 se guardan en OutB1
	//Luego cuando hayan llegado los otros 4 se van guardando en OutB2.
	//OutB1 y OutB2 tienen sus respectivos bits de inicio y parada.
	Conv:
	begin
		CSer<=CSer+1;
		//Recibir los datos
		if (CSer<26) begin
			Bits[8]=DIN;
			Bits={1'b0,Bits[8:1]}; //Hace un corrimiento a Bits
			//Cargar el primer byte
			if (CSer==21) begin
				OutB1={1'b0,Bits[7:0],1'b0};
				LEDS=Bits[7:0];
			end
			//Cargar el segundo byte
			else if (CSer==25)
				OutB2={1'b0,Bits[7:4],5'b0};
		end
		else
			Estados<=Transf;
	end
	
	//En este estado se sacan OutB1 y OutB2 por el puerto serial con el Chip Select encendido
	Transf:
	begin
		CS<=1;
		CSer<=CSer+1;
		//Sacar el primer byte
		if(CSer<=36) begin
			SerialBit<=OutB1[9];
			OutB1={OutB1[8:0],1'b0};//Hace un corrimiento en OutB1
		end
		//Sacar el segundo byte
		else if (CSer<=46) begin
			SerialBit<=OutB2[9];
			OutB2={OutB2[8:0],1'b0};//Hace un corrimiento en OutB2
		end
		else begin
			SerialBit<=1;//Deja la salida en 1
			Estados<=Inicio;
		end
	end
endcase

endmodule