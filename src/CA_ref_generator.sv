
module CA_ref_generator#( //was CA_shifter
    parameter int offset = 0
) (
    input               rst,
    input               clk,
    input         [9:0] phase,
    input      [1022:0] CA_code,

    output logic        tap
);
    logic [9:0] bit_address;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_address <= 10'd0;
        end else begin
            bit_address <= bit_address + 1;
        end
    end

    always_comb begin
        tap = CA_code[(phase + offset + bit_address) % 1023];  // wrap-around
    end

endmodule


/*
module CA_ref_generator#(
    parameter int offset = 0,
    parameter int shift = 0
)(
    input               rst,
    input               clk,  
    input        [9:0]  phase,
    input     [1022:0]  CA_code,

    output logic        tap
);

    logic [9:0] bit_address;
    logic [1:0] sub_chip_counter;

    // Main chip address counter
    always_ff @(posedge clk) begin
        if (rst) begin
            bit_address <= 10'd0;
            sub_chip_counter <= shift;
        end else begin
            sub_chip_counter <= sub_chip_counter + 1;
            if(sub_chip_counter == 2'b11) begin
                bit_address <= bit_address + 1;
            end
        end
    end

   

    always_comb begin
        tap = CA_code[(phase + offset + bit_address) % 1023];
    end

endmodule


*/