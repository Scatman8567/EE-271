module coordinate_select(Clock, Reset, l, r, u, d, board, px, py, nx, ny);
					input logic Clock, Reset;
					input logic l, r, u, d; // directional inputs
					input logic [ 15:0 ][ 15:0 ] board; // playing board
					input logic [ 15:0 ] px, py; // present x state, present y state
					output logic [ 15:0 ] nx, ny; //next x state, next y state
					
	always_ff @(posedge Clock) begin
		if (Reset) begin
			nx <= 0;
			ny <= 0;
		end
		else begin
			if (!l & r) begin
				nx = px - 1;
			end
			else if (!r & l) begin
				nx = px + 1;
			end
			if (!u & d) begin
				ny = py - 1;
			end
			else if (!d & u) begin
				ny = py + 1;
			end
		end
	end
endmodule
