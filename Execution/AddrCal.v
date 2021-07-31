//Branch Addr calculation


`include "include/lagartoII_const.vh"

module addrCalc(
	input					clk_i,
	input			`WORD	addrOffset_i,
	input			`WORD	PC_i,
	output reg		`WORD	addrBranch_o
);

	wire 		`WORD	addrShifted_w;
	wire 		`WORD	addrBranch_w;
	assign		addrShifted_w	=	addrOffset_i << 1;
	
	HCAdder	HCAdder_U0(
			.i_A		(PC_i),
			.i_B		(addrShifted_w),
			.i_carryIn	(1'b0),
			.o_Out		(addrBranch_w) 
		);		

	always @(posedge clk_i)begin
		addrBranch_o = addrBranch_w;
	end

	
endmodule