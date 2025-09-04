module correlator#(
    parameter cell_offset
) (
    input           rst,
    input           sig_in,
    input  [9:0]    Phase,
    input  [1022:0] CACODE,
    input           CLK_16M,
    input           en_gen,
    input           en_sample,

    output [31:0]   koef,
    output          CA_tap

);



CA_ref_generator #(
    .offset(cell_offset)
) Shifter (
    .rst(rst),
    .clk(CLK_16M),
    .gen_en(en_gen),
    .phase(Phase),
    .CA_code(CACODE),
    .tap(CA_tap)
);

accum Accumulator (
    .clk(CLK_16M),      // Main clock signal
    .rst(rst),          // Synchronous reset
    .in(sig_in),        // Input signal to accumulate
    .en_sample(en_sample),   // Flag to output the result
    .add_ena(CA_tap),   // Do plus or minus | 0 = + data | 1 = - data | 
    .sum(koef) 
);
    
endmodule