module TenBitLFSR (Clock, Reset, out);
			input logic, Clock, Reset;
			output logic [ 9:0 ] out;
	always_ff @(posedge Clock) begin
		if (Reset) out <= 10'b0000000000;
		
		// XNOR 10th bit and 7th bit according to the table shown in lab PDF 
		else out <= {(out[9] ~^ out[6]), Q[9 : 1]};
	end
endmodule
