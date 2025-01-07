module NCO_sin(
    input  logic clk,
    input  logic rst,
    input  logic        [1:0] phase_error,
    output logic             sine,   // 1-bit output
    output logic             cosine  // 1-bit output
    
);


    logic [1:0] address,address_cos, raw_address;
    // Lookup table for 1-bit sine values (binary)
    logic [3:0] sine_table = 4'b0110;

    // Phase accumulator and output update
    always_ff @(posedge clk) begin
        if (rst) begin
            sine <= sine_table[0];
            cosine <= sine_table[2];
            raw_address <= 3'b000;
            address <= 2'b00;
            address_cos <= 2'b01;
        end else begin
            sine <= sine_table[address];
            cosine <= sine_table[address_cos];
            address_cos <= raw_address + phase_error +1 ;
            address <= raw_address + phase_error;
            raw_address <= raw_address + 1;
            
        end
    end


endmodule
