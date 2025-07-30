module doppler_compensation (
    input          clk,         // system clock
    input          rst,         // active-high reset
    input   [31:0] phase_step,  // tuning word
    output reg     clk_out      // 1-bit output
);

    logic [31:0] phase_q;

    // phase accumulator + square-wave MSB
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin                       // reset clears everything
            phase_q <= '0;
            clk_out <= 1'b0;
        end else begin
            phase_q <= phase_q + phase_step; // DDS accumulate
            clk_out <= phase_q[31];          // MSB is the square wave
        end
    end

endmodule
