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
		DataOut, m0,m1 : OUT  std_logic_vector(15 DOWNTO 0));
		 
END COMPONENT;

COMPONENT Execute IS
PORT   (Clk,Rst,f11,f12,f21,f22,LDM,Imm_Reg,Jmp,JZ,JN,JC,RTI,Int: IN std_logic;
        EX_MEM_ALURes,D,Imm: IN std_logic_vector(15 DOWNTO 0);
        ALUCode: IN std_logic_vector(3 DOWNTO 0);
        Rs1D,Rs2D: IN std_logic_vector(15 DOWNTO 0);
        FlagEn,stop_flags : IN std_logic;
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
		INT,Rst,Clk,JUMP,CALL,RET,RTI,stall,jmp_ex_mem, call_ex_mem,mem_wb_ret,mem_wb_rti: IN std_logic;
		PCJ,PC3,m0,m1: IN std_logic_vector(15 DOWNTO 0);
		IF_ID_ins_in,PC,PC1: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT stage2 IS  
	PORT (
		INT,Clk,PUSH,POP,CALL,RET,RTI,RegW,Rst: IN std_logic;
		Write_Data,PC: IN std_logic_vector(15 DOWNTO 0);
		Write_Address: IN std_logic_vector(2 DOWNTO 0);
		Rs1A,Rs2A: IN std_logic_vector(2 DOWNTO 0);
		R6_stop : In std_logic;
		Rs1D,Rs2D,Reg6: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

Component mux2 IS  
 GENERIC (n : integer := 16);
		PORT (a, b: IN  std_logic_vector(n-1 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

component hazard_unit is
PORT (
if_id_rs1a, if_id_rs2a,id_ex_rda   : IN std_logic_vector (2 DOWNTO 0);
cu_rsc,cu_rtc, id_ex_memr : IN std_logic ;
stall: OUT std_logic
);
END component;

component forwarding is
PORT (
mem_wb_rda, ex_mem_rda, id_ex_rs1a,id_ex_rs2a  : IN std_logic_vector (2 DOWNTO 0);
mem_wb_rdc, ex_mem_rdc , id_ex_rsc,id_ex_rtc : IN std_logic ;
f11,f12,f21,f22 : OUT std_logic
);
END component;

  SIGNAL Stall, IfIdEn: std_logic;
  SIGNAL IfIdIn, IfIdOut : std_logic_vector(61 downto 0);
  SIGNAL IdExIn, IdExOut : std_logic_vector(147 downto 0);
  SIGNAL ExMemIn, ExMemOut : std_logic_vector(127 downto 0);
  SIGNAL MemWbIn, MemWbOut : std_logic_vector(56 downto 0);
  SIGNAL Prt: std_logic_vector(15 downto 0); 
  SIGNAL PCJ: std_logic_vector(15 downto 0); --Execution Component
--  SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL D : STD_LOGIC_VECTOR(15 DOWNTO 0);
 SIGNAL s_flush : STD_LOGIC; --selection line for flush
  SIGNAL Stage4Out : std_logic_vector(15 downto 0);
  SIGNAL Stage3Out : std_logic_vector(15 downto 0);
  SIGNAL Stage1Out,PC,PC1 : std_logic_vector(15 downto 0);
  Signal RS1D,RS2D,R6 : std_logic_vector(15 downto 0);
  signal CS,flush_out,zeros :std_logic_vector (26 downto 0); --control signals, output of flushing idex
  -- from EX component
  SIGNAL JUMP_ID_EX: Std_logic;
  SIGNAL OutPort,mem0,mem1 : std_logic_vector(15 downto 0);
  signal ex_mem_flush  : std_logic; --selectiom for flushing ex/mem
  signal ex_mem_flush_out,ex_mem_cs: std_logic_vector (12 downto 0); --output of flushing mux
  signal f11,f12,f21,f22 :std_logic; --forwarding mux selectors
  signal stage3_in : std_logic_vector (15 downto 0); --input of forwarding mux in stage 3
  signal stop_r6,stop_flags,stall_temp: std_logic; --if instruction is going to be flushed don't modify r6 or flags
  
	

  
  
	BEGIN
	  
	  -- INTR -RESET - JMP - Call - Ret - Rti - stall
	  --stage_1: stage1 PORT MAP (INTR,RESET,CLK,JUMP_ID_EX,IdExOut(135),ExMemOut(14),ExMemOut(20),Stall,PCJ,PC3,IF_ID_ins_in,PC,PC1);
	    -- opcode(13-9) - Rs1A(8-6) - Rs2A(5-3) - RdA(2-0) - PC(14-29) - PC_UP(30-45)
	    stage_1: stage1 PORT MAP (INTR,Reset,Clk,JUMP_ID_EX,IdExOut(119),ExMemOut(104),ExMemOut(105),Stall,ExMemOut(111),ExMemOut(102),MemWbOut(39),MemWbOut(40),PCJ,Stage4Out,mem0,mem1,Stage1Out,PC,PC1);

	  IF_ID: my_nDFF GENERIC MAP (62) PORT MAP (CLK,RESET,IfIdEn,IfIdIn,IfIdOut);
	  IfIdIn(13 DOWNTO 0)<=Stage1Out(15 DOWNTO 2);
    	IfIdIn(29 DOWNTO 14)<=PC;
    	IfIdIn(45 DOWNTO 30)<=PC1;
	IfIdIn(61 DOWNTO 46)<=IN_PORT;
    	IfIdEn <= not stall;
    
	    ---------------------------Stage 2 ---------------------------------------------------------
	   control_unit : CU port map (IfIdOut(13 downto 9) , CS);
	     --control_unit : CU port map (I , CS);

	stop_r6<=Not(JUMP_ID_EX or IdExOut(119) or IdExOut(120) or IdExOut(126) or ExMemOut(104) or ExMemOut(105) or IdExOut(127));
	
	--hazards and flushing output
	--a :cs, b:zero, so:ex_mem ret or exmem_rti or jmp_id_ex, id_ex_call, flush_imm, x:muxout
	hazard_detecttion : hazard_unit port map (IfIdOut(8 downto 6),IfIdOut(5 downto 3), IdExOut(2 downto 0), CS(24), CS(25),IdExOut(115),stall_temp);
	stall<= stall_temp and (not IdExOut(127));
	zeros <= (others =>'0');
	s_flush <= '1' when(stall='1') or (ExMemOut(104)='1') or (ExMemOut(105) ='1') or (JUMP_ID_EX='1') or (IdExOut(119)='1') or (IdExOut(127)='1')
		else '0';
	flush_mux : mux2 GENERIC MAP (27) PORT MAP (CS,zeros, s_flush, flush_out);
	      
	    stage_2: stage2 PORT MAP (CS(20),Clk,CS(16),CS(17),CS(14),CS(15),CS(21),MemWbOut(37),RESET,D,IfIdOut(29 DOWNTO 14),MemWbOut(2 downto 0),IfIdOut(8 downto 6),IfIdOut(5 downto 3),stop_r6,RS1D,RS2D,R6);
	  -- Rs1A(8-6) - Rs2A(5-3) - RdA(2-0) - Rs1D(9-24) - Rs2D(25-40) - R6(41-56) - PC(57-72) - PC_UP(73-88) - Imm(89-104)- CS(105-131)
	  IdExIn(8 downto 0) <= IfIdOut(8 downto 0);
	  IdExIn(24 downto 9) <= Rs1D;
	   IdExIn(40 downto 25) <= Rs2D;
	    IdExIn(56 downto 41) <= R6;
	     IdExIn(72 downto 57) <= IfIdOut(29 downto 14);
	     IdExIn(88 downto 73) <= IfIdOut(45 downto 30);
	     IdExIn(104 downto 89) <= Stage1Out;--immediate
	     IdExIn(131 downto 105)<=flush_out;
	   IdExIn(147 downto 132)<=IfIdOut(61 DOWNTO 46);
	  ID_EX: my_nDFF GENERIC MAP (148) PORT MAP (CLK,RESET,'1',IdExIn,IdExOut);
	    
	  ---------------------------------Stage 3 --------------------------------------------------------
	 --forwarding unit
	data_forward : forwarding port map (MemWbOut(2 downto 0), ExMemOut(2 downto 0) , IdExOut(8 downto 6), IdExOut(5 downto 3), MemWbOut(35), ExMemOut(107), IdExOut(129), IdExOut(130),f11,f12,f21,f22);

	stop_flags <= not(ExMemOut(104) OR ExMemOut(105)); 
	--if Ex/MEM is in instruction, get forwarding mux input from alu port not ex/mem alu result
	in_mux : mux2 GENERIC MAP (16) PORT MAP (ExMemOut(98 downto 83),ExMemOut(127 downto 112), ExMemOut(110), stage3_in);

	 --LDM,Imm_Reg,Jmp,JZ,JN,JC,RTI,Int,OutSig -- EX_MEM_ALURes (stage3_in) ,D,Imm
		
	  EX: Execute port map(CLK,RESET,f11,f12,f21,f22,IdExOut(128),IdExOut(109),IdExOut(105),IdExOut(106),IdExOut(107),IdExOut(108),IdExOut(126),IdExOut(125),stage3_in,D,IdExOut(104 downto 89),IdExOut(113 downto 110),IdExOut(24 downto 9),IdExOut(40 downto 25),IdExOut(114),stop_flags,JUMP_ID_EX,OutPort,PCJ,Stage3Out);
	  Tri: TriSt port map(IdExOut(123),OutPort,OUT_PORT);


	  ExMemIn(2 downto 0)<=IdExOut(2 downto 0);
	 -- ExMemIn(18 downto 3)<=IdExOut(24 downto 9); --should be the forwarded RS1D from execution
	  ExMemIn(18 downto 3) <= OutPort; --X (result of forwarding)
	  ExMemIn(34 downto 19)<=IdExOut(72 downto 57);
	  ExMemIn(50 downto 35)<=IdExOut(88 downto 73);
	  ExMemIn(66 downto 51)<=IdExOut(104 downto 89);
	  ExMemIn(82 downto 67)<=IdExOut(56 downto 41);
	  --ALUResult from Exectution 
	  ExMemIn(98 downto 83)<= Stage3Out;

--flushing ex-mem
	--control signals from id/ex
	  ex_mem_cs(0)<=IdExOut(115);
	  ex_mem_cs(1)<=IdExOut(116);
	  ex_mem_cs(2)<=IdExOut(125);
	  ex_mem_cs(3)<=IdExOut(119);
	  ex_mem_cs(4)<=IdExOut(121);
	  ex_mem_cs(5)<=IdExOut(120);
	  ex_mem_cs(6)<=IdExOut(126);
	  ex_mem_cs(7)<=IdExOut(122);
	  ex_mem_cs(8)<=IdExOut(131);
	  ex_mem_cs(9)<=IdExOut(117);
	  ex_mem_cs(10)<=IdExOut(118); --RegWrite
	  ex_mem_cs(11)<=IdExOut(124);
	 ex_mem_cs(12) <= JUMP_ID_EX;

ex_mem_flush<='1' when (ExMemOut(104) ='1') or (ExMemOut(105)='1') else '0';
flush_ex_mux : mux2 GENERIC MAP (13) PORT MAP (ex_mem_cs,"0000000000000", ex_mem_flush, ex_mem_flush_out);
	ExMemIn(111 downto 99) <=ex_mem_flush_out;
	ExMemIn(127 downto 112) <=IdExOut(147 downto 132);

-- 	ExMemIn(99)<=IdExOut(115);
--	  ExMemIn(100)<=IdExOut(116);
--	  ExMemIn(101)<=IdExOut(125);
--	  ExMemIn(102)<=IdExOut(119);
--	  ExMemIn(103)<=IdExOut(121);
--	  ExMemIn(104)<=IdExOut(120);
--	  ExMemIn(105)<=IdExOut(126);
--	  ExMemIn(106)<=IdExOut(122);
--	  ExMemIn(107)<=IdExOut(131);
--	  ExMemIn(108)<=IdExOut(117);
--	  ExMemIn(109)<=IdExOut(118); --RegWrite
--	  ExMemIn(110)<=IdExOut(124);
--	  ExMemIn(111) <= JUMP_ID_EX;


	    -------------------------------EX/MEM Buffer-------------------------------------------------------------------
	  -- RdA(0-2) - Rs1D(3-18) - PC(19-34) - PC_UP(35-50) - Imm(51-66) - R6(67-82) - ALURes(83-98) - (13)CS(99-111)- In port value(127-112)
	  -- (MemRead 99 - MemWrite 100 - INT 101- Call 102- Push 103- Ret 104- Rti 105- Pop 106- Rdc 107- MemReg 108- RegWrite 109- InSignal 110 - jump 111)
	  EX_MEM: my_nDFF GENERIC MAP (128) PORT MAP (CLK,RESET,'1',ExMemIn,ExMemOut);
	  ---------------------------Stage 4----------------------------------
	  MEM : MemoryStage port map (CLK,ExMemOut(99),ExMemOut(100),ExMemOut(101),ExMemOut(102),ExMemOut(103),ExMemOut(106),ExMemOut(104),ExMemOut(105),ExMemOut(66 downto 51),ExMemOut(82 downto 67),ExMemOut(18 downto 3),ExMemOut(34 downto 19),ExMemOut(50 downto 35),Stage4Out,mem0,mem1);  
--	 RdA(0-2) - ALURes(3-18) - MemData(19-34)  
	  MemWbIn(2 downto 0) <= ExMemOut(2 downto 0);
	  MemWbIn(18 downto 3) <= ExMemOut(98 downto 83);
	  MemWbIn(34 downto 19) <= Stage4Out;
--	 40-rti 39-ret -38 InSignal - 37 RegWrite - 36 MemReg - 35 Rdc
	  MemWbIn(38 downto 35) <= ExMemOut(110 downto 107);
          MemWbIn(39)<= ExMemOut(104);
	MemWbIn(40)<= ExMemOut(105);
-- in data (41-56)
	MemWbIn(56 downto 41) <= ExMemOut(127 downto 112);
	

	  --------------------------MEM/WB Buffer---------------------------------
	  MEM_WB: my_nDFF GENERIC MAP (57) PORT MAP (CLK,RESET,'1',MemWbIn,MemWbOut); 
	   -- MemReg- RegWrite-MemData(16)-ALUResult(16)-InSignal-Inport(16)-DataOut(16)
	  WB: WriteBackStage PORT MAP(clk,MemWbOut(36),MemWbOut(37),MemWbOut(34 downto 19),MemWbOut(18 downto 3),MemWbOut(38),MemWbOut(56 downto 41),D); 
	    
		
END sys_a;




