//**********************************************************************************************//
//  TITLE:                  MONOCICLO                                							//
//                                                                                              //
//  PROJECT:                Monociclo                                                            //
//  LANGUAGE:               Verilog, SystemVerilog                                              //
//                                                                                              //
//  AUTHOR:                 Luis Martin Garcia Sebastian - luis.garcia9408@gmail.com 			//
//                                                                                              //
//  REVISION:               0.1 - Monociclo														//
//                                                                                              //
//**********************************************************************************************//

`include "include/lagartoII_const.vh"

module	Monociclo(
//===============================================================================================
//	General
//===============================================================================================
	input 						clk_i,
	input						rst_i,
//===============================================================================================
//	WB
//===============================================================================================
	output				`WORD	wb_dato_o
);
	wire				`WORD	if_inst_i_w;
//===============================================================================================

//===============================================================================================
//	PC Generation
//===============================================================================================
	wire 						brSelect_w;
	wire				`WORD	addrBranch_w;

	PCGen PCGen_U0 (
		.clk_i 					(clk_i)			,
		.rst_i					(rst_i)			,
		.brBit					(brSelect_w)	,
		.brAddr_i				(addrBranch_w)	,
		.nextPC_o				(if_inst_i_w)
	);
	
//===============================================================================================
//	IF Stage
//===============================================================================================
	wire				`WORD	if_inst_o_w;
	
	InstMem	InstMem_U0 (
		.clk_i					(clk_i)				,
		.WE_i					(1'b0)				,
		.AddrR_i				(if_inst_i_w[13:2])	,
		.AddrW_i				(12'b0)				,
		.DataW_i				(32'b0)				,
		.DataR_o		 		(if_inst_o_w)
	);
	
//===============================================================================================
//	Deco Stage
//===============================================================================================	

	wire				`WORD	rr_datars1_o_w;
	wire				`WORD	rr_datars2_o_w;
	wire 					rr_regWrite_o_w	;
	
	RegisterFile	ReadRegister_U0 (
		.clk_i					(clk_i				)	,
		.WE_i					(rr_regWrite_o_w	)	,
		.addrSrc1_i				(if_inst_o_w[19:15]	)	,
		.addrSrc2_i				(if_inst_o_w[24:20]	)	,
		.addrDest_i				(if_inst_o_w[11:7]	)	,
		.dataDest_i				(wb_dato_o			)	,
		.dataSrc1_o				(rr_datars1_o_w		)	,
		.dataSrc2_o				(rr_datars2_o_w		)		
	);

	wire			`WORD	imm_o_w			;	
	wire 					aluSrc_w		;
	wire 					branch_w		;
	wire 					memWrite_w		;
	wire 					memRead_w		;
	wire 					memToReg_w		;
	wire 	[1:0]	aluOp_o_w;


	CtrlModule	CtrlModule_U0	(
		.clk_i			(clk_i)				,
		.instruction_i	(if_inst_o_w[6:0])	,
		.branch_o		(branch_w)			,
		.memRead_o		(memRead_w)			,	
		.memtoReg_o		(memToReg_w	)		,
		.ALUOp_o		(aluOp_o_w)			,
		.memWrite_o		(memWrite_w)		,
		.aluSrc_o		(aluSrc_w)			,
		.regWrite_o		(rr_regWrite_o_w)
	);

	ImmGen	ImmGen_U0(
		.instruction_i	(if_inst_o_w),
		.data_o			(imm_o_w)
	);

//==============================================================================
//	Execution Stage
//===============================================================================================	
	wire  	[3:0]	alu_ctrl_o_w;
	wire 	`WORD	aluOpB_w;
	wire 			aluZero_w;

	assign	aluOpB_w	=	(aluSrc_w == 0) ? rr_datars2_o_w : imm_o_w;

	ALUCtrl	ALUCtrl_U0(
		.clk_i				(clk_i),
		.func3_i			(if_inst_o_w[14:12]),
		.func7bit_i			(if_inst_o_w[30]),
		.aluOP_i			(aluOp_o_w),
		.ALUCtrl_o			(alu_ctrl_o_w)
	);	

	wire 			`WORD	aluOut_w;	

	ALU		ALU_U0(
		.clk_i		(clk_i			),
		.A			(rr_datars1_o_w	), 
		.B			(aluOpB_w		), 
		.ctrl		(alu_ctrl_o_w	), 
		.outALU		(aluOut_w		),
		.overflow	(				),
		.zero		(aluZero_w		)
		);

	assign	brSelect_w	=	(branch_w & aluZero_w);
	
	
	
	addrCalc	addrCalc_U0(
		.clk_i				(clk_i),
		.addrOffset_i		(imm_o_w),
		.PC_i				(if_inst_i_w),
		.addrBranch_o		(addrBranch_w)
	);

//==============================================================================
//	Data Accesss Stage
//==============================================================================
	wire 			`WORD	wb_dato_w;
	
	DataMem		DataMem_U0(
		.clk_i			(clk_i			),
		.WE_i			(memWrite_w		),
		.RE_i			(memRead_w		),
		.Addr_i			(aluOut_w		),
		.DataW_i		(rr_datars2_o_w	),
		.DataR_o		(wb_dato_w)
	);

//==============================================================================
//	Write Back Stage
//==============================================================================

	assign 		wb_dato_o	=	(memToReg_w == 1) ? wb_dato_w : aluOut_w;

endmodule 