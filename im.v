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
    input [31:0] PCinput,
	 input Clk,
    input Clr,
	 input stall,
	 output reg [31:0] PC,
	 output [31:0] ADD4
    );
	assign ADD4 = PC + 4;
	always @(posedge Clk)
	if (Clr) PC <= 32'h00003000;
	else if (!stall) PC <= PCinput;
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
