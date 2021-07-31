//ALU 8 bits
`include "include/lagartoII_const.vh"

module ALU (
	input				clk_i,
	input		[3:0]	ctrl,
   	input		`WORD	A, 
	input		`WORD	B, 
   	output reg 	`WORD	outALU, 
	output reg	overflow,
	output		zero
	);

	wire 	w_carryIn, w_carryOut, w_Set, w_overflow;
	wire 	`WORD w_A, w_B, w_outAdder;
	assign zero = (outALU == 0);
	assign	w_carryIn	= 	(( ctrl == 4'b0110) | (ctrl == 4'b1100) | (ctrl == 4'b0111))	?	1'b1 : 1'b0;
	assign	w_B			= 	(( ctrl == 4'b0110) | (ctrl == 4'b1100) | (ctrl == 4'b0111))	?	~B : B;
	assign	w_A			=	(ctrl == 4'b1100)	?	~A : A;
	
	HCAdder hcAdder (w_A, w_B, w_carryIn, w_outAdder, w_Set, w_overflow);
	
	always @(posedge clk_i) begin
		case (ctrl)
            4'b0000: outALU <= w_A & w_B; 	//AND operation
            4'b0001: outALU <= w_A | w_B;	//OR operation
			4'b0011: outALU <= w_A ^ w_B;	//XOR operation
            4'b0010: outALU <= w_outAdder;	//ADD operation	
            4'b0110: outALU <= w_outAdder;	//Substraction operation
            4'b0111: outALU <= w_Set;		//Set Less Than operation
            4'b1100: outALU <= w_A | w_B;	//NOR operation
            default: outALU <= 0;
        endcase

		overflow	<= w_overflow;
	end
	
endmodule 






