module uart_receiver (
    input logic clk,           // System clock
    input logic reset,         // Reset signal
    input logic rx,            // UART receive input
    output logic [2:0] data_out, // 3-bit output data
    output logic data_valid    // Data valid signal
);

    parameter int BAUD_RATE = 9600;
    parameter int CLOCK_FREQ = 10_000_000; // Example: 10 MHz clock
    parameter int BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;

    logic [12:0] baud_counter;
    logic [3:0] bit_counter;
    logic [7:0] shift_reg;
    logic receiving;

    // Baud rate clock divider and receiving control
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_counter <= 0;
            bit_counter <= 0;
            shift_reg <= 0;
            receiving <= 0;
            data_valid <= 0;
        end else begin
            if (!receiving && !rx) begin // Start bit detected
                receiving <= 1;
                baud_counter <= 0;
                bit_counter <= 0;
            end else if (receiving) begin
                baud_counter <= baud_counter + 1;

                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 0; // Reset baud counter after each bit
                    if (bit_counter < 8) begin
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift in received bits
                        bit_counter <= bit_counter + 1;
                    end else begin
                        // End of byte
                        data_out <= shift_reg[2:0]; // Take only 3 LSBs
                        data_valid <= 1;
                        receiving <= 0;
                    end
                end
            end else begin
                data_valid <= 0; // Clear valid flag after reading data
            end
        end
    end
endmodule
