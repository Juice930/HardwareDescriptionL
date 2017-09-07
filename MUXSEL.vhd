Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity MUXSEL is
Port(	BAUD,Dato:in std_logic;
		TX:out std_logic;
		ETX:in integer range 0 to 3);
End Entity;

Architecture Seleccion of MUXSEL is
Begin
	Process(BAUD)
	Begin
		If ETX=0 Then
			TX<='1';
		Elsif ETX=1 Then
			TX<='0';
		Elsif ETX=2 Then
			TX<=Dato;
		Else
			Tx<='1';
		End If;
	End Process;
End Architecture;