// seven segment decoder as a set of SOP or POS equations.

module SevenSegment (
		input logic [ 3:0 ] hexDigit,
		input logic enable,
		output logic [ 6:0 ] segments );
		
	logic b0, b1, b2, b3;
	logic [ 6:0 ] s;
	
	assign b0 = hexDigit[ 0 ];
	assign b1 = hexDigit[ 1 ];
	assign b2 = hexDigit[ 2 ];
	assign b3 = hexDigit[ 3 ];
		// Equations for each of the segments, counting clockwise
		// around the outside starting from the top, then the middle.
		assign s[0] = enable & (b1 & b2 | ~b1 & ~b2 & b3 | ~b0 & b3 |
						 ~b0 & ~b2 | b0 & b2 & ~b3 | b1 & ~b3);
		assign s[1] = enable & (~b3 & ~b2 | ~b0 & ~b2 | ~b1 & ~b0 & ~b3 |
						 ~b1 & b0 & b3 | b1 & b0 & ~b3);
		assign s[2] = enable & (~b1 & ~b3 | b0 & ~b3 | ~b1 & b0 | b3 & ~b2 |
					    b1 & ~b3 & b2);
		assign s[3] = enable & (~b1 & b3 | ~b1 & b0 & b2 | b0 & b3 & ~b2 | 
						 b1 & ~b3 & ~b2 | b1 & ~b0 & ~b3 | b1 & ~b0 & b2 |
						 ~b0 & ~b3 & ~b2);
		assign s[4] = enable & (~b0 & ~b2 | b1 & ~b0 | b3 & b2 | b1 & b3);
		assign s[5] = enable & (~b1 & ~b0 | b3 & ~b2 | b3 & b1 | ~b0 & b2 |
					    ~b1 & ~b3 & b2);
		assign s[6] = enable & (b1 & ~b0 | b3 & ~b2 | b0 & b3 | ~b3 & b2 & ~b1 |
	                ~b3 & ~b2 & b1);
	
	// Invert the outputse for active low on the De1-SoC board. 
		assign segments = ~s;
endmodule

module testbench ();
	logic [ 3:0 ] hex;
	logic [ 6:0 ] segments;
	integer i;
	
	SevenSegment ss (hex, 1, segments );
	
	initial
	for ( i = 0; i < 16; i = i + 1)
		begin
		hex = i; #10;
		end
endmodule

