module inst_mem(
    input [31:0] A,
    output reg [31:0] RD
);
    reg [31:0] mem [0:20];
    initial begin
        $readmemb("inst.mem", mem);
    end
    wire [31:0] addr;
    assign addr = A[31:2];
    assign RD = mem[A[31:2]];
endmodule


