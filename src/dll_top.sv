module dll_top (
    input  logic clk,   // Clock signal
    input  logic clk_10, 
    input  logic rst,   // Reset signal
    input  logic signed [15:0] in_e_i, // Early signal
    input  logic signed [15:0] in_e_q,
    input  logic signed [15:0] in_l_i, // Late signal
    input  logic signed [15:0] in_l_q,
    output logic signed [31:0] correction // Output correction signal for NCO
);
    logic signed [31:0] sum_e_i, sum_e_q, sum_l_i, sum_l_q;
    logic signed [63:0] squared_e_i, squared_e_q, squared_l_i, squared_l_q;
    logic signed [64:0] summed_pe, summed_pl;

    summation_block #(.N(10000)) sum_block_e_i (
        .clk(clk),
        .rst(rst),
        .in(in_e_i),
        .sum(sum_e_i)
    );

    summation_block #(.N(10000)) sum_block_l_i (
        .clk(clk),
        .rst(rst),
        .in(in_l_i),
        .sum(sum_l_i)
    );

    summation_block #(.N(10000)) sum_block_e_q (
        .clk(clk),
        .rst(rst),
        .in(in_e_q),
        .sum(sum_e_q)
    );

    summation_block #(.N(10000)) sum_block_l_q (
        .clk(clk),
        .rst(rst),
        .in(in_l_q),
        .sum(sum_l_q)
    );

    squaring_block sq_block_e_i (
        .in(sum_e_i),
        .out(squared_e_i)
    );

    squaring_block sq_block_l_i (
        .in(sum_l_i),
        .out(squared_l_i)
    );

    squaring_block sq_block_e_q (
        .in(sum_e_q),
        .out(squared_e_q)
    );

    squaring_block sq_block_l_q (
        .in(sum_l_q),
        .out(squared_l_q)
    );

    assign summed_pe = squared_e_i + squared_e_q;

    assign summed_pl = squared_l_i + squared_l_q;

    dll_filter dll_filt (
        .clk(clk_10),
        .rst(rst),
        .pe(summed_pe),
        .pl(summed_pl),
        .correction(correction)
    );
endmodule
