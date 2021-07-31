`include "include/lagartoII_const.vh"

module ALUCtrl(
	input				clk_i,
	input		`FUNC3	func3_i,
	input				func7bit_i,
	input		[1:0]	aluOP_i,
	output reg	[3:0]	ALUCtrl_o
);

	always @(posedge clk_i)begin
		case (aluOP_i)
			2'b00:	ALUCtrl_o	<=	4'b0010;	//ld  or store
			2'b01:	ALUCtrl_o	<=	4'b0110;	//branch
			2'b10:							//R-Type	
				case (func3_i)
						3'b000: ALUCtrl_o	<=	(func7bit_i == 1'b0) ? 4'b0010 : 4'b0110;// add or sub
						3'b010: ALUCtrl_o	<=	4'b0110;//SLT
						//3'b110: ALUCtrl_o	<=	4'b0001;//SLTU
						3'b111: ALUCtrl_o	<=	4'b0000;//and operation
						3'b110: ALUCtrl_o	<=	4'b0001;//or operation	
						3'b100: ALUCtrl_o	<=	4'b0011;//XOR
				endcase
			2'b11:							//I-Type	
				case (func3_i)
						3'b000: ALUCtrl_o	<=	4'b0010;// add
						3'b010: ALUCtrl_o	<=	4'b0110;//SLT
						//3'b110: ALUCtrl_o	<=	4'b0001;//SLTU
						3'b111: ALUCtrl_o	<=	4'b0000;//and operation
						3'b110: ALUCtrl_o	<=	4'b0001;//or operation	
						3'b100: ALUCtrl_o	<=	4'b0011;//XOR
				endcase
		endcase
		
	end
	
endmodule 
