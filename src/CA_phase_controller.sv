module CA_phase_controller(
    input               rst,
    input               clk,
    input               initial_phase,
    input [31:0]        earlyC,
    input [31:0]        lateC,
    output logic [9:0]  phase,
    output logic        lock_lost
);
wire signed [31:0] correlator_diff;
wire [31:0] abs_diff;
assign correlator_diff = earlyC - lateC;
assign abs_diff = correlator_diff[31] == 0 ? correlator_diff : ~correlator_diff+1'b1;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            phase <= initial_phase;
            lock_lost <= 0;
        end
        else begin
            if(abs_diff > 32'd400) begin
                phase <= correlator_diff[31] == 0 ? phase - 1 : phase + 1;
            end
            lock_lost <= 0; //earlyC+promptC+lateC < 1600 ? 1 : 0;
            /* Vien koreliuojant su CA kodu triuksmo lygis apie 500.
               Ziurima ar visi trys koreliatoriai triuksmo lygyje   */
        end
    end
endmodule