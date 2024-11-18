module squaring_block (
    input  logic        clk,   // Clock signal
    input  logic        rst,   // Reset signal
    input  logic signed [31:0] in,  // Input value
    output logic signed [63:0] out  // Squared output value
);
    assign out = in * in;
endmodule
