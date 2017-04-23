
library ieee;
USE IEEE.std_logic_1164.all;

ENTITY Reg4 IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(3 DOWNTO 0);
        q : OUT std_logic_vector(3 DOWNTO 0));
END Reg4;
ARCHITECTURE  Reg  OF Reg4 IS
BEGIN
	PROCESS(clk)
	BEGIN
	  IF(Rst = '1') THEN
    		    q <= "0000";
		ELSIF (rising_edge(clk)and En='1') THEN
 	 	   q <= d;
		END IF;
	END PROCESS;
END Reg ;

