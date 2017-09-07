Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity ASMTX is
Port(	BAUD,T,FCont:in std_logic;
		ETX:out integer range 0 to 3;
		TX,DESP,LOAD,ENA:out std_logic);
End Entity;

Architecture Control of ASMTX is
Type Estados is (Inicio,E1,E2,E3,E4,E5,E6);
Signal Ahora:Estados;
Begin
	Process(BAUD)
	Begin
		IF Rising_Edge(BAUD) Then
			Case Ahora is
				When Inicio=>
					TX<='0';
					ETX<=0;
					LOAD<='0';
					DESP<='0';
					If T='1' Then
						Ahora<=E1;
					End If;
				When E1=>
					If T='0' Then
						Ahora<=E2;
					End If;
				When E2=>
					LOAD<='1';
					Ahora<=E3;
				When E3=>
					LOAD<='0';
					Ahora<=E4;
				When E4=>
					ETX<=1;
					Ahora<=E5;
				When E5=>
					ETX<=2;
					DESP<='1';
					TX<='1';
					If FCont='1' Then
						Ahora<=E6;
						END IF;
				When E6=>
					ETX<=0;
					DESP<='0';
					TX<='0';
					Ahora<=INICIO;
			End Case;
		End If;
	End Process;
End Architecture;
					