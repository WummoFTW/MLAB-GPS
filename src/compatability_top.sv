module compat_top(
    input             DATA_IN,
    input             CLOCK_16,
    input      [4:0]  PRN_SYS,
    input      [31:0] DOPPLER_TW,
    input             RESET,
    input      [9:0]  PHASE_SYS,
    
    output reg        CA_OUTPUT,
    output reg [7:0]  MAX_ID,
    output reg [31:0] ACCUM0,
    output reg [31:0] ACCUMAX
);

wire CLOCK_SAMPLE, SIGNAL;
wire CLOCK_1023M [3:0];
wire [1022:0] CA_TABLE;

top top_search (
    .RST(RESET),
    .CLK_16M(CLOCK_16),
    .CA_table(CA_TABLE),
    .input_data(SIGNAL),
    .CLK_1023_Phased(CLOCK_1023M),
    .CLK_10k(CLOCK_SAMPLE),
    .phase(PHASE_SYS),
    .CA_out(CA_OUTPUT),
    .max_ID(MAX_ID),
    .accum_0(ACCUM0),
    .accum_max(ACCUMAX)
);

pre pre_wrapper (
    .CLK_16M(CLOCK_16),
    .RST(RESET),
    .D_in(DATA_IN),
    .PRN(PRN_SYS),
    .doppler_tw(DOPPLER_TW),
    .CA_code(CA_TABLE),
    .data_out(SIGNAL),
    .clk_1023M(CLOCK_1023M),
    .clk_out(CLOCK_SAMPLE)
);

endmodule