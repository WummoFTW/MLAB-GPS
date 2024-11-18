module costas_top (
    input  logic clk,       // Clock signal
    input  logic clk_10,    // Prescaled Clock signal
    input  logic rst,       // Reset signal
    input  logic signed [2:0] in_i,    // In-phase signal
    input  logic signed [2:0] in_q,    // Quadrature signal
    output logic signed [33:0] correction, // Output correction signal for NCO
    output logic signed [1:0] data_output
);
    logic signed [16:0] sum_i, sum_q;
    logic signed [33:0] phase_error;

    summation_block #(.N(10000)) sum_block_i (
        .clk(clk),
        .clk_10(clk_10),
        .rst(rst),
        .in(in_i),
        .sum(sum_i)
    );

    summation_block #(.N(10000)) sum_block_q (
        .clk(clk),
        .clk_10(clk_10),
        .rst(rst),
        .in(in_q),
        .sum(sum_q)
    );

    
    sign_function d_out(
    .clk(clk),          // Clock signal
    .in(sum_i),         // Input signal
    .out(data_output)   // Sign output (+1 or -1)
);

    // Calculate the phase error
    assign phase_error = sum_i * sum_q;

    costas_filter cost_filt (
        .clk(clk_10),
        .rst(rst),
        .phase_error(phase_error),
        .correction(correction)
    );
endmodule
