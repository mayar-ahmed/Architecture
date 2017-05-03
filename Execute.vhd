
library ieee;
USE IEEE.std_logic_1164.all;


ENTITY Execute IS
PORT   (Clk,Rst,f11,f12,f21,f22,LDM,Imm_Reg,Jmp,JZ,JN,JC,RTI,Int: IN std_logic;
        EX_MEM_ALURes,D,Imm: IN std_logic_vector(15 DOWNTO 0);
        ALUCode: IN std_logic_vector(3 DOWNTO 0);
        Rs1D,Rs2D: IN std_logic_vector(15 DOWNTO 0);
        FlagEn,stop_flags : IN std_logic;
        JUMP: OUT std_logic;
        OUTPort,PCJ,ALURESOUT: OUT std_logic_vector(15 DOWNTO 0)
        -----------------------------------------------
        --FlagsOUT: OUT std_logic_vector(3 DOWNTO 0)
        
        ------------------------------------------------
      --  EX_MEM: OUT std_logic_vector(110 DOWNTO 0)
        ); 
END Execute;

ARCHITECTURE  Execute  OF Execute IS
	SIGNAL a,b,ALURes,X,Y:std_logic_vector(15 DOWNTO 0);
	SIGNAL FlagIN,FlagOUT,ALUFlag,PreservedOUT:std_logic_vector(3 DOWNTO 0);
--	SIGNAL FlagEn:std_logic;
	Signal smux1,smux2 :std_logic_vector(1 DOWNTO 0);
	
COMPONENT ALU IS
PORT   (a,b: IN std_logic_vector(15 DOWNTO 0); 
        s,Flag: IN std_logic_vector(3 DOWNTO 0);
        NewFlag: OUT std_logic_vector(3 DOWNTO 0);
        Res : OUT std_logic_vector(15 DOWNTO 0)
        );
END COMPONENT;

COMPONENT Reg4 IS
PORT   (Rst,Clk,En: IN std_logic;
	      d :IN std_logic_vector(3 DOWNTO 0);
        q : OUT std_logic_vector(3 DOWNTO 0));
END COMPONENT;

component mux2 IS  
		PORT (a, b: IN  std_logic_vector(15 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(15 DOWNTO 0));    
END component;

component mux2_4bit IS  
		PORT (a, b: IN  std_logic_vector(3 DOWNTO 0);
			s0: in std_logic;
		      x: OUT std_logic_vector(3 DOWNTO 0));    
END component;

component mux4 IS 
	GENERIC (n : integer := 16);
	PORT ( a,b,c,d: IN  std_logic_vector (n-1 DOWNTO 0);
		   s : IN std_logic_vector (1 downto 0);
		   y : OUT std_logic_vector (n-1 DOWNTO 0));
END component;
signal flage : std_logic;

BEGIN
	flage <= stop_flags and FlagEn;
  smux1 <= f12 & f11;
  S1Forward: mux4 PORT MAP(Rs1D,D,EX_MEM_ALURes,EX_MEM_ALURes,smux1,X);
  PCJ <= X;
  S1: mux2 PORT MAP(X,Imm,LDM,a);
    smux2 <= f22& f21;
  S2Forward: mux4 PORT MAP(Rs2D,D,EX_MEM_ALURes,EX_MEM_ALURes,smux2,Y);
  S2: mux2 PORT MAP(Y,Imm,Imm_Reg,b);
	ALUResult: ALU PORT MAP (a,b,ALUCode,FlagOUT,ALUFlag,ALURes);
	FlagMux: mux2_4bit PORT MAP(ALUFlag,PreservedOUT,RTI,FlagIN);
  Flags: Reg4 PORT MAP (Rst,Clk,flage,FlagIN,FlagOUT);  
  PreservedFlags: Reg4 PORT MAP (Rst,Clk,Int,FlagOUT,PreservedOUT);  
 -- PortValue: TriSt PORT MAP(OutSig,X,OUTPort);
    
JUMP <= '1' WHEN Jmp='1' or (JZ='1' and FlagOUT(0)='1') or (JN='1' and FlagOUT(1)='1') or(JC='1' and FlagOUT(2)='1')
ELSE '0';
-----------------------------------------------
OUTPort <= X;
ALURESOUT <= ALURes;
--FlagsOUT <= FlagOUT;
-----------------------------------------------
--EX_MEM <= EX(8 DOWNTO 6) & EX(24 DOWNTO 9) & EX(88 DOWNTO 73) & EX(104 DOWNTO 89) & EX(120 DOWNTO 105) & EX(72 DOWNTO 57) & ALURes & 

END Execute;

