module prescaler_accum (
    input  logic   clk_in,
    input  logic   rst,
    output logic   clk_out
);
    parameter samples = 14'd1000;
    logic [13:0] counter; //10k counter to prescale to

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst)
            counter <= 14'd0;  // Reset the counter to 0
        else if (counter == samples - 14'd1)
            counter <= 14'd0;  // Reset counter when it reaches 10,000
        else
            counter <= counter + 14'd1;  // Increment counter
    end

    assign clk_out = (counter == samples - 14'd1);  // Generate output clock pulse every 10,000 input clock cycles
endmodule
