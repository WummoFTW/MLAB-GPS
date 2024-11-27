`timescale 1ns / 1ps

module tb_top_costas;

    // Testbench signals
    reg               CLK_ram;
    reg               CLK;
    reg               RST;
    reg   [21:0]      ram_address; // Address for the RAM_module
    wire              data_in;
    wire              data_out;

    logic [21:0]      i;
    wire out_clk, out_clk_10k;

    // Instantiate the top_module
    top_costas uut (
        .CLK(CLK),
        .RST(RST),
        .data_in(data_in),
        .prn_in(1'b0),
        .CLK_10k(out_clk_10k),
        .data_out(data_out)
    );

    // Instantiate the 3-bit RAM module
    ram_1bit ram_in (
        .clk(CLK),
        .rst(RST),
        .address(ram_address),
        .data_out(data_in)
    );

    ram_1bit_out ram_out (
        .clk(out_clk_10k),
        .rst(RST),
        
        .data_in(data_out)
    );

    initial begin
        CLK = 0;
        forever #50 CLK_ram = ~CLK_ram; // 100 MHz clock period (100 ns)
    end

    // Clock generation (100 MHz for example)
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK; // 100 MHz clock period (100 ns)
    end

    // =================== Prescaler ===================

    prescaler_10k Prescaler (
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
            i <= 22'd0;
            ram_address <= 0;
        end else if(ram_address == 22'd810000)begin
                $stop;
        end else begin
            
            ram_address <= ram_address + 1; 
        end
    end

endmodule
