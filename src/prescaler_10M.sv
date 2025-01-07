module prescaler_1_023M (
    input  logic   clk,
    input  logic   rst,
    output logic   clk_out
);
    logic [19:0] counter; //10k counter to prescale to

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 20'd0;  // Reset the counter to 0
        else if (counter == 20'd1022999)
            counter <= 20'd0;  // Reset counter when it reaches 10,000
        else
            counter <= counter + 20'd1;  // Increment counter
    end

    assign clk_out = (counter == 20'd1022999);  // Generate output clock pulse every 10,000 input clock cycles
endmodule