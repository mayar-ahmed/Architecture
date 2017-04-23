LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY R6Alu IS  
	PORT (A: IN  std_logic_vector(15 DOWNTO 0);
		enable,inc_dec,none: in std_logic;
		S     : OUT std_logic_vector(15 DOWNTO 0));    
END ENTITY R6Alu;

ARCHITECTURE R6 of R6Alu is

COMPONENT my_nadder IS
 GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            s : OUT std_logic_vector(n-1 DOWNTO 0);  
           cout : OUT std_logic);
END COMPONENT;

COMPONENT mux2 IS  
 GENERIC (n : integer := 16);
		PORT (a, b: IN  std_logic_vector(n-1 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(n-1 DOWNTO 0));    
END COMPONENT;

signal addr: std_logic_vector(15 downto 0);
signal COUT : std_logic;
signal addr_in: std_logic_vector(15 downto 0);
begin
mux: mux2 GENERIC MAP (16) PORT MAP ("1111111111111111","0000000000000001",inc_dec,addr_in); 
-- add 1 incase of increment and add 2's complement of 1 incase of decrement
adder: my_nadder GENERIC MAP (16) PORT MAP (A,addr_in,'0',addr,COUT);

process(enable,none,addr)
begin
if(enable='1') and none='0'
	then S <= addr;
else S <= A;
end if;
end process;
end R6;
