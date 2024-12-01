module file_reg(
    input clk,
    input rst,
    input [4:0] A1, A2, A3,
    input [31:0] WD,
    input We,
    output [31:0] RD1, RD2
);

    reg [31:0] Reg_file [31:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Reg_file[i] <= 32'b0;
            end
        end else if (We) begin
            if (A3 != 5'b0)
                Reg_file[A3] <= WD;
        end
    end
    assign RD1 = Reg_file[A1];
    assign RD2 = Reg_file[A2];
endmodule


module file_reg_tb;
    reg clk;
    reg rst;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD;
    reg We;
    wire [31:0] RD1, RD2;

    // Instantiate the module under test
    file_reg dut (
        .clk(clk),
        .rst(rst),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD(WD),
        .We(We),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initialize signals
    initial begin
        clk = 0;
        rst = 1;
        We = 0;
        // Set other inputs as needed

        // Apply reset
        #10 rst = 0;
        #10 rst = 0;

        // Write data to register at address A3
        #20 We = 1;
        #20 A3 = 5; // Example address
        #20 WD = 32'h12345678; // Example data
        #20 We = 0;

        // Read data from registers at addresses A1 and A2
        #30 A1 = 2; // Example address
        #30 A2 = 10; // Example address

        // Add more test cases as needed
        // ...

        $finish;
    end
endmodule

