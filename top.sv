`include "../src/costas_filter.sv"
`include "../src/costas_top.sv"
`include "../src/prescaler_10k.sv"
`include "../src/sign_function.sv"
`include "../src/summation_block.sv"
`include "../src/NCO_sin.sv"
`include "../src/xor_block.sv"




module top (
    input               CLK,
    input               RST,
    input         [2:0] data_in,
    output signed [1:0] data_out
);
    
    logic               CLK_10k;

    logic signed [15:0] xor_e_sum , xor_l_sum, xor_e, xor_l;
    logic signed [31:0] suma_e_i,  suma_e_q, suma_l_q, suma_l_i;
    logic signed [31:0] sqr_e_i,  sqr_e_q, sqr_l_q, sqr_l_i;
    logic signed [63:0] squared_e_i, squared_e_q, squared_l_i, squared_l_q;
    logic signed [64:0] power_e, power_l;

    logic signed [16:0] corr, CA_corr, sin_corr;

    logic signed [15:0] xor_p;
    logic signed [31:0] suma_p_i,  suma_p_q;
    logic signed [31:0] sin, cos;
    logic               prn_e, prn_p, prn_l;


// =================== Punctual PART ===================

xor_block xor_punctual_i (
    .a(data_in),
    .b(sin), // SIN sujungimas
    .y(suma_p_i)
);

xor_block xor_punctual_q (
    .a(data_in),
    .b(cos), // COS sujungimas
    .y(suma_p_q)
);

// =================== Costas Loop ===================

costas_top KOSTAS(
    .clk(CLK),          // Clock signal
    .clk_10(CLK_10k),
    .rst(RST),          // Reset signal
    .in_i(suma_p_i),    // In-phase signal
    .in_q(suma_p_q),    // Quadrature signal
    .correction(sin_corr),       // Output correction signal for NCO
    .data_output(data_out)
);

NCO_sin #(.PHASE_WIDTH(17)) Sin_NCO (
    .clk(CLK),
    .rst(RST),
    .phase_error(sin_corr),
    .sine(sin),
    .cosine(cos)
    );

// =================== Prescaler ===================

prescaler_10k Prescaler (
    .clk(CLK),
    .rst(RST),
    .clk_out(CLK_10k)
);

endmodule