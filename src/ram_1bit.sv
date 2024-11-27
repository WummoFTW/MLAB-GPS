module ram_1bit (
    input wire clk,
    input wire rst,
    input wire [21:0] address,   // Address input for selecting data
    output reg        data_out   // 3-bit data output
);
    // Define RAM with 128 locations (3-bit each)
    reg ram [3999999:0];

    // Initialize RAM values (can be modified for different patterns)
    initial begin
         $readmemb("c:\\Users\\newadmin\\Desktop\\GPS\\1bit\\MLAB-GPS\\sim_data\\Data1124.hex", ram);
         
    end

    // Output data based on the address
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 1'b0;
        else
            data_out <= ram[address];
    end
endmodule
