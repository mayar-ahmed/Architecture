
library ieee;
USE IEEE.std_logic_1164.all;

ENTITY RdDec IS
PORT   (en:in std_logic;
	S: IN std_logic_vector(2 DOWNTO 0);
	D :OUT std_logic_vector(7 DOWNTO 0));
END RdDec;
ARCHITECTURE  RDec  OF RdDec IS
BEGIN
	PROCESS(en,S)
	BEGIN
		IF(en = '0') THEN
    		    D <= "00000000";
		ELSIF (S="000") THEN
 	 	   D <= "00000001";
		ELSIF (S="001") THEN
 	 	   D <= "00000010";
		ELSIF (S="010") THEN
 	 	   D <= "00000100";
		ELSIF (S="011") THEN
 	 	   D <= "00001000";
 	 	ELSIF (S="100") THEN
 	 	   D <= "00010000";
 	 	ELSIF (S="101") THEN
 	 	   D <= "00100000";
		ELSIF (S="110") THEN
 	 	   D <= "01000000";
		ELSIF (S="111") THEN
 	 	   D <= "10000000";
		END IF;
	END PROCESS;
END RDec;
