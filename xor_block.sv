module xor_block (
    input  logic signed [2:0] a, // Input signal
    input  logic signed [2:0] b, // Local PRN code
    output logic signed [2:0] y  // XOR result
);
    assign y = a ^ b;
endmodule
