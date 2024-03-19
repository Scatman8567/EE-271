 module userInput(out, clk, reset, button);
	output logic out;
	input logic clk, reset, button;
	
	enum {on, off} ps, ns;
	
	always_comb begin
		case(ps)
			on: 	if(button) ns = on;
			
					else ns = off;
				
			off: 	if(button) ns = on;
						
					else ns = off;
			
		endcase
	end
	
	assign out = (ps == on & ns == off);
	//assign pressed = (ns == on);
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= off;
		else
			ps <= ns;
	end
endmodule