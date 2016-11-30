`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:12 11/23/2016 
// Design Name: 
// Module Name:    hazardunit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define op 31:26
`define funct 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`include"decoder.v"
module hazardunit(
	input [31:0] InstrD,
	input [31:0] InstrE,
	input [31:0] InstrM,
	input [31:0] InstrW,
	output stall,
	output [1:0] ForwardRSD,
	output [1:0] ForwardRTD,
	output [2:0] ForwardRSE,
	output [2:0] ForwardRTE,
	output [1:0] ForwardRTM
    );
	wire cal_r_D, cal_i_D, btype_D, load_D, jr_D, jal_D, store_D;
	wire cal_r_E, cal_i_E, btype_E, load_E, jr_E, jal_E, store_E;
	wire cal_r_W, cal_i_W, btype_W, load_W, jr_W, jal_W, store_W;
	wire cal_r_M, cal_i_M, btype_M, load_M, jr_M, jal_M, store_M;
	
	wire equalErd, equalErt, equalMrt;
	
	wire stall_b, stall_cal_r_D, stall_cal_i_D, stall_load_D, stall_store_D;
	
	wire [3:0] iEt, iMt, iDt, iWt;
	wire equaliErd, equaliErt, equaliMrt;
	
	decoder Ddecoder(InstrD, iDt);
	decoder Edecoder(InstrE, iEt);
	decoder Mdecoder(InstrM, iMt);
	decoder Wdecoder(InstrW, iWt);

	assign cal_r_D = iDt == 1;
	assign cal_i_D = iDt == 2;
	assign btype_D = iDt == 3;
	assign load_D  = iDt == 4;
	assign jr_D    = iDt == 5;
	assign jal_D   = iDt == 6;
	assign store_D = iDt == 7;
	
	assign cal_r_E = iEt == 1;
	assign cal_i_E = iEt == 2;
	assign btype_E = iEt == 3;
	assign load_E  = iEt == 4;
	assign jr_E    = iEt == 5;
	assign jal_E   = iEt == 6;
	assign store_E = iEt == 7;
	
	assign cal_r_M = iMt == 1;
	assign cal_i_M = iMt == 2;
	assign btype_M = iMt == 3;
	assign load_M  = iMt == 4;
	assign jr_M    = iMt == 5;
	assign jal_M   = iMt == 6;
	assign store_M = iMt == 7;
	
	assign cal_r_W = iWt == 1;
	assign cal_i_W = iWt == 2;
	assign btype_W = iWt == 3;
	assign load_W  = iWt == 4;
	assign jr_W    = iWt == 5;
	assign jal_W   = iWt == 6;
	assign store_W = iWt == 7;
	
	assign equalErd = (InstrE[`rd] != 0) && ((InstrD[`rs] == InstrE[`rd]) || (InstrD[`rt] == InstrE[`rd]));
	assign equaliErd = (InstrE[`rd] != 0) && (InstrD[`rs] == InstrE[`rd]);

	assign equalErt = (InstrE[`rt] != 0) && ((InstrD[`rs] == InstrE[`rt]) || (InstrD[`rt] == InstrE[`rt]));
	assign equaliErt = (InstrE[`rt] != 0) && (InstrD[`rs] == InstrE[`rt]);

	assign equalMrt = (InstrM[`rt] != 0) && ((InstrD[`rs] == InstrM[`rt]) || (InstrD[`rt] == InstrM[`rt]));
	assign equaliMrt = (InstrM[`rt] != 0) && (InstrD[`rs] == InstrM[`rt]);

	assign stall_b =  btype_D && (cal_r_E && equalErd ||
									  cal_i_E && equalErt ||
									  load_E  && equalErt ||
									  load_M  && equalMrt  );
	assign stall_cal_r_D = cal_r_D && load_E && equalErt;
	assign stall_cal_i_D = cal_i_D && load_E && equaliErt;
	assign stall_load_D = load_D && load_E && equaliErt;
	assign stall_jr_D = jr_D && (cal_r_E && equaliErd ||
									  cal_i_E && equaliErt ||
									  load_E  && equaliErt ||
									  load_M  && equaliMrt  );
	assign stall_store_D = store_D && load_E && equaliErt;
	assign stall = stall_b || stall_cal_r_D || stall_cal_i_D || stall_load_D || stall_jr_D || stall_store_D;
	assign ForwardRSD = 
			(btype_D || jr_D) && jal_E && (InstrD[`rs] == 31) ? 1 :
			(btype_D || jr_D) && cal_r_M && (InstrD[`rs] == InstrM[`rd]) ? 2 :
			(btype_D || jr_D) && cal_i_M && (InstrD[`rs] == InstrM[`rt]) ? 2 :
			(btype_D || jr_D) && jal_M && (InstrD[`rs] == 31) ? 3 :
																					0;
	assign ForwardRTD = 
			btype_D && jal_E && (InstrD[`rt] == 31) ? 1 :
			btype_D && cal_r_M && (InstrD[`rt] == InstrM[`rd]) ? 2 :
			btype_D && cal_i_M && (InstrD[`rt] == InstrM[`rt]) ? 2 :
			btype_D && jal_M && (InstrD[`rt] == 31) ? 3 :
																		0;
	
	assign ForwardRSE =
			(cal_r_E || cal_i_E || load_E || store_E) && cal_r_M && (InstrE[`rs] == InstrM[`rd]) ? 1 :
			(cal_r_E || cal_i_E || load_E || store_E) && cal_i_M && (InstrE[`rs] == InstrM[`rt]) ? 1 :
			(cal_r_E || cal_i_E || load_E || store_E) && jal_M && (InstrE[`rs] == 31) ? 2 :
			(cal_r_E || cal_i_E || load_E || store_E) && jal_W && (InstrE[`rs] == 31) ? 3 :
			(cal_r_E || cal_i_E || load_E || store_E) && cal_r_W && (InstrE[`rs] == InstrW[`rd]) ? 4 :
			(cal_r_E || cal_i_E || load_E || store_E) && cal_i_W && (InstrE[`rs] == InstrW[`rt]) ? 4 :
																																	0;
	
	assign ForwardRTE =
			(cal_r_E || store_E) && cal_r_M && (InstrE[`rt] == InstrM[`rd]) ? 1 :
			(cal_r_E || store_E) && cal_i_M && (InstrE[`rt] == InstrM[`rt]) ? 1 :
			(cal_r_E || store_E) && jal_M && (InstrE[`rt] == 31) ? 2 :
			(cal_r_E || store_E) && jal_W && (InstrE[`rt] == 31) ? 3 :
			(cal_r_E || store_E) && cal_r_W && (InstrE[`rt] == InstrW[`rd]) ? 4 :
			(cal_r_E || store_E) && cal_i_W && (InstrE[`rt] == InstrW[`rt]) ? 4 :
																										0;
	
	assign ForwardRTM = 
			store_M && jal_W && (InstrM[`rt] == 31) ? 1 :
			store_M && cal_r_W && (InstrM[`rt] == InstrW[`rd]) ? 2 :
			store_M && cal_i_W && (InstrM[`rt] == InstrW[`rt]) ? 2 :
																						0;
endmodule
