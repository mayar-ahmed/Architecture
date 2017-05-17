do sim.do
# vsim -gui work.system 
# Start time: 03:18:52 on May 15,2017
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
# Loading work.mux2(data_flow)
# Loading work.my_ndff(a_my_ndff)
# Loading work.cu(cu_struct)
# Loading work.hazard_unit(hu_struct)
# Loading work.stage2(st2)
# Loading work.r6alu(r6)
# Loading work.reg_r6(regr6)
# Loading work.rddec(rdec)
# Loading work.dec(dec)
# Loading work.trist(tri)
# Loading work.forwarding(fu_struct)
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
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /system/MEM/mem
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /system/MEM/mem
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /system/stage_1/INS_MEM
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /system/EX/ALUResult/ALU1
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /system/stage_1/INS_MEM/instruction
mem load -filltype value -filldata 1101100000010100 -fillradix symbolic /system/stage_1/INS_MEM/instruction(0)
mem load -filltype value -filldata 0000000000011110 -fillradix symbolic /system/stage_1/INS_MEM/instruction(1)
mem load -filltype value -filldata 1100010100000000 -fillradix symbolic /system/stage_1/INS_MEM/instruction(2)
mem load -filltype value -filldata 0000110101100100 -fillradix symbolic /system/stage_1/INS_MEM/instruction(3)
mem load -filltype value -filldata 0000110101100100 -fillradix symbolic /system/stage_1/INS_MEM/instruction(4)
mem load -filltype value -filldata 0010010101101000 -fillradix symbolic /system/stage_1/INS_MEM/instruction(16)
mem load -filltype value -filldata {0000000000000000 1101000000000000} -fillradix symbolic /system/stage_1/INS_MEM/instruction(17)
mem load -filltype value -filldata 1101000000000000 -fillradix symbolic /system/stage_1/INS_MEM/instruction(17)
mem load -filltype value -filldata 1101100000001100 -fillradix symbolic /system/stage_1/INS_MEM/instruction(30)
mem load -filltype value -filldata 0000000000010100 -fillradix symbolic /system/stage_1/INS_MEM/instruction(31)
mem load -filltype value -filldata 0000101110101000 -fillradix symbolic /system/stage_1/INS_MEM/instruction(32)
mem load -filltype value -filldata {0010110100000100
} -fillradix symbolic /system/stage_1/INS_MEM/instruction(33)
mem load -filltype value -filldata 1100100000000000 -fillradix symbolic /system/stage_1/INS_MEM/instruction(34)
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
force -freeze sim:/system/RESET 1 0
run
force -freeze sim:/system/RESET 0 0
run
run
run
run
run
run
run
force -freeze sim:/system/INTR 1 0
run
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
run
