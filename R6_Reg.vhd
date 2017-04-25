library ieee;
USE IEEE.std_logic_1164.all;

ENTITY Reg_R6 IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(15 DOWNTO 0);
        q : OUT std_logic_vector(15 DOWNTO 0));
END Reg_R6;
ARCHITECTURE  RegR6  OF Reg_R6 IS
BEGIN
	PROCESS(clk,Rst)
	BEGIN
		IF(Rst = '1') THEN
    		    q <= "0000001111111111";
		ELSIF (falling_edge(clk)and En='1') THEN
 	 	   q <= d;
		END IF;
	END PROCESS;
END RegR6 ;
