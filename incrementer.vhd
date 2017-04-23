LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY incrementer IS  
	PORT (A: IN  std_logic_vector(15 DOWNTO 0);
		enable: in std_logic;
		S     : OUT std_logic_vector(15 DOWNTO 0));    
END ENTITY incrementer;

ARCHITECTURE incr of incrementer is
COMPONENT my_nadder IS
 GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;  
            s : OUT std_logic_vector(n-1 DOWNTO 0);  
           cout : OUT std_logic);
END COMPONENT;



signal addr: std_logic_vector(15 downto 0);
signal COUT : std_logic;
begin 

adder: my_nadder GENERIC MAP (16) PORT MAP (A,"0000000000000000",'1',addr,COUT);
process(enable,addr)
begin
if(enable='0') then
	S <= A;
else S <= addr;
end if;
end process;
end incr;