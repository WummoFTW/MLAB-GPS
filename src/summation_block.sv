module summation_block #(
    parameter int N = 10000  // Number of samples to sum
)(
    input  logic        clk,   // Clock signal
    input  logic        rst,   // Reset signal
    input  logic signed [15:0] in, // Input value (I/Q component)
    output logic signed [31:0] sum  // Output summed value
);
    logic signed [31:0] accum;  // Accumulator

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            accum <= 0;
        // else if (/*sample period*/)
        else
            accum <= accum + in;
    end

    assign sum = accum;
endmodule
