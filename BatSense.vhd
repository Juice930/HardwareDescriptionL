Library IEEE;
Use IEEE.Std_Logic_1164.all;

Entity BatSense Is
Port(	INIT,CLK50,ECHO:in std_logic;
		TRIG:out std_logic;
		Seg1:out std_logic_vector(0 to 6);
		Seg2:out std_logic_vector(0 to 6);
		Seg3:out std_logic_vector(0 to 6));
End BatSense;

Architecture BatiSentido of BatSense is
Type Estados is (Inicio,E1,E2,E3,E4,E5,E6);
Signal CLK,RSTWD,WD,ELT:std_logic;
Signal Div:integer range 0 to 1449;
Signal C,Dec,U,N: integer range 0 to 9;
Signal Gerade:Estados;
Signal Dist:integer range 0 to 600;
Signal D:integer range 0 to 625;
Signal CWD:integer range 0 to 1000;
Begin

--Divisor entre 1450
Process(CLK50)
Begin
	If Rising_Edge(CLK50) Then
		If Div=0 Then
			Div<=1449;
			CLK<=not CLK;
		Else
			Div<=Div-1;
		End If;
	End If;
End Process;

--Watchdog
Process(CLK)
Begin
	If Rising_Edge(CLK) Then
		If RSTWD='1' Then
			CWD<=0;
			WD<='0';
		Else
			If CWD=1000 Then
				CWD<=0;
				WD<='1';
			Else
				CWD<=CWD+1;
				WD<='0';
			End If;
		End If;
	End If;
End Process;

--Bat ASM
Process(CLK)
Begin
	If Rising_Edge(CLK)THEN
		If WD='0' Then
			Case Gerade IS
				When Inicio=>
					Trig<='0';
					D<=0;
					RSTWD<='1';
					Dist<=0;
					If INIT='1' THEN
						Gerade<=E1;
					Else
						Gerade<=Inicio;
					END IF;
				When E1=>
					Trig<='1';
					RSTWD<='0';
					Gerade<=E2;
				When E2=>
					Trig<='0';
					If ECHO='1' Then
						Gerade<=E3;
					Else
						Gerade<=E2;
					End If;
				When E3=>
					If D=600 Then
						D<=600;
					Else
						D<=D+1;
					End If;
					If ECHO='0' Then
						Gerade<=E4;
					Else
						Gerade<=E3;
					End If;
				When E4=>
					Dist<=D;
					Gerade<=E5;
				When E5=>
					If D>Dist+25 Then
						Gerade<=E6;
					Else
						D<=D+1;
					End If;
				When E6=>
					D<=0;
					RSTWD<='1';
					TRIG<='0';
					Gerade<=E1;
				When Others=>
					Gerade<=Inicio;
			End Case;
		Else
			Gerade<=E1;
		End If;
	End If;
End Process;

--Convertidor Binario a BCD
Process(CLK)
Begin
	If Rising_Edge(CLK) Then
		C<=Dist/100;
		Dec<=Dist/10 mod 10;
		U<=Dist mod 10;
	End If;
End Process;

--Convertidor BCD a 7 segmentos
Process(CLK)
	Begin
		Case U is
								 --"ABCDEFG";
			When 0 =>		Seg1 <= "0000001";
			When 1 =>		Seg1 <= "1001111";
			When 2 =>		Seg1 <= "0010010";
			When 3 =>		Seg1 <= "0000110";
			When 4 =>		Seg1 <= "1001100";
			When 5 =>		Seg1 <= "0100100";
			When 6 =>		Seg1 <= "0100000";
			When 7 =>		Seg1 <= "0001111";
			When 8 =>		Seg1 <= "0000000";
			When 9 =>		Seg1 <= "0001100";
			When Others=> 	Seg1 <= "1111111";
	End Case;
End Process;

--Convertidor BCD a 7 segmentos
Process(CLK)
	Begin
		Case Dec is
								 --"ABCDEFG";
			When 0 =>		Seg2 <= "0000001";
			When 1 =>		Seg2 <= "1001111";
			When 2 =>		Seg2 <= "0010010";
			When 3 =>		Seg2 <= "0000110";
			When 4 =>		Seg2 <= "1001100";
			When 5 =>		Seg2 <= "0100100";
			When 6 =>		Seg2 <= "0100000";
			When 7 =>		Seg2 <= "0001111";
			When 8 =>		Seg2 <= "0000000";
			When 9 =>		Seg2 <= "0001100";
			When Others=> 	Seg2 <= "1111111";
	End Case;
End Process;

--Convertidor BCD a 7 segmentos
Process(CLK)
	Begin
		Case C is
								 --"ABCDEFG";
			When 0 =>		Seg3 <= "0000001";
			When 1 =>		Seg3 <= "1001111";
			When 2 =>		Seg3 <= "0010010";
			When 3 =>		Seg3 <= "0000110";
			When 4 =>		Seg3 <= "1001100";
			When 5 =>		Seg3 <= "0100100";
			When 6 =>		Seg3 <= "0100000";
			When 7 =>		Seg3 <= "0001111";
			When 8 =>		Seg3 <= "0000000";
			When 9 =>		Seg3 <= "0001100";
			When Others=> 	Seg3 <= "1111111";
	End Case;
End Process;

End BatiSentido;