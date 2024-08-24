module ALU
(
	input signed [31:0] alu_input_0,
	input signed [31:0] alu_input_1,
	input [3:0] alu_control,
	output zero,
	output reg [31:0] alu_output 
);

	always @(alu_input_0,alu_input_1,alu_control) begin
		case (alu_control)
			4'b0000 : alu_output = alu_input_0 & alu_input_1; // Bitwise AND
			4'b0001 : alu_output = alu_input_0 | alu_input_1; // Bitwise OR
			4'b0010 : alu_output = alu_input_0 + alu_input_1; // Addition
			4'b0110 : alu_output = alu_input_0 - alu_input_1; // Subtraction
			4'b0111 : alu_output = (alu_input_0 < alu_input_1) ? 32'h1 : 32'h0; // Set Less Than
			4'b0101 : alu_output = ~(alu_input_0 | alu_input_1); // Logical NOR
			default : alu_output = 32'h0;
		endcase
	end
	
	assign zero = (alu_output == 32'h00000000);
	
endmodule

module tb_ALU ();
	reg [31:0] tb_alu_input_0;
	reg [31:0] tb_alu_input_1;
	reg [3:0] tb_alu_control;
	wire tb_zero;
	wire [31:0] tb_alu_output;
	
	initial begin
		tb_alu_input_0 = 32'h00000003;
		tb_alu_input_1 = 32'hFFFFFFFF;
		#50 tb_alu_control = 4'b0000;
		#50 tb_alu_control = 4'b0001;
		#50 tb_alu_control = 4'b0010;
		#50 tb_alu_control = 4'b0110;
		#50 tb_alu_control = 4'b0111;
		#50 tb_alu_control = 4'b0101;
		#50 tb_alu_control = 4'b0001;
		#50;
	end
	
	ALU test_ALU
	(
		.alu_input_0 (tb_alu_input_0),
		.alu_input_1 (tb_alu_input_1),
		.alu_control (tb_alu_control),
		.zero        (tb_zero       ),
		.alu_output  (tb_alu_output )
	);

endmodule