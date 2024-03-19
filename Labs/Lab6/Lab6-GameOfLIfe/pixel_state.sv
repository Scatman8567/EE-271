module pixel_state (Clock, Reset, n, ne, e, se, s, sw, w, nw, light_sel, toggle, setup, g_light);
		input logic Clock, Reset;
		input logic n, ne, e, se, s, sw, w, nw; // adjacent lights
		input logic light_sel; // logic checking if the light is selected or not
		input logic toggle; // toggles the light being on or off
		input logic setup; // setup switch
		output logic g_light; // logic for whether the light is green or not
	logic [ 3:0 ] count;
		
	adjLights adj (.Clock, .Reset, .n, .ne, .e, .se, .s, .sw, .w, .nw, .count);
	enum {game_on, game_off, setup_on, setup_off, idle} ps, ns;
		
	always_comb begin
		case (ps)
			game_off:
				if (setup) begin
					ns <= setup_off;
				end
				else if (count == 3) begin
					ns <= game_on;
				end
				else begin
					ns <= game_off;
				end

			game_on:
				if (setup) begin
					ns = setup_on;
				end
				else if (count == 2 | count == 3) begin
					ns <= game_on;
				end
				else begin
					ns <= game_off;
				end

			setup_off:
				if (!setup) begin
					ns <= game_off;
				end
				else if (light_sel & toggle) begin
					ns <= setup_on;
				end
				else begin
					ns <= setup_off;
				end

			setup_on:
				if (!setup) begin
					ns <= game_on;
				end
				else if (light_sel & toggle) begin
					ns <= setup_off;
				end
				else begin
					ns <= setup_on;
				end

			idle:
				if (setup) begin
					ns <= setup_off;
				end
				else begin
					ns <= game_off;
				end
		endcase
	end
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= idle;
		else begin
			ps <= ns;
			case(ps)
				setup_off, game_off, idle: g_light <= 0;
				setup_on, game_on: g_light <= 1;
			endcase
		end
	end
endmodule
