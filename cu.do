vsim work.cu
# vsim work.cu 
# Start time: 00:23:30 on Apr 18,2017
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.cu(cu_struct)
quit -sim
# End time: 00:23:44 on Apr 18,2017, Elapsed time: 0:00:14
# Errors: 0, Warnings: 0
# Compile of cu.vhd was successful.
vsim work.cu
# vsim work.cu 
# Start time: 00:23:56 on Apr 18,2017
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.cu(cu_struct)
add wave -position insertpoint  \
sim:/cu/op \
sim:/cu/cs
force -freeze sim:/cu/op 00000 0
run
force -freeze sim:/cu/op 00001 0
run
force -freeze sim:/cu/op 00010 0
run
force -freeze sim:/cu/op 00011 0
run
force -freeze sim:/cu/op 00100 0
run
force -freeze sim:/cu/op 00101 0
force -freeze sim:/cu/op 00110 0
run
force -freeze sim:/cu/op 00111 0
run
force -freeze sim:/cu/op 01000 0
run
force -freeze sim:/cu/op 01001 0
run
force -freeze sim:/cu/op 01010 0
run
force -freeze sim:/cu/op 01011 0
run
force -freeze sim:/cu/op 01100 0
run
force -freeze sim:/cu/op 01101 0
run
force -freeze sim:/cu/op 01110 0
run
force -freeze sim:/cu/op 01111 0
run
force -freeze sim:/cu/op 10000 0
run
force -freeze sim:/cu/op 10001 0
run
force -freeze sim:/cu/op 10010 0
run
force -freeze sim:/cu/op 10011 0
run
force -freeze sim:/cu/op 10100 0
run
force -freeze sim:/cu/op 10101 0
run
force -freeze sim:/cu/op 10110 0
run
force -freeze sim:/cu/op 10111 0
run
force -freeze sim:/cu/op 11000 0
run
force -freeze sim:/cu/op 11001 0
run
force -freeze sim:/cu/op 11010 0
run
force -freeze sim:/cu/op 11011 0
run
force -freeze sim:/cu/op 11100 0
run
force -freeze sim:/cu/op 11101 0
run
force -freeze sim:/cu/op 11110 0
run