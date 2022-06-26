module hanoi
	#(
		parameter N = 16, // NUMBER OF RINGS
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

	logic [$clog2(N)-1:0] exp_ind;
	logic [$clog2(M)-1:0] exp_loc;

	logic [$clog2(M)-1:0] old_loc;

	logic [$clog2(M)*N-1:0] boris_const;
		
	always @ (posedge clk) begin
		if (rst) begin
			for(int i = 0; i < N*$clog2(M); i++) begin
				rings_out[i] = 0;
			end
			for(int i = 1; i < N; i++) begin
				counter_out[i] = 0;
			end
				counter_out[0] = 1;
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

	always_comb begin
		for(int i = N-1; i >= 0; i--) begin
			if( !(counter_out - ((counter_out >> i) << i)) ) begin
				exp_ind = i;
				break;
			end
		end
	end

	always_comb begin
		old_loc = rings[(exp_ind+1)*$clog2(M)-1 -: $clog2(M)];
		if((N - exp_ind) & 1) begin // go left
			if(old_loc == 0) exp_loc = M-1;
			else exp_loc = old_loc - 1;
		end
		else begin // go right
			if(old_loc == M-1) exp_loc = 0;
			else exp_loc = old_loc + 1;
		end
	end

	always_comb begin
		for(int i = 0; i < N; i++) begin
			boris_const[$clog2(M)*i+$clog2(M)-1 -: $clog2(M)] = M-1;
		end
	end

	assign rings = rings_out;

	default clocking
		@(posedge clk);
	endclocking

	default disable iff (rst);

	assume_valid_index :
		restrict property (ind == exp_ind);

	assume_valid_location :
		restrict property (loc == exp_loc);

	cover_thingy :
		cover property (rings == boris_const);
endmodule
