`include "include/lagartoII_const.vh"

module ImmGen(
	input			`WORD	instruction_i,
	output reg		`WORD	data_o
);

	wire 			`OPCODE	opCode_w;

	assign	opCode_w	= 	instruction_i[`OPCODE_WIDTH-1:0];

	always @(*)begin
		case (opCode_w)
			7'b0010011:	data_o = {{`BrTAG_WIDTH{instruction_i[`WORD_WIDTH-1]}}, instruction_i[`WORD_WIDTH-1:`BrTAG_WIDTH]};
			7'b0000011:	data_o = {{`BrTAG_WIDTH{instruction_i[`WORD_WIDTH-1]}}, instruction_i[`WORD_WIDTH-1:`BrTAG_WIDTH]};
			default: data_o	=	{`WORD_WIDTH{1'b0}};
		endcase
	end
	
endmodule 

