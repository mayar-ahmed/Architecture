
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY rom;

ARCHITECTURE rom OF rom IS

	TYPE rom_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL instruction : rom_type ;
	
BEGIN
		dataout <= instruction(to_integer(unsigned(address(9 downto 0))));
END rom;

