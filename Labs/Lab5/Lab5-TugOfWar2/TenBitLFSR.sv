module tenBitLFSR(Clock, Reset, out);
			input logic Clock, Reset;
			output logic [ 9:0 ] out;
	// TA shoed that assigning state prior to the always_ff block avoids issues
	logic xnor_out;
	
	assign xnor_out = (out[0] ~^ out[3]);
	always_ff @(posedge Clock) begin
		// Reset case, returns to 10 bit 0's
		if (Reset) out <= 10'b0000000000;
		
		// XNOR 10th bit and 7th bit according to the table shown in lab PDF 
		else out <= {xnor_out, out[9 : 1]};
	end
endmodule
module tenBitLFSRTestbench();
	logic [ 9:0 ] out;
	logic Clock, Reset;
	
	tenBitLFSR dut(.Clock, .Reset, .out);
	// Set up a simulated clock.
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;
					
	end
	// Test the design.
	initial begin
		// The only input of an LFSR is reset, output is correct. 
		Reset <= 1;							@(posedge Clock);
												@(posedge Clock);
		Reset <= 0;			 repeat(10) @(posedge Clock);
		$stop; // end the simulation
	end
endmodule
