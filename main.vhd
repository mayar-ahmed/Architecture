library ieee;
USE IEEE.std_logic_1164.all;


ENTITY Sys IS
PORT (Rst,INT,Clk: IN std_logic);
END Sys;


ARCHITECTURE  System  OF Sys IS


COMPONENT stage1 IS  
	PORT (
		INT,Rst,Clk,JUMP,CALL,RET,RTI,stall: IN std_logic;
		PCJ,PC3: IN std_logic_vector(15 DOWNTO 0);
		IF_ID_ins_in,PC,PC1: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT Buff IS
GENERIC (n : integer := 16);
PORT   (
	Rst,Clk,En: IN std_logic;
	d :IN std_logic_vector(n-1 DOWNTO 0);
        q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT stage2 IS  
	PORT (
		INT,Clk,PUSH,POP,CALL,RET,RTI,RegW,Rst: IN std_logic;
		Write_Data,PC: IN std_logic_vector(15 DOWNTO 0);
		Write_Address: IN std_logic_vector(2 DOWNTO 0);
		Rs1A,Rs2A: IN std_logic_vector(2 DOWNTO 0);
		Rs1D,Rs2D,Reg6: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


signal stall : std_logic;
signal IF_ID_IN: std_logic_vector(45 DOWNTO 0);
signal IF_ID_OUT: std_logic_vector(45 DOWNTO 0);
signal immediate: std_logic_vector(15 DOWNTO 0);
signal PCJ: std_logic_vector(15 DOWNTO 0);
signal PC3: std_logic_vector(15 DOWNTO 0);
signal CALL_ID_EX,JUMP_ID_EX: std_logic;--id/ex
signal RET_EX_MEM,RTI_EX_MEM : std_logic;--ex/mem
signal PC: std_logic_vector(15 DOWNTO 0);
signal PC1: std_logic_vector(15 DOWNTO 0); --incremented pc
signal IF_ID_ins_in: std_logic_vector(15 DOWNTO 0); --stage one output > instruction
signal RegW: std_logic;
signal CALL_CU,JUMP_CU,RET_CU,RTI_CU,PUSH_CU,POP_CU: std_logic; --CONTROL UNIT 

signal CU_signals: std_logic_vector(25 DOWNTO 0); --control signals

signal WB_data: std_logic_vector(15 DOWNTO 0);
signal WB_add: std_logic_vector(2 DOWNTO 0);
signal ID_EX_IN: std_logic_vector(130 DOWNTO 0);
signal ID_EX_OUT: std_logic_vector(130 DOWNTO 0);
signal if_id_en:std_logic;
BEGIN

stage_1: stage1 PORT MAP (INT,Rst,Clk,JUMP_ID_EX,CALL_ID_EX,RET_EX_MEM,RTI_EX_MEM,stall,PCJ,PC3,IF_ID_ins_in,PC,PC1);
IF_ID_IN(13 DOWNTO 0)<=IF_ID_ins_in(13 DOWNTO 0);
IF_ID_IN(29 DOWNTO 14)<=PC;
IF_ID_IN(45 DOWNTO 30)<=PC1;
if_id_en <= not stall;
IF_ID: Buff GENERIC MAP (46)PORT MAP (Rst,Clk,if_id_en,IF_ID_IN,IF_ID_OUT);

immediate<=IF_ID_ins_in;


ID_EX: Buff GENERIC MAP (130) PORT MAP (Rst,Clk,'1',ID_EX_IN,ID_EX_OUT);

stage_2: stage2 PORT MAP (INT,Clk,PUSH_CU,POP_CU,CALL_CU,RET_CU,RTI_CU,RegW,Rst,WB_data,PC,WB_add,RS1A,RS2A,RS1D,RS2D,R6);



END System;

