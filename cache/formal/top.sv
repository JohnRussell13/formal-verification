module top(	input logic clk,
			input logic rst,

			input logic [index_width - 1 : 0] index,
			input logic [tag_width - 1 : 0] tag,
			input logic it_valid,
			output logic it_ready,

			output logic hit_miss,
			output logic [1 : 0] col,
			output logic hm_valid,
			input logic hm_ready);
    
	Cache_Ctrl uufv(.clk(clk),
					.rst(rst),
					.index(index),
					.tag(tag),
					.it_valid(it_valid),
					.it_ready(it_ready),
					.hit_miss(hit_miss),
					.col(col),
					.hm_valid(hm_valid),
					.hm_ready(hm_ready));

	cover property (it_ready == 0);
	cover property (it_ready == 1);
	cover property (hit_miss == 1 & hm_valid == 1);
	cover property (hit_miss == 0 & hm_valid == 1);
	cover property (col == 0 & hm_valid == 1);
	cover property (col == 1 & hm_valid == 1);
	cover property (col == 2 & hm_valid == 1);
	cover property (col == 3 & hm_valid == 1);

	restrict property (index < 64); // easier to check for misses
	// restrict valid == 1 until ready == 1


	// assert it_ready, then after 2 clk it_valid
	// can't check for LRU on this level!


endmodule
