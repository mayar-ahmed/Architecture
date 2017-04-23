
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2_4bit IS  
		PORT (a, b: IN  std_logic_vector(3 DOWNTO 0);
			s0: in std_logic;
		      x: OUT std_logic_vector(3 DOWNTO 0));    
END ENTITY mux2_4bit;


ARCHITECTURE Data_flow OF mux2_4bit IS
BEGIN
     -- TODO : write the architecture of mux2
     x <= a WHEN s0= '0'
		  	ELSE b;
END Data_flow;

