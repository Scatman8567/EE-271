module adjLights (Clock, Reset, n, ne, e, se, s, sw, w, nw, count);
				input logic Clock, Reset, n, ne, e, se, s, sw, w, nw;
				output logic [ 3:0 ] count;
				
	logic [ 7:0 ] surround;
	
	always_ff @(posedge Clock) begin
		if (Reset)
			count = 0;
		else begin
			surround = {n, ne, e, se, s, sw, w, nw};
			count = 0;
			for (int i = 0; i < 8; i++) begin
				if (surround[i] == 1) begin
					count++;
				end
			end
		end
	end
endmodule
