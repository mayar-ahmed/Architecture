
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY SH_ROT is
PORT (
a,b : IN std_logic_vector (15 DOWNTO 0);
s0,s1 : IN std_logic;
flagin : IN std_logic_vector (3 DOWNTO 0); 
flagout :OUT std_logic_vector (3 DOWNTO 0); 
f : OUT std_logic_vector (15 DOWNTO 0) 
);
END SH_ROT;

ARCHITECTURE SH_Rot OF SH_ROT IS
  signal y: std_logic_vector (15 DOWNTO 0);  
  signal temp: std_logic_vector (15 DOWNTO 0);  
  signal fout: std_logic_vector (3 DOWNTO 0);
BEGIN

--Logic shift Right A  
------------------y <= std_logic_vector(shift_right(unsigned(a),b)) WHEN s1='0' and s0 = '0'
y <= std_logic_vector(shift_right(unsigned(a),  to_integer(unsigned(b)))) WHEN s1='0' and s0 = '0'
------------------temp(15-to_integer(unsigned(b)) DOWNTO 0) <= a(15 DOWNTO to_integer(unsigned(b)) );
------------------temp(15 DOWNTO 15-to_integer(unsigned(b))-1 ) <= (OTHERS =>'0');
------------------y <= temp WHEN s1='0' and s0 = '0' 
------------------y <= '0'  & a(15 DOWNTO 1)  WHEN s1='0' and s0 = '0'
--Logic shift Left A 
------------------ELSE std_logic_vector(shift_left(unsigned(a), b)) WHEN s1 = '0' and s0 = '1'
ELSE std_logic_vector(shift_left(unsigned(a),  to_integer(unsigned(b)))) WHEN s1 = '0' and s0 = '1'
------------------ELSE (15 DOWNTO to_integer(unsigned(b)) => a(15 - to_integer(unsigned(b)) DOWNTO 0) , OTHERS =>'0') WHEN s1 = '0' and s0 = '1'
------------------ELSE a(14 DOWNTO 0) & '0' WHEN s1 = '0' and s0 = '1'
--Rotate Right with carry A
ELSE flagin(2) & a(15 DOWNTO 1) WHEN s1 = '1' and s0 = '0'        --2 Carry
--Rotate Left with carry A
ELSE a(14 DOWNTO 0) & flagin(2);                                   --2 Carry
  
--Z flag
fout(0) <= '1' when y = "0000000000000000"
else '0';

-- N flag
fout(1) <= '1' when y(15) = '1'
else '0';
  
-- C flag
fout(2) <= a(0) when s1 = '1' and s0 = '0'
ELSE a(15) WHEN s1='1' and s0 ='1'
else '0';
  
-- V flag
fout(3) <= a(15) XOR y(15);
f <= y;

flagout <= fout;
END SH_Rot;		
