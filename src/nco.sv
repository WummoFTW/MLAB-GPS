module nco (
    input  logic        clk,     // Clock signal
    input  logic        rst,     // Reset signal
    input  logic [31:0] correction, // Control signal from loop filter
    output logic [31:0] phase   // NCO phase output
);
    logic signed [31:0] phase_accum;

    always_ff @(posedge clk) begin //RST buvo negedge
        if (rst)
            phase_accum <= 0;
        else
            phase_accum <= phase_accum + correction;
    end

    //Missing logic (PROBS, gal veiks)

    assign phase = phase_accum;
endmodule
