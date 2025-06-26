module doppler_gen (
    input          clk,
    input          rst,
    input   [12:0] doppler,   // Hz
    output reg     sin        // 1-bit output
);

    
    localparam logic [3:0] LUT = 4'b1100;
    
    localparam int                PHASE_W = 32; // accumulator width
    localparam int unsigned       CLK_HZ  = 16_000_000;
    localparam longint unsigned   TWO_POW32 = 64'd4294967296; // 2^32

    
    logic [PHASE_W-1:0] tuning_word;
    always_comb
        tuning_word = 4294967;//int'((doppler * TWO_POW32) / CLK_HZ); // all integer maths

    
    logic [PHASE_W-1:0] phase_acc;
    always_ff @(posedge clk or posedge rst)
        if (rst)
            phase_acc <= '0;
        else
            phase_acc <= phase_acc + tuning_word;

    
    logic [1:0] addr;
    always_comb addr = phase_acc[PHASE_W-1 -: 2]; // MS-bits → 0-3
    always_comb sin  = LUT[addr];

endmodule
