module dll_filter (
    input  logic               clk,         // Clock signal
    input  logic               rst,         // Reset signal
    input  logic        [28:0] p_e,         // Power early
    input  logic        [28:0] p_l,         // Power late
    output logic signed [28:0] correction   // Correction signal for carrier NCO
);
    logic signed [28:0] filtered;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            filtered <= 28'd0;
            
        end else begin
            filtered <= p_e - p_l; 
        end
    end

    assign correction = filtered;
endmodule
