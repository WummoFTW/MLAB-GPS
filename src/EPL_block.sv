module EPL_block(
    input           rst,              // Reset
    input           clk_16M,          // 16 MHz clock for accumulator
    input           en_1_023M,       // 1.023 MHz clock
    input           en_1_023M_hc,    // 1.023 MHz clock with 180 deg phase
    input           en_sample,       // Sample clock 16 kHz (1000 16 MHz clock cycles)
    input           sig_in,           // Signal in
    input [9:0]     phase,            // Initial phase found by search module
    input [1022:0]  CA_table,         // C/A code table required for C/A code generators

    output          message,          // Output data 50 bps
    output          lock_lost         // Signal that shows that module is not tracking signal anymore (Requires reset)
);
    wire earlyCA, lateCA, promptCA, earlyCA_hc, lateCA_hc, clk_whole, clk_halfchip, switch_clk_flag;
    wire [31:0] earlyCoeff, lateCoeff, promptCoeff, earlyCoeff_hc, lateCoeff_hc;
    wire [9:0]controlled_phase;

    // Correlators (accumulators)
    accum earlyCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(earlyCA),
        .in(sig_in),
        .en_sample(clk_sample),
        .sum(earlyCoeff)
    );
    accum earlyCorrelator_hc(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(earlyCA_hc),
        .in(sig_in),
        .en_sample(clk_sample),
        .sum(earlyCoeff_hc)
    );
    accum lateCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(lateCA),
        .in(sig_in),
        .en_sample(clk_sample),
        .sum(lateCoeff)
    );
    accum lateCorrelator_hc(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(lateCA_hc),
        .in(sig_in),
        .en_sample(clk_sample),
        .sum(lateCoeff_hc)
    );
    accum promptCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(promptCA),
        .in(sig_in),
        .en_sample(clk_sample),
        .sum(promptCoeff)
    );

    // Accumulator that averages prompt correlator output to get GPS data
    data_accum #(
        .samplesize(9'd160)
    ) data_accumulator (
        .rst(rst),
        .clk(clk_16M),
        .sample_en(clk_sample),
        .in_data(promptCoeff),
        .out_data(message)
    );

    // Module that controls phase to track the signal
    CA_phase_controller phase_control(
        .rst(rst),
        .clk(clk_16M),
        .sample_en(clk_sample),
        .initial_phase(phase),
        .earlyC(earlyCoeff),
        .earlyC_hc(earlyCoeff_hc),
        .lateC(lateCoeff),
        .lateC_hc(lateCoeff_hc),
        .promptC(promptCoeff),
        .phase(controlled_phase),
        .switch_en(switch_clk_flag),
        .lock_lost(lock_lost)
    );

    // Module that helps perform half chip phase changes
    clk_switch Clock_switcher(
        .rst(rst),
        .clk(clk_16M),
        .switch_sig(switch_clk_flag),
        .whole_en(clk_1_023M),
        .halfchip_en(clk_1_023M_hc),
        .en_1(clk_whole),
        .en_2(clk_halfchip)
    );

    // C/A code generators
    CA_ref_generator #(
        .offset(1022)
    ) EarlyCA (
        .rst(rst),
        .clk(clk_16M),
        .gen_en(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(earlyCA)
    );

    CA_ref_generator #(
        .offset(1022)
    ) EarlyCA_hc (
        .rst(rst),
        .clk(clk_16M),
        .gen_en(clk_halfchip),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(earlyCA_hc)
    );

    CA_ref_generator PromptCA (
        .rst(rst),
        .clk(clk_16M),
        .gen_en(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(promptCA)
    );

    CA_ref_generator #(
        .offset(0)
    ) LateCA_hc (
        .rst(rst),
        .clk(clk_16M),
        .gen_en(clk_halfchip),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(lateCA_hc)
    );

    CA_ref_generator #(
        .offset(1)
    ) LateCA (
        .rst(rst),
        .clk(clk_16M),
        .gen_en(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(lateCA)
    );

endmodule