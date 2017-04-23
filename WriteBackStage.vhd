LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WriteBackStage IS
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
		 
END ENTITY WriteBackStage;

ARCHITECTURE wb_a OF WriteBackStage IS
	SIGNAL Data,inSecondMux : std_logic_vector(15 DOWNTO 0);
	signal RdASig: std_logic_vector(2 downto 0);
  signal RdcSig : std_logic;
  
  COMPONENT mux2 IS  
 GENERIC (n : integer := 16);
		PORT (a, b: IN  std_logic_vector(n-1 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(n-1 DOWNTO 0));    
END COMPONENT;


	BEGIN
	  first_mux: mux2 generic map (16) port map(MemData,ALUResult,MemReg,inSecondMux);
	  second_mux: mux2 generic map (16) port map(inSecondMux,INPort,INSignal,Data);
	  DataOut <= Data;
	  --RdASig <= RdA;
	  --RdAOut <= RdASig;
	  --RdcSig <= Rdc;
	  --RdcOut <= RdcSig;
END wb_a;





