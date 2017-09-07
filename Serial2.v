//Hardware descrito para leer los datos de 8 canales del ADC de la tarjeta DE0Nano de Altera 
//y transmitirlos por puerto Serial a la PC. El programa escrito en Python correspondiente 
//se llama Serializador2.py.
//Por: Pablo Velázquez
//ICN
module Serial2(
	CLK50,
	CLK,
	MISO,
	MOSI,
	LEDS,
	CS,
	TX
);
input CLK50, MISO;			//Entrada de 50 MHz y MISO
output reg MOSI,CS,TX,CLK;	//MOSI, ChipSelect, Salida Serial y CLK interno
output reg [7:0] LEDS;		//Salidas a los leds para un solo canal definido más adelante

reg [11:0] C=0;				//Contador para el divisor de frecuencia
reg [5:0] CSer;				//Contador para la ASM
reg [2:0] CHN,CHNAux;		//8 canales!
reg [1:0] Estados;			//2 flipflops para los estados de la ASM
reg [9:0] ID,B1,B2;			//3 bytes de salida por lectura
reg [7:0] Bits;				//Flipflops para almacenar temporalmente las lecturas

//Estados de la ASM
parameter Inicio=2'd0;		
parameter Canal=2'd1;
parameter Recep=2'd2;
parameter Transf=2'd3;

//Divisor de Frecuencia
always @(negedge CLK50)
	if (C==0) begin
		CLK<=!CLK;			
		C=50E6/(9600*2);	//Recomiendo utilizar un baudrate de 9600 para la transmisión, con uno más alto hay problemas en el puerto de la PC
	end
	else
		C=C-12'b1;

//ASM
always @(negedge CLK)
	case(Estados)
		Inicio:
		begin
			if (CHN==3)//Límite de canales-1 MODIFICAR AQUI!
				CHN<=0;
			else
				CHN<=CHN+1;
			CHNAux=CHN+3'b1;
			CS<=1;						//Desactiva el ChipSelect
			CSer=0;						//Resetea la cuenta
			MOSI<=0;					//Apaga el MOSI
			TX<=1;						//Bit de transmisión en alto
			Estados<=Canal;				//Avanza al siguiente estado
			ID<={1'b0,8'd48+CHN,1'b0};	//Se prepara el byte de ID para que vaya saliendo
										//ID contiene el canal de la salida en ASCII
		end
		Canal:
		begin
			CS<=0;							//Activa el ChipSelect
			CSer=CSer+6'b1;					//Se incrementa la cuenta de CSer cada vez que regresa a este estado
			TX=ID[0];						//Asignamos el bit menos significativo a la salida
			ID={1'b1,ID[9:1]};				//Vamos corriendo el ID
			if (CSer>=3 & CSer<=5) begin	//Tiempo en el que debe salir el MOSI
				MOSI<=CHNAux[2];			//Se asigna la salida del MOSI
				CHNAux<={CHNAux[1:0],1'b1};	//Se corre el número que va a ir saliendo
				if (CSer==5)				//Si el contador es 5 el MISO va a llegar
					Bits[0]=MISO;			//Se guarda el primer elemento del MISO
			end
			else if (CSer==6) begin			//Si la cuenta es 6
				MOSI<=0;					//Desactivamos el MOSI
				Bits={Bits[6:0],MISO};		//Corremos los Bits con la entrada del MISO
				Estados<=Recep;				//Pasamos al siguiente estado
			end
		end
		Recep:
		begin
			CSer=CSer+6'b1;					//Incrementa la cuenta
			if (CSer<=18) begin	
				//TRANSMISIÓN DE BITS
				Bits={Bits[6:0],MISO};		//Vamos almacenando los Bits
				if (CSer<=14) begin			//Si es menor o igual a 14 se transmite el ID
					TX=ID[0];				//La salida es el bit menos significativo del ID
					ID={1'b1,ID[9:1]};		//Se corre el ID
				end
				else begin					//Si es mayor a 14 entonces se transmite el byte 1
					TX=B1[0];				//La salida es el bit menos significativo del byte 1
					B1={1'b1,B1[9:1]};		//Corremos el byte 1
				end
				
				//RECEPCIÓN DE BITS
				if(CSer==13) begin			//Si la cuenta es 13 hay que capturar el byte 1
					B1={1'b0,Bits,1'b0};	//Capturamos el byte 1 y le agregamos unos bits de inicio y parada
					if(CHN-1==0)			//Canal que se muestra en los leds
						LEDS=Bits;			
				end
				else if (CSer==17)				//Cuando la cuenta es 17 capturamos el byte 2
					B2={1'b0,Bits[3:0],5'b0};	//Capturamos el byte 2 y le agregamos 0 y bits de inicio y parada
			end
			else begin				//Si la cuenta es mayor a 18
				TX=B1[0];			//La salida se asigna a B1 todavía
				B1={1'b1,B1[9:1]};	//Se corre el byte 1
				Estados<=Transf;	//Pasamos al siguiente estado
			end
		end
		Transf:
		begin
			CS<=1;					//Apagamos el ChipSelect
			CSer=CSer+6'b1;			//Incrementamos la cuenta
			if (CSer<=30) begin		//Si la cuenta es menor a 30 se deben enviar los bits restantes del byte 1
				TX=B1[0];			
				B1={1'b1,B1[9:1]};
			end
			else if (CSer<=40) begin//Si es mayor 30 pero menor que 40 se asigna el byte 2
				TX=B2[0];
				B2={1'b1,B2[9:1]};
			end
			else
				TX=1;				//Si es mayor a 40 la salida es 1
			if (CSer==50)			//Esperamos a que la cuenta se haga 50 para volver a empezar
				Estados<=Inicio;
		end
	endcase
endmodule