module sign_function (
    input  logic clk,   // Clock signal
    input  logic [13:0] in,  // Input signal
    output logic  out   // Sign output (+1 or -1)
);

    always_comb begin
        if (in >= 14'd5000)
            out = 1'b0;  // +1
        else
            out = 1'b1;  // -1 (Two's complement representation)
    end

endmodule
