clear -all
analyze -sv09 bool_checker.sv bind.sv
analyze -vhdl bool_proc.vhd
elaborate -vhdl -top bool_proc
clock clk
reset rst
prove -bg -all
