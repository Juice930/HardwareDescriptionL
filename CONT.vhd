LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY CONT IS 
PORT(BAUD:IN STD_LOGIC;
     ESTADO_TX:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
     FIN_CONT8BITS:OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE CONT OF CONT IS
SIGNAL CONTEO:INTEGER RANGE 0 TO 8;
BEGIN

  PROCESS(BAUD)
  BEGIN
   IF RISING_EDGE(BAUD) THEN
    IF ESTADO_TX="10" THEN
     IF CONTEO=8 THEN
     FIN_CONT8BITS<='1';
     ELSE
     CONTEO<=CONTEO+1;
     FIN_CONT8BITS<='0';
     END IF;
    ELSE
    FIN_CONT8BITS<='0';
    CONTEO<=0;  
    END IF;      
   END IF;
  END PROCESS;
  
END CONT;