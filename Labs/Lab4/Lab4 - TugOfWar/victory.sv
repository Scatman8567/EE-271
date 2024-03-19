module victory (Clock, Reset, LEDR9, LEDR1, L, R, w);
				input logic Clock, Reset, LEDR9, LEDR1, L, R;
				output logic [ 6:0 ] w;
				
	enum {off, P1, P2} ps, ns;
	// Define the next state
	always_comb begin
		case(ps)
			off: if(LEDR9 & L & ~R) ns = P1;
				  else if (LEDR1 & R & ~L) ns = P2;
				  else ns = off;
			P1: ns = P1;
			P2: ns = P2;
		endcase
	end
	// Define output
	always_comb begin
		if (ns == P1) w = 7'b1111001;
		else if (ns == P2) w = 7'b0100100;
		else w = 7'b1111111;
	end
	// Define the sequential block
	always_ff @(posedge Clock) begin
		if(Reset)
			ps <= off;
		else
			ps <= ns;
	end
endmodule
module victoryTestbench();
	logic Clock, Reset, LEDR9, LEDR1, L, R;
	logic [ 6:0 ] w;
	
	victory dut (.Clock, .Reset, .LEDR9, .LEDR1, .L, .R, .w);
	
	// clock set-up
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;
					
	end // initial
		
	initial begin
	
			Reset <= 0;														  repeat(4) @(posedge Clock); // 4 cycles of reset being off
			Reset <= 1;								  						  repeat(5) @(posedge Clock); // 5 cycles of reset of being on to show the resetted state
			Reset <= 0; LEDR9 <= 1; LEDR1 <= 0; L <= 1; R <= 0;  repeat(5) @(posedge Clock); // State 1: LED9 is on, LED1 is off, Left is pressed, right is not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset 
			Reset <= 0; LEDR9 <= 0; LEDR1 <= 1; L <= 0; R <= 1;  repeat(5) @(posedge Clock); // State 2: LED9 is off, LED1 is on, Right is pressed, left is not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; LEDR9 <= 1; LEDR1 <= 0; L <= 0; R <= 1;  repeat(5) @(posedge Clock);	// State 3: LED9 is on, LED1 is off, right is pressed, left is not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; LEDR9 <= 0; LEDR1 <= 1; L <= 1; R <= 0;  repeat(5) @(posedge Clock); // State 4: LED9 is off, LED1 is on, Left is pressed, Right is not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; LEDR9 <= 0; LEDR1 <= 0; L <= 1; R <= 0;  repeat(5) @(posedge Clock); // State 4: LED9 is off, LED1 is off, Left is pressed, Right is not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; LEDR9 <= 0; LEDR1 <= 0; L <= 0; R <= 1;  repeat(5) @(posedge Clock); // State 4: LED9 is off, LED1 is off, Left is not pressed, Right is pressed
			// The cases of both LED9 and LED1 being on should not be possible, so should not be tested.
			$stop; // stops the simulation
		
	end // initial
endmodule
