library ieee;
USE IEEE.std_logic_1164.all;

ENTITY Buff IS
GENERIC (n : integer := 16);
PORT   (
	Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(n-1 DOWNTO 0);
        q : OUT std_logic_vector(n-1 DOWNTO 0));
END Buff;
ARCHITECTURE  Buff  OF Buff IS
BEGIN
	PROCESS(clk,Rst)
	BEGIN
		IF(Rst = '1') THEN
    		    q <= (OTHERS=>'0');
		ELSIF (rising_edge(clk)and En='1') THEN
 	 	   q <= d;
		END IF;
	END PROCESS;
END Buff ;
