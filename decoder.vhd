
library ieee;
USE IEEE.std_logic_1164.all;

ENTITY Dec IS
PORT   (en:in std_logic;
	S: IN std_logic_vector(2 DOWNTO 0);
	D :OUT std_logic_vector(5 DOWNTO 0));
END Dec;
ARCHITECTURE  Dec  OF Dec IS
BEGIN
	PROCESS(en,S)
	BEGIN
		IF(en = '0') THEN
    		    D <= "000000";
		ELSIF (S="000") THEN
 	 	   D <= "000001";
		ELSIF (S="001") THEN
 	 	   D <= "000010";
		ELSIF (S="010") THEN
 	 	   D <= "000100";
		ELSIF (S="011") THEN
 	 	   D <= "001000";
 	 	ELSIF (S="100") THEN
 	 	   D <= "010000";
 	 	ELSIF (S="101") THEN
 	 	   D <= "100000";
 	 	else D<= "000000";
		END IF;
	END PROCESS;
END Dec;
