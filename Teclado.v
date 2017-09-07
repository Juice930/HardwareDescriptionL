module Teclado(
	input CLK50, 
	input CLKSP2,
	input DATA,
	output reg parity,
	output [6:0] LED);
	
wire [7:0] ARROW_UP = 8'h75;	//codes for arrows
wire [7:0] ARROW_DOWN = 8'h72;

reg read,reset;
reg [11:0] cread;	//Watchdog
reg error;
reg [9:0] serbits;	//Palabra de 7 bits, 1 paridad, inicio, fin y ack
reg [3:0] n;		//Cantidad de bits recibidos
reg [6:0] byt;
wire CLK;
reg [15:0] C;
reg [1:0] Estados;

parameter Inicio=2'd0;
parameter Datos=2'd1;
parameter Stop=2'd2;

//Divisor de Frecuencia
assign CLK=CLK50;

assign LED=byt;

always @(posedge CLK)
parity = ~^serbits[6:0];

always @(posedge CLK)
	if(Estados==Datos)
		if(cread==2000) begin
			reset=1;
			cread=0;
		end
		else begin
			cread=cread+1;
			reset=0;
		end
	else
		cread=0;

always @(posedge CLKSP2 or posedge reset)
if(reset)
	Estados=Inicio;
else
	case(Estados)
		Inicio:
		begin
			if (!DATA) begin
				Estados=Datos;
				serbits={DATA,serbits[9:1]};
			end
		end
		Datos:
		begin
			if (n==9) begin
				n=n+1;
				serbits={DATA,serbits[9:1]};
			end
			else if(n==10) begin
				n=0;
				if(~^serbits[6:0]==serbits[7])
					byt=serbits[6:0];
				else
					byt=7'b0;
				Estados=Inicio;
			end
			else begin
				n=n+1;
				serbits={DATA,serbits[9:1]};
			end
		end
	endcase
endmodule
