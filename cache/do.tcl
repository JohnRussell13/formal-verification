analyze -sv09 rtl/cache_ctrl.sv rtl/memory.sv formal/top.sv
elaborate -top {top}
clock clk
reset rst
prove -bg -all
