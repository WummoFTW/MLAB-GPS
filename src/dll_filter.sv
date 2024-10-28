module dll_filter (
    input  logic clk,   // Clock signal
    input  logic rst,   // Reset signal
    input  logic signed [63:0] pe, // Early energy
    input  logic signed [63:0] pl, // Late energy
    output logic signed [31:0] correction // Correction signal for NCO
);
    logic signed [63:0] error;
    logic signed [31:0] filtered;

    // Calculate the error between Early and Late energies
    assign error = pe - pl;

    // Simple proportional loop filter (P-controller)
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            filtered <= 0;
        else
            filtered <= error[31:0]; // Truncate to desired bit width
    end

    //Placeholder need to add filter logic PROBABLY

    assign correction = filtered;
endmodule
