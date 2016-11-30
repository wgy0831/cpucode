`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:26 11/30/2016 
// Design Name: 
// Module Name:    npc 
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
module npc(
	 input sel,
    input [31:0] PC4,
    input [25:0] I26,
    input [15:0] I16,
    output [31:0] NPCout
    );
	assign NPCout = sel ? {PC4[31:28], I26[25:0], 2'b00} : (PC4 + {{14{I16[15]}}, I16[15:0], 2'b00});

endmodule
