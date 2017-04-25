LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY System IS
	PORT(
		CLK:      IN std_logic;
		RESET:    IN std_logic;
		INTR:     IN std_logic;
	--	I: out port 
		IN_PORT:  IN std_logic_vector(15 downto 0);
		OUT_PORT: OUT std_logic_vector(15 downto 0));
END ENTITY System;

ARCHITECTURE sys_a OF System IS
  
COMPONENT TriSt IS
  PORT   (En: IN std_logic;
	D : IN std_logic_vector(15 DOWNTO 0);
	Q :OUT std_logic_vector(15 DOWNTO 0));
END   COMPONENT;

  COMPONENT my_nDFF IS
	GENERIC ( n : integer := 16);
	PORT( Clk,Rst : IN std_logic;
	       En : IN std_logic;
		  d : IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
  END COMPONENT;
  COMPONENT WriteBackStage IS
	PORT(
		clk : IN std_logic;
		MemReg: IN std_logic; 
		RegWrite: IN std_logic;
		--Rdc: IN std_logic;
		MemData: IN  std_logic_vector(15 DOWNTO 0); 
		--RdA: IN  std_logic_vector(2 DOWNTO 0);
		ALUResult: IN  std_logic_vector(15 DOWNTO 0);
		INSignal: IN std_logic; 
		INPort: IN  std_logic_vector(15 DOWNTO 0);
		--RdAOut : OUT  std_logic_vector(2 DOWNTO 0);
		DataOut : OUT  std_logic_vector(15 DOWNTO 0));
		--RdcOut : OUT std_logic);
END COMPONENT;
COMPONENT MemoryStage IS
	PORT(
		clk : IN std_logic;
		MemRead : IN std_logic;
		MemWrite : IN std_logic;
		Int: IN std_logic;
		Call: IN std_logic;
		Push: IN std_logic;
		Pop: IN std_logic;
		Ret: IN std_logic;
		Rti: IN std_logic;
		Imm: IN  std_logic_vector(15 DOWNTO 0);
		R6: IN  std_logic_vector(15 DOWNTO 0);
		Rs1D: IN  std_logic_vector(15 DOWNTO 0);
		PC: IN  std_logic_vector(15 DOWNTO 0);
		PC_UP: IN  std_logic_vector(15 DOWNTO 0);
		DataOut : OUT  std_logic_vector(15 DOWNTO 0));
		 
END COMPONENT;

COMPONENT Execute IS
PORT   (Clk,Rst,f11,f12,f21,f22,LDM,Imm_Reg,Jmp,JZ,JN,JC,RTI,Int: IN std_logic;
        EX_MEM_ALURes,D,Imm: IN std_logic_vector(15 DOWNTO 0);
        ALUCode: IN std_logic_vector(3 DOWNTO 0);
        Rs1D,Rs2D: IN std_logic_vector(15 DOWNTO 0);
        FlagEn : IN std_logic;
        JUMP: OUT std_logic;
        OUTPort,PCJ,ALURESOUT: OUT std_logic_vector(15 DOWNTO 0)
        ); 
END COMPONENT;

COMPONENT CU IS
PORT (
op : IN std_logic_vector (4 DOWNTO 0);
cs : OUT std_logic_vector (26 downto 0)
);
END COMPONENT;

