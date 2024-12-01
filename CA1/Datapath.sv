module datapath (
    input logic clk,
    input logic reset,
    input logic [2:0] data_in_3,
    input logic [2:0] address_3,
    input logic load_3,
    input logic read_3,
    output logic [2:0] data_out_3,
    input logic [7:0] data_in_8,
    input logic [2:0] address_8,
    input logic load_8,
    input logic read_8,
    input logic [2:0] n,       // Input N
    input logic [2:0] i,       // Input i for IsSafe
    output logic [7:0] results, // Output results from calculator
    output logic safe           // Output safe signal from IsSafe
);

    // Instantiate the 3-bit register module
    reg3 reg3_inst (
        .clk(clk),
        .reset(reset),
        .data_in(data_in_3),
        .address(address_3),
        .load(load_3),
        .read(read_3),
        .data_out(data_out_3)
    );

    // Instantiate the 8-bit register module
    reg8 reg8_inst (
        .clk(clk),
        .reset(reset),
        .data_in(data_in_8),
        .address(address_8),
        .load(load_8),
        .read(read_8),
        .data_out(data_out_8)
    );

    // Instantiate the calculator module
    calculator calc_inst (
        .n(n),
        .results(results)
    );

    // Instantiate the IsSafe module
    IsSafe is_safe_inst (
        .n(n),
        .i(i),
        .safe(safe)
    );
endmodule


module datapath_tb;

    // Testbench signals
    logic clk;
    logic reset;
    logic [2:0] data_in_3;
    logic [2:0] address_3;
    logic load_3;
    logic read_3;
    logic [2:0] data_out_3;
    logic [7:0] data_in_8;
    logic [2:0] address_8;
    logic load_8;
    logic read_8;
    logic [2:0] n;              // Input N
    logic [2:0] i;              // Input i
    logic [7:0] results;        // Results from calculator
    logic safe;                 // Safe signal from IsSafe

    // Instantiate the datapath module
    datapath uut (
        .clk(clk),
        .reset(reset),
        .data_in_3(data_in_3),
        .address_3(address_3),
        .load_3(load_3),
        .read_3(read_3),
        .data_out_3(data_out_3),
        .data_in_8(data_in_8),
        .address_8(address_8),
        .load_8(load_8),
        .read_8(read_8),
        .n(n),
        .i(i),
        .results(results),
        .safe(safe)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 time units clock period

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        load_3 = 0;
        read_3 = 0;
        load_8 = 0;
        read_8 = 0;
        data_in_3 = 3'b000;
        data_in_8 = 8'b00000000;
        address_3 = 3'b000;
        address_8 = 3'b000;

        // Apply reset
        #10;
        reset = 0;

        // Test with different values of N and I
        for (int n_val = 0; n_val < 8; n_val++) begin
            n = n_val; // Example: set N from 0 to 7
            for (int i_val = 1; i_val <= 8; i_val++) begin
                i = i_val; // Set I from 1 to 8
                #10; // Wait for a clock cycle
                $display("N = %0d, I = %0d, Results = %b, Safe = %0d", n, i, results, safe);
            end
        end

        $stop; // End simulation
    end

endmodule
