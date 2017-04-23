LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_nDFF IS
	GENERIC ( n : integer := 16);
	PORT( Clk,Rst : IN std_logic;
	       En : IN std_logic;
		  d : IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
END my_nDFF;

ARCHITECTURE a_my_nDFF OF my_nDFF IS
	BEGIN
		PROCESS (Clk,Rst)
			BEGIN
				IF Rst = '1' THEN
					q <= (OTHERS=>'0');
				ELSIF falling_edge(Clk) and En='1' THEN
					q <= d;
				END IF;
		END PROCESS;
END a_my_nDFF;
