// Early / Late correlator
module EL_correlator(
    input rst,              // Reset  
    input CA_code,          // Reference C/A code
    //input clk_1_023M,       // 1.023 MHz clock
    input clk_16M,          // 16 MHz clock for accumulator
    input sig_in,           // Signal in
    input clk_sample,       // Clock that determines sample count

    output logic [31:0] accum
);
    logic despread;
    assign despread = sig_in ~^ CA_code;

    always_ff @(posedge clk_16M or posedge rst) begin
        if(rst) begin
            accum <= 0;
        end
        else begin
            accum <= accum + despread;
            if (clk_sample == 1'b1) begin
                accum <= 31'd0;
            end
        end
    end

endmodule