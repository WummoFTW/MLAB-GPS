/*  Labai paprastas vidurkinimo algoritmas. Gali buti problemu
    jei akumuliavimas prasideda ne laiku. Galimai reiks keisti.*/

module data_accum #(
    parameter int samplesize = 160
)(
    input   rst,                    // Reset
    input   clk,                    // Clock 16 kHz (sample clock so the correlator output is valid)
    input signed [31:0]  in_data,   // Prompt correlator output
    output logic out_data           // Data 50 bps
);

    localparam NOISE_FLOOR = 32'd100;

    logic [9:0] accum, counter;
    wire data;
    assign data = in_data[31] == 0 ? 1 : 0; // Checks whether the ouput is positive or negative

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            accum <= 10'd0;
            counter <= 10'd0;
            out_data <= 1'b0;
        end
        else begin
            // If data is above noise floor, add 1 or 0 depending on the correlator output sign
            if(in_data > NOISE_FLOOR || in_data < -NOISE_FLOOR) begin 
                accum <= accum + data;
            end
            counter++;
            // When samplesize is reached output bit and reset module
            if(counter == samplesize) begin
                out_data <= accum > (samplesize >> 1) ? 1 : 0;
                accum <= 0;
                counter <= 0;
            end
        end
    end 
endmodule