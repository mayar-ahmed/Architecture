LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stage1 IS  
	PORT (
		INT,Rst,Clk,JUMP,CALL,RET,RTI,stall: IN std_logic;
		PCJ,PC3: IN std_logic_vector(15 DOWNTO 0);
		IF_ID_ins_in,PC,PC1: OUT std_logic_vector(15 DOWNTO 0));
END ENTITY stage1;

ARCHITECTURE st1 of stage1 IS

COMPONENT mux4 IS 
	 GENERIC (n : integer := 16);
	PORT ( a,b,c,d: IN  std_logic_vector (n-1 DOWNTO 0);
		   s : IN std_logic_vector (1 downto 0);
		   y : OUT std_logic_vector (n-1 DOWNTO 0));
END COMPONENT;

COMPONENT Reg IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(15 DOWNTO 0);
        q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT rom IS
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


COMPONENT Buff IS
GENERIC (n : integer := 16);
PORT   (
	Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(n-1 DOWNTO 0);
        q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT incrementer IS 
PORT (A: IN  std_logic_vector(15 DOWNTO 0);
		enable: in std_logic;
		S     : OUT std_logic_vector(15 DOWNTO 0));    
END COMPONENT;

signal INS_ADD: std_logic_vector(15 DOWNTO 0);
signal INS_DATA: std_logic_vector(15 DOWNTO 0);
signal PC_IN: std_logic_vector(15 DOWNTO 0);
signal PC_OUT: std_logic_vector(15 DOWNTO 0);
signal PC_MUX_S: std_logic_vector(1 DOWNTO 0);
signal PC_1: std_logic_vector(15 DOWNTO 0);
signal INS_ADD_MUX_S: std_logic_vector(1 DOWNTO 0);
signal INT_INS: std_logic_vector(15 DOWNTO 0);
signal INT_INS_MUX_S: std_logic_vector(1 DOWNTO 0);
--signal inc_en: std_logic; --incrementer enable
signal pc_en: std_logic;
begin

INS_MEM: rom PORT MAP (Clk,INS_ADD,INS_DATA);
pc_en<=not stall;
PC_Reg:  Reg PORT MAP (Rst,Clk,pc_en,PC_IN,PC_OUT);
PC_INC:  incrementer PORT MAP (PC_OUT,'1',PC_1); --PC_1 = pc+1
PC_MUX_S(0)<=RET or RTI or INT or Rst;--INVERTED FROM THE DRAWING DONT CHANGE IT
PC_MUX_S(1)<=((CALL or JUMP)AND NOT(INT or Rst) AND NOT(RET or RTI))or INT or Rst;
m1: mux4 GENERIC MAP (16) PORT MAP (PC_1,PCJ,PC3,INS_DATA,PC_MUX_S,PC_IN); --pc input
PC<=PC_OUT;
PC1<=PC_1;
INS_ADD_MUX_S(1)<=INT;--INVERTED FROM THE DRAWING DONT CHANGE IT
INS_ADD_MUX_S(0)<=Rst;
m2: mux4 GENERIC MAP (16) PORT MAP (PC_OUT,"0000000000000001","0000000000000000","0000000000000000",INS_ADD_MUX_S,INS_ADD); --pc out to ins memory address
INT_INS<="0000000000000000"; --interrupt instruction opcode
INT_INS_MUX_S(1)<=INT;--INVERTED FROM THE DRAWING DONT CHANGE IT
INT_INS_MUX_S(0)<=CALL or JUMP or RET or RTI;
m3: mux4 GENERIC MAP (16) PORT MAP (INS_DATA,INT_INS,"0000000000000000",INT_INS,INT_INS_MUX_S,IF_ID_ins_in); --ins data to buffer


END st1;