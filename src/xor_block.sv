module xor_block (
    input  logic a, // Input signal
    input  logic b, // Local PRN code
    output logic y  // XOR result
);
    assign y = a ^ b;
endmodule
