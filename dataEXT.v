`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:58 12/11/2016 
// Design Name: 
// Module Name:    dataEXT 
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
module dataEXT(
    input [1:0] Addr,
    input [31:0] Din,
    input [2:0] ECon,
    output reg [31:0] Dout
    );
	wire [31:0] data;
	assign data = Addr == 0? Din : Addr == 1? Din[31:8] : Addr == 2? Din[31:16]: Din[31:24];
	always @(*)
	case (ECon)
		1: Dout = {24'b0, data[7:0]};
		2: Dout = {{24{data[7]}}, data[7:0]};
		3: Dout = {16'b0, data[15:0]};
		4: Dout = {{16{data[15]}}, data[15:0]};
		default: Dout = data;
	endcase
endmodule
