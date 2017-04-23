
library ieee;
USE IEEE.std_logic_1164.all;

ENTITY TriSt ISPORT   (En: IN std_logic;
	D : IN std_logic_vector(15 DOWNTO 0);
	Q :OUT std_logic_vector(15 DOWNTO 0));END TriSt;
ARCHITECTURE  Tri  OF TriSt IS
BEGIN
	PROCESS(En,D)
	BEGIN
		IF(En = '0') THEN
    		    Q <= "ZZZZZZZZZZZZZZZZ";
		ELSIF (En='1') THEN
		    Q<=D; 	 	  
		END IF;
	END PROCESS;
END Tri;