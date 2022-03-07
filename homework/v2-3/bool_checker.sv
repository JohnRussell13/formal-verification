checker bool_checker ( clk, rst, a, y1, y2, z1, z2) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	assert property (y1 == y2);
	assert property (z1 == z2);

endchecker
