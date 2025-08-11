module system_top(
    input             RESET,
    input             CLOCK_16,
    input             DATA_IN,
    input       [4:0] PRN_SYS,
    input      [31:0] DOPPLER_TW,
    input       [9:0] PHASE_SYS,

    output reg        CA_OUTPUT,
    output reg [7:0]  MAX_ID,
    output reg [31:0] ACCUM0,
    output reg [31:0] ACCUMAX
);

top top_wrapper (
    .RST(RESET),
    .CLK_16M(CLOCK_16),
    .D_in(DATA_IN),
    .PRN(PRN_SYS),
    .doppler_tw(DOPPLER_TW),
    .phase(PHASE_SYS),
    .CA_out(CA_OUTPUT),
    .max_ID(MAX_ID),
    .accum_0(ACCUM0),
    .accum_max(ACCUMAX)
);

design_1_wrapper vio_0 (
    .clk_0(CLOCK_16),
    .probe_in0_0(CA_OUTPUT),
    .probe_in1_0(MAX_ID),
    .probe_in2(ACCUM0),
    .probe_in3(ACCUMAX),
    .probe_out0_0(RESET),
    .probe_out1(DATA_IN),
    .probe_out2(PRN_SYS),
    .probe_out3(PHASE_SYS),
    .probe_out4(DOPPLER_TW)
    );

endmodule