// Top-level module that defines the I/Os for the DE-1 SoC board

module test (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	logic[ 4:0 ] a;
	logic[ 4:0 ] b;
	logic[ 5:0 ] s;
	logic[ 3:0 ] c;
	assign a = SW[ 9:5 ];
	assign b = SW[ 4:0 ];
	assign s = a + b;
	assign c = {2'b00, s[ 5:4 ]};
	assign LEDR = SW;
	SevenSegment Hex0( s[ 3:0 ], 1, HEX0);
	SevenSegment Hex1( c[ 3:0 ], 1, HEX1);
	SevenSegment Hex2( SW[ 3:0 ], 1, HEX2);
	SevenSegment Hex3( SW[ 4 ], 1, HEX3);
	SevenSegment Hex4( SW[ 8:5 ], 1, HEX4);
	SevenSegment Hex5( SW[ 9 ], 1, HEX5);
endmodule