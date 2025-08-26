module fpga_top (
    input           FPGA_CLK16_P,
    input           FPGA_CLK16_N,
    input           FPGA_D_IN,
    
    output          FPGA_LOCK_LOST,    
    output          FPGA_D_OUT,
    output          FPGA_CA_OUTPUT,
    output [31:0]   FPGA_ACCUMAX,
    output [31:0]   FPGA_ACCUM0,
    output [7:0]    FPGA_MAX_ID
);

wire FPGA_RESET, FPGA_CLK16;
wire [4:0] FPGA_PRN;
wire [31:0] FPGA_DOPPLER_TW;
wire [9:0] FPGA_PHASE_SYS;

system_top system_top_wrapper (
    .DATA_IN(FPGA_D_IN),
    .CLOCK_16(FPGA_CLK16),
    .PRN_SYS(FPGA_PRN),
    .DOPPLER_TW(FPGA_DOPPLER_TW),
    .RESET(FPGA_RESET),
    .PHASE_SYS(FPGA_PHASE_SYS),
    .CA_OUTPUT(FPGA_CA_OUTPUT),
    .MAX_ID(FPGA_MAX_ID),
    .ACCUM0(FPGA_ACCUM0),
    .ACCUMAX(FPGA_ACCUMAX),
    .D_OUT(FPGA_D_OUT),
    .LOCK_LOST(FPGA_LOCK_LOST)    
);

design_1 vio_0 (
    .clk(FPGA_CLK16),
    .probe_in0(FPGA_CA_OUTPUT),
    .probe_in1(FPGA_MAX_ID),
    .probe_in2(FPGA_ACCUM0),
    .probe_in3(FPGA_ACCUMAX),
    .probe_out0(FPGA_RESET),
    .probe_out1(),
    .probe_out2(FPGA_PRN),
    .probe_out3(FPGA_PHASE_SYS),
    .probe_out4(FPGA_DOPPLER_TW)
    );

IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) IBUFDS_inst (
   .O(FPGA_CLK16),            // Buffer output
   .I(FPGA_CLK16_P),          // Diff_p buffer input (connect directly to top-level port)
   .IB(FPGA_CLK16_N)          // Diff_n buffer input (connect directly to top-level port)
);


endmodule