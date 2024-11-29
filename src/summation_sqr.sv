module summation_sqr (
    input  logic            clk,      // Main clock signal
    input  logic            rst,      // Reset signal
    input  logic            clk_10,   // Flag signal (indicates end of accumulation period)
    input  logic            in, // Input value (I/Q component)
    output logic     [27:0] sum  // Output summed value
);
    logic  [31:0]   accum;  // Accumulator

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            sum <= 32'd0;
        end else if (clk_10) begin
            sum <= accum * accum;      // Update sum with accumulated value
            accum <= 32'd0;    // Reset accumulator for the next cycle
        end else begin
            accum <= accum + in; // Accumulate input values
        end
    end

endmodule