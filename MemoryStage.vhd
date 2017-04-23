LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MemoryStage IS
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
		 
END ENTITY MemoryStage;

ARCHITECTURE memStage_a OF MemoryStage IS
	SIGNAL MemData, MemAddress, MemOut : std_logic_vector(15 DOWNTO 0);
	signal RdASig: std_logic_vector(2 downto 0);
	signal AddSel : std_logic;
	
	COMPONENT Memory IS
	PORT(
		clk : IN std_logic;
		re  : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT mux2 IS  
		PORT (a, b: IN  std_logic_vector(15 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(15 DOWNTO 0));    
  END COMPONENT;
  
  COMPONENT mux4 IS 
	 GENERIC (n : integer := 16);
	PORT ( a,b,c,d: IN  std_logic_vector (n-1 DOWNTO 0);
		   s : IN std_logic_vector (1 downto 0);
		   y : OUT std_logic_vector (n-1 DOWNTO 0));
END COMPONENT;
Signal selec : std_logic_vector(1 downto 0);
	BEGIN
	  AddSel <= Call OR Push OR Ret OR Rti OR Pop;
	  muxAdd: mux2 port map(Imm,R6,AddSel,MemAddress);
	    selec(0) <= Call;
	    selec(1) <= Int;
	  muxData: mux4 GENERIC map(16) port map(Rs1D,PC_UP,PC,"0000000000000000",selec,MemData);
	  
    mem: Memory port map(clk,MemRead,MemWrite,MemAddress,MemData,MemOut);
	  DataOut <= MemOut;
	  --RdASig <= RdA;
	  --RdAOut <= RdASig;
END memStage_a;




