module sign_function (
    input  logic            clk,    // Clock signal
    input  logic            rst,    // Reset signal
    input  logic     [13:0] in,     // Input signal
    input  logic            sign,
    output logic            out     // Sign output (+1 or -1)
);

    logic is_inverted = 1'b0;
    logic [11:0] buffer = 12'd0;

    

    always_comb begin
        if(rst) begin
            buffer = 12'd0;
            is_inverted = 1'b0;

        end else begin
            buffer <= buffer << 1;
            buffer[0] <= sign;

            is_inverted <= |buffer;

            if (is_inverted)begin
                if (in >= 14'd5000)
                    out = 1'b0;  
                else
                    out = 1'b1;  
            end else begin
                if (in >= 14'd5000)
                    out = 1'b1;  
                else
                    out = 1'b0;  
            end
        end
    end

endmodule
