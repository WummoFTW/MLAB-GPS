module NCO_sin #(parameter PHASE_WIDTH = 3, parameter TABLE_SIZE = 8) (
    input logic clk,
    input logic rst,
    input logic [16:0] phase_error,
    output logic signed [2:0] sine,
    output logic signed [2:0] cosine
);

    // Internal phase accumulator with enough bits for addressing
    logic [33:0] phase_accumulator;

    // Phase increment value (non-zero for frequency generation)
    logic [33:0] phase_increment;

    // Lookup table to store sine values
    logic signed [2:0] sine_table [0:TABLE_SIZE-1];

    // Address signals for sine and cosine lookup
    integer address;
    integer cosine_address;

    // Phase accumulator update
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            phase_accumulator <= 0;
            phase_increment <= 3; // Set a non-zero increment to control frequency
        end else begin
            phase_accumulator <= phase_accumulator + phase_increment + phase_error;
        end
    end

    // Calculate addresses based on phase accumulator
    always_comb begin
        // Ensure valid address range by taking modulo TABLE_SIZE
        address = (phase_accumulator % TABLE_SIZE);
        cosine_address = (address + (TABLE_SIZE / 4)) % TABLE_SIZE;
    end

    // Output sine and cosine values from the lookup table
    always_ff @(posedge clk) begin
        sine   <= sine_table[address];
        cosine <= sine_table[cosine_address];
    end

    // Initialize lookup table for sine (cosine values are derived from sine with a phase shift)
    initial begin
        // Populate the sine table with 3-bit values (-4 to 3)
        sine_table[0] = 3'b000; //  0           [-4] [2] [1]
        sine_table[1] = 3'b010; //  2           [1 ] [0] [0]
        sine_table[2] = 3'b011; //  3
        sine_table[3] = 3'b010; //  2
        sine_table[4] = 3'b000; //  0
        sine_table[5] = 3'b110; // -2
        sine_table[6] = 3'b101; // -3
        sine_table[7] = 3'b110; // -2
    end

endmodule
