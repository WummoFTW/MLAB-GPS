module oversample (
    input       clk,
    input       rst,
    input       data_in,

    output reg  data_out
);
    reg [5:0] data;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            count <= 5'd0;
            data <= 6'd0;
            data_out <= 1'b0;
        end else begin

        data <= data + data_in;
        count <= count +1;
        if(count == 5'd19) begin
            data_out <= (data >= 10) ? 1'b1 : 1'b0;
            count <= 5'd0;
            data <= 6'd0;
        end


        end
    end

    
endmodule