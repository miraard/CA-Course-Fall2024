module data_path(
    input clk,
    input rst,
    input [1:0]pcsel,
    input [1:0]regsel,
    input [2:0]extend_func,
    input wereg,
    input wedata,
    input aluselb,
    input [2:0]aluop,
    input outsel,
    output [6:0]op,
    output [2:0]func3,
    output [6:0]func7,
    output ZERO,
    output neg
);
    wire [31:0] pcin,pcout;
    wire [31:0] instruction;
    wire [31:0] extended_imm; 
    wire [31:0] WD,RD1,RD2;
    wire [31:0] ALUB;
    wire [31:0] alu_res;
    wire [31:0] memory_out;
    wire [31:0] write_data;
    wire [31:0] choice0,choice1,choice2,choice3;
    wire zero;

    PC  pc(clk,rst,pcin,pcout);

    inst_mem instruction_memory(pcout,instruction);
    assign op = instruction[6:0];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];

    imm_extend immediate_extened(instruction[31:7],extend_func,extended_imm);

    file_reg file_register(clk,rst,instruction[19:15],instruction[24:20],instruction[11:7],WD,wereg,RD1,RD2);
    
    multiplexer_2to1 bselect(aluselb,RD2,extended_imm,ALUB);
    
    ALU alu(RD1,ALUB,aluop,alu_res,zero);
    
    memory MEMORY(alu_res,RD2,clk,rst,wedata,memory_out);
    
    multiplexer_2to1 write_data_select(outsel,alu_res,memory_out,write_data);
    
    adder choice0_ADDER(32'h00000004,pcout,choice0);
    assign choice2 = write_data;
    assign choice3 = extended_imm;
    adder choice1_ADDER(pcout,extended_imm,choice1);
    multiplexer_4to1 pc_choice(pcsel,choice0,choice1,choice2,choice3,pcin);
    multiplexer_4to1 WD_select(regsel,write_data,choice0,extended_imm,32'b0,WD);
    
    assign ZERO=zero;
    assign neg = alu_res[31];
endmodule
