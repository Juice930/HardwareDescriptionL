Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity ASM is
Port(	CLK,BSD,COMP:in std_logic;
		VT:in integer range 0 to 11;
		K,CLR1,CLR2,HR1,HR2:out std_logic);
End Entity;

Architecture Holi of ASM is
Type Estados is (Inicio, E1,E2,E3,E4,E5,E6,E7,Cerrada,E9,E10,E11,E12,Abre);
Signal Genau:Estados;
Begin
	Process(CLK)
	Begin
		If Falling_Edge(CLK) Then
			Case Genau is
				When Inicio=>
					K<='0';
					CLR1<='0';
					CLR2<='0';
					HR1<='0';
					HR2<='0';
					If BSD='1' Then
						Genau<=E1;
					End If;
				When E1=>
					If VT>=0 and VT<10 Then
						Genau<=E2;
					Elsif VT=10 Then --CERRAR
						Genau<=E4;
					Else	--ABRIR
						Genau<=Inicio;
					End If;
				When E2=>
					HR1<='1';
					Genau<=E3;
				When E3=>
					HR1<='0';
					If BSD='0' Then
						Genau<=Inicio;
					End If;
				When E4=>
					HR2<='1';
					Genau<=E5;
				When E5=>
					HR2<='0';
					Genau<=E6;
				When E6=>
					CLR1<='1';
					Genau<=E7;
				When E7=>
					CLR1<='0';
					If BSD='0' Then
						Genau<=Cerrada;
					End If;
				When Cerrada=>
					If BSD='1' Then
						Genau<=E9;
					End If;
				When E9=>
					If VT>=0 and VT<10 Then
						Genau<=E11;
					Elsif VT=11 Then--ABRIR
						Genau<=E10;
					Else
						Genau<=Cerrada;
					End If;
				When E10=>
					If Comp='1' Then
						Genau<=Abre;
					Else
						Genau<=E6;
					End If;
				When E11=>
					HR1<='1';
					Genau<=E12;
				When E12=>
					HR1<='0';
					If BSD='0' Then
						Genau<=Cerrada;
					End If;
				When Abre=>
					K<='1';
					CLR1<='1';
					CLR2<='1';
					Genau<=Inicio;
			End Case;
		End If;
	End Process;
End Architecture;