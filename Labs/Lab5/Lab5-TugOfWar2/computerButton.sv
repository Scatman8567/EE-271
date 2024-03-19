module computerButton(Clock, Reset, LFSR, SW, out);
					output logic out;
					input logic Clock, Reset;
					input logic [ 9:0 ] LFSR;
					input logic [ 8:0 ] SW;
	//Extended version of the SW inputs
	logic [ 9:0 ] ext;
	
	//Concatenate the switch input with a 1 at the beginning
	assign ext = {1'b0, SW}; 
	//use comparator with ext being the compared value
	comparator computer(.Clock, .Reset, .A(ext), .B(LFSR), .out(out));
endmodule
module computerButtonTestbench();
	logic out;
	logic Clock, Reset;
	logic [9:0] LFSR;
	logic [8:0] SW;
	logic [9:0] SW_extend;
	
	computerButton dut(.Clock, .Reset, .LFSR, .SW, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD / 2) 
		Clock <= ~Clock;
	end
	
	initial begin
		Reset <= 1;											   @(posedge Clock);
																   @(posedge Clock);
		Reset <= 0;											   @(posedge Clock);
																   @(posedge Clock);
		// Case 1: LFSR output < SW Input
		LFSR = 10'b000000001;	SW = 9'b010000000;	@(posedge Clock);
																   @(posedge Clock);
		Reset <= 1;											   @(posedge Clock);
																   @(posedge Clock);
		Reset <= 0;											   @(posedge Clock);
																   @(posedge Clock);															
		// Case 2: LFSR output > Sw Input
		LFSR = 10'b1110000001;	SW = 9'b010000000;	@(posedge Clock);
																   @(posedge Clock);
		$stop;
	end
endmodule 