library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ContaPapu is
Port(	CLK: in std_logic;
		ENA: out std_logic;
		Disp: out std_logic_vector(0 to 6));
end ContaPapu;

architecture Holi of ContaPapu is
Signal Cuenta:integer range 0 to 3999999;
Signal C:integer range 0 to 15;
Signal y:std_logic;
begin
ENA<='1';
--Divisor de frecuencia
	Process(CLK)
	Begin
		if falling_edge(CLK) then
			if cuenta=0 then
				cuenta<=3999999;
				y<=not y;
			else
				cuenta<=cuenta-1;
			end if;
		end if;
	end process;
--Contador 4 bits
Process(y)
Begin
	If Falling_Edge(y) then
		If C=15 then
			C<=0;
		Else
			C<=C+1;
		End If;
	End If;
End Process;

--Decodificador
with C select
Disp<=	"0000001"	when 0,
		"1001111"	when 1,
		"0010010"	when 2,
		"0000110"	when 3,
		"1001100"	when 4,
		"0100100"	when 5,
		"0100000"	when 6,
		"0001111"	when 7,
		"0000000"	when 8,
		"0001100"	when 9,
		"0001000"	when 10,
		"1100000"	when 11,
		"0110001"	when 12,
		"1000010"	when 13,
		"0110000"	when 14,
		"0111000"	when 15;

end Holi;
