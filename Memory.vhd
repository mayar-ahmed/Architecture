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
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY Memory;

ARCHITECTURE mem_a OF Memory IS

	TYPE mem_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL mem : mem_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						mem(to_integer(unsigned(address))) <= datain;
					ELSIF re = '1' THEN
				    dataout <= mem(to_integer(unsigned(address)));
				  ELSE
				     dataout <= (others=>'0');   	  
					END IF;
					 
				END IF;
		END PROCESS;
		--dataout <= mem(to_integer(unsigned(address)));
END mem_a;



