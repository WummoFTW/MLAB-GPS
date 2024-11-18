module summation_block #(
    parameter int N = 10000  // Number of samples to sum
)(
    input  logic        clk,      // Main clock signal
    input  logic        clk_10,   // Flag signal (indicates end of accumulation period)
    input  logic        rst,      // Reset signal
    input  logic signed [2:0] in, // Input value (I/Q component)
    output logic signed [16:0] sum  // Output summed value
);
    logic signed [31:0] accum;  // Accumulator

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            sum <= 32'd0;
        end else if (clk_10) begin
            sum <= accum;      // Update sum with accumulated value
            accum <= 32'd0;    // Reset accumulator for the next cycle
        end else begin
            if (in[2] == 0)
                accum <= accum + in[1:0]; // Accumulate input values
            else begin
                accum <= accum - in[1:0];
            end
        end
    end

endmodule
