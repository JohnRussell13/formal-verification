clear -all
analyze -sv09 hanoi.sv
elaborate -top hanoi
clock clk
reset rst
prove -all
