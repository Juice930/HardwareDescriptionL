library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Decod7 is
Port(	A: in std_logic_vector(0 to 3);
	B: out std_logic_vector(0 to 6));
end;

architecture Deco of Decod7 is
begin
when A select
B<=	"0110011" when "0000",
	"0110000" when "0001",
	"0110011" when "0010",
	"0000001" when "0011",
	"1111110" when "0100",
	"1011011" when "0101",
	"1111001" when "0110",
	"1111110" when "0111",
	"1111111" when "1000",
	"1111001" when "1001",
	"0000000" when others;
end Deco;

