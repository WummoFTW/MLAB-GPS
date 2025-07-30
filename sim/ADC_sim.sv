module ADC_sim (
    input       clk,
    input       D_in,
    output reg  D_out
);
    always @(posedge clk) begin 
        D_out <= D_in;
    end
endmodule