COMPONENT stage1 IS  
	PORT (
		INT,Rst,Clk,JUMP,CALL,RET,RTI,stall: IN std_logic;
		PCJ,PC3: IN std_logic_vector(15 DOWNTO 0);
		IF_ID_ins_in,PC,PC1: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT stage2 IS  
	PORT (
		INT,Clk,PUSH,POP,CALL,RET,RTI,RegW,Rst: IN std_logic;
		Write_Data,PC: IN std_logic_vector(15 DOWNTO 0);
		Write_Address: IN std_logic_vector(2 DOWNTO 0);
		Rs1A,Rs2A: IN std_logic_vector(2 DOWNTO 0);
		Rs1D,Rs2D,Reg6: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;


  SIGNAL Stall, IfIdEn: std_logic;
  SIGNAL IfIdIn, IfIdOut : std_logic_vector(45 downto 0);
  SIGNAL IdExIn, IdExOut : std_logic_vector(131 downto 0);
  SIGNAL ExMemIn, ExMemOut : std_logic_vector(110 downto 0);
  SIGNAL MemWbIn, MemWbOut : std_logic_vector(38 downto 0);
  SIGNAL Prt: std_logic_vector(15 downto 0); 
  SIGNAL PCJ: std_logic_vector(15 downto 0); --Execution Component
--  SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL D : STD_LOGIC_VECTOR(15 DOWNTO 0);
 -- SIGNAL C : STD_LOGIC;
  SIGNAL Stage4Out : std_logic_vector(15 downto 0);
  SIGNAL Stage3Out : std_logic_vector(15 downto 0);
  SIGNAL Stage1Out,PC,PC1 : std_logic_vector(15 downto 0);
  Signal RS1D,RS2D,R6 : std_logic_vector(15 downto 0);
  signal CS :std_logic_vector (26 downto 0);
  -- from EX component
  SIGNAL JUMP_ID_EX: Std_logic;
  SIGNAL OutPort : std_logic_vector(15 downto 0);
  
	BEGIN
	  
	  -- INTR -RESET - JMP - Call - Ret - Rti - stall
	  --stage_1: stage1 PORT MAP (INTR,RESET,CLK,JUMP_ID_EX,IdExOut(135),ExMemOut(14),ExMemOut(20),Stall,PCJ,PC3,IF_ID_ins_in,PC,PC1);
	    -- opcode(13-9) - Rs1A(8-6) - Rs2A(5-3) - RdA(2-0) - PC(14-29) - PC_UP(30-45)
	    stage_1: stage1 PORT MAP (INTR,Reset,Clk,JUMP_ID_EX,IdExOut(119),ExMemOut(104),ExMemOut(105),Stall,PCJ,Stage4Out,Stage1Out,PC,PC1);

	  IF_ID: my_nDFF GENERIC MAP (46) PORT MAP (CLK,RESET,IfIdEn,IfIdIn,IfIdOut);
	  IfIdIn(13 DOWNTO 0)<=Stage1Out(15 DOWNTO 2);
    	IfIdIn(29 DOWNTO 14)<=PC;
    	IfIdIn(45 DOWNTO 30)<=PC1;
    	IfIdEn <= not stall;
    

	    ---------------------------Stage 2 ---------------------------------------------------------
	   control_unit : CU port map (IfIdOut(13 downto 9) , CS);
	     --control_unit : CU port map (I , CS);
	      
	    stage_2: stage2 PORT MAP (INTR,Clk,CS(16),CS(17),CS(14),CS(15),CS(21),MemWbOut(37),RESET,D,IfIdOut(29 DOWNTO 14),MemWbOut(2 downto 0),IfIdOut(8 downto 6),IfIdOut(5 downto 3),RS1D,RS2D,R6);
	  -- Rs1A(8-6) - Rs2A(5-3) - RdA(2-0) - Rs1D(9-24) - Rs2D(25-40) - R6(41-56) - PC(57-72) - PC_UP(73-88) - Imm(89-104)- CS(105-131)
	  IdExIn(8 downto 0) <= IfIdOut(8 downto 0);
	  IdExIn(24 downto 9) <= Rs1D;
	   IdExIn(40 downto 25) <= Rs2D;
	    IdExIn(56 downto 41) <= R6;
	     IdExIn(72 downto 57) <= IfIdOut(29 downto 14);
	     IdExIn(88 downto 73) <= IfIdOut(45 downto 30);
	     IdExIn(104 downto 89) <= Stage1Out;--immediate
	     IdExIn(131 downto 105)<=CS;
	  ID_EX: my_nDFF GENERIC MAP (132) PORT MAP (CLK,RESET,'1',IdExIn,IdExOut);
	    
	  ---------------------------------Stage 3 --------------------------------------------------------
	  --LDM,Imm_Reg,Jmp,JZ,JN,JC,RTI,Int,OutSig -- EX_MEM_ALURes,D,Imm
	  EX: Execute port map(CLK,RESET,'0','0','0','0',IdExOut(128),IdExOut(109),IdExOut(105),IdExOut(106),IdExOut(107),IdExOut(108),IdExOut(126),IdExOut(125),ExMemOut(98 downto 83),D,IdExOut(104 downto 89),IdExOut(113 downto 110),IdExOut(24 downto 9),IdExOut(40 downto 25),IdExOut(114),JUMP_ID_EX,OutPort,PCJ,Stage3Out);
	  Tri: TriSt port map(IdExOut(123),OutPort,OUT_PORT);
	  ExMemIn(2 downto 0)<=IdExOut(2 downto 0);
	  ExMemIn(18 downto 3)<=IdExOut(24 downto 9);
	  ExMemIn(34 downto 19)<=IdExOut(72 downto 57);
	  ExMemIn(50 downto 35)<=IdExOut(88 downto 73);
	  ExMemIn(66 downto 51)<=IdExOut(104 downto 89);
	  ExMemIn(82 downto 67)<=IdExOut(56 downto 41);
	  --ALUResult from Exectution 
	  ExMemIn(98 downto 83)<= Stage3Out;
	  ExMemIn(99)<=IdExOut(115);
	  ExMemIn(100)<=IdExOut(116);
	  ExMemIn(101)<=IdExOut(125);
	  ExMemIn(102)<=IdExOut(119);
	  ExMemIn(103)<=IdExOut(121);
	  ExMemIn(104)<=IdExOut(120);
	  ExMemIn(105)<=IdExOut(126);
	  ExMemIn(106)<=IdExOut(122);
	  ExMemIn(107)<=IdExOut(131);
	  ExMemIn(108)<=IdExOut(117);
	  ExMemIn(109)<=IdExOut(118); --RegWrite
	  ExMemIn(110)<=IdExOut(124);
	    -------------------------------EX/MEM Buffer-------------------------------------------------------------------
	  -- RdA(0-2) - Rs1D(3-18) - PC(19-34) - PC_UP(35-50) - Imm(51-66) - R6(67-82) - ALURes(83-98) - (12)CS(99-110)
	  -- (MemRead 99 - MemWrite 100 - INT 101- Call 102- Push 103- Ret 104- Rti 105- Pop 106- Rdc 107- MemReg 108- RegWrite 109- InSignal 110)
	  EX_MEM: my_nDFF GENERIC MAP (111) PORT MAP (CLK,RESET,'1',ExMemIn,ExMemOut);
	  ---------------------------Stage 4----------------------------------
	  MEM : MemoryStage port map (CLK,ExMemOut(99),ExMemOut(100),ExMemOut(101),ExMemOut(102),ExMemOut(103),ExMemOut(106),ExMemOut(104),ExMemOut(105),ExMemOut(66 downto 51),ExMemOut(82 downto 67),ExMemOut(18 downto 3),ExMemOut(34 downto 19),ExMemOut(50 downto 35),Stage4Out);  
--	 RdA(0-2) - ALURes(3-18) - MemData(19-34)  
	  MemWbIn(2 downto 0) <= ExMemOut(2 downto 0);
	  MemWbIn(18 downto 3) <= ExMemOut(98 downto 83);
	  MemWbIn(34 downto 19) <= Stage4Out;
--	 38 InSignal - 37 RegWrite - 36 MemReg - 35 Rdc
	  MemWbIn(38 downto 35) <= ExMemOut(110 downto 107);
	  --------------------------MEM/WB Buffer---------------------------------
	  MEM_WB: my_nDFF GENERIC MAP (39) PORT MAP (CLK,RESET,'1',MemWbIn,MemWbOut); 
	   -- MemReg- RegWrite-MemData(16)-ALUResult(16)-InSignal-Inport(16)-DataOut(16)
	  WB: WriteBackStage PORT MAP(clk,MemWbOut(36),MemWbOut(37),MemWbOut(34 downto 19),MemWbOut(18 downto 3),MemWbOut(38),IN_PORT,D); 
	    
		
END sys_a;




