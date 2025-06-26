module ram_1bit_in (
    input wire clk,
    input wire rst,
    input wire [24:0] address,   // Address input for selecting data
    output reg        data_out   // data output
);
    // Define RAM with 128 locations (3-bit each)
    reg ram [15999999:0];

    // Initialize RAM values (can be modified for different patterns)
    initial begin
         $readmemb("C:\\Users\\kpetr\\Desktop\\GPS_Parallel\\sim\\sim_data\\data-NODATA-56.hex", ram);
         
    end
    

    // Output data based on the address
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 1'b0;
        else
            data_out <= ram[address];
    end
endmodule
