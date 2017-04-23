library ieee;
USE IEEE.std_logic_1164.all;


ENTITY ALU IS
PORT   (a,b: IN std_logic_vector(15 DOWNTO 0); 
        s,Flag: IN std_logic_vector(3 DOWNTO 0);
        NewFlag: OUT std_logic_vector(3 DOWNTO 0);
        Res : OUT std_logic_vector(15 DOWNTO 0);
        FlagEn: OUT std_logic);
END ALU;

ARCHITECTURE  ALU  OF ALU IS
	SIGNAL ALUOUT1,ALUOUT2,ALUOUT3:std_logic_vector(15 DOWNTO 0);
	SIGNAL NewFlag1,NewFlag2,NewFlag3:std_logic_vector(3 DOWNTO 0);
COMPONENT SH_ROT IS
   PORT (
a,b : IN std_logic_vector (15 DOWNTO 0);
s0,s1 : IN std_logic;
flagin : IN std_logic_vector (3 DOWNTO 0); 
flagout :OUT std_logic_vector (3 DOWNTO 0); 
f : OUT std_logic_vector (15 DOWNTO 0) 
);

END COMPONENT;
COMPONENT logic IS
PORT (
a : IN std_logic_vector (15 DOWNTO 0);
b : IN std_logic_vector (15 DOWNTO 0);
s0,s1 : IN std_logic;
flagin : IN std_logic_vector (3 DOWNTO 0); 
flagout :OUT std_logic_vector (3 DOWNTO 0); 
f : OUT std_logic_vector (15 DOWNTO 0)
);
END COMPONENT;

COMPONENT arithmetic IS
   PORT( 
    a,b : IN std_logic_vector (15 DOWNTO 0);
		s0, s1,s2: IN std_logic;
		stat_in: IN std_logic_vector(3 DOWNTO 0);
		stat_out: OUT std_logic_vector(3 DOWNTO 0);
		f : OUT std_logic_vector (15 DOWNTO 0));
	
END COMPONENT;

BEGIN
  
	ALU1: SH_ROT PORT MAP (a,b,s(0),s(1),Flag,NewFlag1,ALUOUT1);
  ALU2: logic PORT MAP (a,b,s(0),s(1),Flag,NewFlag2,ALUOUT2);
  ALU3: arithmetic PORT MAP (a,b,s(0),s(1),s(2),Flag,NewFlag3,ALUOUT3);
    
  Res <= ALUOUT1 WHEN s(3)='1' and s(2)='1'
  ELSE ALUOUT2 WHEN s(3)='1' and s(2)='0'
  ELSE ALUOUT3 WHEN (s(3)='0' and s(2)='1') or (s(3)='0' and s(2)='0' and s(1)='0' and s(0)='1')
  ELSE "0000000000000000";
    
  NewFlag <= NewFlag1 WHEN s(3)='1' and s(2)='1'
  ELSE NewFlag2 WHEN s(3)='1' and s(2)='0'
  ELSE NewFlag3 WHEN (s(3)='0' and s(2)='1') or (s(3)='0' and s(2)='0' and s(1)='0' and s(0)='1')
  ELSE Flag WHEN (s(3)='0' and s(2)='0' and s(1)='0' and s(0)='0')
  Else Flag(3) & '0' & Flag(1 DOWNTO 0) WHEN (s(3)='0' and s(2)='0' and s(1)='1' and s(0)='0')
  Else Flag(3) & '1' & Flag(1 DOWNTO 0);
    
END ALU;


