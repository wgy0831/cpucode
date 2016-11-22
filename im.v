`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:33:21 11/16/2016 
// Design Name: 
// Module Name:    im 
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
module ifu(
    input [31:0] Imm16,
	 input [31:0] Rdata,
    input [31:0] Ldata,
    input Clk,
    input Clr,
	 input [1:0] PCControl,
	 output reg [31:0] PC,
	 output [31:0] PC2Reg
    );
	wire [31:0] PCa4;
	assign PCa4 = PC + 4;
	assign PC2Reg = PC + 4;
	always @(posedge Clk)
	if (Clr) PC <= 32'h00003000;
	else
		case (PCControl)
		2'b00 : PC <= PCa4;
		2'b01 : PC <= (Imm16 << 2) + PCa4;
		2'b10 : PC <= Rdata;
		2'b11 : PC <= Ldata;
		endcase
endmodule


module im(
	input [9:0] Addr,
	output [31:0] Data
	);
	reg [31:0] rom [1023:0];
	initial begin
		$readmemh("code.txt", rom);
	end;
	assign Data = rom[Addr];
endmodule
