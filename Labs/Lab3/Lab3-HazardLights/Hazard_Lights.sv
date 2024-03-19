module Hazard_Lights (clk, reset, w, out);
	input logic clk, reset; 
	input logic [1:0] w;
	output logic [2:0] out;
	// State variables
	enum { Right, Left, Middle, Both } ps, ns;
	// Next State logic

	always_comb begin
		case (ps)
			Right: if (w == 2'b00) ns = Both;
					else if (w == 2'b01) ns = Middle;
					else ns = Left;
			Left: if (w == 2'b00) ns = Both;
					else if (w == 2'b01) ns = Right;
					else ns = Middle;
			Middle: if (w == 2'b00) ns = Both;
					else if (w == 2'b01) ns = Left;
					else ns = Right;
			Both: if (w == 2'b00) ns = Middle;
					else if (w == 2'b01) ns = Right;
					else ns = Left;
			endcase
	end
	
// Output logic - could also be another always_comb block.
	always_comb begin
		case (ps)
			Right: out = 3'b001;
			Left: out = 3'b100;
			Middle: out = 3'b010;
			Both: out = 3'b101;
		endcase
	end
// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= Both;
		else
			ps <= ns;
	end
endmodule

module Hazard_Lights_testbench();
	logic clk, reset;
	logic [1:0] w;
	logic [2:0]out;
	Hazard_Lights dut (clk, reset, w, out);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin

		@(posedge clk);

		reset <= 1; @(posedge clk); // Always reset FSMs at start
		reset <= 0; w <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		w <= 2'b01; @(posedge clk);
		w <= 2'b00; @(posedge clk);
		w <= 2'b11; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		w <= 0; @(posedge clk);
		@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
