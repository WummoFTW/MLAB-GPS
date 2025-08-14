module system_top(
    input             DATA_IN,
    
    output reg        CA_OUTPUT,
    output reg [7:0]  MAX_ID,
    output reg [31:0] ACCUM0,
    output reg [31:0] ACCUMAX
);

wire RESET, CLOCK_16, PRN_SYS, DOPPLER_TW, PHASE_SYS;

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

design_1 vio_0 (
    .clk(CLOCK_16),
    .probe_in0(CA_OUTPUT),
    .probe_in1(MAX_ID),
    .probe_in2(ACCUM0),
    .probe_in3(ACCUMAX),
    .probe_out0(RESET),
    .probe_out1(),
    .probe_out2(PRN_SYS),
    .probe_out3(PHASE_SYS),
    .probe_out4(DOPPLER_TW)
    );



endmodule