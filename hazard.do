vsim work.hazard_unit
# vsim work.hazard_unit 
# Start time: 21:23:21 on Apr 19,2017
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.hazard_unit(hu_struct)
# vsim work.hazard_unit 
# Start time: 21:16:27 on Apr 19,2017
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.hazard_unit(hu_struct)
add wave -position insertpoint  \
sim:/hazard_unit/if_id_rs1a \
sim:/hazard_unit/if_id_rs2a \
sim:/hazard_unit/id_ex_rda \
sim:/hazard_unit/cu_rsc \
sim:/hazard_unit/cu_rtc \
sim:/hazard_unit/id_ex_memr \
sim:/hazard_unit/stall
force -freeze sim:/hazard_unit/if_id_rs1a 001 0
force -freeze sim:/hazard_unit/if_id_rs2a 010 0
force -freeze sim:/hazard_unit/id_ex_rda 001 0
force -freeze sim:/hazard_unit/cu_rsc 1 0
force -freeze sim:/hazard_unit/cu_rtc 0 0
force -freeze sim:/hazard_unit/id_ex_memr 1 0
run
force -freeze sim:/hazard_unit/cu_rsc 0 0
run
force -freeze sim:/hazard_unit/cu_rtc 1 0
force -freeze sim:/hazard_unit/cu_rsc 1 0
force -freeze sim:/hazard_unit/id_ex_rda 000 0
force -freeze sim:/hazard_unit/if_id_rs2a 001 0
run
force -freeze sim:/hazard_unit/if_id_rs1a 000 0
run
