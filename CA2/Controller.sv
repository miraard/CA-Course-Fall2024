module controller (
    input clk,
    input rst,
    input [6:0] op,
    input [2:0] func3,
    input [6:0] func7,
    input zero,
    input negetive,
    output reg [1:0] pcsel,
    output reg [1:0] regsel,
    output reg [2:0] extend_func,
    output reg wereg,
    output reg wedata,
    output reg aluselb,
    output reg [2:0] aluop,
    output reg outsel
);
    // op code
    parameter R_type = 7'b0110011;
    parameter I_type = 7'b0010011;
    parameter I_type_load = 7'b0000011;
    parameter I_type_jump = 7'b1100111;
    parameter S_type = 7'b0100011;
    parameter B_type = 7'b1100011;
    parameter J_type = 7'b1101111;
    parameter U_type = 7'b0110111;

    // func3 R type code
    parameter func3_R_type_add_sub = 3'b000;
    parameter func3_R_type_sll = 3'b001;
    parameter func3_R_type_slt = 3'b010;
    parameter func3_R_type_xor = 3'b100;
    parameter func3_R_type_or = 3'b110;
    parameter func3_R_type_and = 3'b111;
    
    // func3 I type code
    parameter func3_I_type_lw = 3'b010;
    parameter func3_I_type_addi = 3'b000;
    parameter func3_I_type_slti = 3'b010;
    parameter func3_I_type_xori = 3'b100;
    parameter func3_I_type_ori = 3'b110;
    parameter func3_I_type_andi = 3'b111;
    parameter func3_I_type_jalr = 3'b000;

    // func3 S type code
    parameter func3_S_type_sb = 3'b000;
    parameter func3_S_type_sh = 3'b001;
    parameter func3_S_type_sw = 3'b010;

    // func3 B type code
    parameter func3_B_type_beq = 3'b000;
    parameter func3_B_type_bne = 3'b001;

    // func3 J type code
    parameter func3_J_type_jal = 3'b000;

    // func3 U type code
    parameter func3_U_type_lui = 3'b011;
    parameter func3_U_type_auipc = 3'b100;

    // func7 R type code
    parameter func7_R_type_default = 7'b0000000;
    parameter func7_R_type_sub = 7'b0100000;

    // immediate extend operation
    parameter extend_I_type = 3'b000;
    parameter extend_S_type = 3'b001;
    parameter extend_B_type = 3'b010;
    parameter extend_J_type = 3'b011;
    parameter extend_U_type = 3'b100;
    parameter extend_default = 3'b000;

    // ALU operation
    parameter op_add  = 3'b000;
    parameter op_sub  = 3'b001;
    parameter op_and  = 3'b010;
    parameter op_or   = 3'b011;
    parameter op_slt  = 3'b100;
    parameter op_xor  = 3'b110;
    parameter op_default = 3'b000;

    // pc select
    parameter next_pc = 2'b00;
    parameter jal_branch_pc = 2'b01;
    parameter jarl_pc = 2'b10;
    parameter nothing_pc = 2'b11;

    // reg select
    parameter reg_sel_data = 2'b00;
    parameter reg_sel_pc = 2'b01;
    parameter reg_sel_imm = 2'b10;
    parameter reg_sel_default = 2'b00;

    // alu select
    parameter alu_b_reg = 1'b0;
    parameter alu_b_imm = 1'b1;
    parameter alu_b_default = 1'b0;

    // out select
    parameter out_sel_alu = 1'b0;
    parameter out_sel_mem = 1'b1;
    parameter out_sel_default = 1'b0;

    always @(*) begin
        {pcsel, regsel, extend_func, wereg, wedata, aluselb, aluop, outsel} = 13'b0;
        case(op)
            R_type: begin
                pcsel = next_pc;
                regsel = reg_sel_data;
                extend_func = extend_default;
                wereg = 1'b1;
                wedata = 1'b0;
                aluselb = alu_b_reg;
                outsel = out_sel_alu;
                
                case(func7)
                    func7_R_type_default:
                        case(func3)
                            func3_R_type_add_sub: aluop = op_add;
                            func3_R_type_sll: aluop = op_default;
                            func3_R_type_slt: aluop = op_slt;
                            func3_R_type_xor: aluop = op_xor;
                            func3_R_type_or: aluop = op_or;
                            func3_R_type_and: aluop = op_and;
                        endcase
                    func7_R_type_sub:
                        if (func3 == func3_R_type_add_sub)
                            aluop = op_sub;
                endcase
            end

            I_type: begin
                pcsel = next_pc;
                regsel = reg_sel_data;
                extend_func = extend_I_type;
                wereg = 1'b1;
                wedata = 1'b0;
                aluselb = alu_b_imm;
                outsel = out_sel_alu;

                case(func3)
                    func3_I_type_addi: aluop = op_add;
                    func3_I_type_slti: aluop = op_slt;
                    func3_I_type_xori: aluop = op_xor;
                    func3_I_type_ori: aluop = op_or;
                    func3_I_type_andi: aluop = op_and;
                endcase
            end

            I_type_load: begin
                case(func3)
                    func3_I_type_lw: begin
                        pcsel = next_pc;
                        regsel = reg_sel_data;
                        extend_func = extend_I_type;
                        wereg = 1'b1;
                        wedata = 1'b0;
                        aluselb = alu_b_imm;
                        outsel = out_sel_mem;
                        aluop = op_add;
                    end
                endcase
            end

            I_type_jump: begin
                case(func3)
                    func3_I_type_jalr: begin
                        pcsel = jarl_pc;
                        regsel = reg_sel_pc;
                        extend_func = extend_I_type;
                        wereg = 1'b1;
                        wedata = 1'b0;
                        aluselb = alu_b_imm;
                        outsel = out_sel_alu;
                        aluop = op_add;
                    end
                endcase
            end

            S_type: 
                if(func3 == func3_S_type_sw) begin
                    pcsel = next_pc;
                    regsel = reg_sel_default;
                    extend_func = extend_S_type;
                    wereg = 1'b0;
                    wedata = 1'b1;
                    aluselb = alu_b_imm;
                    outsel = out_sel_default;
                end

             J_type: begin
                pcsel = jal_branch_pc;
                regsel = reg_sel_pc;
                extend_func = extend_J_type;
                wereg = 1'b1;
                wedata = 1'b0;
                aluselb = alu_b_default;
                outsel = out_sel_default;
                aluop = op_default;
             end

            U_type: begin
                pcsel = next_pc;
                regsel = reg_sel_imm;
                extend_func = extend_U_type;
                wereg = 1'b1;
                wedata = 1'b0;
                aluselb = alu_b_default;
                outsel = out_sel_default;
                aluop = op_add;
            end

            B_type: begin
                pcsel = next_pc;
                regsel = reg_sel_default;
                extend_func = extend_B_type;
                wereg = 1'b0;
                wedata = 1'b0;
                aluselb = alu_b_reg;
                outsel = out_sel_default;
                aluop = op_sub;

                case(func3)
                    func3_B_type_beq:
                        if(zero == 1'b1)
                            pcsel = jal_branch_pc;
                    func3_B_type_bne:
                        if(zero == 1'b0)
                            pcsel = jal_branch_pc;

                endcase
            end
        endcase
    end
endmodule
