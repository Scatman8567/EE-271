module player (Clock, Reset, key, o);
			input logic Clock, Reset, key;
			output logic o;
		enum {on, off} ps, ns;
		// Define the next state
		always_comb begin
			case(ps)
				on: if(key) ns = on;
						else ns = off;
				off: if(key) ns = on;
						else ns = off;
			endcase
		end
		// Define output
		assign o = (ps == on & ns == off);
		
		// Define the sequential block
		always_ff @(posedge Clock) begin
			if(Reset)
					ps <= off;
			else 
					ps <= ns;
			end
endmodule
module playerTestbench();
	logic Clock, Reset, key, o;
	
	player dut (.Clock, .Reset, .key, .o); 
	// clock set-up
	parameter clock_period = 100;
		
	initial begin
		Clock <= 0;
		forever #(clock_period /2) Clock <= ~Clock;
					
	end // initial
		
	initial begin
		Reset <= 0;														  repeat(4) @(posedge Clock); // 4 cycles of reset being off
		Reset <= 1;								  						  repeat(5) @(posedge Clock); // 5 cycles of reset of being on to show the resetted state
		Reset <= 0; key <= 1;	  									  repeat(5) @(posedge Clock); // State 1: Button pressed
		Reset <= 1;								  			   						@(posedge Clock);	// Reset 
		Reset <= 0; key <= 0;	  									  repeat(5) @(posedge Clock); // State 2: Button unpressed
		Reset <= 1;								  			   						@(posedge Clock);	// Reset 
		$stop; // stops the simulation
	end
endmodule
