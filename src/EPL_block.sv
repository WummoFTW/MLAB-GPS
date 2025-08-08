module EPL_block(
    input           rst,              // Reset
    input           clk_16M,          // 16 MHz clock for accumulator
    input           clk_1_023M,       // 1.023 MHz clock
    input           clk_sample,
    input           sig_in,           // Signal in
    input [9:0]      phase,
    input [1022:0]  CA_table,

    output          lock_lost
);
    wire earlyCA, lateCA;
    wire [31:0] earlyCoeff, lateCoeff;
    wire [9:0]controlled_phase;

    EL_correlator earlyCorrelator(
        .rst(rst),
        .CA_code(earlyCA),
        .clk_16M(clk_16M),
        .sig_in(sig_in),
        .clk_sample(clk_sample),
        .accum(earlyCoeff)
    );
    EL_correlator lateCorrelator(
        .rst(rst),
        .CA_code(lateCA),
        .clk_16M(clk_16M),
        .sig_in(sig_in),
        .clk_sample(clk_sample),
        .accum(lateCoeff)
    );

    CA_phase_controller phase_control(
        .rst(rst),
        .clk(clk_sample),
        .initial_phase(phase),
        .earlyC(earlyCoeff),
        .lateC(lateCoeff),
        .phase(controlled_phase),
        .lock_lost(lock_lost)
    );

    CA_ref_generator #(
        .offset(0)//Reiktu padaryt kad prompt kodo generatorius turetu offset 1 arba kazkaip kitaip realizuoti chipu offsetus
    ) EarlyCA (
        .rst(rst),
        .clk(clk_1_023M),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(earlyCA)
    );
    CA_ref_generator #(
        .offset(2)
    ) LateCA (
        .rst(rst),
        .clk(clk_1_023M),
        .phase(controlled_phase),
        .CA_code(CA_table),
        .tap(lateCA)
    );
endmodule