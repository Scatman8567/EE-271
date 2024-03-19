// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (Clock, Reset, divided_clocks);
	input logic Reset, Clock;
	output logic [31:0] divided_clocks = 0;
	always_ff @(posedge Clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

module clock_dividerTestbench();
	logic Clock, Reset;
	logic [ 31:0 ] divided_clocks;
	
	clock_divider dut(.Clock, .Reset, .divided_clocks);
	
	parameter clock_period = 100;
	
	integer i;
	initial begin
		for( i = 0; i < clock_period; i++) begin
			@(posedge Clock);
		end
		$stop;
	end
endmodule
