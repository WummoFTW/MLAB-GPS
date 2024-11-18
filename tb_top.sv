`timescale 1ns / 1ps

module tb_top;

    // Testbench signals
    reg               CLK;
    reg               RST;
    reg  [19:0]        ram_address; // Address for the RAM_module
    wire [2:0]        data_in;
    wire signed [1:0] data_out;

    logic       [13:0] i;

    // Instantiate the top_module
    top uut (
        .CLK(CLK),
        .RST(RST),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Instantiate the 3-bit RAM module
    ram_3bit ram_in (
        .clk(CLK),
        .rst(RST),
        .address(ram_address),
        .data_out(data_in)
    );

    // Clock generation (100 MHz for example)
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK; // 100 MHz clock period (10 ns)
    end

    

    // Testbench routine
    initial begin
        // Apply initial reset
        RST = 1;
        
        #200;                   // Hold reset for 20 ns

        RST = 0;               // Release reset

        

        // Simonytes Dantu tarpas
       

        // Finalize simulation
        //#1000000;
        //$stop;
    end

    
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            i <= 14'd0;
            ram_address <= 0;
        end else begin
            
            ram_address <= ram_address + 1;
            
            end
        end

    

    // Monitor output data
    initial begin
        $monitor("Time = %0t | CLK = %b | RST = %b | ram_address = %b | data_in = %b | data_out = %d", 
                 $time, CLK, RST, ram_address, data_in, data_out);
    end

endmodule
