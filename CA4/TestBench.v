// module TB();
//     reg clk, rst;
//     RISC_V risc_v(.clk(clk), .rst(rst));
//     always #5 clk = ~clk;

//     initial begin
//         clk = 1'b0;
//         #2 rst = 1'b1;
//         #6 rst = 1'b0;
//         #4000 $stop;
//     end
    
// endmodule


module TB();
    reg clk;
    reg regWrite;
    reg [4:0] readRegister1, readRegister2, writeRegister;
    reg [31:0] writeData;
    wire [31:0] readData1, readData2;

    RegisterFile rf (
        .clk(clk),
        .regWrite(regWrite),
        .readRegister1(readRegister1),
        .readRegister2(readRegister2),
        .writeRegister(writeRegister),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    initial begin
        clk = 0;
        regWrite = 0;
        writeRegister = 5'd0;
        writeData = 32'd0;
        readRegister1 = 5'd0;
        readRegister2 = 5'd0;

        // Initialize registers
        #5 regWrite = 1; writeRegister = 5'd1; writeData = 32'd50;
        #5 clk = ~clk;
        #5 clk = ~clk; regWrite = 1; writeRegister = 5'd2; writeData = 32'd20;
        #5 clk = ~clk;
        #5 clk = ~clk; regWrite = 0;

        // Read values
        #5 readRegister1 = 5'd1; readRegister2 = 5'd2;
        #5 clk = ~clk;
        #5 clk = ~clk;

        // Display results
        $display("Reg1: %d, Reg2: %d", readData1, readData2);
    end
endmodule


// data as input
// 20
// 1
// 2
// 3
// 2147483653
// 8
// 10
// 65547
// 28
// 32
