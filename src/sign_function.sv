module sign_function (
    input  logic clk,   // Clock signal
    input  logic signed [31:0] in,  // Input signal
    output logic signed [1:0] out   // Sign output (+1 or -1)
);
    always_comb begin
        if (in > 0)
            out = 2'b01;  // +1
        else
            out = 2'b11;  // -1 (Two's complement representation)
    end
endmodule
