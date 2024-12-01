module adder(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    assign  C = A + B;
endmodule


module multiplexer_2to1 (
    input wire S, 
    input wire [31:0]D0, 
    input wire [31:0]D1, 
    output wire [31:0]Y 
);
    assign Y = (S == 1'b0) ? D0 : D1;
endmodule


module multiplexer_4to1 (
    input [1:0] S, 
    input [31:0] D0,
    input [31:0] D1,
    input [31:0] D2,
    input [31:0] D3, 
    output [31:0]Y 
);
    assign Y = (S == 2'b00) ? D0 :
               (S == 2'b01) ? D1 :
               (S == 2'b10) ? D2 :
               (S == 2'b11) ? D3 : 4'b0;
endmodule

