module Tester (
    input               rst,
    input               CLK_16M,
    input               clk_50,
    input               clk_1023M,
    input      [1022:0] CA_code,
    input         [9:0] phase,
    output logic        tap
);
    wire ca_code, doppler_shift;
    reg [6:0] addr = 0;

    reg [127:0] data = 128'h494C696B654269674269747331323334;


    always_ff @( posedge clk_50 ) begin
        addr = addr +1;
    end

    doppler_gen Doppler (
        .clk(CLK_16M),
        .rst(rst),
        .doppler(12'd4000),   // Hz
        .sin(doppler_shift)        // 1-bit output
    );

    CA_ref_generator #(
        .offset(0)
    ) Test_ref (
        .rst(rst),
        .clk(clk_1023M),
        .phase(phase),
        .CA_code(CA_code),
        .tap(ca_code)
    );

    assign tap = data[addr] ^ ca_code ^ doppler_shift;

endmodule