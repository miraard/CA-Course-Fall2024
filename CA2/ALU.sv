module ALU (
    input signed [31:0] A,
    input signed [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] ALUResult,
    output reg Zero
);
    parameter op_add  = 3'b000;
    parameter op_sub  = 3'b001;
    parameter op_and  = 3'b010;
    parameter op_or   = 3'b011;
    parameter op_slt  = 3'b100;
    parameter op_sltu = 3'b101;
    parameter op_xor  = 3'b110;
    always @(*) begin
        case(ALUOp)
            op_add: ALUResult = A + B;
            op_sub: ALUResult = A - B;
            op_and: ALUResult = A & B;
            op_or: ALUResult = A | B;
            op_slt: ALUResult = A < B;
            op_sltu: ALUResult = $unsigned(A) < $unsigned(B);
            op_xor: ALUResult = A ^ B;
        endcase
    end
    assign Zero = (ALUResult == 0);
endmodule


module ALU_tb();
    reg signed [31:0] A, B;
    reg [2:0] ALUOp;
    wire [31:0] ALUResult;
    wire Zero;

    ALU dut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        A = 10;
        B = 5;
        ALUOp = 3'b000; // Addition operation

        #10;

        A = -5;
        B = 3;
        ALUOp = 3'b001; // Subtraction operation

        #10;

        A = 8;
        B = 3;
        ALUOp = 3'b010; // Bitwise AND operation

        #10;

        A = 5;
        B = 3;
        ALUOp = 3'b011; // Bitwise OR operation

        #10;

        A = -10;
        B = 15;
        ALUOp = 3'b100; // Less than operation

        #10;

        A = -10;
        B = 15;
        ALUOp = 3'b101; // Less than operation

        #10;

        $finish;
    end
endmodule
