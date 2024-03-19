module normalLight (Clock, Reset, L, R, NL, NR, lightOn);
	input logic Clock, Reset;
	// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.
	
	// this should function exactly the same as the centerlight with the exception
	// that the reset state turns the light off (because only centerlight should be on during reset)
	input logic L, R, NL, NR;
	// when lightOn is true, the normal light should be on.
	output logic lightOn;
	// enumerating variables
	enum {on, off} ps, ns;
	// on = light on, off = light off
	// Define the next state
	always_comb begin
		case(ps)
			on: if((R & ~L) | (L & ~R)) ns = off;
			//on:	  if(~R & L | R & ~L) ns = off;
					else ns = on;
			
			off: if((NL & (R & ~L)) | (NR & (L & ~R))) ns = on;
			//off: 	  if(NR & L & ~R | NL & R & ~L) ns = on;
					else ns = off;
		endcase
	end
	// Define output
	always_comb begin
		case(ps)
			on: lightOn = 1;
			
			off: lightOn = 0;
		endcase
	end
	// Define the sequential block
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= off;
		else
			ps <= ns;
	end
endmodule
module normalLightTestbench();
	logic L, R, NL, NR, lightOn, Clock, Reset;
	
	centerLight dut (.lightOn, .Clock, .Reset, .L, .R, .NL, .NR);
	
	// clock set-up
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;
					
	end // initial
		
	initial begin
	
			Reset <= 0;														  repeat(4) @(posedge Clock); // 4 cycles of reset being off
			Reset <= 1;								  						  repeat(5) @(posedge Clock); // 5 cycles of reset of being on to show the resetted state
			Reset <= 0; R <= 1; L <= 0; NL <= 0; NR <= 0;		  repeat(5) @(posedge Clock); // State 1: Center light on (ps), Right pressed, Left not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset 
			Reset <= 0; R <= 0; L <= 1; NL <= 0; NR <= 0;  		  repeat(5) @(posedge Clock); // State 2: Center light on (ps), Left pressed, Right not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; R <= 1; L <= 0; NL <= 1; NR <= 0;  		  repeat(5) @(posedge Clock);	// State 3: Left Light on (ps), right pressed, left not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; R <= 0; L <= 1; NL <= 0; NR <= 1;  		  repeat(5) @(posedge Clock); // State 4: Right light on (ps), left pressed, right not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; R <= 0; L <= 1; NL <= 1; NR <= 0;  		  repeat(5) @(posedge Clock); // Stage 5: Left light on (ps), left presssed, right not pressed
			Reset <= 1;								  			   						@(posedge Clock);	// Reset
			Reset <= 0; R <= 1; L <= 0; NL <= 0; NR <= 1;  		  repeat(5) @(posedge Clock); // Stage 6: Right light on (ps), right pressed, left not pressed
 			
			$stop; // stops the simulation
		
	end // initial
endmodule
