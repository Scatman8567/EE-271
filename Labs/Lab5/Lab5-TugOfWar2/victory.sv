module victory (Clock, Reset, LEDR9, LEDR1, L, R, HEX0, HEX5, restart);
				input logic Clock, Reset, LEDR9, LEDR1, L, R;
				output logic restart;
				output logic [ 6:0 ] HEX0, HEX5;
	logic [ 2:0 ] P1Wins, P2Wins;
				
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
	// Assigns the 3 bit values of the number of player 1 and 2
   //	wins to seven segment displays
		case(P1Wins)
			3'b000: HEX5 = 7'b1000000;
			3'b001: HEX5 = 7'b1111001;
			3'b010: HEX5 = 7'b0100100;
			3'b011: HEX5 = 7'b0110000;
			3'b100: HEX5 = 7'b0011001;
			3'b101: HEX5 = 7'b0010010;
			3'b110: HEX5 = 7'b0000010;
			3'b111: HEX5 = 7'b1111000;
		endcase
		case(P2Wins)
			3'b000: HEX0 = 7'b1000000;
			3'b001: HEX0 = 7'b1111001;
			3'b010: HEX0 = 7'b0100100;
			3'b011: HEX0 = 7'b0110000;
			3'b100: HEX0 = 7'b0011001;
			3'b101: HEX0 = 7'b0010010;
			3'b110: HEX0 = 7'b0000010;
			3'b111: HEX0 = 7'b1111000;
		endcase
	end

	// Define the sequential block
	always_ff @(posedge Clock) begin
		// Increments the winner's points when game is over
		if(ps == off & ns == P1) begin

			P1Wins <= P1Wins + 1;

		end
		// Increments the winner's points when game is ove
		else if(ps == off & ns == P2) begin

			P2Wins <= P2Wins + 1;
		end
		// Reset Case: Brings points back to 0, brings the state to off, restart is also off
		if(Reset) begin
			P2Wins <= 3'b000;
			P1Wins <= 3'b000;
			ps <= off;
			restart <= 0;
		end
		// If P1 or P2 wins equals 7, bring the points to 0, game resets.
		if(P2Wins == 3'b111 | P1Wins == 3'b111) begin
			P2Wins <= 3'b000;
			P1Wins <= 3'b000;
			ps <= off;
			restart <= 0;
		end
		// If restart is true, then brings it back to reset case, and restart is off again
		else if(restart) begin
			ps <= off;
			restart <= 0;
		end
		// Default state, present state becomes next state
		else
			ps <= ns;
		// If present state is P1 or P2, restart	
		if(ps == P1 | ps == P2)
			restart <= 1;
		else
			restart <= 0;
	end
endmodule
module victoryTestbench();
	logic Clock, Reset, LEDR9, LEDR1, L, R, restart;
	logic [ 6:0 ] HEX0, HEX5;
	
	victory dut (.Clock, .Reset, .LEDR9, .LEDR1, .L, .R, .HEX0, .HEX5, .restart);
	
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
