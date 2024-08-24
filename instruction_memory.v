module instruction_memory
(
	input [31:0] read_address,
	output [31:0] instruction
);

	reg [31:0] instruction_memory_ROM [17:0];

	//Initializing Instruction Memory with test Instructions
	always @(read_address) begin
		instruction_memory_ROM [0] = 32'h012A4020; // add $t0,$t1,$t2
		instruction_memory_ROM [1] = 32'h02328022; // sub $s3,$s1,$s2
		instruction_memory_ROM [2] = 32'h8FB00010; // lw  $s0,16($sp)
		instruction_memory_ROM [3] = 32'h00000000; //
		instruction_memory_ROM [4] = 32'h00000000; //
		instruction_memory_ROM [5] = 32'h00000000; //
		instruction_memory_ROM [6] = 32'h00000000; //
		instruction_memory_ROM [7] = 32'h00000000; //
		instruction_memory_ROM [8] = 32'h00000000; //
		instruction_memory_ROM [9] = 32'h00000000; //
		instruction_memory_ROM[10] = 32'h00000000; //
		instruction_memory_ROM[11] = 32'h00000000; //
		instruction_memory_ROM[12] = 32'h00000000; //
		instruction_memory_ROM[13] = 32'h00000000; //
		instruction_memory_ROM[14] = 32'h00000000; //
		instruction_memory_ROM[15] = 32'h00000000; //
		instruction_memory_ROM[16] = 32'h00000000; //
		instruction_memory_ROM[17] = 32'h00000000; //
	end

	assign instruction = (read_address==32'h003FFFFC) ? 32'h00000000 : instruction_memory_ROM[(read_address - 4194304)/4] ;

endmodule

module tb_instruction_memory();
	reg [31:0] tb_read_address;
	wire [31:0] tb_instruction;

	integer i;
	initial begin
		tb_read_address = 32'h003FFFFC;
		#25;
		for(i=0; i<18; i=i+1) begin
			tb_read_address = 32'h00400000 | (i*4);
			#25;
		end
	end

	instruction_memory test_instruction_memory 
	(
		.read_address(tb_read_address),
		.instruction (tb_instruction )
	);

endmodule