module controller (
    input               adder_flag,
    input               clk,
    input               rst,
    input         [7:0] max_id,
    input signed [31:0] max_sum,
    output reg    [9:0] phase
);
    always @(posedge clk) begin
        if (rst) begin
            phase <= 10'd0;
        end else if(adder_flag == 1) begin // CIA KAZKADA VEIKE
            if (max_sum < -2048 || max_sum > 2047) begin 
                if (max_id < 8'd32) begin
                    phase <= phase + 10'd8;
                end else if (max_id > 8'd96) begin
                    phase <= phase - 10'd8;
                end
            end else begin
                phase = phase+32;
            end
        end
    end
endmodule

/*
module controller (
    input            adder_flag,
    input            clk,
    input            rst,
    input      [7:0] max_id,
    output reg [9:0] phase
);
    // Registers for delayed signals
    reg adder_flag_d;
    reg [7:0] max_id_d;

    always_ff @(posedge clk) begin
        if (rst) begin
            phase <= 10'd0;
            adder_flag_d <= 0;
            max_id_d <= 8'd0;
        end else begin
            // Delay adder_flag and max_id
            adder_flag_d <= adder_flag;
            max_id_d <= max_id;

            // Use delayed versions for phase update
            if(adder_flag_d == 1) begin
                if (max_id_d < 8'd32) begin
                    phase <= phase + 10'd1;
                end else if (max_id_d > 8'd96) begin
                    phase <= phase - 10'd1;
                end
            end
        end
    end
endmodule

module controller (
    input               adder_flag,
    input               clk,
    input               rst,
    input         [7:0] max_id,
    input signed [31:0] max_sum,
    output reg    [9:0] phase
);
    always @(posedge clk) begin
        if (rst) begin
            phase <= 10'd0;
        end else if(adder_flag == 1) begin
            if (max_sum < -2048 || max_sum > 2047) begin 
                if (max_id < 8'd32) begin
                    phase <= phase + 10'd8;
                end else if (max_id > 8'd96) begin
                    phase <= phase - 10'd8;
                end
            end else begin
                phase = phase+32;
            end
        end
    end
endmodule

*/