module ram_1bit_out (
    input wire      clk,
    input wire      rst,
    input wire      data_in
);
    reg [80:0]  ram ;
    reg [80:0]  ram_inv ;
    reg [6:0]   address  = 7'b0;

    
    

    // input data based on the address
    always_ff @(posedge clk) begin
        if (rst)
            ram <= 80'd0;
        else
            ram <= ram << 1;
            ram[0] <= data_in;
            ram_inv <= ram_inv << 1;
            ram_inv[0] <= ~data_in;
    end
endmodule
