Library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

Entity Trucutru is
Port(	Deco:	out		integer range 0 to 15;
		Mux:	in 		std_logic_vector(0 to 3);
		ENA:	out		std_logic;
		BSINC:	out		std_logic;
		CLK:	in 		std_logic;
		Disp:	out 	std_logic_vector(0 to 6));
End Entity;

Architecture looksito of Trucutru is

	Signal	CARRY,BS,SINC,Q2,RST,MAX:	std_logic;
	Signal	C1:		integer range 0 to 3;
	Signal  C2:		integer range 0 to 3;
	Signal	C3:		integer range 0 to 200;
	Signal 	CUENTA: INTEGER RANGE 0 TO 9999;
	Signal 	RELOJ:STD_LOGIC;

Begin
	--2 Contadores de 2 bits en cascada, uno con CARRY y pausa
	Process(RELOJ,SINC)
	Begin
		If SINC='0' and Falling_Edge(RELOJ) then
			If C1=3 then
				C1<=0;
				CARRY<='1';
			Else
				C1<=C1+1;
				CARRY<='0';
			End If;
		End If;
	End Process;
		
	Process(CARRY)
	Begin
		If Falling_Edge(CARRY) then
			If C2=3 then
				C2<=0;
			Else
				C2<=C2+1;
			End If;
		End if;
	End Process;

	--Decodificador
	with C2 select
	Deco<=	1 when 0,
			2 when 1,
			4 when 2,
			8 when 3;
	--Mux
	with C1 select
	BS<=	Mux(0) when 0,
			Mux(1) when 1,
			Mux(2) when 2,
			Mux(3) when 3;
	--Decodificador 7 segmentos
	Process(C1,C2)
	Begin
		If 		C2=0 and C1=0 then	--Tecla 4
			Disp<="0001000";
		Elsif	C2=0 and C1=1 then	--Tecla 8
			Disp<="1100000";
		Elsif	C2=0 and C1=2 then	--Tecla 12
			Disp<="0110001";
		Elsif	C2=0 and C1=3 then	--Tecla 16
			Disp<="1000010";
		Elsif 	C2=1 and C1=0 then	--Tecla 3
			Disp<="0000110";
		Elsif	C2=1 and C1=1 then	--Tecla 7
			Disp<="0100000";
		Elsif	C2=1 and C1=2 then	--Tecla 11
			Disp<="0001100";
		Elsif	C2=1 and C1=3 then	--Tecla 15
			Disp<="0111000";
		Elsif	C2=2 and C1=0 then	--Tecla 2
			Disp<="0010010";
		Elsif	C2=2 and C1=1 then	--Tecla 6
			Disp<="0100100";
		Elsif	C2=2 and C1=2 then	--Tecla 10
			Disp<="0000000";
		Elsif	C2=2 and C1=3 then	--Tecla	14
			Disp<="0000001";
		Elsif	C2=3 and C1=0 then	--Tecla 1
			Disp<="1001111";
		Elsif	C2=3 and C1=1 then	--Tecla 5
			Disp<="1001100";
		Elsif	C2=3 and C1=2 then	--Tecla 9
			Disp<="0001110";
		Elsif	C2=3 and C1=3 then	--Tecla 13
			Disp<="0010000";
		End if;
	End Process;

	--Antibote
	Process(RELOJ)
	Begin
		If falling_edge(RELOJ) then
			RST<=BS;
			Q2<=RST;
		End If;
	End Process;
		
	Process(RELOJ,RST)
	Begin
		If RST='0' then
			C3<=0;
			MAX<='0';
		Elsif Falling_Edge(RELOJ) then
			If 	C3=200 then
				MAX<='1';
			Else
				C3<=C3+1;
				MAX<='0';
			End If;
		End If;
	End Process;

	SINC<=Q2 and MAX;

	--Enable del Display
	ENA<=SINC;
	BSINC<=SINC;

	--Divisor de frecuencia		
	Process(CLK)
	Begin
		If falling_edge (CLK) Then
			If CUENTA = 9999 Then
				CUENTA <= 0;
				RELOJ <= NOT reloj;
			Else 
				CUENTA <= CUENTA +1;
			End if;
		End if;
	End process;

End looksito;