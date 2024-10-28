module xor_block (
    input  logic signed [15:0] a, // Input signal
    input  logic signed [15:0] b, // Local PRN code
    output logic signed [15:0] y  // XOR result
);
    assign y = a ^ b;
endmodule
