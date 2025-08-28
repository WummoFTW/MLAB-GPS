module DLL_control_clock(
    input  logic                clk_in,                         // base clock 16 MHz
    input  logic                rst,                            // reset
    input  logic signed [31:0]  fcw_correction,                 //Frequency control word correction
    output logic                clk_out
);

    localparam logic [63:0] base_fcw = 64'd1179459451799887360;
    logic [63:0] fcw;
    logic [63:0] phase_accumulator;
    logic prev_out;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            phase_accumulator <= 64'd0;
            fcw <= base_fcw;
        end else begin
            fcw <= base_fcw + (fcw_correction <<< 32);// Nes nesutampa dydziai
            phase_accumulator <= phase_accumulator + fcw;
            prev_out <= phase_accumulator[63];
        end
    end

    assign clk_out = (~prev_out) & phase_accumulator[63];

endmodule
