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
	 input IntReq,
	 output reg [31:0] PC,
	 output [31:0] ADD4
    );
	assign ADD4 = PC + 4;
	always @(posedge Clk)
	if (Clr) PC <= 32'h00003000;
	else if (!stall || IntReq) PC <= PCinput;
endmodule


module im(
	input [10:0] Addr,
	output [31:0] Data
	);
	reg [31:0] rom [2047:0];
	initial begin
		$readmemh("code.txt", rom);
		$readmemh("handler.txt", rom, 1120, 2047);
	end;
	wire [10:0] nA;
   assign nA = {~Addr[10], Addr[9:0]};
	assign Data = rom[nA];
endmodule
