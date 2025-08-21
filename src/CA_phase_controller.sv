
module CA_phase_controller(
    input               rst,
    input               clk,
    input [9:0]         initial_phase,
    input signed [31:0] earlyC,
    input signed [31:0] earlyC_hc,
    input signed [31:0] lateC,
    input signed [31:0] lateC_hc,
    input [31:0]        promptC,
    output logic [9:0]  phase,
    output logic        switch_clk,
    output logic        lock_lost
);
wire [31:0] abs_early, abs_late, abs_prompt, abs_early_hc, abs_late_hc;
logic [9:0] phase_change;

assign abs_early = earlyC[31] == 1'b0 ? earlyC : ~earlyC + 1'b1;
assign abs_late = lateC[31] == 1'b0 ? lateC : ~lateC + 1'b1;
assign abs_early_hc = earlyC_hc[31] == 1'b0 ? earlyC_hc : ~earlyC_hc + 1'b1;
assign abs_late_hc = lateC_hc[31] == 1'b0 ? lateC_hc : ~lateC_hc + 1'b1;
assign abs_prompt = promptC[31] == 1'b0 ? promptC : ~promptC + 1'b1;

assign phase = initial_phase + phase_change;



    always_ff @(negedge clk or posedge rst) begin
        if(rst) begin
            phase_change <= 10'd0;
            lock_lost <= 1'b0;
            switch_clk <= 1'b0;
        end
        else begin
            /*spaghetti code
            problema db kad 1023 faze nekeicia fazes
            (phase = 1023, phase%1023=0), reiktu praleisti arba kazkaip kitaip
            FIXED hence mountain of if statements*/
            if(abs_prompt < 400) begin 
                if(abs_early_hc > abs_prompt && abs_early_hc > abs_early && abs_early + abs_early_hc > abs_late + abs_late_hc) begin
                    if(switch_clk) begin
                        switch_clk <= ~switch_clk;
                    end
                    else begin
                        switch_clk <= ~switch_clk;
                    end
                end
                else if(abs_late_hc > abs_prompt && abs_late_hc > abs_late && abs_early + abs_early_hc < abs_late + abs_late_hc) begin
                    if(switch_clk) begin
                        switch_clk <= ~switch_clk;
                        if(phase_change + 1'b1 + initial_phase == 10'd1023) begin
                            phase_change <= phase_change + 2'd2;
                        end
                        else begin
                            phase_change <= phase_change + 1'b1;
                        end
                    end
                    else begin
                        switch_clk <= ~switch_clk;
                        if(phase_change + 1'b1 + initial_phase == 10'd1023) begin
                            phase_change <= phase_change + 2'd2;
                        end
                        else begin
                            phase_change <= phase_change + 1'b1;
                        end
                    end
                end
                else begin
                    if(abs_early > 32'd200 && abs_early + abs_early_hc > abs_late + abs_late_hc) begin
                        if(phase_change - 1'b1 + initial_phase == 10'd1023) begin
                            phase_change <= phase_change - 2'd2;
                        end
                        else begin
                            phase_change <= phase_change - 1'b1;
                        end
                    end
                    else if(abs_late > 32'd200 && abs_early + abs_early_hc < abs_late + abs_late_hc) begin
                        if(phase_change + 1'b1 + initial_phase == 10'd1023) begin
                            phase_change <= phase_change + 2'd2;
                        end
                        else begin
                            phase_change <= phase_change + 1'b1;
                        end
                    end
                end
            end
            // Fiksuojamas fazes pametimas kai visu koreliatoriu vertes mazos
            if(abs_early < 32'd100 && abs_early_hc < 32'd100 && abs_prompt < 32'd100 && abs_late_hc < 32'd100 && abs_late < 32'd100) begin
                lock_lost <= 1;
            end
        end
    end
endmodule
