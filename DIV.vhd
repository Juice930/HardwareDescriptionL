LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY DIV IS
PORT(CLK:IN STD_LOGIC;
     BAUD:BUFFER STD_LOGIC);
END ENTITY;

ARCHITECTURE DIV OF DIV IS
SIGNAL CUENTA:INTEGER RANGE 0 TO 2499999;
BEGIN

  PROCESS(CLK)
  BEGIN
   IF RISING_EDGE(CLK) THEN
    IF CUENTA=0 THEN
    CUENTA<=2499999;
    BAUD<=NOT BAUD;
    ELSE
    CUENTA<=CUENTA-1;
    END IF;
   END IF;
  END PROCESS;
END DIV;