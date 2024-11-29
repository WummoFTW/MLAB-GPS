module costas_filter (
    input  logic        clk,     // Clock signal
    input  logic        rst,     // Reset signal
    input  logic        [27:0] phase_error, // Phase error
    output logic        [1:0] correction,   // Correction signal for carrier NCO
    output logic        sign
);
    logic signed [31:0] filtered;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            filtered <= 0;
            sign <= 0;
        end else begin
            filtered <= phase_error[27:26];  // Truncate to desired bit width
            sign <= phase_error[1];
        end
    end

    // HOW IS THIS WORKING WTF 
    // PLS HELP

    assign correction = filtered;
endmodule
