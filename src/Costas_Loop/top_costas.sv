module top_costas (
    input               CLK,
    input               RST,
    input               data_in,
    input               prn_in,
    input               CLK_10k,

    output              data_out
);
    logic        [27:0] phase_error;
    logic        [1:0]  correction;

    logic               prn_p;
    logic               xor_p_i, xor_p_q;
    logic        [13:0] suma_p_i,  suma_p_q;

    logic               sin, cos;

    logic               polarity;

// =================== Punctual PART ===================

    xor_block xor_punctual_prn (
        .a(data_in),    //Data_in pakeist reikes
        .b(prn_in), // SIN sujungimas
        .y(prn_p)
    );
    
    xor_block xor_punctual_i (
        .a(prn_p),  //Data_in pakeist reikes
        .b(sin),    // SIN sujungimas
        .y(xor_p_i)
    );

    xor_block xor_punctual_q (
        .a(prn_p),    //Data_in pakeist reikes
        .b(cos), // COS sujungimas
        .y(xor_p_q)
    );

    summation_block sum_block_i (
        .clk(CLK),
        .rst(RST),
        .clk_10(CLK_10k),
        .in(xor_p_i),
        .sum(suma_p_i)
    );

    summation_block sum_block_q (
        .clk(CLK),
        .rst(RST),
        .clk_10(CLK_10k),
        .in(xor_p_q),
        .sum(suma_p_q)
    );

    // Calculate the phase error
    assign phase_error = suma_p_q * suma_p_i;

    sign_function d_out(
        .clk(CLK),          // Clock signal
        .in(suma_p_i),      // Input signal
        .sign(polarity),
        .out(data_out)   // Sign output (+1 or -1)
    );

    costas_filter cost_filt (
        .clk(CLK_10k),
        .rst(RST),
        .phase_error(phase_error),
        .correction(correction),
        .sign(polarity)
    );

    NCO_sin Sin_NCO (
        .clk(CLK),
        .rst(RST),
        .phase_error(correction),
        .sine(sin),
        .cosine(cos)
    );

endmodule