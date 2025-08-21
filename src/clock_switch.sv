/*module clk_switch(
    input           rst,
    input           switch_sig,
    input           clk_1_023M,
    input           clk_1_023M_hc,
    input  [9:0]    phase,
    output          clk_1,
    output          clk_2,
    output [9:0]    phase_1
);

logic ena_clk;
logic prev_switch_sig;
//logic last_clk;

assign clk_1 = ~ena_clk ? 1'b0 :
                    switch_sig ? clk_1_023M :  clk_1_023M_hc;
assign clk_2 = ~ena_clk ? 1'b0 :
                   ~switch_sig ? clk_1_023M :  clk_1_023M_hc;
assign phase_1 =                ~switch_sig ?         phase :
                  phase + 10'd1 == 10'd1023 ? phase + 10'd2 :
                                              phase + 10'd1 ;

    always_ff @(posedge clk_1_023M or posedge clk_1_023M_hc or posedge rst) begin
        if(rst) begin
            ena_clk <= 1'b1;
            prev_switch_sig <= 1'b0;
        end
        else begin
            if(prev_switch_sig ^ switch_sig) begin
                ena_clk <= 1'b0;
            end
            else begin
                if(~ena_clk) begin
                    ena_clk <= 1'b1;
                end
            end
            prev_switch_sig <= switch_sig;
        end
    end
endmodule*/

module clk_switch(
    input           rst,
    input           switch_sig,
    input           clk_1_023M,
    input           clk_1_023M_hc,
    output logic    clk_1,
    output logic    clk_2
);

logic clk;
logic [1:0] count;
logic prev_switch_sig;
//logic last_clk;
/* Pasidaryt kad praleistu kas antra clocka ir taip generuotu 2 skirtingus clockus, juos valdyt is sinchroninio loopo*/
assign clk = clk_1_023M ^ clk_1_023M_hc;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            prev_switch_sig <= 1'b0;
            count <= 0;
            clk_2 <= 1'b1;
            clk_1 <= 1'b0;
        end
        else begin
            if(count[0] == 0) begin
                clk_1 <= 1'b1;
                clk_2 <= 1'b0;
            end
            else begin
                clk_2 <= 1'b1;
                clk_1 <= 1'b0;
            end

            if(prev_switch_sig ^ switch_sig) begin
                count <= count + 2'd2;
                //phase_1 <= phase + 10'd1;
            end
            else begin
                count++;
            end

            prev_switch_sig <= switch_sig;
            
        end
    end
endmodule