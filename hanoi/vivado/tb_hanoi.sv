`timescale 1ns / 1ps

module tb_hanoi ();

localparam N = 3, M = 3;

function logic [$clog2(N)-1:0] next_ind(input int counter);
    logic [$clog2(N)-1:0] ind;

    for(int i = N-1; i >= 0; i--) begin
        if(!(counter - ((counter >> i) << i))) begin
            ind = i;
            return ind;
        end
    end
endfunction

function logic [$clog2(N)-1:0] next_loc(input logic [N*$clog2(M)-1:0] rings, input logic [$clog2(N)-1:0] ind);
    logic [$clog2(M)-1:0] loc;
    int ind_i;
    int new_loc;
    int old_loc;
    ind_i = ind;
    
    old_loc = rings[(ind_i+1)*$clog2(M)-1 -: $clog2(M)];

    if((N - ind_i) & 1) begin // go left
        if(old_loc == 0) new_loc = N-1;
        else new_loc = old_loc - 1;
    end
    else begin // go right
        if(old_loc == N-1) new_loc = 0;
        else new_loc = old_loc + 1;
    end
    
    loc = new_loc;
    return loc;
endfunction

logic clk_s, rst_s;
logic [$clog2(N)-1:0] ind_s;
logic [$clog2(M)-1:0] loc_s;
logic [N*$clog2(M)-1:0] rings_s;

int counter; 

hanoi #(N, M) hanoi_inst(
    .clk(clk_s),
    .rst(rst_s),
    .ind(ind_s),
    .loc(loc_s),
    .rings(rings_s)
);
    
always begin
    #10ns clk_s = !clk_s;
end
		
always @ (posedge clk_s) begin
    counter++;
end

initial begin
    counter = 0;
    clk_s = 0;
    rst_s = 1;
    #15ns rst_s = 0;
end 

assign ind_s = next_ind(counter);
assign loc_s = next_loc(rings_s, ind_s);

endmodule