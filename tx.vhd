-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Web Edition"
-- CREATED		"Fri Mar 31 14:01:00 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY tx IS 
	PORT
	(
		Boton :  IN  STD_LOGIC;
		REL :  IN  STD_LOGIC;
		DATOSIN :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		TX :  OUT  STD_LOGIC;
		LED :  OUT  STD_LOGIC
	);
END tx;

ARCHITECTURE bdf_type OF tx IS 

COMPONENT asmtx
	PORT(BAUD : IN STD_LOGIC;
		 T : IN STD_LOGIC;
		 FCont : IN STD_LOGIC;
		 TX : OUT STD_LOGIC;
		 DESP : OUT STD_LOGIC;
		 LOAD : OUT STD_LOGIC;
		 ENA : OUT STD_LOGIC;
		 ETX : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT cont
	PORT(BAUD : IN STD_LOGIC;
		 ESTADO_TX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 FIN_CONT8BITS : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT div
	PORT(CLK : IN STD_LOGIC;
		 BAUD : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT muxsel
	PORT(BAUD : IN STD_LOGIC;
		 Dato : IN STD_LOGIC;
		 ETX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 TX : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT registro
	PORT(cdat : IN STD_LOGIC;
		 dezp : IN STD_LOGIC;
		 boud : IN STD_LOGIC;
		 datos_tx : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sal : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;


BEGIN 



b2v_inst : asmtx
PORT MAP(BAUD => SYNTHESIZED_WIRE_10,
		 T => Boton,
		 FCont => SYNTHESIZED_WIRE_1,
		 TX => LED,
		 DESP => SYNTHESIZED_WIRE_8,
		 LOAD => SYNTHESIZED_WIRE_7,
		 ETX => SYNTHESIZED_WIRE_11);


b2v_inst1 : cont
PORT MAP(BAUD => SYNTHESIZED_WIRE_10,
		 ESTADO_TX => SYNTHESIZED_WIRE_11,
		 FIN_CONT8BITS => SYNTHESIZED_WIRE_1);


b2v_inst2 : div
PORT MAP(CLK => REL,
		 BAUD => SYNTHESIZED_WIRE_10);


b2v_inst3 : muxsel
PORT MAP(BAUD => SYNTHESIZED_WIRE_10,
		 Dato => SYNTHESIZED_WIRE_5,
		 ETX => SYNTHESIZED_WIRE_11,
		 TX => TX);


b2v_inst4 : registro
PORT MAP(cdat => SYNTHESIZED_WIRE_7,
		 dezp => SYNTHESIZED_WIRE_8,
		 boud => SYNTHESIZED_WIRE_10,
		 datos_tx => DATOSIN,
		 sal => SYNTHESIZED_WIRE_5);


END bdf_type;