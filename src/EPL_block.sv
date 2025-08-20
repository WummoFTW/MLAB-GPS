module EPL_block(
    input           rst,              // Reset
    input           clk_16M,          // 16 MHz clock for accumulator
    input           clk_1_023M,       // 1.023 MHz clock
    input           clk_1_023M_hc,
    input           clk_sample,
    input           sig_in,           // Signal in
    input [9:0]     phase,
    input [1022:0]  CA_table,

    output          message,
    output          lock_lost
);
    wire earlyCA, lateCA, promptCA, earlyCA_hc, lateCA_hc, clk_whole, clk_halfchip, switch_clk_flag;
    wire [31:0] earlyCoeff, lateCoeff, promptCoeff, earlyCoeff_hc, lateCoeff_hc;
    wire [9:0]controlled_phase;

    accum earlyCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(earlyCA),
        .in(sig_in),
        .clk_10(clk_sample),
        .sum(earlyCoeff)
    );
    accum earlyCorrelator_hc(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(earlyCA_hc),
        .in(sig_in),
        .clk_10(clk_sample),
        .sum(earlyCoeff_hc)
    );
    accum lateCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(lateCA),
        .in(sig_in),
        .clk_10(clk_sample),
        .sum(lateCoeff)
    );
    accum lateCorrelator_hc(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(lateCA_hc),
        .in(sig_in),
        .clk_10(clk_sample),
        .sum(lateCoeff_hc)
    );
    accum promptCorrelator(
        .rst(rst),
        .clk(clk_16M),
        .add_ena(promptCA),
        .in(sig_in),
        .clk_10(clk_sample),
        .sum(promptCoeff)
    );
    data_accum #(
        .samplesize(9'd160)
    ) data_accumulator (
        .rst(rst),
        .clk(clk_sample),
        .in_data(promptCoeff),
        .out_data(message)
    );

    CA_phase_controller phase_control(
        .rst(rst),
        .clk(clk_sample),
        .initial_phase(phase),
        .earlyC(earlyCoeff),
        .earlyC_hc(earlyCoeff_hc),
        .lateC(lateCoeff),
        .lateC_hc(lateCoeff_hc),
        .promptC(promptCoeff),
        .phase(controlled_phase),
        .switch_clk(switch_clk_flag),
        .lock_lost(lock_lost)
    );

    clk_switch Clock_switcher(
        .rst(rst),
        .switch_sig(switch_clk_flag),
        .clk_1_023M(clk_1_023M),
        .clk_1_023M_hc(clk_1_023M_hc),
        .clk_1(clk_whole),
        .clk_2(clk_halfchip)
    );

    CA_ref_generator #(
        .offset(1022)
    ) EarlyCA (
        .rst(rst),
        .clk(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(earlyCA)
    );

    CA_ref_generator #(
        .offset(0)
    ) EarlyCA_hc (
        .rst(rst),
        .clk(clk_halfchip),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(earlyCA_hc)
    );

    CA_ref_generator PromptCA (
        .rst(rst),
        .clk(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(promptCA)
    );

    CA_ref_generator #(
        .offset(1)
    ) LateCA_hc (
        .rst(rst),
        .clk(clk_halfchip),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(lateCA_hc)
    );

    CA_ref_generator #(
        .offset(1)
    ) LateCA (
        .rst(rst),
        .clk(clk_whole),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(lateCA)
    );

endmodule