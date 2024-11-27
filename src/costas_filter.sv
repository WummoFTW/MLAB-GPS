module costas_filter (
    input  logic        clk,     // Clock signal
    input  logic        rst,     // Reset signal
    input  logic signed [27:0] phase_error, // Phase error
    output logic signed [1:0] correction   // Correction signal for carrier NCO
);
    logic signed [31:0] filtered;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            filtered <= 0;
        else
            filtered <= phase_error[27:26];  // Truncate to desired bit width
    end

    //Placeholder need to add filter logic PROBABLY

    assign correction = filtered;
endmodule
