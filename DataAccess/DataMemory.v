`include "include/lagartoII_const.vh"
module	DataMem (
	input								clk_i	,
	input								WE_i	,
	input								RE_i	,
	input 			`WORD				Addr_i	,
	input 			`WORD				DataW_i	,
	output reg 		`WORD				DataR_o
	);

	reg				`WORD				MemorySync	[2**`INDEX_MSB-1:0];		
	
	initial
	begin
		$readmemh	("include/bubblesortdata.hex", MemorySync);
	end
	
	//WIrte seccion
	always @(posedge clk_i)
		begin 
			if (WE_i)
				MemorySync[Addr_i]		<=	DataW_i;
		end

	//Read seccion
	always @(posedge clk_i)
		begin 
			if (RE_i)
				DataR_o						=	MemorySync[Addr_i ];
		end
	
endmodule

