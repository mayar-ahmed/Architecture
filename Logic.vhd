LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY logic is
PORT (
a : IN std_logic_vector (15 DOWNTO 0);
b : IN std_logic_vector (15 DOWNTO 0);
s0,s1 : IN std_logic;
flagin : IN std_logic_vector (3 DOWNTO 0); 
flagout :OUT std_logic_vector (3 DOWNTO 0); 
f : OUT std_logic_vector (15 DOWNTO 0)
);
END logic;

ARCHITECTURE logic OF logic IS
  signal y: std_logic_vector (15 DOWNTO 0);
BEGIN
  
y <= a and b WHEN s1='0' and s0 = '0'
ELSE a or b WHEN s1 = '0' and s0 = '1'
ELSE a WHEN s1 = '1' and s0 = '0'
ELSE not a;

--Z flag
flagout(0) <= '1' when y = "0000000000000000"
else '0';

-- N flag
flagout(1) <= '1' when y(15) = '1'
else '0';
  
-- C flag
flagout(2) <= '0';

-- V flag
flagout(3) <= '0';
f <= y;
END logic;		
