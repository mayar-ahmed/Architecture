LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
		clk : IN std_logic;
		re  : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout, m0, m1: OUT std_logic_vector(15 DOWNTO 0));
		
END ENTITY Memory;

ARCHITECTURE mem_a OF Memory IS

	TYPE mem_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL mem : mem_type ;
	signal dummy,zero,one : std_logic_vector (15 downto 0);
	
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						mem(to_integer(unsigned(address))) <= datain;   	  
					END IF;
					 
				END IF;
		END PROCESS;

		dummy(15 downto 10)<= (others =>'0');
		dummy(9 downto 0) <= address(9 downto 0);
		zero<=(others =>'0');
		one <= "0000000000000001";
		dataout <= mem(to_integer(unsigned(dummy))) when re='1' else (others=>'0');
		m0 <= mem(to_integer(unsigned(zero)));
		m1 <= mem(to_integer(unsigned(one)));
END mem_a;



