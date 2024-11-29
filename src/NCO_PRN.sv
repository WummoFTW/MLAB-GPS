module NCO_PRN (
    input  logic                clk,       // Clock signal
    input  logic                rst,       // Reset signal
    input  logic        [5:0]   prn_select, // PRN number (1-32)
    input  logic signed [31:0]  correction,
    output logic       ca_code_p, // Punctual C/A code (1 bit)
    output logic       ca_code_e,    // Early C/A code (1 bit)
    output logic       ca_code_l 
);

    // Shift registers for punctual, early, and late codes
    logic [9:0] g1_punctual, g2_punctual;
    logic [9:0] g1_early, g2_early;
    logic [9:0] g1_late, g2_late;

    // G2 tap points for each PRN (32 satellites)
    logic [9:0] g2_taps;

    // Correction counter
    logic [31:0] correction_counter;
    logic apply_correction;

    // PRN tap selection logic (you can replace this with actual PRN selection logic for each satellite)
    always_comb begin
        case (prn_select)
            6'd1: g2_taps = 10'b1111101100;  // PRN1 taps
            6'd2: g2_taps = 10'b1011011110;  // PRN2 taps

            // Add cases for other PRN numbers (up to PRN 32)

            default: g2_taps = 10'b1111101100; // Default to PRN1 taps
        endcase
    end

    // Correction counter control
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            correction_counter <= correction;
            apply_correction <= (correction != 0);
        end else if (apply_correction && correction_counter > 0) begin
            correction_counter <= correction_counter - 1;
            if (correction_counter == 1)
                apply_correction <= 0;
        end
    end

    // C/A code generation logic with controlled shifts
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize the registers to 1
            g1_punctual <= 10'b1111111111;
            g2_punctual <= 10'b1111111111;
            g1_early    <= 10'b1111111111;
            g2_early    <= 10'b1111111111;
            g1_late     <= 10'b1111111111;
            g2_late     <= 10'b1111111111;
        end else if (!apply_correction || correction_counter > 0) begin
            // Shift registers for punctual
            g1_punctual <= {g1_punctual[8:0], g1_punctual[9] ^ g1_punctual[2]};
            g2_punctual <= {g2_punctual[8:0], g2_punctual[9] ^ g2_punctual[7] ^ g2_taps};

            // Shift registers for early (one step ahead)
            g1_early <= {g1_punctual[7:0], g1_punctual[9] ^ g1_punctual[2], g1_punctual[8]};
            g2_early <= {g2_punctual[7:0], g2_punctual[9] ^ g2_punctual[7] ^ g2_taps, g2_punctual[8]};

            // Shift registers for late (one step behind)
            g1_late <= {g1_late[8:0], g1_late[9] ^ g1_late[2]};
            g2_late <= {g2_late[8:0], g2_late[9] ^ g2_late[7] ^ g2_taps};
        end
    end

    // Output the exclusive-OR of the last bits of G1 and G2 as the C/A code
    assign ca_code_p = g1_punctual[9] ^ g2_punctual[9];
    assign ca_code_e = g1_early[9]    ^ g2_early[9];
    assign ca_code_l = g1_late[9]     ^ g2_late[9];

endmodule
