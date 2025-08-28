module clk_switch(
    input           rst,                // Reset
    input           clk,                // 16 MHz clock
    input           switch_sig,         // Switch clocks signal
    input           whole_en,         // 1.023 MHz clock
    input           halfchip_en,      // 1.023 MHz clock with 180 deg phase
    output logic    en_1,              // 1.023 MHz clock (phase changed depending on switch_sig)
    output logic    en_2               // 1.023 MHz clock (phase changed depending on switch_sig)
);

logic clk, not_skip;
logic [1:0] count;
logic prev_switch_sig;

assign en = whole_en ^ halfchip_en; // Twice as fast clock

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            prev_switch_sig <= 1'b0;
            count <= 0;
            en_2 <= 1'b1;
            en_1 <= 1'b0;
            not_skip <= 1'b1;
        end
        else begin
            if(en) begin
                // If count is even
                if(count[0] == 0) begin
                    if(not_skip) begin
                        en_1 <= 1'b1;
                        en_2 <= 1'b0;
                    end else begin
                        not_skip <= 1'b1;
                    end
                end
                // If count is odd
                else begin
                    if(not_skip) begin
                        en_2 <= 1'b1;
                        en_1 <= 1'b0;
                    end else begin
                        not_skip <= 1'b1;
                    end
                end
                // If edge is detected on switch_sig, increment count by one more
                if(prev_switch_sig ^ switch_sig) begin
                    count <= count + 2'd2;
                    not_skip <= 1'b0;
                end
                // Increment count
                else begin
                    count++;
                end
                // Store previous switch_sig value
                prev_switch_sig <= switch_sig;
            end else begin
                en_1 <= 1'b0;
                en_2 <= 1'b0;
            end
        end
    end
endmodule