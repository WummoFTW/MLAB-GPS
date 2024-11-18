module ram_3bit (
    input wire clk,
    input wire rst,
    input wire [19:0] address,   // Address input for selecting data
    output reg [2:0] data_out   // 3-bit data output
);
    // Define RAM with 128 locations (3-bit each)
    reg [2:0] ram [1048575:0];

    // Initialize RAM values (can be modified for different patterns)
    initial begin
         $readmemb("C:\\Users\\newadmin\\Desktop\\Costas_tests\\sim\\BPSK_signed.bin", ram);
         
    end

    // Output data based on the address
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 3'b000;
        else
            data_out <= ram[address];
    end
endmodule
