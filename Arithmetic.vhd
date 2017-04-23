
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- interface 
ENTITY arithmetic IS
   PORT( 
    a,b : IN std_logic_vector (15 DOWNTO 0);
		s0, s1,s2: IN std_logic;
		stat_in: IN std_logic_vector(3 DOWNTO 0);
		stat_out: OUT std_logic_vector(3 DOWNTO 0);
		f : OUT std_logic_vector (15 DOWNTO 0));
	
END ENTITY arithmetic;

-- implementation
ARCHITECTURE struct of arithmetic is
-- includes 

	component generic_nadder IS --16 bit adder
       		GENERIC (n : integer := 16);
		PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             	cin : IN std_logic;  
            	s : OUT std_logic_vector(n-1 DOWNTO 0);    
              	cout : OUT std_logic);
	END component;

	component mux4 IS 
	GENERIC (n : integer := 16);
	PORT ( a,b,c,d: IN  std_logic_vector (n-1 DOWNTO 0);
		   s : IN std_logic_vector (1 downto 0);
		   y : OUT std_logic_vector (n-1 DOWNTO 0));
END component;
	
	component mux2_bit IS  -- 1 bit 2*1 mux (input, output 1 bit)
		PORT (a, b: IN  std_logic;
			s0: in std_logic;
		      x: OUT std_logic);    
	END component;

	--component mux4_bit IS -- 1 bit 4*1 mux (input, output 16 bits)
	--	PORT ( a,b,c,d: IN  std_logic;
	--	   s0,s1: IN std_logic;
	--	   y : OUT std_logic);
	-- END component;

component mux2 IS  
		PORT (a, b: IN  std_logic_vector(15 DOWNTO 0);
			S0: in std_logic;
		      x       : OUT std_logic_vector(15 DOWNTO 0));    
END component;
	
	
-- wires 
    signal  m1,m2,bbar,abar,z,ff,outp:std_logic_vector (15 DOWNTO 0); 
	--m1,2 16 bit mux4 (for a , b)
    signal m3 :std_logic;
	  signal s,smux :std_logic_vector(1 DOWNTO 0);
	  signal muxC :std_logic_vector(0 DOWNTO 0);
begin
  abar <= not a;
	bbar <= not b;
	z <= (OTHERS =>'0'); --0000
	ff <= (OTHERS =>'1');--ffff
	--sel<= (s2 AND s3 And s4); --selection for multiplexer 4

	multiplexer1: mux2 port map(abar,a,s2,m1);      --a will be in m1
	s(1 DOWNTO 0) <= s0 & s1;
	multiplexer2: mux4 port map(b,z,ff,bbar,s,m2); --b will be in m2
	  smux <= s0 & s1;
	multiplexerCarry: mux4 GENERIC MAP(1) port map("0","1","0","1",smux,muxC); 
	  m3 <= muxC(0);
	  --	multiplexer4: mux2_bit port map(m3,'1', sel,m4); --carry in m4
	
	adder: generic_nadder GENERIC MAP (16) PORT MAP (m1,m2,m3,outp,stat_out(2));
	
	--set flags in status register 
	--stat(0):z , stat(1):N , stat(2):C , stat(3):V
	
	stat_out(0) <= '1' WHEN outp=z 
			Else '0';

	stat_out(1) <= '1' WHEN outp(15)='1'
			ELSE '0';
		
	--condition for overflow (
	stat_out(3) <='1' WHEN (m1(15)='1' and m2(15)='1' and outp(15)='0') OR 
			(m1(15)='0' and m2(15)='0' and outp(15)='1')
			ELSE '0';
			  
	f<= outp;
	

end struct;

