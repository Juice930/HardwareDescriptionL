Library IEEE;
Use IEEE.std_logic_1164.all;
Entity Rammy is
Generic(Word:Integer:=16;
		Bits:Integer:=8);
Port(	CLK,RW:In std_logic;
		ENT:In Std_logic_vector(0 to Bits-1);
		SAL:Out std_logic_vector(0 to Bits-1);
		ADDR: In integer range 0 to Word-1);
End Rammy;

Architecture XXX of Rammy is
Type Datos is array (0 to Word-1) of std_logic_vector(0 to Bits-1);
Signal Memory:Datos;
Begin
	Process(CLK)
	Begin
		If Rising_Edge(CLK) then
			If RW='1' then	--RW=1 escribe, RW=0 lee.
				Memory(ADDR)<=ENT;
			End If;
		End If;
	End Process;
	Sal<=Memory(ADDR);
End XXX;
