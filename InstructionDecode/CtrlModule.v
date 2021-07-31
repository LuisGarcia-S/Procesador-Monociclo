`include "include/lagartoII_const.vh"

module CtrlModule (
	input					clk_i			,
	input		`OPCODE		instruction_i	,

	output 				branch_o		,
	output 				memRead_o		,
	output 				memtoReg_o		,
	output 		[2:0]	ALUOp_o			,
	output 				memWrite_o		,
	output 				aluSrc_o		,
	output 				regWrite_o 		
	);

	reg 			[7:0]	FuncCat;		

	always @(posedge clk_i) begin
		case (instruction_i)
			7'b0010011:	FuncCat	<=	8'b10100011;//OP-IMM
			7'b0110011:	FuncCat	<= 	8'b00100010;//R-Type
			7'b1100011:	FuncCat	<= 	8'b11110000;//Branch
			7'b0000011:	FuncCat	<= 	8'b1X001000;//Load	
			7'b0100011:	FuncCat	<= 	8'b0X000101;//Store
			default:	FuncCat	<=	8'b00000000;
		endcase
	end
	
	assign aluSrc_o			=	FuncCat[7];
	assign memtoReg_o		=	FuncCat[6];
	assign regWrite_o		=	FuncCat[5];
	assign memRead_o		=	FuncCat[4];
	assign memWrite_o		=	FuncCat[3];
	assign branch_o			=	FuncCat[2];
	assign ALUOp_o			=	FuncCat[1:0];

endmodule