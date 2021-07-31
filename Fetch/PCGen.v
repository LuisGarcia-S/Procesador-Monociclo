//**********************************************************************************************//
//  TITLE:                  PCGen                              						         //
//                                                                                              //
//  PROJECT:                Monciclo                                                            //
//  LANGUAGE:               Verilog
//                                                                                              //
//  AUTHOR:                 Luis Martin Garcia Sebastian - luis.garcia9408@gmail.com 				//
//                                                                                              //
//  REVISION:               0.1 - Monociclo									                           //
//                                                                                              //
//**********************************************************************************************//

`include "include/lagartoII_const.vh"
 
module PCGen(
 //==============================================================
 //	General
 //==============================================================
	input				clk_i,
	input				rst_i,
	input		`WORD	brAddr_i,
	input				brBit,
 //==============================================================
 //	PC
 //==============================================================
 
	output reg		`WORD	nextPC_o
);


	always	@(posedge clk_i, negedge rst_i)
		begin
			if (!rst_i)
				nextPC_o	<=	`WORD_ZERO;
			else
				nextPC_o	<=	(brBit==0) ? (nextPC_o + `PC_INCREMENT) : brAddr_i;

				
		end
endmodule
