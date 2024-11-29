module top(
    input               CLK,
    input               RST,
    input               data_in,

    output              data_out
);
    logic               prn_present, prn_early, prn_late;
    logic               prn_e, prn_l; // Signal going into sine/cosine XOR's
    logic               xor_e_i, xor_e_q, xor_l_i, xor_l_q;
    logic        [27:0] power_e_i,  power_e_q, power_l_i,  power_l_q;
    logic        [28:0] power_early, power_late;

    logic               sin, cos;

    logic               CLK_10k;


// =================== Early PART ===================

    xor_block xor_early_prn (
        .a(data_in),    
        .b(prn_early),     // PRN sujungimas
        .y(prn_e)
    );
    
    xor_block xor_early_i (
        .a(prn_e),      
        .b(sin),        // SIN sujungimas
        .y(xor_e_i)
    );

    xor_block xor_early_q (
        .a(prn_e),    
        .b(cos),        // COS sujungimas
        .y(xor_e_q)
    );

    summation_sqr power_early_i (
    .clk(CLK),          // Main clock signal
    .rst(RST),          // Reset signal
    .clk_10(CLK_10k),   // Flag signal (indicates end of accumulation period)
    .in(xor_e_i),       // Input value (I/Q component)
    .sum(power_e_i)     // Output summed and squared value
    );

    summation_sqr power_early_q (
    .clk(CLK),          // Main clock signal
    .rst(RST),          // Reset signal
    .clk_10(CLK_10k),   // Flag signal (indicates end of accumulation period)
    .in(xor_e_q),       // Input value (I/Q component)
    .sum(power_e_q)     // Output summed and squared value
    );

    assign power_early = power_e_i + power_e_q;

// =================== Late PART ===================

    xor_block xor_late_prn (
        .a(data_in),    
        .b(prn_late),     // PRN sujungimas
        .y(prn_l)
    );
    
    xor_block xor_late_i (
        .a(prn_l),      
        .b(sin),        // SIN sujungimas
        .y(xor_l_i)
    );

    xor_block xor_late_q (
        .a(prn_l),    
        .b(cos),        // COS sujungimas
        .y(xor_l_q)
    );

    summation_sqr power_late_i (
    .clk(CLK),          // Main clock signal
    .rst(RST),          // Reset signal
    .clk_10(CLK_10k),   // Flag signal (indicates end of accumulation period)
    .in(xor_l_i),       // Input value (I/Q component)
    .sum(power_l_i)     // Output summed and squared value
    );

    summation_sqr power_late_q (
    .clk(CLK),          // Main clock signal
    .rst(RST),          // Reset signal
    .clk_10(CLK_10k),   // Flag signal (indicates end of accumulation period)
    .in(xor_l_q),       // Input value (I/Q component)
    .sum(power_l_q)     // Output summed and squared value
    );

   assign power_late = power_l_i + power_l_q;

// =================== Costas Loop ===================

    
    top_costas Costas_Loop (
    .CLK(CLK),
    .RST(RST),
    .data_in(data_in),
    .prn_in(prn_present),
    .CLK_10k(CLK_10k),

    .data_out(data_out)
);

// =================== Prescaler ===================

    prescaler_10k Prescaler (
        .clk(CLK),
        .rst(RST),
        .clk_out(CLK_10k)
    );

endmodule