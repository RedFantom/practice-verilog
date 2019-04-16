/** Author: RedFantom
 * License: MIT License
 * Copyright (c) 2019 RedFantom
 *
 * Moore FSM Implementation of:
 * <ftp://ftp.intel.com/Pub/fpgaup/pub/Intel_Material/Laboratory_Exercises/Digital_Logic/Verilog/lab7.pdf>
*/


module intel_fsm(input clk, input reset, input w, output o);
    parameter S_A = 4'b0000;
    parameter S_B = 4'b0001;
    parameter S_C = 4'b0010;
    parameter S_D = 4'b0011;
    parameter S_E = 4'b1000;
    parameter S_F = 4'b0100;
    parameter S_G = 4'b0101;
    parameter S_H = 4'b0110;
    parameter S_I = 4'b1001;

    reg[3:0] curr_state, next_state;

    always @(*) begin  // Combinational Logic
        case(curr_state)
            S_A: next_state = w ? S_F : S_B;
            S_B: next_state = w ? S_F : S_C;
            S_C: next_state = w ? S_F : S_D;
            S_D: next_state = w ? S_F : S_E;
            S_E: next_state = w ? S_F : S_E;
            S_F: next_state = w ? S_G : S_B;
            S_G: next_state = w ? S_H : S_B;
            S_H: next_state = w ? S_I : S_B;
            S_I: next_state = w ? S_I : S_B;
            default: next_state = S_A;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            curr_state = S_A;
        else
            curr_state = next_state;
    end

    assign o = curr_state[3];

endmodule : intel_fsm
