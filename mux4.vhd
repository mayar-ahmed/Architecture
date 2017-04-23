LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux4 IS 
	 GENERIC (n : integer := 16);
	PORT ( a,b,c,d: IN  std_logic_vector (n-1 DOWNTO 0);
		   s : IN std_logic_vector (1 downto 0);
		   y : OUT std_logic_vector (n-1 DOWNTO 0));
END ENTITY mux4;

-- take care of the usage of when else 
ARCHITECTURE  Data_flow OF mux4 IS
BEGIN
     y <=   a WHEN s(0) = '0' AND s(1) ='0'
       ELSE b WHEN s(0) = '0' AND s(1) ='1'
       ELSE c WHEN s(0) = '1' AND s(1) ='0'
	     ELSE d;
END Data_flow;
