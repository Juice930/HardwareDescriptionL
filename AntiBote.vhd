Library IEEE;
Use IEEE.std_logic_1164.all;
Entity AntiBote is
Port(	BS,CLK:in std_logic;
		SINC:out std_logic);
End Entity;

Architecture Sexy of AntiBote is
Signal Q2,RST,CARRY:std_logic;
Signal C:integer range 0 to 3;
	Begin
		Process(CLK)
		Begin
			If falling_edge(CLK) then
				RST<=BS;
				Q2<=RST;
			End If;
		End Process;
		
		SINC<=Q2 and CARRY;
		
		Process(CLK,RST)
		Begin
			If RST='0' then
				C<=0;
				CARRY<='0';
			Elsif falling_edge(CLK) then
				If C=3 then
					CARRY<='1';
				Else
					C<=C+1;
					CARRY<='0';
				End If;
			End If;
		End Process;
End Sexy;
