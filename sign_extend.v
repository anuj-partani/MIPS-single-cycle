module sign_extend
(
    input [15:0] sign_extend_in,
    output [31:0] sign_extend_out
);

    assign sign_extend_out = {{16{sign_extend_in[15]}},sign_extend_in};

endmodule

module tb_sign_extend ();
	reg [15:0] tb_sign_extend_in;
	wire [31:0] tb_sign_extend_out;
	
	initial begin
		tb_sign_extend_in = 16'h7ABC;
		#100 tb_sign_extend_in = 16'hA123;
		#100 tb_sign_extend_in = 16'h7654;
		#100 tb_sign_extend_in = 16'hAAAA;
		#100 tb_sign_extend_in = 16'h3AAA;
		#100 tb_sign_extend_in = 16'h6D32;
	end
	
	sign_extend test_sign_extend
	(
		.sign_extend_in  (tb_sign_extend_in ),
		.sign_extend_out (tb_sign_extend_out)
	);
	
endmodule