LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stage2 IS  
	PORT (
		INT,Clk,PUSH,POP,CALL,RET,RTI,RegW,Rst: IN std_logic;
		Write_Data,PC: IN std_logic_vector(15 DOWNTO 0);
		Write_Address: IN std_logic_vector(2 DOWNTO 0);
		Rs1A,Rs2A: IN std_logic_vector(2 DOWNTO 0);
		Rs1D,Rs2D,Reg6: OUT std_logic_vector(15 DOWNTO 0));
END ENTITY stage2;
ARCHITECTURE  st2  OF stage2 IS

COMPONENT mux2 IS  
 GENERIC (n : integer := 16);
		PORT (a, b: IN  std_logic_vector(n-1 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(n-1 DOWNTO 0));    
END COMPONENT;

COMPONENT Reg IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(15 DOWNTO 0);
        q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT Reg_R6 IS
PORT   (Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(15 DOWNTO 0);
        q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


COMPONENT R6Alu IS  
	PORT (A: IN  std_logic_vector(15 DOWNTO 0);
		enable,inc_dec,none: in std_logic;
		S     : OUT std_logic_vector(15 DOWNTO 0));    
END COMPONENT;

COMPONENT Dec IS
PORT   (en:in std_logic;
	S: IN std_logic_vector(2 DOWNTO 0);
	D :OUT std_logic_vector(5 DOWNTO 0));
END COMPONENT;

COMPONENT RdDec IS
PORT   (en:in std_logic;
	S: IN std_logic_vector(2 DOWNTO 0);
	D :OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

COMPONENT TriSt IS
        PORT   (En: IN std_logic;
	D : IN std_logic_vector(15 DOWNTO 0);
	Q :OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


signal Src1_Dec: std_logic_vector(7 DOWNTO 0);
signal Src2_Dec: std_logic_vector(7 DOWNTO 0);

signal WB_Dec: std_logic_vector(5 DOWNTO 0);

signal R0: std_logic_vector(15 DOWNTO 0);
signal R1: std_logic_vector(15 DOWNTO 0);
signal R2: std_logic_vector(15 DOWNTO 0);
signal R3: std_logic_vector(15 DOWNTO 0);
signal R4: std_logic_vector(15 DOWNTO 0);
signal R5: std_logic_vector(15 DOWNTO 0);
signal R6: std_logic_vector(15 DOWNTO 0);
signal R6_mux_select : std_logic;



--R6 signals
signal inc,none: std_logic;
signal R6_OUT: std_logic_vector(15 DOWNTO 0);
signal R6Alu_OUT: std_logic_vector(15 DOWNTO 0);
signal R6_en: std_logic;

begin


-------------------------------Registers-----------------------------------
reg0: Reg PORT MAP (Rst,Clk,WB_Dec(0),Write_Data,R0);
reg1: Reg PORT MAP (Rst,Clk,WB_Dec(1),Write_Data,R1);
reg2: Reg PORT MAP (Rst,Clk,WB_Dec(2),Write_Data,R2);
reg3: Reg PORT MAP (Rst,Clk,WB_Dec(3),Write_Data,R3);
reg4: Reg PORT MAP (Rst,Clk,WB_Dec(4),Write_Data,R4);
reg5: Reg PORT MAP (Rst,Clk,WB_Dec(5),Write_Data,R5);

--------R6------

inc<=POP or RET or RTI;
none<=inc xnor (PUSH or CALL or INT);
R6_en<=POP or PUSH or RET OR RTI OR CALL OR INT;
r6A: R6Alu PORT MAP (R6_OUT,'1',inc,none,R6Alu_OUT);
r6reg: Reg_R6 PORT MAP (Rst,Clk,R6_en,R6Alu_OUT,R6_OUT);

mR6: mux2 GENERIC MAP (16) PORT MAP (R6_OUT,R6Alu_OUT,inc,R6); 

------------------------------------Decoders------------------------------
Ds1: RdDec PORT MAP ('1',Rs1A,Src1_Dec); --source 1 decoder
Ds2: RdDec PORT MAP ('1',Rs2A,Src2_Dec); --source 2 decoder
WB:  Dec PORT MAP (RegW,Write_Address,WB_Dec); --Write back decoder
-------------------------------buffers----------------------------------
----source 1 tristates----
TS1s0: TriSt PORT MAP (Src1_Dec(0),R0,Rs1D);
TS1s1: TriSt PORT MAP (Src1_Dec(1),R1,Rs1D);
TS1s2: TriSt PORT MAP (Src1_Dec(2),R2,Rs1D);
TS1s3: TriSt PORT MAP (Src1_Dec(3),R3,Rs1D);
TS1s4: TriSt PORT MAP (Src1_Dec(4),R4,Rs1D);
TS1s5: TriSt PORT MAP (Src1_Dec(5),R5,Rs1D);
TS1s6: TriSt PORT MAP (Src1_Dec(6),R6,Rs1D);
TS1s7: TriSt PORT MAP (Src1_Dec(7),PC,Rs1D);
----source 2 tristates-----

TS2s0: TriSt PORT MAP (Src2_Dec(0),R0,Rs2D);
TS2s1: TriSt PORT MAP (Src2_Dec(1),R1,Rs2D);
TS2s2: TriSt PORT MAP (Src2_Dec(2),R2,Rs2D);
TS2s3: TriSt PORT MAP (Src2_Dec(3),R3,Rs2D);
TS2s4: TriSt PORT MAP (Src2_Dec(4),R4,Rs2D);
TS2s5: TriSt PORT MAP (Src2_Dec(5),R5,Rs2D);
TS2s6: TriSt PORT MAP (Src2_Dec(6),R6,Rs2D);
TS2s7: TriSt PORT MAP (Src2_Dec(7),PC,Rs2D);


Reg6<=R6;



END st2;