`timescale 1ns / 1ps

module tb_top;

    // Testbench signals

    reg               CLK;
    reg               RST;
    reg   [24:0]      ram_address; // Address for the RAM_module
    wire              data_in;
    wire              data_out;

    logic [24:0]      i;
    

    reg               CLK_1023;
    reg               CLK_50;
    reg               CLK_waterfall;
    wire              ADC_data;
    reg               data_dummy;
    wire              debug_clk;

    // Instantiate the top module

    ADC_sim ADC (
    .clk(CLK),
    .D_in(data_in),
    .D_out(ADC_data)
    );

    top uut (
        .RST(RST),
        .CLK_16M(CLK),
        .D_in(ADC_data),
        .PRN(5'd1),
        .doppler_tw(32'd4294967),
        .phase(10'd4),
        .CA_out(data_out),
        .max_ID(),
        .accum_0(),
        .accum_max()
    );

    Tester Data_input (
        .rst(RST),
        .CLK_16M(CLK),
        .clk_1023M(CLK_1023),       //uut.ref_1_023M.clk_0
        .clk_50(CLK_50),
        .CA_code(uut.CA_table),
        .phase(10'd8),
        .tap(data_in)
    );


    ram_1bit_out Data_output (
    .clk(CLK_50),
    .rst(RST),
    .data_in(data_out)
    );  



    // Clock generation 
    initial begin
        CLK = 0;
        forever #31.25 CLK = ~CLK; // 16 MHz clock period (62.5 ns)
    end

    // Clock generation for 1.023 MHz (period ≈ 977.5 ns)
    initial begin
        CLK_1023 = 0;
        forever #488.75 CLK_1023 = ~CLK_1023; // Half-period ≈ 488.75 ns
    end

    // Clock generation (50 Hz for example)
    initial begin
        CLK_50 = 0;
        forever #10_000_000 CLK_50 = ~CLK_50; // 50 Hz clock period (10 ms)
    end

    initial begin
        CLK_waterfall = 0;
        forever #2000_000 CLK_waterfall = ~CLK_waterfall; // 10 MHz clock period (100 ns)
    end

    always @(posedge CLK_waterfall) begin  // For the waterfalls !!!
        integer i;
        
        for (i = 0; i < 128; i = i + 1) begin
            $write("%0d ", $signed(uut.coefficient[i]));
        end
        $write("\n");
    end



    // Testbench routine
    initial begin
        // Apply initial reset
        data_dummy = 1'b1;
        RST = 1'b1;
        
        #500;                   // Hold reset for 50 ns

        RST = 1'b0;               // Release reset

    end

    
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            i <= 24'd0;
            ram_address <= 0;
        end else if(ram_address == 24'd15999999)begin
                ram_address <= ram_address + 1;
                $stop;
        end else if(ram_address == 24'd10)begin
                ram_address <= ram_address + 1;
                
    
        end else begin
            
            ram_address <= ram_address + 1; 
        end
    end

endmodule


