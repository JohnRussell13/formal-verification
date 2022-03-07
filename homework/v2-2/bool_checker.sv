checker bool_checker ( clk, rst, a, b, c, d, e, f, o1, o2) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	assert property (o1 == o2);

endchecker
