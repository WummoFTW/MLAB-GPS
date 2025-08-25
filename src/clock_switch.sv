module clk_switch(
    input           rst,                // Reset
    input           switch_sig,         // Switch clocks signal
    input           clk_1_023M,         // 1.023 MHz clock
    input           clk_1_023M_hc,      // 1.023 MHz clock with 180 deg phase
    output logic    clk_1,              // 1.023 MHz clock (phase changed depending on switch_sig)
    output logic    clk_2               // 1.023 MHz clock (phase changed depending on switch_sig)
);

logic clk;
logic [1:0] count;
logic prev_switch_sig;

assign clk = clk_1_023M ^ clk_1_023M_hc; // Twice as fast clock

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            prev_switch_sig <= 1'b0;
            count <= 0;
            clk_2 <= 1'b1;
            clk_1 <= 1'b0;
        end
        else begin
            // If count is even
            if(count[0] == 0) begin
                clk_1 <= 1'b1;
                clk_2 <= 1'b0;
            end
            // If count is odd
            else begin
                clk_2 <= 1'b1;
                clk_1 <= 1'b0;
            end
            // If edge is detected on switch_sig, increment count by one more
            if(prev_switch_sig ^ switch_sig) begin
                count <= count + 2'd2;
            end
            // Increment count
            else begin
                count++;
            end
            // Store previos switch_sig value
            prev_switch_sig <= switch_sig;
        end
    end
endmodule