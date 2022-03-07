`timescale 1ns / 1ps

module wsc_tb();

function logic [2 : 0] next(input logic [3 : 0] state, input logic [2 : 0] wsc);
    logic [2 : 0] new_wsc;
    logic ok;
    
    if(state[2:0] == 7) side = 1;
    else if(state[2:0] == 0) side = 0;
    
    if(state[3] == side) begin // first island -- always move 
        for(int i = 0; i < 3; i++) begin
            if(state[i] == state[3] && (!wsc[i] || (state[2:0] == 7 || state[2:0] == 0))) begin // can move and (wasn't just moved or reached the end)
                ok = 1;
                for(int j = i+1; j < 3-1; j++) begin
                    if(state[j] == state[j+1]) begin // no eating
                        ok = 0; // not ok
                    end
                end
                
                if(ok == 1) begin
                    for(int j = 0; j < 3; j++) begin
                        new_wsc[j] = (j == i) ? 1 : 0;
                    end
                    return new_wsc;
                end
            end
        end
    end
    
    else begin // move only if needed
        for(int i = 0; i < 3; i++) begin // second island
            if(state[i] == state[3] && !wsc[i]) begin // can move and wasn't just moved
                ok = 0;
                for(int j = 0; j < i; j++) begin
                    if(state[j] == state[i]) ok = 1; // must move
                end
            
                for(int j = i+1; j < 3-1; j++) begin
                    if(state[j] == state[i]) ok = 1; // must move
                end
                
                if(ok == 1) begin
                    for(int j = 0; j < 3; j++) begin
                        new_wsc[j] = (j == i) ? 1 : 0;
                    end
                    return new_wsc;
                end
            end
        end
    end
    
    for(int i = 0; i < 3; i++) begin
        new_wsc[i] = 0;
    end
    return new_wsc;
endfunction

logic clk_s, rst_s;
logic [2 : 0] wsc_s;
logic [3 : 0] state_s;
logic error, done;
logic side;

wsc wsc_inst
  ( .clk(clk_s),
    .rst(rst_s),
    .wolf(wsc_s[2]),
    .sheep(wsc_s[1]),
    .cab(wsc_s[0]),
    .state(state_s));
    
always begin
    #10ns clk_s = !clk_s;
end

initial begin
    side = 0;
    clk_s = 0;
    rst_s = 1;
    #15ns rst_s = 0;
end 

assign wsc_s = next(state_s, wsc_s);

// sheep dies || cabege dies
assign error = (state_s[2] == state_s[1] && state_s[3] != state_s[2] || state_s[1] == state_s[0] && state_s[3] != state_s[0]) ? 1 : 0;
assign done = (state_s == 15) & !error;

endmodule