module max_index (
    input  logic signed [31:0] data [0:127],
    output logic [7:0] max_idx
);

    logic [7:0] level0 [0:63];
    logic [7:0] level1 [0:31];
    logic [7:0] level2 [0:15];
    logic [7:0] level3 [0:7];
    logic [7:0] level4 [0:3];
    logic [7:0] level5 [0:1];

    function automatic logic signed [31:0] abs_val(input logic signed [31:0] val); // Trashy just remove the last bit !!!
    return (val < 0) ? -val : val;
    endfunction


    always_comb begin
        // Level 0
        for (int i = 0; i < 64; i++) begin
            level0[i] = (abs_val(data[2*i]) >= abs_val(data[2*i+1])) ? 2*i : 2*i + 1;
        end

        // Level 1
        for (int i = 0; i < 32; i++) begin
            level1[i] = (abs_val(data[level0[2*i]]) >= abs_val(data[level0[2*i+1]]))
                        ? level0[2*i] : level0[2*i+1];
        end

        // Level 2
        for (int i = 0; i < 16; i++) begin
            level2[i] = (abs_val(data[level1[2*i]]) >= abs_val(data[level1[2*i+1]]))
                        ? level1[2*i] : level1[2*i+1];
        end

        // Level 3
        for (int i = 0; i < 8; i++) begin
            level3[i] = (abs_val(data[level2[2*i]]) >= abs_val(data[level2[2*i+1]]))
                        ? level2[2*i] : level2[2*i+1];
        end

        // Level 4
        for (int i = 0; i < 4; i++) begin
            level4[i] = (abs_val(data[level3[2*i]]) >= abs_val(data[level3[2*i+1]]))
                        ? level3[2*i] : level3[2*i+1];
        end

        // Level 5
        for (int i = 0; i < 2; i++) begin
            level5[i] = (abs_val(data[level4[2*i]]) >= abs_val(data[level4[2*i+1]]))
                        ? level4[2*i] : level4[2*i+1];
        end

        // Final comparison
        max_idx = (abs_val(data[level5[0]]) >= abs_val(data[level5[1]]))
                  ? level5[0] : level5[1];
    end

endmodule
