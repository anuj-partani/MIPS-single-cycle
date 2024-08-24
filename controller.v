module controller 
(
	input [5:0] opcode,
	output reg reg_dest,
	output reg jump,
	output reg branch,
	output reg mem_read,
	output reg mem_write,
	output reg mem_to_reg,
	output reg alu_src,
	output reg [1:0] alu_op,
	output reg reg_write
);
	always @(opcode) begin
		
		reg_write = 0;
		
		case (opcode)
			6'b000000 : begin // AND,OR,ADD,SUB,SLT
				reg_dest   = 1'b1; 
				jump       = 1'b0;
				branch     = 1'b0;
				mem_read   = 1'b0;
				mem_write  = 1'b0;
				mem_to_reg = 1'b0;
				alu_op     = 2'b10;
				alu_src    = 1'b0;
				#1 
				reg_write  = 1'b1;
			end
		
			6'b100011 : begin // load word lw
				reg_dest   = 1'b0; 
				jump       = 1'b0;
				branch     = 1'b0;
				mem_read   = 1'b1;
				mem_write  = 1'b0;
				mem_to_reg = 1'b1;
				alu_op     = 2'b00;
				alu_src    = 1'b1;
				#1
				reg_write  = 1'b1;
			end
		 
			6'b101011 : begin // store word sw
				reg_dest   = 1'bx; 
				jump       = 1'b0;
				branch     = 1'b0;
				mem_read   = 1'b1;
				mem_write  = 1'b1;
				mem_to_reg = 1'bx;
				alu_op     = 2'b00;
				alu_src    = 1'b1;
				reg_write  = 1'b0;
			end
			
			6'b000100 : begin // branch equal beq
				reg_dest   = 1'bx; 
				jump       = 1'b0;
				mem_read   = 1'b0;
				mem_write  = 1'b0;
				mem_to_reg = 1'bx;
				alu_op     = 2'b01;
				alu_src    = 1'b0;
				reg_write  = 1'b0;
				#2 branch  = 1'b1;
			end
			
			6'b000010 : begin // jump
				reg_dest   = 1'bx; 
				jump       = 1'b1;
				branch     = 1'b0;
				mem_read   = 1'b0;
				mem_write  = 1'b0;
				mem_to_reg = 1'bx;
				alu_op     = 2'b00; // 2'bxx Jump doesn't use ALU
				alu_src    = 1'b0;
				reg_write  = 1'b0;
			end
		
			default : begin // others
				reg_dest   = 1'b0; 
				jump       = 1'b0;
				branch     = 1'b0;
				mem_read   = 1'b0;
				mem_write  = 1'b0;
				mem_to_reg = 1'b0;
				alu_op     = 2'b00;
				alu_src    = 1'b0;
				reg_write  = 1'b0;
			end
			
		endcase
	end
	
endmodule

module tb_controller ();
	reg [5:0] tb_opcode;
	wire tb_reg_dest;
	wire tb_jump;
	wire tb_branch;
	wire tb_mem_read;
	wire tb_mem_write;
	wire tb_mem_to_reg;
	wire tb_alu_src;
	wire [1:0] tb_alu_op;
	wire tb_reg_write;

	initial begin
			tb_opcode = 6'b000000; // R-Type
		#50 tb_opcode = 6'b100011; // load word
		#50 tb_opcode = 6'b101011; // store word 
		#50 tb_opcode = 6'b000100; // branch equal
		#50 tb_opcode = 6'b000010; // jump
		#50 tb_opcode = 6'b111111; // unknown
		#50;
	end

	controller test_controller 
	(
		.opcode     (tb_opcode    ),
		.reg_dest   (tb_reg_dest  ),
		.jump       (tb_jump      ),
		.branch     (tb_branch    ),
		.mem_read   (tb_mem_read  ),
		.mem_write  (tb_mem_write ),
		.mem_to_reg (tb_mem_to_reg),
		.alu_src    (tb_alu_src   ),
		.alu_op     (tb_alu_op    ),
		.reg_write  (tb_reg_write )
	);

endmodule