module data_mem(
    input [31:0] A,    // Address input (32-bit address)
    output reg [31:0] RD // Data output (32-bit data)
);
    // Declare a memory array to hold the data
    reg [31:0] mem [0:31];  // You can adjust the memory size as needed (here, 32 entries)

    // Initialize the memory from the file
    initial begin
        $readmemb("data.mem", mem); // Load data from "data.mem" file
    end

    // Memory read operation
    always @(*) begin
        RD = mem[A[31:2]]; // Use the address A (strip the lower 2 bits to match the word alignment)
    end
endmodule

