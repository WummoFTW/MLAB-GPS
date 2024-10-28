module adder (
    input logic signed [63:0] in1,
    input logic signed [63:0] in2,
    output logic signed [64:0] out 
);
     assign out = in1 + in2;
endmodule