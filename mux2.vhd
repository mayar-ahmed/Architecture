LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2 IS  
 GENERIC (n : integer := 16);
		PORT (a, b: IN  std_logic_vector(n-1 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(n-1 DOWNTO 0));    
END ENTITY mux2;


ARCHITECTURE Data_flow OF mux2 IS
BEGIN
     -- TODO : write the architecture of mux2
     x <= a WHEN s0= '0'
		  	ELSE b;
END Data_flow;
