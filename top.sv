module top (
    input CLK,
    input RST,
    input data_in
);
    
    wire signed [15:0] xor_e_sum , xor_l_sum, xor_e, xor_l;
    logic signed [31:0] sum_e_i,  sum_e_q, sum_l_q, sum_l_i;
    logic signed [31:0] sqr_e_i,  sqr_e_q, sqr_l_q, sqr_l_i;
    logic signed [63:0] squared_e_i, squared_e_q, squared_l_i, squared_l_q;
    logic signed [64:0] power_e, power_l;

    logic signed [31:0] corr;

// =================== EARLY PART ===================

xor_block xor_early (
    .a(data_in),
    .b(), // PRN sujungimas
    .y(xor_e)
);

xor_block xor_early_i (
    .a(xor_e),
    .b(), // SIN sujungimas
    .y(sum_e_i)
);

xor_block xor_early_q (
    .a(xor_e),
    .b(), // COS sujungimas
    .y(sum_e_q)
);

summation_block sum_early_i (
    .clk(CLK),
    .rst(RST),
    .in(sum_e_i),
    .sum(sqr_e_i)
);

summation_block sum_early_q (
    .clk(CLK),
    .rst(RST),
    .in(sum_e_q),
    .sum(sqr_e_q)
);

squaring_block sqr_early_i (
    .clk(CLK),
    .rst(RST),
    .in(sqr_e_i),
    .out(squared_e_i)
);

squaring_block sqr_early_q (
    .clk(CLK),
    .rst(RST),
    .in(sqr_e_q),
    .out(squared_e_q)
);

adder add_early (
    .in1(squared_e_i),
    .in2(squared_e_q),
    .out(power_e)
);

// =================== LATE PART ===================

xor_block xor_late (
    .a(data_in),
    .b(), // PRN sujungimas
    .y(xor_l)
);

xor_block xor_late_i (
    .a(xor_l),
    .b(), // SIN sujungimas
    .y(sum_l_i)
);

xor_block xor_late_q (
    .a(xor_l),
    .b(), // COS sujungimas
    .y(sum_l_q)
);

summation_block sum_late_i (
    .clk(CLK),
    .rst(RST),
    .in(sum_l_i),
    .sum(sqr_l_i)
);

summation_block sum_late_q (
    .clk(CLK),
    .rst(RST),
    .in(sum_l_q),
    .sum(sqr_l_q)
);

squaring_block sqr_late_i (
    .clk(CLK),
    .rst(RST),
    .in(sqr_l_i),
    .out(squared_l_i)
);

squaring_block sqr_late_q (
    .clk(CLK),
    .rst(RST),
    .in(sqr_l_q),
    .out(squared_l_q)
);

adder add_late (
    .in1(squared_l_i),
    .in2(squared_l_q),
    .out(power_l)
);

// =================== DLL PART ===================

dll_filter dll (
    .clk(CLK),
    .rst(RST),
    .pe(power_e),
    .pl(power_l),
    .correction(corr)
);

nco dll_nco(
    .clk(CLK),
    .rst(RST),
    .correction(corr), // Control signal from loop filter
    .phase()   // NCO phase output
);

endmodule