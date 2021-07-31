`include "include/lagartoII_const.vh"
module	InstMem (
	input								clk_i	,
	input								WE_i	,
	input 			[`INDEX_MSB-1:0]	AddrR_i	,
	input 			[`INDEX_MSB-1:0]	AddrW_i	,
	input 			`WORD				DataW_i	,
	output wire		`WORD				DataR_o
	);

	reg				`WORD				MemorySync	[2**`INDEX_MSB-1:0];		
	
	initial
	begin
		$readmemh	("include/bubblesorttext.hex", MemorySync);
	end
	
	
	always @(posedge clk_i)
		begin 
			if (WE_i)
				MemorySync[AddrW_i]		<=	DataW_i;
		end
		
	assign  DataR_o						=	MemorySync[AddrR_i ];
	
endmodule

