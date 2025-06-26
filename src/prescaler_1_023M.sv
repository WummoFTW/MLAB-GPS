/*
module prescaler_1_023M (
    input  logic clk_in,   // 10 MHz input
    input  logic rst,      // active-high reset
    output logic clk_0,    // 0 pulse
    output logic clk_1,    // 90 pulse
    output logic clk_2,    // 180 pulse
    output logic clk_3     // 270 pulse
);

    localparam int unsigned DDS_INC = 32'd439375154;

    logic [31:0] phase_accumulator;
    logic [1:0]  current_phase, previous_phase;

    // Phase pulse outputs
    logic [3:0] phase_pulse;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            phase_accumulator <= 32'd0;
            previous_phase    <= 2'd0;
            phase_pulse       <= 4'd0;
        end else begin
            // Accumulate phase
            phase_accumulator <= phase_accumulator + DDS_INC;

            // Determine top 2 bits (current phase index)
            current_phase <= phase_accumulator[31:30];

            // Generate 1-cycle pulse when phase changes
            if (current_phase != previous_phase) begin
                // One-hot pulse corresponding to current phase
                phase_pulse <= 4'b0001 << current_phase;
            end else begin
                phase_pulse <= 4'b0000;  // no pulse
            end

            // Update previous phase
            previous_phase <= current_phase;
        end
    end

    // Assign to outputs
    assign clk_0 = phase_pulse[0];
    assign clk_1 = phase_pulse[1];
    assign clk_2 = phase_pulse[2];
    assign clk_3 = phase_pulse[3];

endmodule

*/
/*
module prescaler_1_023M (
    input  logic clk_in,   // base clock 10 MHz
    input  logic rst,      // reset
    output logic clk_0,    // 0 pulse
    output logic clk_1,    // 90 pulse
    output logic clk_2,    // 180 pulse
    output logic clk_3     // 270 pulse
);

    localparam logic [50:0] DDS_INC = 51'd143974450587501;

    logic [50:0] phase_accumulator;
    logic [1:0]  current_phase, previous_phase;
    logic [3:0]  phase_pulse;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            phase_accumulator <= 51'd0;
            previous_phase    <= 2'd0;
            phase_pulse       <= 4'd0;
        end else begin
            phase_accumulator <= phase_accumulator + DDS_INC;
            current_phase <= phase_accumulator[50:49];

            if (current_phase != previous_phase) begin
                phase_pulse <= 4'b0001 << current_phase;
            end else begin
                phase_pulse <= 4'b0000;
            end

            previous_phase <= current_phase;
        end
    end

    assign clk_0 = phase_pulse[0];
    assign clk_1 = phase_pulse[1];
    assign clk_2 = phase_pulse[2];
    assign clk_3 = phase_pulse[3];

endmodule
*/

module prescaler_1_023M (
    input  logic clk_in,   // base clock 16 MHz
    input  logic rst,      // reset
    output logic clk_0,    // 0 pulse
    output logic clk_1,    // 90 pulse
    output logic clk_2,    // 180 pulse
    output logic clk_3     // 270 pulse
);

    localparam logic [63:0] DDS_INC = 64'd1179459451799887360;

    logic [63:0] phase_accumulator;
    logic [1:0]  previous_phase;
    logic [3:0]  phase_pulse;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            phase_accumulator <= 64'd0;
            previous_phase    <= 2'd0;
            phase_pulse       <= 4'd0;
        end else begin
            // Declare temporary variables explicitly as automatic
            automatic logic [63:0] next_acc;
            automatic logic [1:0]  next_phase;
            
            next_acc   = phase_accumulator + DDS_INC;
            phase_accumulator <= next_acc;
            
            next_phase = next_acc[63:62];
            
            if (next_phase != previous_phase) begin
                phase_pulse <= 4'b0001 << next_phase;
            end else begin
                phase_pulse <= 4'b0000;
            end
            
            previous_phase <= next_phase;
        end
    end

    assign clk_0 = phase_pulse[0];
    assign clk_1 = phase_pulse[3];
    assign clk_2 = phase_pulse[2];
    assign clk_3 = phase_pulse[1];

endmodule
