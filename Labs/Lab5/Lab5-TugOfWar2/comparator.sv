module comparator (Clock, Reset, A, B, out);
				input logic Clock, Reset;
				input logic [ 9:0 ] A, B;
				output logic out;
	logic val;
	// TA showed that A > B should be outside always_ff block, assigned to 
	// temp value
	assign val = (A > B);
	always_ff @(posedge Clock) begin
		// reset case
		if (Reset)
			out <= 0;
		// output is temp value
		out <= val;
	end
endmodule

module comparatorTestbench();
	logic out;
	logic Clock, Reset;
	logic [ 9:0 ] A, B;
	
	comparator dut(.Clock, .Reset, .A, .B, .out);
	// Set up a simulated clock.
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;	
	end
	// Test the design.
	initial begin
		Reset <= 1;	 											@(posedge Clock);
																	@(posedge Clock);
		Reset <= 0;												@(posedge Clock);
																	@(posedge Clock);
		//Test 1: B > A
		A <= 10'b0100010000; B <= 10'b1000100000;		@(posedge Clock);
																	@(posedge Clock);
		Reset <= 1;	 											@(posedge Clock);
																	@(posedge Clock);
		Reset <= 0;												@(posedge Clock);															
		// Test 2: A > B
		A <= 10'b1000000000; B <= 10'b0000010000;		@(posedge Clock);
																	@(posedge Clock);
		$stop; // stop the simulation
	end
endmodule
		