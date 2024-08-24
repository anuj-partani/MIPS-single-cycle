module data_memory
(
	input [31:0] address,
	input [31:0] write_data,
	input mem_read,
	input mem_write,
	input clk,
	output reg [31:0] read_data
);
	
	reg [31:0] data_memory_RAM [15:0];
	
	initial begin
		data_memory_RAM [0] = 32'h00000000; // assume starts at 32'h10001000
		data_memory_RAM [1] = 32'h00000000; // 32'h10001004
		data_memory_RAM [2] = 32'h00000000; // 32'h10001008
		data_memory_RAM [3] = 32'h00000000; // 32'h1000100C
		data_memory_RAM [4] = 32'h12345678; // 32'h10001010
		data_memory_RAM [5] = 32'h00000000; // 32'h10001014
		data_memory_RAM [6] = 32'h00000000; // 32'h10001018
		data_memory_RAM [7] = 32'h00000000; // 32'h1000101C
		data_memory_RAM [8] = 32'h00000000; // 32'h10001020
		data_memory_RAM [9] = 32'h00000000; // 32'h10001024
		data_memory_RAM[10] = 32'h00000000; // 32'h10001028
		data_memory_RAM[11] = 32'h00000000; // 32'h1000102C
		data_memory_RAM[12] = 32'h00000000; // 32'h10001030
		data_memory_RAM[13] = 32'h00000000; // 32'h10001034
		data_memory_RAM[14] = 32'h00000000; // 32'h10001038
		data_memory_RAM[15] = 32'h00000000; // 32'h1000103C
	end                                     
	
	always @(posedge clk) begin
		if (mem_write) begin
			data_memory_RAM[(address-268439552)/4] <= write_data;
		end
		
		if (mem_read) begin
			read_data = data_memory_RAM[(address-268439552)/4];
		end
	end
		
endmodule

module tb_data_memory();
	reg tb_clk;
	reg [31:0] tb_address;
	reg [31:0] tb_write_data;
	reg tb_mem_read;
	reg tb_mem_write;
	wire [31:0] tb_read_data;
	
	initial begin
		tb_clk = 1;
		repeat (30) begin
			#5 tb_clk = ~tb_clk;
		end
	end
	
	initial begin
		// initializing first address and some data to be written
		tb_mem_read   = 1'b0;
		tb_mem_write  = 1'b0;
		tb_address 	  = 32'h10001000;
		tb_write_data = 32'h11112222;
		
		// setting mem_write to write ar address 10001000h
		#10 tb_mem_write = 1'b1; 
		#10 tb_mem_write = 1'b0; 
		#10;
		
		// setting data to be written at second address location
		tb_address    = 32'h10001004;
		tb_write_data = 32'h33334444;
		
		// setting mem_write to write at address 10001004h
		#10 tb_mem_write = 1'b1; 
		#10 tb_mem_write = 1'b0; 
		#10;
		
		//reading data from location 10001000h
		tb_address = 32'h10001000;
		#10 tb_mem_read = 1'b1; 
		#10 tb_mem_read = 1'b0; 
		#10;
		
		//reading data from location 10001004h
		tb_address =32'h10001004;
		#10 tb_mem_read = 1'b1; 
		#10 tb_mem_read = 1'b0; 
		#10;
		
	end

	data_memory test_data_memory
	(
		.clk        (tb_clk       ),
		.address    (tb_address   ),
		.write_data (tb_write_data),
		.mem_read   (tb_mem_read  ),
		.mem_write  (tb_mem_write ),
		.read_data  (tb_read_data )
	);
	
endmodule