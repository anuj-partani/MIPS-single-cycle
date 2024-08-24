module MIPS(
    input clk,
    input reset,
	output [31:0] WriteData, 
	output [31:0] ALUOut,
    output reg [31:0] pc_output
);


	wire [31:0] instruction_intermediate;
	wire [4:0] mux_2x1_5_register;
	wire [31:0] mux_2x1_32_register;
	wire [31:0] sign_extend_op;
	wire [31:0] write_data_mux_op;
	wire [31:0] read_data_1, read_data_2;
	wire reg_dst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite;
	wire zero;
	wire [1:0] aluop; 
	wire [3:0] alu_control;
	wire [31:0] alu_output;
	wire [31:0] read_data_mem_op;
    
	assign ALUOut = alu_output;
	assign WriteData = write_data_mux_op;
	
	
	wire [31:0] pc_4;
	assign pc_4 = pc_output + 4;
	
	wire [31:0] beq_input;
	assign beq_input = sign_extend_op << 2;
	
	wire [31:0] add_alu_result;
	assign add_alu_result = pc_4 + beq_input;
	
	wire [31:0] branch_mux_out;
	
	wire [31:0] temp_out;
	
	
	
	always @(posedge clk) begin
		if(reset == 1'b1)		
			pc_output <= 32'h00400000;
		else
			pc_output <= temp_out;
	end

    instruction_memory i0 (.read_address(pc_output), 
                           .instruction	(instruction_intermediate));

    controller c0 
	(
		.opcode     (instruction_intermediate[31:26]),
		.reg_dest   (reg_dst                        ),
		.jump       (jump                           ),
		.branch     (branch                         ),
		.mem_read   (memread                        ),
		.mem_write  (memwrite                       ),
		.mem_to_reg (memtoreg                       ),
		.alu_src    (alusrc                         ),
		.alu_op     (aluop                          ),
		.reg_write  (regwrite                       )
	);


    mux2x1_5bits m0 (.in_0(instruction_intermediate[20:16]),
                    .in_1(instruction_intermediate[15:11]),
                    .sel(reg_dst),
                    .out(mux_2x1_5_register));


    register_file r0 (.read_register_1(instruction_intermediate[25:21]),
                      .read_register_2(instruction_intermediate[20:16]),
                      .reg_write(regwrite),
                      .write_register(mux_2x1_5_register),
                      .write_data(write_data_mux_op),
                      .read_data_1(read_data_1),
                      .read_data_2(read_data_2),
					  .clk(clk));

    sign_extend s0 (.in_instr (instruction_intermediate[15:0]),
                    .out_instr (sign_extend_op));

    mux2x1_32bits m1 (.in_0 (read_data_2),
                      .in_1 (sign_extend_op),
                      .sel (alusrc),
                      .out (mux_2x1_32_register));

    ALU_controller a0 (.funct (instruction_intermediate[5:0]),
                       .alu_op (aluop),
                       .operation (alu_control));

    ALU a1(.alu_input_0 (read_data_1),
           .alu_input_1 (mux_2x1_32_register),
           .alu_control (alu_control),
           .zero (zero),
           .alu_output (alu_output));

    data_memory d0 (.address (alu_output),
                    .write_data (read_data_2),
                    .mem_read (memread),
                    .mem_write (memwrite),
                    .read_data (read_data_mem_op),
					.clk(clk));

    mux2x1_32bits m2 (.in_0 (alu_output),
                      .in_1 (read_data_mem_op),
                      .sel (memtoreg),
                      .out (write_data_mux_op));
    


	mux2x1_32bits m3 (
		.in_0 (pc_4),
        .in_1 (add_alu_result),
        .sel (branch & zero),
        .out (branch_mux_out)
	);
	
	mux2x1_32bits m4(
		.in_0 (branch_mux_out),
        .in_1 ({pc_4[31:28],instruction_intermediate[25:0],2'b00}),
        .sel (jump),
        .out (temp_out)
	);
	
endmodule


module tb_MIPS();
	reg tb_clk;
	reg tb_reset;
	wire [31:0] tb_pc_output;
	wire [31:0] tb_WriteData;
	wire [31:0] tb_ALUOut;

	initial begin
		tb_clk = 0;
		repeat (100) begin
			#5 tb_clk = ~tb_clk;
		end
	end
	
	initial begin
		tb_reset = 1'b1;
		#50 tb_reset = 1'b0;
	end

	MIPS test_MIPS(
	.clk       (tb_clk      ),
	.reset     (tb_reset    ),
	.pc_output (tb_pc_output),
	.WriteData (tb_WriteData),
	.ALUOut    (tb_ALUOut   )
	);

endmodule