module DFlipFlop2 (Clock, Reset, key, series2);
			input logic Clock, Reset, key;
			output logic series2;
			
	logic series1;
	// State 1: first series of flip flop
	always_ff @(posedge Clock) begin
		series1 <= Reset ? 0 : key;
	end
	// State 2: Second series of flip flop
	always_ff @(posedge Clock) begin
		series2 <= Reset ? 0 : series1;
	end
endmodule
module DFlipFlop2Testbench();
	logic key, series2, Clock, Reset;
	
	DFlipFlop2 dut (.Clock, .Reset, .key, .series2);
	
	// clock set-up
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;
					
	end // initial
		
	initial begin
	
			Reset <= 0;														  repeat(4) @(posedge Clock); // 4 cycles of reset being off
			Reset <= 1;								  						  repeat(5) @(posedge Clock); // 5 cycles of reset of being on to show the resetted state
			Reset <= 0; key <= 1; 										  repeat(5) @(posedge Clock); // State 1: button pressed
			Reset <= 1;																		@(posedge Clock);	// Reset 
			Reset <= 0; key <= 0; 										  repeat(5) @(posedge Clock); // State 1: button unpressed
			$stop; // stops the simulation
		
	end // initial
endmodule