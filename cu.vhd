
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY CU is
PORT (
op : IN std_logic_vector (4 DOWNTO 0);
cs : OUT std_logic_vector (26 downto 0)
);
END ENTITY CU;
ARCHITECTURE CU_STRUCT OF CU IS

signal nop,add,sub,ands,ors,mov,rlc,rrc,shl,shr,setc,clrc,push,pop,outs,ins,nots,neg,inc,dec,jz,jn,jc,jmp,call,ret,rti,ldm,ldd,stds,ints: std_logic_vector (4 DOWNTO 0);
signal oneop, twop,j : std_logic; 
BEGIN

nop<="00000";
add<="00001";
sub<="00010";
ands<="00011";
ors<="00100";
mov<="00101";
rlc<="00110";
rrc<="00111";
shl<="01000";
shr<="01001";
setc<="01010";
clrc<="01011";
push<="01100";
pop<="01101";
outs<="01110";
ins<="01111";
nots<="10000";
neg<="10001";
inc<="10010";
dec<="10011";
jz<="10100";
jn<="10101";
jc<="10110";
jmp<="10111";
call<="11000";
ret<="11001";
rti<="11010";
ldm<="11011";
ldd<="11100";
stds<="11101";
ints<="11110";

twop <= '1' when ((op =add) or (op=sub) or (op=ands) or (op=ors) ) else '0';
oneop <= '1' when ((op=rrc) or (op=rlc) or (op=shl) or (op=shr) or (op=nots) or (op=neg) 
		or (op=inc) or (op=dec) or (op=mov)) else '0';
j<= '1' when ((op= jmp) or (op=jz) or (op=jc) or (op=jn)) else '0';

cs(0)<= '1' when op=jmp else '0';
cs(1) <= '1' when op=jz else '0';
cs(2) <= '1' when op=jn else '0';
cs(3) <= '1' when op=jc else '0';
cs(4) <= '1' when op=shl or op=shr else '0';
cs(8 downto 5)<= "0001" when (op=neg )
 	else "0010" when (op=clrc)
	else "0011" when (op=setc)
	else "0100" when (op =add)
	else "0101" when (op=inc)
	else "0110" when (op=dec)
	else "0111" when (op=sub)
	else "1000" when (op=ands)
	else "1001" when (op=ors)
	else "1010" when (op=mov) or (op=ldm)
	else "1011" when (op=nots)
	else "1100" when (op=shr)
	else "1101" when (op=shl)
	else "1110" when (op=rrc)
	else "1111" when (op=rlc)
	else "0000";
cs(9) <= '1' when (((twop='1') or (oneop='1') or (op=setc) or (op=clrc) ) and (op /=mov)) else '0';
cs(10) <= '1' when ((op =ret) or (op=pop) or (op=ldd) or (op=rti)) else '0';
cs(11) <= '1' when ((op=call)or (op=push) or (op=stds) or (op=ints)) else '0';
cs(12) <= '1' when ((oneop='1') or (twop='1') or (op=ldm)) else '0';
cs(13) <= '1' when ((oneop='1') or (twop='1')  or (op=ldm) or (op=ldd) or (op=ins) or (op=pop)) else '0';
cs(14) <= '1' when op=call else '0';
cs(15) <= '1' when op=ret else '0';
cs(16) <= '1' when op=push else '0';
cs(17) <= '1' when op=pop else '0';
cs(18) <= '1' when op=outs else '0';
cs(19) <= '1' when op=ins else '0';
cs(20) <= '1' when op=ints else '0';
cs(21) <= '1' when op=rti else '0';
cs(22) <= '1' when ((op=shl) or (op=shr) or (op=ldm) or (op= ldd) or (op=stds)) else '0'; 
cs(23) <= '1' when op=ldm else '0';
cs(24) <= '1' when ((oneop='1') or (twop='1') or (j='1') or (op=stds) or (op=call) or (op=outs) or (op=push)) else '0';
cs(25) <= twop;
cs(26) <= '1' when ((oneop='1') or (twop='1')  or (op=ldd) or (op=ldm) or (op=pop) or (op=ins)) else '0';

END CU_STRUCT;	 