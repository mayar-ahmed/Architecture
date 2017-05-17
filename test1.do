vsim -gui work.system
# vsim -gui work.system 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.system(sys_a)
# Loading work.stage1(st1)
# Loading work.rom(rom)
# Loading work.reg(reg)
# Loading work.incrementer(incr)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.mux4(data_flow)
# Loading work.my_ndff(a_my_ndff)
# Loading work.cu(cu_struct)
# Loading work.stage2(st2)
# Loading work.r6alu(r6)
# Loading work.mux2(data_flow)
# Loading work.reg_r6(regr6)
# Loading work.rddec(rdec)
# Loading work.dec(dec)
# Loading work.trist(tri)
# Loading work.execute(execute)
# Loading work.alu(alu)
# Loading work.sh_rot(sh_rot)
# Loading work.logic(logic)
# Loading work.arithmetic(struct)
# Loading work.generic_nadder(a_my_nadder)
# Loading work.mux2_4bit(data_flow)
# Loading work.reg4(reg)
# Loading work.memorystage(memstage_a)
# Loading work.memory(mem_a)
# Loading work.writebackstage(wb_a)


add wave  \
sim:/system/CLK \
sim:/system/RESET \
sim:/system/INTR \
sim:/system/IN_PORT \
sim:/system/OUT_PORT \
sim:/system/Stall \
sim:/system/IfIdEn \
sim:/system/IfIdIn \
sim:/system/IfIdOut \
sim:/system/IdExIn \
sim:/system/IdExOut \
sim:/system/ExMemIn \
sim:/system/ExMemOut \
sim:/system/MemWbIn \
sim:/system/MemWbOut \
sim:/system/PC 

add wave  \
sim:/system/stage_2/R0 \
sim:/system/stage_2/R1 \
sim:/system/stage_2/R2 \
sim:/system/stage_2/R3 \
sim:/system/stage_2/R4 \
sim:/system/stage_2/R5 \
sim:/system/EX/FlagOUT

force -freeze sim:/system/IN_PORT 16'h0005 0

add wave -position insertpoint  \
sim:/system/stage_2/R6_OUT \
sim:/system/stage_2/R6Alu_OUT \
sim:/system/stage_2/R6_en



force -freeze sim:/system/CLK 1 0, 0 {50 ps} -r 100
mem load -i {/media/mayar/Not fun/year 3/semester 2/Arch/processor/inst.mem} /system/stage_1/INS_MEM/instruction


mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /system/MEM/mem/mem
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /system/MEM/mem/mem(0)
mem load -filltype value -filldata 0000000000010000 -fillradix symbolic /system/MEM/mem/mem(1)



force -freeze sim:/system/RESET 1 0

run

force -freeze sim:/system/RESET 0 0
force -freeze sim:/system/INTR 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
# WARNING: No extended dataflow license exists
run
run
run
run
run
run
force -freeze sim:/system/IN_PORT 1111111111111011 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/system/IN_PORT 1111111111111000 0
run
run
run
run
run
run
run
run
# WARNING: No extended dataflow license exists
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
#memory result =18 


