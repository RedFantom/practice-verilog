/** Author: RedFantom
 * License: MIT License
 * Copyright (c) 2019 RedFantom
*/


module half_adder(input a, input b, output sum, output carry);
    xor xor1(sum, a, b);
    and and1(carry, a, b);
endmodule : half_adder


module full_adder(input a, input b, input carry_in, output sum, output carry);
    wire carry1, carry2, sum1;
    half_adder ha1(.a(a), .b(b), .sum(sum1), .carry(carry1));
    half_adder ha2(.a(a), .b(b), .sum(sum), .carry(carry2));
    or or1(carry, carry1, carry2);
endmodule : full_adder


module adder(a, b, c);
    parameter N;
    input[N-1:0] a, b;
    output [N-1:0] c;
    wire[N-1:0] carry;
    generate for (genvar i=0; i<N; i=i+1) begin
        if (i==0) half_adder a(a[i], b[i], c[i], carry[i]);
        else full_adder a(a[i], b[i], carry[i-1], c[i], carry[i]);
    endgenerate
endmodule : adder
