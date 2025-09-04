
module CA_phase_controller(
    input               rst,                // Reset
    input               clk,                // 16 MHz Clock
    input               sample_en,          // Enables data sampling
    input [9:0]         initial_phase,      // Phase found by search module
    input signed [31:0] earlyC,             // 1 chip early correlator output
    input signed [31:0] earlyC_hc,          // 0.5 chip early correlator output (hc == half chip)
    input signed [31:0] lateC,              // 1 chip late correlator output
    input signed [31:0] lateC_hc,           // 0.5 chip late correlator output (hc == half chip)
    input [31:0]        promptC,            // Prompt correlator output
    output logic [9:0]  phase,              // Phase given to C/A code generators
    output logic        switch_en,         // Signal to switch clock phase by 180 deg
    output logic        lock_lost           // Signal that shows that module is not tracking signal anymore
);

localparam CHANGE_THRESHOLD = 32'd400;      // Threshold at which correction is needed
localparam CHIP_CHANGE_THRESHOLD = 32'd200; // Threshold at which 1 chip correction is needed
localparam NOISE_FLOOR = 32'd100; // Any value lower than this is considered noise

wire [31:0] abs_early, abs_late, abs_prompt, abs_early_hc, abs_late_hc;
logic [9:0] phase_change;
wire el_compare;
logic delay_cycle;

assign abs_early = earlyC[31] == 1'b0 ? earlyC : ~earlyC + 1'b1;                // Absolute 1 chip early value
assign abs_late = lateC[31] == 1'b0 ? lateC : ~lateC + 1'b1;                    // Absolute 1 chip late value
assign abs_early_hc = earlyC_hc[31] == 1'b0 ? earlyC_hc : ~earlyC_hc + 1'b1;    // Absolute half chip early correlator value
assign abs_late_hc = lateC_hc[31] == 1'b0 ? lateC_hc : ~lateC_hc + 1'b1;        // Absolute half chip late correlator value
assign abs_prompt = promptC[31] == 1'b0 ? promptC : ~promptC + 1'b1;            // Absolute prompt correlator value
assign el_compare = abs_early + abs_early_hc > abs_late + abs_late_hc ? 1 : 0;  // Shows which is bigger early correlator sum or late correlator sum
assign phase = initial_phase + phase_change;                                    // Calculates phase for C/A code generators


// Phase 0 and 1023 is considered the same by C/A code generators
// This function avoids 1023 phase
function [9:0] change_phase (
    input [9:0] phase_change, phase,    
    input operation                     // Operation decides whether 1 chip should be added ( + operation == 1) or subtracted ( - operation == 0) 
);   
    begin
        case (operation)
            1'b0:
                if(phase - 1'b1 == 10'd1023) begin
                    change_phase = phase_change - 2'd2;
                end
                else begin
                    change_phase = phase_change - 1'b1;
                end
            1'b1:
                if(phase + 1'b1 == 10'd1023) begin
                    change_phase = phase_change + 2'd2;
                end
                else begin
                    change_phase = phase_change + 1'b1;
                end
            default:;
        endcase
    end
endfunction

    always_ff @(negedge clk or posedge rst) begin
        if(rst) begin
            phase_change <= 10'd0;
            lock_lost <= 1'b0;
            switch_en <= 1'b0;
            delay_cycle <= 1'b0;
        end
        else begin
            delay_cycle <= sample_en;
            if(delay_cycle) begin
                // If correction is needed
                if(abs_prompt < CHANGE_THRESHOLD) begin
                    // If half chip early correlator ouput is biggest, correct by half chip
                    if(abs_early_hc > abs_prompt && abs_early_hc > abs_early && el_compare) begin
                        switch_en <= ~switch_en;
                    end
                    // If half chip late correlator ouput is biggest, correct by half chip
                    else if(abs_late_hc > abs_prompt && abs_late_hc > abs_late && !el_compare) begin
                        switch_en <= ~switch_en;
                        phase_change <= change_phase(phase_change, phase, 1'b1);
                    end
                    else begin
                        // If early correlator ouput reaches the threshold, correct by 1 chip
                        if(abs_early > CHIP_CHANGE_THRESHOLD && el_compare) begin
                            phase_change <= change_phase(phase_change, phase, 1'b0);
                        end
                        // If late correlator ouput reaches the threshold, correct by 1 chip
                        else if(abs_late > CHIP_CHANGE_THRESHOLD && !el_compare) begin
                            phase_change <= change_phase(phase_change, phase, 1'b1);
                        end
                    end
                end
                // If all of the correlators are below noise floor, lock is lost
                if( abs_early < NOISE_FLOOR &&
                    abs_early_hc < NOISE_FLOOR &&
                    abs_prompt < NOISE_FLOOR &&
                    abs_late_hc < NOISE_FLOOR &&
                    abs_late < NOISE_FLOOR )
                begin
                    lock_lost <= 1;
                end
            end
        end
    end
endmodule
