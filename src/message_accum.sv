/*  Labai paprastas vidurkinimo algoritmas. Gali buti problemu
    jei akumuliavimas prasideda ne laiku. Galimai reiks keisti.*/

module data_accum #(
    parameter int samplesize = 160
)(
    input   rst,
    input   clk,
    input signed [31:0]  in_data,
    output logic out_data
);
    logic [9:0] accum, counter;
    wire data;
    assign data = in_data[31] == 0 ? 1 : 0;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            accum <= 10'd0;
            counter <= 10'd0;
            out_data <= 1'b0;
        end
        else begin
            if(in_data > 32'd100 || in_data < -32'd100) begin
                accum <= accum + data;
            end
            counter++;
            if(counter == samplesize) begin
                out_data <= accum > (samplesize >> 1) ? 1 : 0;
                accum <= 0;
                counter <= 0;
            end
        end
    end 
endmodule