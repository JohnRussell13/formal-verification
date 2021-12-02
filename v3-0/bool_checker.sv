checker bool_checker ( clk, rst, RT, RDY, START, ENDD) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	assert property (RT -> !(RDY || START || ENDD));

endchecker
