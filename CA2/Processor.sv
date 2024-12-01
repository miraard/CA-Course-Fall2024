`timescale 1ns/1ns
module processor(input clk, rst);
    wire [6:0]op;
    wire [2:0]func3;
    wire [6:0]func7;
    wire zero;
    wire negetive;
    wire [1:0]pcsel;
    wire [1:0]regsel;
    wire [2:0]extend_func;
    wire wereg;
    wire wedata;
    wire aluselb;
    wire [2:0]aluop;
    wire outsel;

    controller cont(
        .clk(clk),
        .rst(rst),
        .op(op),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .negetive(negetive),
        .pcsel(pcsel),
        .regsel(regsel),
        .extend_func(extend_func),
        .wereg(wereg),
        .wedata(wedata),
        .aluselb(aluselb),
        .aluop(aluop),
        .outsel(outsel)
    );

    data_path dp(
        .clk(clk),
        .rst(rst),
        .pcsel(pcsel),
        .regsel(regsel),
        .extend_func(extend_func),
        .wereg(wereg),
        .wedata(wedata),
        .aluselb(aluselb),
        .aluop(aluop),
        .outsel(outsel),
        .op(op),
        .func3(func3),
        .func7(func7),
        .ZERO(zero),
        .neg(negetive)
    );
endmodule


module tbP();

    // Inputs and outputs for the modules
    reg [24:0] unextend_data;
    reg [2:0] extend_func;
    wire [31:0] extended_data;

    reg [31:0] A_inst_mem;
    wire [31:0] RD_inst_mem;

    reg [31:0] A_adder, B_adder;
    wire [31:0] C_adder;

    reg S_mux_2to1;
    reg [31:0] D0_mux_2to1, D1_mux_2to1;
    wire [31:0] Y_mux_2to1;

    reg [1:0] S_mux_4to1;
    reg [31:0] D0_mux_4to1, D1_mux_4to1, D2_mux_4to1, D3_mux_4to1;
    wire [31:0] Y_mux_4to1;

    // Instantiate the modules
    imm_extend imm_ext (
        .unextend_data(unextend_data),
        .extend_func(extend_func),
        .extended_data(extended_data)
    );

    reg [31:0] A_data_mem;
    wire [31:0] RD_data_mem;



    // Instantiate the data memory module
    data_mem data_mem_mod (
        .A(A_data_mem), // Address input
        .RD(RD_data_mem) // Data output
    );

    inst_mem inst_mem_mod (
        .A(A_inst_mem),
        .RD(RD_inst_mem)
    );

    adder adder_mod (
        .A(A_adder),
        .B(B_adder),
        .C(C_adder)
    );

    multiplexer_2to1 mux_2to1_mod (
        .S(S_mux_2to1),
        .D0(D0_mux_2to1),
        .D1(D1_mux_2to1),
        .Y(Y_mux_2to1)
    );

    multiplexer_4to1 mux_4to1_mod (
        .S(S_mux_4to1),
        .D0(D0_mux_4to1),
        .D1(D1_mux_4to1),
        .D2(D2_mux_4to1),
        .D3(D3_mux_4to1),
        .Y(Y_mux_4to1)
    );

    // Add signals to the waveform viewer
    initial begin
        // Add all the signals that you want to observe in the waveform viewer
        $dumpfile("tbP_waveform.vcd");
        $dumpvars(0, tbP);

        // Scenario 1: Test Immediate Extension for I-Type
        unextend_data = 25'h1FFFFFF;
        extend_func = 3'b000; // I-Type
        #100;

        // Scenario 2: Test Immediate Extension for S-Type
        extend_func = 3'b001; // S-Type
        #100;

        // Scenario 3: Test Immediate Extension for B-Type
        extend_func = 3'b010; // B-Type
        #100;

        // Scenario 4: Test Instruction Memory Read
        A_inst_mem = 32'h00000004; // Reading 2nd instruction
        #100;

        // Scenario 5: Test Adder Functionality
        A_adder = 32'h00000010;
        B_adder = 32'h00000020;
        #100;

        // Scenario 6: Test 2-to-1 Multiplexer with S=0
        S_mux_2to1 = 0;
        D0_mux_2to1 = 32'h12345678;
        D1_mux_2to1 = 32'h87654321;
        #100;

        // Scenario 7: Test 2-to-1 Multiplexer with S=1
        S_mux_2to1 = 1;
        #100;

        // Scenario 8: Test 4-to-1 Multiplexer for S=00
        S_mux_4to1 = 2'b00;
        D0_mux_4to1 = 32'hAAAA0000;
        D1_mux_4to1 = 32'hBBBB1111;
        D2_mux_4to1 = 32'hCCCC2222;
        D3_mux_4to1 = 32'hDDDD3333;
        #100;

        // Scenario 9: Test 4-to-1 Multiplexer for S=10
        S_mux_4to1 = 2'b10;
        #100;

        // Scenario 10: Test 4-to-1 Multiplexer for S=11
        S_mux_4to1 = 2'b11;
        #100;

        // End the simulation
        $stop;
    end

endmodule

