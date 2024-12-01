module memory(
    input [31:0] A,
    input [31:0]WD,
    input clk, rst, We,
    output reg [31:0] RD
);
    reg [31:0] mem [0:20];
    initial begin
        $readmemb("data.mem", mem);
    end

    always @(posedge clk) begin
        if (We) begin
            mem[A] <= WD;
        end
    end
    assign RD = mem[A[31:2]];
endmodule

module memory_tb;
    reg clk, rst, We;
    reg [31:0] A, WD;
    wire [31:0] RD;

    // Instantiate the memory module
    memory mem_inst (
        .A(A),
        .WD(WD),
        .clk(clk),
        .rst(rst),
        .We(We),
        .RD(RD)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initialize signals
    initial begin
        clk = 0;
        rst = 1;
        We = 0;
        A = 0;
        WD = 0;

        // Reset sequence
        #10 rst = 0;
        #10 rst = 0;

        // Write operation
        #10 We = 1;
        #10 A = 100; // Example address
        #10 WD = 32'h00000011; // Example data
        We = 1;

        // Read operation
        #10 A = 100; // Same address as before
        #10 We = 0;

        // Add more test cases as needed

        $finish;
    end
endmodule

