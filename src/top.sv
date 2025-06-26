module top (
    input             RST,
    input             CLK_16M,

    input             D_in,
    input       [4:0] PRN,
    input      [31:0] doppler_tw,
    input       [9:0] phase,

    output reg        CA_out,
    output reg [7:0]  max_ID,
    output reg [31:0] accum_0,
    output reg [31:0] accum_max
);

wire            CLK_10k;
wire [3:0]      CLK_1023_Phased;
wire [1022:0]   CA_table;
wire [127:0]    CA_output;
wire            input_data,input_data_decode;
wire            D_in_doppler, doppler_decode;

wire signed [31:0] coefficient [0:127];

wire [7:0]      CA_id;

cycle_delay delay_2 (
    .clk(CLK_16M),
    .rst(RST),
    .data_in(D_in_doppler),
    .data_out(input_data),
    .data_out_code(input_data_decode)
);


CA_master CA_data (
    .rst(RST),
    .prn_select(PRN),
    .CA_code(CA_table) 
);

prescaler_accum calculate_flag (
    .clk_in(CLK_16M),
    .rst(RST),
    .clk_out(CLK_10k)
);

prescaler_1_023M ref_1_023M (
    .clk_in(CLK_16M),           // 10 MHz input clock
    .rst(RST),                  // synchronous reset
    .clk_0(CLK_1023_Phased[0]), // 0 Phase clock
    .clk_1(CLK_1023_Phased[1]), // 0.25 Phase clock
    .clk_2(CLK_1023_Phased[2]), // 0.5 Phase clock
    .clk_3(CLK_1023_Phased[3])  // 0.75 Phase clock
);


max_index maximum (
    .data(coefficient),
    .max_idx(CA_id)
);

doppler_compensation doppler_comp (
    .clk(CLK_16M),    // system clock
    .rst(RST),
    .phase_step(doppler_tw), // tuning word
    .clk_out(doppler_decode)  // 1-bit output
);
/*
controller ctrl (
    .adder_flag(CLK_10k),
    .clk(CLK_16M),
    .rst(RST),
    .max_id(CA_id),
    .max_sum(coefficient[CA_id]),
    .phase(PHASE)
);
*/
genvar i, j;

generate
    
    for (i =0 ; i < 128 ; i = i+1) begin
        
        correlator#(
        .cell_offset(i/4)
        ) Correlator (
        .rst(RST),
        .sig_in(input_data),
        .Phase(phase),
        .CACODE(CA_table),
        .CLK_16M(CLK_16M),
        .clk_1_023M(CLK_1023_Phased[i%4]),
        .clk_10k(CLK_10k),
        .koef(coefficient[i]),
        .CA_tap(CA_output[i])
        );
        
    end
endgenerate
assign D_in_doppler = D_in ^ doppler_decode;
assign CA_out = input_data ^ CA_output[CA_id];
assign max_ID = CA_id;
assign accum_0 = coefficient[0];
assign accum_max = coefficient[CA_id];


// Reikia kokiu 4 vnt vidurkinto MAX_id


/*
How to find whether to shift the search window

Find max value if its below BIT certain threshold - shift
*/



endmodule
/*
========= TODO ==========

Try dont resample 
Do the same clock

USE NOT XOR 

==================

[V] add_ena


=============== Progress ================



*/