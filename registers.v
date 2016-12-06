`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:28 11/23/2016 
// Design Name: 
// Module Name:    registersD 
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
module registersD(
    input [31:0] Instr,
    output reg [31:0] InstrD,
    input [31:0] pca4,
    output reg [31:0] pca4D,
    input Clk,
	 input stall,
	 input Clr
    );
	always @(posedge Clk) begin
	//	$display("%h", Instr);
		if (Clr) begin
			InstrD <= 0;
			pca4D <= 0;
		end else
		if (!stall) begin
			InstrD <= Instr;
			pca4D <= pca4;
		end
	end
endmodule
module registersE(
    input Clk,
	 input stall,
    input [31:0] Instr,
    output reg [31:0] InstrE,
    input [31:0] pca4,
    output reg [31:0] pca4E,
    input [31:0] rs,
	 output reg [31:0] rsE,
	 input [31:0] rt,
	 output reg [31:0] rtE,
	 input [31:0] ext,
	 output reg [31:0] extE,
	 input regWrite,
	 output reg regWriteE,
	 input Clr
    );
	always @(posedge Clk) begin
		if (Clr || stall) begin
			InstrE <= 0;
			pca4E <= 0;
			rsE <= 0;
			rtE <= 0;
			extE <= 0;
			regWriteE <= 0;
		end else begin
			InstrE <= Instr;
			pca4E <= pca4;
			rsE <= rs;
			rtE <= rt;
			extE <= ext;
			regWriteE <= regWrite;
		end
	end
endmodule
module registersM(
    input Clk,
    input [31:0] Instr,
    output reg [31:0] InstrM,
    input [31:0] pca4,
    output reg [31:0] pca4M,
    input [31:0] ALUout,
	 output reg [31:0] ALUoutE,
	 input [31:0] rt,
	 output reg [31:0] rtE,
	 input regWrite,
	 output reg regWriteM,
	 input Clr
    );
	always @(posedge Clk) begin
		if (Clr) begin
			InstrM <= 0;
			pca4M <= 0;
			ALUoutE <= 0;
			rtE <= 0;
			regWriteM <= 0;
		end
		else begin
			InstrM <= Instr;
			pca4M <= pca4;
			ALUoutE <= ALUout;
			rtE <= rt;
			regWriteM <= regWrite;
		end
	end
endmodule
module registersW(
    input Clk,
    input [31:0] Instr,
    output reg [31:0] InstrW,
    input [31:0] pca4,
    output reg [31:0] pca4W,
    input [31:0] ALUout,
	 output reg [31:0] ALUoutW,
	 input [31:0] dr,
	 output reg [31:0] drW,
	 input regWrite,
	 output reg regWriteW,
	 input Clr
    );
	always @(posedge Clk) begin
		if (Clr) begin
			InstrW <= 0;
			pca4W <= pca4;
			ALUoutW <= 0;
			drW <= 0;
			regWriteW <= 0;
		end
		else begin
			InstrW <= Instr;
			pca4W <= pca4;
			ALUoutW <= ALUout;
			drW <= dr;
			regWriteW <= regWrite;
		end
	end
endmodule
