module mux2x1_5bits 
(
    input [4:0] mux_in_0,
    input [4:0] mux_in_1,
    input mux_sel,
    output [4:0] mux_out
);

    assign mux_out = (mux_sel) ? mux_in_1 : mux_in_0;
	
endmodule


module tb_mux2x1_5bits();
	reg [4:0] tb_mux_in_0;
    reg [4:0] tb_mux_in_1;
    reg tb_mux_sel;
    wire [4:0] tb_mux_out;
	
	initial begin
		tb_mux_in_0 = 5'h1F;
		tb_mux_in_1 = 5'h00;
		tb_mux_sel = 1'b0;
		#25 tb_mux_sel = 1'b1;
		#25 tb_mux_sel = 1'b0;
		#25;
	end
	
	mux2x1_5bits test_mux2x1_5bits
	(
		.mux_in_0 (tb_mux_in_0),
		.mux_in_1 (tb_mux_in_1),
		.mux_sel  (tb_mux_sel ),
		.mux_out  (tb_mux_out )
	);
	
endmodule