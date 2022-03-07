module hanoi
	#(
		parameter N = 3,
		parameter M = 3
	)
	(
		input clk,
		input rst,
		input [$clog2(N)-1:0] ind, // 0 <= ind_i < N
		input [$clog2(M)-1:0] loc, // 0 <= loc_i < M
		output [N*$clog2(M)-1:0] rings
	);

	logic [N*$clog2(M)-1:0] rings_in;
	logic [N*$clog2(M)-1:0] rings_out;
	logic [N-1:0] counter_in;
	logic [N-1:0] counter_out; 
		
	always @ (posedge clk) begin
		if (rst) begin
			for(int i = 0; i < N*$clog2(M); i++) begin
				rings_out[i] = 0;
			end
			for(int i = 0; i < N; i++) begin
				counter_out[i] = 0;
			end
		end
		else begin
			rings_out = rings_in;
			counter_out = counter_in;
		end
	end

	always_comb begin
		for(int i = 0; i < N; i++) begin
			if(i == ind) rings_in[(i+1)*$clog2(M)-1 -: $clog2(M)] = loc;
			else rings_in[(i+1)*$clog2(M)-1 -: $clog2(M)] = rings_out[(i+1)*$clog2(M)-1 -: $clog2(M)];
		end
		counter_in = counter_out + 1;
	end

	assign rings = rings_out;

	default clocking
		@(posedge clk);
	endclocking

	//default disable iff (rst);
endmodule