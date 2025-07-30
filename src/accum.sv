/*
// 10k accum
module accum (
    input  logic        clk,       // Main clock signal
    input  logic        rst,       // Synchronous reset
    input  logic        clk_10,    // 50/50 duty cycle clock (used as flag signal)
    input  logic        in,        // Input signal to accumulate
    output logic [31:0] sum        // Output sum (latched on clk_10 rising edge)
);

    logic [31:0] accum;            // Internal accumulator
    logic        clk_10_prev;      // Previous value of clk_10
    logic        clk_10_rising;    // Detected rising edge of clk_10

    // Edge detection logic for clk_10
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            clk_10_prev <= 1'b0;
        else
            clk_10_prev <= clk_10;
    end

    assign clk_10_rising = (clk_10 == 1'b1 && clk_10_prev == 1'b0);

    // Accumulation logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            sum   <= 32'd0;
        end else if (clk_10_rising) begin
            sum   <= accum;
            accum <= 32'd0;
        end else begin
            accum <= accum + in;
        end
    end

endmodule
===========================================================================================

 // 10 accum
 module accum (
    input  logic        clk,       // Main clock signal
    input  logic        rst,       // Synchronous reset
    input  logic        in,        // Input signal to accumulate
    input  logic        clk_10,
    input  logic        add_ena,   // do plus or minus ================== 0 = + data | 1 = - data 
    output logic [31:0] sum        // Output sum every 10 inputs
);

    logic [31:0] accum;            // Internal accumulator
    logic [9:0]  count;            // Counter to track up to 10

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            count <= 4'd0;
            sum   <= 32'd0;
        end else begin
            accum <= accum + in;
            count <= count + 1;

            if (count == 10'd1023) begin
                sum   <= accum + in; // Include current input
                accum <= 32'd0;
                count <= 10'd0;
            end
        end
    end

endmodule


*/
 
 // 10 accum
 module accum (
    input  logic        clk,        // Main clock signal
    input  logic        rst,        // Synchronous reset
    input  logic        in,         // Input signal to accumulate
    input  logic        clk_10,     // Flag to output the result
    input  logic        add_ena,    // do plus or minus ================== 0 = + data | 1 = - data 
    output logic [31:0] sum         // Output sum every 10 inputs
);

    logic [31:0]  accum;            // Internal accumulator
    logic [10:0]  count;            // Counter to track up to 1023

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'd0;
            count <= 4'd0;
            sum   <= 32'd0;
        end else if(add_ena == 1'b0) begin
            accum <= accum + in;
            count <= count + 1;

            if (clk_10 == 1'b1) begin
                sum   <= accum + in; 
                accum <= 32'd0;
                count <= 10'd0;
            end
        end else if(add_ena == 1'b1) begin
            accum <= accum - in;
            count <= count + 1;

            if (clk_10 == 1'b1) begin
                sum   <= accum - in; 
                accum <= 32'd0;
                count <= 10'd0;
            end
        end
    end

endmodule
