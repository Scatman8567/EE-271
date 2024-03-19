module Mux16_1 (
					input logic A, B, C, D,
					output logic f);
	always_comb
		case( { A, B, C, D} )
			8, 10, 12, 13: f = 1;
			default: f = 0;
		endcase
endmodule
