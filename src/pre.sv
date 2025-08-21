module pre(//Module I work on before the gym
    input        CLK_16M,
    input        RST,
    input        D_in,
    input [4:0]  PRN,
    input [31:0] doppler_tw,

    output [1022:0] CA_code,
    output          data_out,
    output          clk_1023M[3:0],
    //output          clk_1,
    //output          clk_2,
    //output          clk_3,
    output          clk_out
);

wire            D_in_doppler, doppler_decode;
wire            input_data,input_data_decode;


cycle_delay delay_2 (
    .clk(CLK_16M),
    .rst(RST),
    .data_in(D_in_doppler),
    .data_out(data_out),
    .data_out_code(input_data_decode)
);


CA_master CA_data (
    .rst(RST),
    .prn_select(PRN),
    .CA_code(CA_code) 
);

prescaler_accum calculate_flag (
    .clk_in(CLK_16M),
    .rst(RST),
    .clk_out(clk_out)
);

prescaler_1_023M ref_1_023M (
    .clk_in(CLK_16M),           // 10 MHz input clock
    .rst(RST),                  // synchronous reset
    .clk_0(clk_1023M[0]), // 0 Phase clock
    .clk_1(clk_1023M[1]), // 0.25 Phase clock
    .clk_2(clk_1023M[2]), // 0.5 Phase clock
    .clk_3(clk_1023M[3])  // 0.75 Phase clock
);

doppler_compensation doppler_comp (
    .clk(CLK_16M),    // system clock
    .rst(RST),
    .phase_step(doppler_tw), // tuning word
    .clk_out(doppler_decode)  // 1-bit output
);

assign D_in_doppler = D_in ^ doppler_decode;

endmodule