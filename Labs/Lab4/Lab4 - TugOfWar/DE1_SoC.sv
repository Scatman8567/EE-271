// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// Assign HEX 5 - 1 to be off, not necessary for this lab
	 assign HEX5 = 7'b1111111;
	 assign HEX4 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX1 = 7'b1111111;
	 
	 // logic utilized for representing the button inputs that are flip flopped and then the button inputs
	 // that the player module produces
	 logic key0, key3;
	 logic ffKey0, ffKey3;
	 
	 
	 // 2 Calls for the series of 2 double flip-flop modules (one for the left and one for the right player)
	 DFlipFlop2 Button0 (.Clock(CLOCK_50), .Reset(SW[9]), .key(~KEY[0]), .series2(ffKey0));
	 DFlipFlop2 Button1 (.Clock(CLOCK_50), .Reset(SW[9]), .key(~KEY[3]), .series2(ffKey3));
	 
	 // 2 Calls for the player module and creates the button inputs that have been put through the 
	 // flip flop and the user input as shown on the lab4 file
	 player LPlayer (.Clock(CLOCK_50), .Reset(SW[9]), .key(ffKey0), .o(key0));
	 player RPlayer (.Clock(CLOCK_50), .Reset(SW[9]), .key(ffKey3), .o(key3));
	 
	 // normal light module calls for the first right 4 LEDs, when the LED is past LEDR1, the input should be 0.
	 normalLight one (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	 normalLight two (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	 normalLight three (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	 normalLight four (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	 
	 // center light module call for the middle light, middle light will be active on reset.
	 centerLight five (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	 
	 // normal light module call for the left 4 LEDs, when the LED is past LEDR9, the input should be 0.
	 normalLight six (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	 normalLight seven (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	 normalLight eight (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	 normalLight nine (.Clock(CLOCK_50), .Reset(SW[9]), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));

	 // Module that outputs a 1 or 2 on HEX0 if the Left input exceeds the LEDR9, or if the right input exceeds LEDR1
	 victory victor (.Clock(CLOCK_50), .Reset(SW[9]), .LEDR9(LEDR[9]), .LEDR1(LEDR[1]), .L(key3), .R(key0), .w(HEX0));
endmodule
module DE1_SocTestbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	// Test the design.
	initial begin
							  repeat(1) @(posedge CLOCK_50);
											
		// Left Winner
		SW[9] <= 1; 					@(posedge CLOCK_50);
		SW[9] <= 0;						@(posedge CLOCK_50);
		KEY[3] <= 1; KEY[3] <= 1;	@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		// Right Winner
		SW[9] <= 1; 					@(posedge CLOCK_50);
		SW[9] <= 0;						@(posedge CLOCK_50);
		KEY[0] <= 1; KEY[3] <= 1;	@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 0; 					@(posedge CLOCK_50);
		KEY[3] <= 1; 					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		$stop; //End the simulation.
	end
endmodule