clear -all
analyze -sv09 bool_checker.sv bind.sv
analyze -vhdl gen_lut4.vhd n1.vhd n1_lec.vhd bool_proc.vhd
elaborate -vhdl -top bool_proc
clock clk
reset rst
prove -bg -all
