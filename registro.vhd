library ieee;
use ieee.std_logic_1164.all;

entity registro is
port (cdat,dezp,boud:in std_logic;
	  datos_tx:in std_logic_vector(7 downto 0);
	  sal:out std_logic);
end entity;

architecture reg of registro is
signal dato:std_logic_vector(7 downto 0);
begin 
--sal <= dato(0);
process(cdat,dezp)
begin
		if rising_edge(boud) then
			if cdat='1' then
				dato <= datos_tx;
			elsif dezp='1' then
			    sal <= dato(0);
				dato(0) <= dato(1);
				dato(1) <= dato(2);
				dato(2) <= dato(3);
				dato(3) <= dato(4);
				dato(4) <= dato(5);
				dato(5) <= dato(6);
				dato(6) <= dato(7);
			end if;
		end if;
end process;
end reg;