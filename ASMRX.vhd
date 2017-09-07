Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity ASMRX is
Port(	BAUD,RG,FCont:in std_logic;
		RX,DESP,ARX:out std_logic);
End Entity;

Architecture ASMRX of ASMRX is
Type Estados is (Inicio,E1);
Signal Ahora:Estados;
Begin
	Process(BAUD)
	Begin
		If Rising_Edge(BAUD) Then
			Case Ahora is
				When Inicio=>
					RX<='0';
					ARX<='0';
					DESP<='0';
					If RG='0' Then
						RX<='1';
						DESP<='1';
						ARX<='1';
						Ahora<=E1;
					End If;
				When E1=>
					If FCont='1' Then
						DESP<='0';
						RX<='0';
						ARX<='0';
						Ahora<=Inicio;
					End If;
			END CASE;
		END IF;
	END PROCESS;
END ASMRX;