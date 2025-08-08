`timescale 1ns / 1ps

module EPL_tb;
    reg reset, clock_16M, signal;
    reg [9:0] simulated_error;
    wire clock_sample, clock_1_023M, CA_signal;
    reg [15:0] counter;
    wire [1022:0] CA_table;

    prescaler_accum helper_clk_sample(
        .clk_in(clock_16M),
        .rst(reset),
        .clk_out(clock_sample)
    );

    prescaler_1_023M helper_clk_1_023M(
        .clk_in(clock_16M),
        .rst(reset),
        .clk_0(clock_1_023M)
    );

    CA_master helper_CA_data(
        .rst(reset),
        .prn_select(5'd1),
        .CA_code(CA_table)
    );
    CA_ref_generator #(
        .offset(1)
    ) helper_CA_code_gen(
        .rst(reset),
        .clk(clock_1_023M),
        .phase(simulated_error),
        .CA_code(CA_table),
        .tap(CA_signal)
    );

    assign signal = CA_signal;

    EPL_block uut(
        .rst(reset),
        .clk_16M(clock_16M),
        .clk_1_023M(clock_1_023M),
        .clk_sample(clock_sample),
        .sig_in(signal),
        .phase(10'd0),
        .CA_table(CA_table)
    );
    

    initial begin
        reset = 0;
        clock_16M = 0;
        simulated_error = 10'd0;
        counter = 0;
        #100 reset = 1;
        #100 reset = 0;
        
        forever begin
            #31.25 clock_16M = ~clock_16M;
        end
    end

    always @(posedge clock_16M) begin
        if(counter < 10000 && counter % 1000 == 0) begin
            simulated_error <= simulated_error + 1;
        end
        else if(counter < 20000 && counter % 1000 == 0) begin
            simulated_error <= simulated_error - 1;
        end
        else if(counter < 30000 && counter % 1000 == 0) begin
            simulated_error <= 0;
        end
        else if(counter < 50000 && counter % 1000 == 0) begin
            simulated_error <= $urandom % 2;
        end
        else if(counter > 50000) begin
            $finish;
        end
        counter++;
    end

    
endmodule