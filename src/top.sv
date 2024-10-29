module top (
    input CLK,
    input RST,
    input data_in,
    output signed [1:0] data_out
);
    
    logic clk_10k;

    logic signed [15:0] xor_e_sum , xor_l_sum, xor_e, xor_l;
    logic signed [31:0] suma_e_i,  suma_e_q, suma_l_q, suma_l_i;
    logic signed [31:0] sqr_e_i,  sqr_e_q, sqr_l_q, sqr_l_i;
    logic signed [63:0] squared_e_i, squared_e_q, squared_l_i, squared_l_q;
    logic signed [64:0] power_e, power_l;

    logic signed [31:0] corr, CA_corr, sin_corr;

    logic signed [15:0] xor_p;
    logic signed [31:0] suma_p_i,  suma_p_q;
    logic signed [31:0] sin, cos;
    logic prn_e, prn_p, prn_l;

// =================== EARLY PART ===================

xor_block xor_early (
    .a(data_in),
    .b(prn_e), // PRN sujungimas
    .y(xor_e)
);

xor_block xor_early_i (
    .a(xor_e),
    .b(sin), // SIN sujungimas
    .y(suma_e_i)
);

xor_block xor_early_q (
    .a(xor_e),
    .b(cos), // COS sujungimas
    .y(suma_e_q)
);


// =================== LATE PART ===================

xor_block xor_late (
    .a(data_in),
    .b(prn_l), // PRN sujungimas
    .y(xor_l)
);

xor_block xor_late_i (
    .a(xor_l),
    .b(sin), // SIN sujungimas
    .y(suma_l_i)
);

xor_block xor_late_q (
    .a(xor_e),
    .b(cos), // COS sujungimas
    .y(suma_l_q)
);

// =================== Punctual PART ===================

xor_block xor_punctual (
    .a(data_in),
    .b(prn_p), // PRN sujungimas
    .y(xor_p)
);

xor_block xor_punctual_i (
    .a(xor_p),
    .b(sin), // SIN sujungimas
    .y(suma_p_i)
);

xor_block xor_punctual_q (
    .a(xor_p),
    .b(cos), // COS sujungimas
    .y(suma_p_q)
);

// =================== DLL PART ===================

dll_top DLL_to_NCO (
    .clk(CLK),          // Clock signal
    .rst(RST),          // Reset signal
    .in_e_i(suma_e_i),  // Early signal
    .in_e_q(suma_e_q),
    .in_l_i(suma_l_i),  // Late signal
    .in_l_q(suma_l_q),
    .correction(corr)   // Output correction signal for NCO
);

nco dll_nco(
    .clk(CLK),
    .rst(RST),
    .correction(corr),  // Control signal from loop filter
    .phase(CA_corr)            // NCO phase output
);

CACODE PRN_gen(
    .clk(CLK),             // Clock signal
    .rst(RST),             // Reset signal
    .prn_select(5'd1),  // PRN number (1-32)
    .correction(CA_corr),
    .ca_code_p(prn_p),  // Output C/A code PUNCTUAL (1 bit)
    .ca_code_e(prn_e),  // Output C/A code EARLY    (1 bit)
    .ca_code_l(prn_l)   // Output C/A code LATE     (1 bit)
);

// =================== Costas Loop ===================

costas_top KOSTAS(
    .clk(CLK),          // Clock signal
    .rst(RST),          // Reset signal
    .in_i(suma_p_i),    // In-phase signal
    .in_q(suma_p_q),    // Quadrature signal
    .correction(sin_corr),       // Output correction signal for NCO
    .data_output(data_out)
);

NCO_sin #(.PHASE_WIDTH(32)) Sin_NCO (
    .clk(CLK),
    .reset_n(RST),
    .phase_error(sin_corr),
    .sine(sin),
    .cosine(cos)
    );

// =================== Prescaler ===================

prescaler_10k Prescaler (
    .clk(CLK),
    .rst(RST),
    .clk_out(clk_10k)
);

endmodule