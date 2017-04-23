LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY hazard_unit is
PORT (
if_id_rs1a, if_id_rs2a,id_ex_rda   : IN std_logic_vector (2 DOWNTO 0);
cu_rsc,cu_rtc, id_ex_memr : IN std_logic ;
stall: OUT std_logic
);
END hazard_unit;
ARCHITECTURE hu_STRUCT OF hazard_unit IS
signal src1 ,src2 : std_logic;
BEGIN

src1 <= '1' when ((cu_rsc = '1') and (id_ex_rda = if_id_rs1a)) else '0';
src2 <= '1' when ((cu_rtc = '1') and (id_ex_rda = if_id_rs2a)) else '0' ;

stall <= '1' when (id_ex_memr ='1') and ((src1='1') or (src2='1')) else '0';

--Stall = (ID/EX.MemRead) &&
--[ (IF/ID.RSC && (ID/EX.RDA == IF/ID.RS1A)) ||  (IF/ID.RTC&&(ID/EX.RDA==IF/ID.RS2A)) ]




END hu_STRUCT;	 