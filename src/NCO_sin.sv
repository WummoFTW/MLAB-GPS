module NCO_sin #(parameter PHASE_WIDTH = 3, parameter TABLE_SIZE = 8) (
    input logic clk,
    input logic reset_n,
    input logic [PHASE_WIDTH-1:0] phase_error,
    output logic signed [2:0] sine,
    output logic signed [2:0] cosine
);

    // Internal phase accumulator
    logic [PHASE_WIDTH-1:0] phase_accumulator;

    // Phase increment value (can be adjusted to change output frequency)
    logic [PHASE_WIDTH-1:0] phase_increment;

    // Lookup table to store sine values (cosine values will be derived using a phase offset)
    logic signed [31:0] sine_table [0:TABLE_SIZE-1];

    // LUT address
    logic [$clog2(TABLE_SIZE)-1:0] address;
    logic [$clog2(TABLE_SIZE)-1:0] cosine_address;

    // Phase accumulator update
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            phase_accumulator <= 0;
        end else begin
            phase_accumulator <= phase_accumulator + phase_increment + phase_error;
        end
    end

    // Calculate address from phase accumulator (using the most significant bits)
    assign address = phase_accumulator[PHASE_WIDTH-1 -: $clog2(TABLE_SIZE)];
    assign cosine_address = (address + (TABLE_SIZE / 4)) % TABLE_SIZE;

    // Output sine and cosine values from the lookup table
    always_ff @(posedge clk) begin
        sine   <= sine_table[address];
        cosine <= sine_table[cosine_address];
    end

    // Initialize lookup table for sine (cosine values are derived from sine with a phase shift)
    initial begin
        // Populate the sine table with 3-bit values (-4 to 3)
        sine_table[0] = 0;
        sine_table[1] = 2;
        sine_table[2] = 3;
        sine_table[3] = 2;
        sine_table[4] = 0;
        sine_table[5] = -2;
        sine_table[6] = -3;
        sine_table[7] = -2;
    end

endmodule
