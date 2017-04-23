library ieee;
USE IEEE.std_logic_1164.all;

ENTITY Reg IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(15 DOWNTO 0);
        q : OUT std_logic_vector(15 DOWNTO 0));
END Reg;
ARCHITECTURE  Reg  OF Reg IS
BEGIN
	PROCESS(clk,Rst)
	BEGIN
		IF(Rst = '1') THEN
    		    q <= "0000000000000000";
		ELSIF (rising_edge(Clk)and En='1') THEN
 	 	   q <= d;
		END IF;
	END PROCESS;
END Reg ;
