module system_top(
    input             DATA_IN,
    input             CLOCK_16,
    input      [4:0]  PRN_SYS,
    input      [31:0] DOPPLER_TW,
    input             RESET,
    input      [9:0]  PHASE_SYS,
    
    output reg        CA_OUTPUT,
    output reg [7:0]  MAX_ID,
    output reg [31:0] ACCUM0,
    output reg [31:0] ACCUMAX,
    output            D_OUT,
    output            LOCK_LOST
);

wire CLOCK_16, CLOCK_SAMPLE, SIGNAL;
wire RST_st, PRN_st, phase_st, doppler_tw_st, tap_connect;
wire CLOCK_1023M [3:0];
wire [1022:0] CA_TABLE;

/*design_1 vio_0 (
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
    );*/

top top_search (
    .RST(RESET),
    .CLK_16M(CLOCK_16),
    .CA_table(CA_TABLE),
    .input_data(SIGNAL),
    .CLK_1023_Phased(CLOCK_1023M),
    .CLK_10k(CLOCK_SAMPLE),
    //.D_in(DATA_IN),
    //.PRN(PRN_SYS),
    //.doppler_tw(DOPPLER_TW),
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

EPL_block top_tracker (
    .rst(RESET),
    .clk_16M(CLOCK_16),
    .clk_1_023M(CLOCK_1023M[0]),
    .clk_1_023M_hc(CLOCK_1023M[2]),
    .clk_sample(CLOCK_SAMPLE),
    .sig_in(SIGNAL),
    .phase(PHASE_SYS),
    .CA_table(CA_TABLE),
    .message(D_OUT),
    .lock_lost(LOCK_LOST)
);

/*stimulus_main signal_generator (
    .rst(RESET),
    .CLK_16M(CLOCK_16),
    .clk_50(),
    .clk_1023M(),
    .CA_code(DATA_IN),
    .phase(phase),
    .tap(tap_connect)
);*/

endmodule