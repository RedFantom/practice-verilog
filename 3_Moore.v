/** Author: RedFantom
 * License: MIT License
 * Copyright (c) 2019 RedFantom
*/


module coffee_moore_fsm(clk, insert, reset, coins, coffee, state, change);
    /** Implementation of a Moore FSM for a Coffee Machine
     *
     * The machine accepts coins of 5, 10 and 20 cents. A total of 40
     * cents is required for the machine to brew a coffee. The machine
     * returns change in the `change` output.
    */
    input clk;
    input reset;
    input insert; // Coins input sampled at posedge insert
    input[2:0] coins;
    output coffee;
    output[3:0] state; // 12 possible states
    output[1:0] change;

    parameter S_0C = 4'b0000;
    parameter S_5C = 4'b0001;
    parameter S_10C = 4'b0010;
    parameter S_15C = 4'b0011;
    parameter S_20C = 4'b0100;
    parameter S_25C = 4'b0101;
    parameter S_30C = 4'b0110;
    parameter S_35C = 4'b0111;
    parameter S_40C = 4'b1000;
    parameter S_45C = 4'b1001; // 5c coin change
    parameter S_50C = 4'b1010; // 10c coin change
    parameter S_55C = 4'b1011; // 5c and 10c coin change
    
    parameter I_0C = 3'b000;
    parameter I_5C = 3'b001; // Only one coin can be inserted at a time
    parameter I_10C = 3'b010;
    parameter I_20C = 3'b100;

    reg[3:0] curr_state, next_state;
    reg insert_state;
    
    always @(*) begin // Combinational Logic
        case(curr_state)
            S_0C: case(coins)
                I_0C: next_state = S_0C;
                I_5C: next_state = S_5C;
                I_10C: next_state = S_10C;
                I_20C: next_state = S_20C;
                default: next_state = curr_state;
                endcase
            S_5C: case(coins)
                I_0C: next_state = S_5C;
                I_5C: next_state = S_10C;
                I_10C: next_state = S_15C;
                I_20C: next_state = S_25C;
                default: next_state = curr_state;
                endcase
            S_10C: case(coins)
                I_0C: next_state = S_10C;
                I_5C: next_state = S_15C;
                I_10C: next_state = S_20C;
                I_20C: next_state = S_30C;
                default: next_state = curr_state;
                endcase
            S_15C: case(coins)
                I_0C: next_state = S_15C;
                I_5C: next_state = S_20C;
                I_10C: next_state = S_25C;
                I_20C: next_state = S_35C;
                default: next_state = curr_state;
                endcase
            S_20C: case(coins)
                I_0C: next_state = S_20C;
                I_5C: next_state = S_25C;
                I_10C: next_state = S_30C;
                I_20C: next_state = S_40C;
                default: next_state = curr_state;
                endcase
            S_25C: case(coins)
                I_0C: next_state = S_25C;
                I_5C: next_state = S_30C;
                I_10C: next_state = S_35C;
                I_20C: next_state = S_45C;
                default: next_state = curr_state;
                endcase
            S_30C: case(coins)
                I_0C: next_state = S_30C;
                I_5C: next_state = S_35C;
                I_10C: next_state = S_40C;
                I_20C: next_state = S_50C;
                default: next_state = curr_state;
                endcase
            S_35C: case(coins)
                I_0C: next_state = S_35C;
                I_5C: next_state = S_40C;
                I_10C: next_state = S_45C;
                I_20C: next_state = S_55C;
                default: next_state = curr_state;
                endcase
            S_40C: next_state = S_0C;
            S_45C: next_state = S_0C;
            S_50C: next_state = S_0C;
            S_55C: next_state = S_0C;
            default: next_state = S_0C;
        endcase    
    end
    
    
    always @(posedge clk) begin // Sequential Logic
        if (reset) begin
            curr_state = S_0C;
            insert_state = 1'b0;
        end else if (!insert_state && insert) begin // posedge
            curr_state = next_state;
        end
        insert_state = insert;
    end

    assign state = curr_state;
    assign coffee = curr_state[3];
    assign change = coffee ? curr_state[2:0] : 3'b000;

endmodule : coffee_moore_fsm
