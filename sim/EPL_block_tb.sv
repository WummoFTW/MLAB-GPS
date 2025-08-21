`timescale 1ns / 1ps

module EPL_tb;
    reg reset, clock_16M, clock_50, signal;
    reg [31:0] simulated_error;
    wire clock_sample, clock_1_023M, clock_1_023M_half_chip, clock_signal;
    reg [15:0] counter, counter1 = 15, counter2 = 7;
    wire [1022:0] CA_table;
    wire message;
    reg print = 0;
    reg [15:0][7:0] storage;

    prescaler_accum helper_clk_sample(
        .clk_in(clock_16M),
        .rst(reset),
        .clk_out(clock_sample)
    );
    prescaler_1_023M helper_clk_1_023M(
        .clk_in(clock_16M),
        .rst(reset),
        .clk_0(clock_1_023M),
        .clk_2(clock_1_023M_half_chip)
    );

    DLL_control_clock helper_clk_signal(
        .clk_in(clock_16M),
        .rst(reset),
        .fcw_correction(simulated_error),
        .clk_out(clock_signal)
    );

    CA_master helper_CA_data(
        .rst(reset),
        .prn_select(5'd1),
        .CA_code(CA_table)
    );


    Tester helper_signal_gen(
        .rst(reset),
        .CLK_16M(clock_16M),
        .clk_50(clock_50),
        .clk_1023M(clock_signal),
        .CA_code(CA_table),
        .phase(10'd1019),
        .tap(signal)
    );

    EPL_block uut(
        .rst(reset),
        .clk_16M(clock_16M),
        .clk_1_023M(clock_1_023M),
        .clk_1_023M_hc(clock_1_023M_half_chip),
        .clk_sample(clock_sample),
        .sig_in(signal),
        .phase(10'd1019),
        .CA_table(CA_table),
        .message(message)
    );
    

    initial begin
        reset = 0;
        clock_16M = 0;
        simulated_error = 32'd0;
        counter = 0;
        
        #100 reset = 1;
        #100 reset = 0;
        
        forever begin
            #31.25 clock_16M = ~clock_16M;
        end
    end

    initial begin
        clock_50 = 0;
        #200;
        forever begin
            #10_000_000 clock_50 = ~clock_50;
        end
    end

    always @(posedge clock_16M) begin
        if(counter < 10000 && counter % 2500 == 0) begin
            simulated_error <= simulated_error + 300000;
        end
        else if(counter < 30000 && counter % 2500 == 0) begin
            simulated_error <= simulated_error - 300000;
        end
        else if(counter == 30000) begin
            simulated_error <= 0;
        end
        else if(counter < 60000 && counter % 2500 == 0) begin
            if(counter % 5000 == 0) begin
                simulated_error <= simulated_error + $urandom % 100000;
            end
            else begin
                simulated_error <= simulated_error - $urandom % 100000;
            end
        end
        else if(counter > 60000) begin
        end
        counter++;
    end
    
    //Kazkass netaip. Jauciu duomenys perduodami keistai
    always_ff @(posedge clock_50) begin
        if(print) begin
            for(counter1 = 0; counter1 < 16; counter1++) begin
                $write("%0c", storage[counter1]);
            end
            $write("\n");
            print <= 0;
            $finish;
        end
        else begin
            storage[counter1] <= storage[counter1] >> 1;
            storage[counter1][7] <= message;

            if(counter2 == 0) begin
                counter2 <= 7;
                counter1 <= counter1 - 1;
                if(counter1 == 0) begin
                    print <= 1;
                end
            end
            else begin
                counter2 <= counter2 - 1;
            end
        end
    end
endmodule