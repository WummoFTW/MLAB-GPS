module cycle_delay (
    input   clk,
    input   rst,
    input   data_in,
    output  data_out,
    output  data_out_code
);

    reg [2:0] data;

    always @(posedge clk) begin
        if (rst) begin
            data <= 3'b000;
        end else begin
            data[0] <= data_in;
            data[1] <= data[0];
            data[2] <= data[1];
        end
    end

    assign data_out = data_in; //data[1];
    assign data_out_code = data[2];
endmodule
