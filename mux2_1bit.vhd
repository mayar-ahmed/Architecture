LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2_bit IS  
		PORT (a, b: IN  std_logic;
			s0: in std_logic;
		      x: OUT std_logic);    
END ENTITY mux2_bit;


ARCHITECTURE Data_flow OF mux2_bit IS
BEGIN
     -- TODO : write the architecture of mux2
     x <= a WHEN s0= '0'
		  	ELSE b;
END Data_flow;
