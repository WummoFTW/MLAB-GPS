`timescale 1ns / 1ps

module tb_top;

    // Testbench signals
    reg               CLK_ram;
    reg               CLK;
    reg               RST;
    reg   [24:0]      ram_address; // Address for the RAM_module
    wire              data_in;
    wire              data_out;

    logic [24:0]      i;
    wire out_clk, out_clk_10k;

    reg               CLK_1023;
    reg               CLK_50;

    // Instantiate the top module
    top uut (
        .CLK(CLK),
        .RST(RST),
        .data_in(data_in),
        .CLK_1_023M(CLK_1023),
        .data_out(data_out)
    );

    // Instantiate the 1-bit RAM module
    ram_1bit_in ram_in (
        .clk(CLK),
        .rst(RST),
        .address(ram_address),
        .data_out(data_in)
    );

    ram_1bit_out ram_out (
        .clk(CLK_50),
        .rst(RST),
        
        .data_in(data_out)
    );



    // Clock generation (100 MHz for example)
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK; // 10 MHz clock period (100 ns)
    end

    // Clock generation for 1.023 MHz (period ≈ 977.5 ns)
    initial begin
        CLK_1023 = 0;
        forever #488.75 CLK_1023 = ~CLK_1023; // Half-period ≈ 488.75 ns
    end

    // Clock generation (50 Hz for example)
    initial begin
        CLK_50 = 0;
        forever #10000000 CLK_50 = ~CLK_50; // 10 MHz clock period (100 ns)
    end

    // =================== Prescaler ===================

    prescaler_1k Prescaler (
        .clk(CLK),
        .rst(RST),
        .clk_out(out_clk_10k)
    );



    

    // Testbench routine
    initial begin
        // Apply initial reset
        RST = 1'b1;
        
        #200;                   // Hold reset for 20 ns

        RST = 1'b0;               // Release reset

        

        // Simonytes Dantu tarpas
       

        // Finalize simulation
        //#1000000;
        //$stop;
    end

    
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            i <= 24'd0;
            ram_address <= 0;
        end else if(ram_address == 24'd16299999)begin
                ram_address <= ram_address + 1;
                $stop;
        end else begin
            
            ram_address <= ram_address + 1; 
        end
    end

endmodule
