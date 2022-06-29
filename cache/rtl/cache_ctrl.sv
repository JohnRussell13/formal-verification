`timescale 1ns / 1ps

module Cache_Ctrl
    #(
        parameter index_width = 10,
        parameter tag_width = 16,
        parameter associative_sets = 4
    )
    (
        input logic clk,
        input logic rst,

        input logic [index_width - 1 : 0] index,
        input logic [tag_width - 1 : 0] tag,
        input logic it_valid,
        output logic it_ready,

        output logic hit_miss,
        output logic [1 : 0] col,
        output logic hm_valid,
        input logic hm_ready
    );

// ------ DECLARATION ------ //

// FSM states
typedef enum logic[1 : 0] {IDLE, CHECK, FINISH} state_t;
state_t state_i, state_o;

// Registers
logic [associative_sets-1 : 0] comp_i, comp_o;
logic [tag_width-1 : 0] tag_i, tag_o;
logic [index_width-1 : 0] index_i, index_o;
logic [tag_width-1 : 0] LRU_i, LRU_o;

// Rest
logic [tag_width-1 : 0] comp_m; // matrix for LRU_i
logic [associative_sets * tag_width - 1 : 0] rdata; // line from the tag memory
logic [index_width-1 : 0] waddr; // where to write
logic write_en; // LRU and tag memory
logic [associative_sets*tag_width-1 : 0] wdata; // tag memory
logic [associative_sets-1 : 0] comp_r; // result of the comparation

// ------ LOGIC ------ //

// Concurrent assigments
assign hit_miss = |comp_o; // or reduction
assign LRU_i = (LRU_o | {associative_sets{comp_o}}) & (~ comp_m); // black magic

// LRU implementation
// 15  11  7  3
// 14  10  6  2
// 13   9  5  1
// 12   8  4  0
always_comb begin // concat transopsed comp_o - can't do it without for loops :(
    for(int i = associative_sets; i > 0; i--) begin
        comp_m[i*associative_sets-1 -: associative_sets] = {associative_sets{comp_o[i]}};
    end
end

always_comb begin // col = one_hot_to_bin(comp_o)
    col = 0;
    for(int i = 0; i < associative_sets; i++) begin
        if(comp_o[i]) begin
            col = i;
        end
    end
end

always_comb begin // wdata = tag from memory with 1/4 changed (using LRU!)
    for(int i = associative_sets; i > 0; i--) begin
        if(!(|LRU_o[i*associative_sets-1 -: associative_sets])) wdata[i*tag_width-1 -: tag_width] = tag_o; // if all 0's, change this 1/4 to the value on the input port
        else wdata[i*tag_width-1 -: tag_width] = rdata[i*tag_width-1 -: tag_width]; // else, just don't change what's in the memory
    end
end

// Registers
always_ff @(posedge clk) begin
    comp_o <= comp_i;
    tag_o <= tag_i;
    index_o <= index_i;
    LRU_o <= LRU_o; // write_en
    if(write_en) LRU_o <= LRU_i;
    
    if(rst) begin
        comp_o <= 0;
        tag_o <= 0;
        index_o <= 0;
	    LRU_o <= 0;
    end
end

// Tag memory implementation
Memory #(.addr_width(index_width), .data_width(associative_sets * tag_width)) 
    Tag_Memory(.clk(clk), 
               .write_en(write_en), 
               .waddr(index_o), 
               .wdata(wdata), 
               .raddr(index_o), 
               .rdata(rdata));      

// Comparator
always_comb begin
    for(int i = 0; i < associative_sets; i++) begin
        comp_r[i] = (tag_o == rdata[(i+1)*tag_width-1 -: tag_width]);
    end
end

// FSM sync
always_ff @(posedge clk) begin
    if(rst == 1) begin
        state_o <= IDLE;
    end
    else begin
        state_o <= state_i;
    end
end

// FSM comb
always_comb begin

    it_ready = 0;
    hm_valid = 0;
    comp_i = comp_o;
    tag_i = tag_o;
    index_i = index_o;
    write_en = 0;

    case(state_o)
        IDLE: begin
            it_ready = 1;
            state_i = IDLE;
            if(it_valid) begin
                state_i = CHECK;
                tag_i = tag;
                index_i = index;
            end
        end
        CHECK: begin
            state_i = FINISH;
            comp_i = comp_r; // only change comp_i when checking
        end
        FINISH: begin
            hm_valid = 1;
            write_en = hit_miss;
            state_i = (hm_ready == 1) ? IDLE : FINISH;
        end
        default: begin
            state_i = IDLE;
        end
    endcase
end

default clocking 
	@(posedge clk);
endclocking

default disable iff (rst);
    
endmodule

