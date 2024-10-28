`timescale 1ns / 1ps

module gps_receiver_tb;
    // Declare input signals (clocks, codes, etc.)
    reg clk;
    reg rst;
    reg early_code;
    reg late_code;
    reg punctual_code;
    reg signed [15:0] carrier_signal;

    // Declare output for each part of the system you want to observe
    wire signed [15:0] I_E, Q_E;  // Early code outputs
    wire signed [15:0] I_L, Q_L;  // Late code outputs
    wire signed [15:0] I_P, Q_P;  // Punctual code outputs

    // Instantiate the system under test (SUT), which is the GPS receiver
    gps_receiver DUT (
        .clk(clk),
        .rst(rst),
        .early_code(early_code),
        .late_code(late_code),
        .punctual_code(punctual_code),
        .carrier_signal(carrier_signal),
        .I_E(I_E),
        .Q_E(Q_E),
        .I_L(I_L),
        .Q_L(Q_L),
        .I_P(I_P),
        .Q_P(Q_P)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 ns clock period

    // Initial stimulus for the testbench
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        early_code = 0;
        late_code = 0;
        punctual_code = 0;
        carrier_signal = 0;

        // Reset the system
        #20 rst = 0;

        // Provide early, late, and punctual code signals
        #30 early_code = 1; late_code = 0; punctual_code = 0;
        #50 early_code = 0; late_code = 1; punctual_code = 0;
        #50 early_code = 0; late_code = 0; punctual_code = 1;

        // Provide carrier signal variations to simulate incoming signals
        #100 carrier_signal = 16'sd1000;  // Sample carrier signal
        #100 carrier_signal = 16'sd-500;

        // End simulation after some time
        #500 $stop;
    end
endmodule
