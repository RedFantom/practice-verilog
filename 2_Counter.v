/** Author: RedFantom
 * License: MIT License
 * Copyright (c) 2019 RedFantom
*/
`include "1_Adders.v"


module counter(input clk, input reset, input enable, count);
    parameter N_CLK = 100; // Amount of cycles to increment count after
    parameter N = 32; // Integer size in bits

    output[N-1:0] count;
    reg[N-1:0] count;

    wire[N-1:0] count_out, clock_out;
    reg[N-1:0] clock_in;

    adder #(.N(N)) counter_adder(.a(count), .b({31'b0, 1'b1}, .c(count_out));
    adder #(.N(N)) clock_adder(.a(clock_in), .b({31'b0, 1'b1}, .c(clock_out));

    always @(posedge clk) begin
        if(reset) begin
            clock_in <= 0; count <= 0; // Delayed assignments prevent feedback
                // loops in the adders
        end else if (clock_in == N_CLK) begin
            count <= count_out;
            clock_in <= 0; // If not set to zero, will only count once and
                // after overflow
        end

        if (enable)
            clock_in <= clock_out;
    end
endmodule : counter
