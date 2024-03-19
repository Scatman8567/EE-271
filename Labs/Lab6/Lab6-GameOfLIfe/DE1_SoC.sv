// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 // Turn off HEX displays
    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 assign HEX6 = '1;
	 // Parameter for the size of the board
	 parameter int boardEdge = 16;
	 // x and y coordinates for next state
	 logic [ boardEdge - 1:0 ] nx, ny;
	 // x and y coordinates for previous state
	 logic [ boardEdge - 1:0 ] px, py;
	 // board size
	 logic [ boardEdge - 1:0 ][ boardEdge - 1:0 ] board;
	 logic setup;
	 logic t_btn, l_btn, r_btn, u_btn, d_btn;


	 always_ff @(posedge SYSTEM_CLOCK) begin
		// toggle button input
		t_btn <= ~KEY[0];
		// left button input
		l_btn <= ~KEY[3] & ~SW[7];
		// right button input 
		r_btn <= ~KEY[2] & ~SW[7];
		// up button input
		u_btn <= ~KEY[3] & SW[7];
		// down button input
		d_btn <= ~KEY[2] & SW[7];
		// SW7 chooses if the inputs on the key will be L or R or U or D
		if (Reset) begin
		end
		else begin
			RedPixels <= '0;
			if (setup) begin
				RedPixels[ny][nx] <= 1;
				py <= ny;
				px <= nx;
			end
		end
	 end
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK, GAME_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign GAME_CLOCK = clk[20];
	 assign SYSTEM_CLOCK =clk[14]; // 1526 Hz clock signal	 
	 assign LEDR[0] = clk[25];
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic Reset;                 // reset - toggle this on startup
	 
	 // Reset switch
	 assign Reset = SW[9];
	 // Setup Switch
	 assign setup = SW[8];
	 // Default values for unused outputs
	 assign LEDR[6:1] = 6'b000000;
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .Reset, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	 // Double flipflop each of the input signals just to avoid metastability
	 DFlipFlop2 FFToggle (.Clock(GAME_CLOCK), .Reset, .key(t_btn), .series2(ff_t_btn));
	 DFlipFlop2 FFLeft (.Clock(GAME_CLOCK), .Reset, .key(l_btn), .series2(ff_l_btn));
	 DFlipFlop2 FFRight (.Clock(GAME_CLOCK), .Reset, .key(r_btn), .series2(ff_r_btn)); 
	 DFlipFlop2 FFUp (.Clock(GAME_CLOCK), .Reset, .key(u_btn), .series2(ff_u_btn));
	 DFlipFlop2 FDown (.Clock(GAME_CLOCK), .Reset, .key(d_btn), .series2(ff_d_btn)); 
	 
	 // player inputs
	 player buttonToggle (.Clock(GAME_CLOCK), .Reset, .key(ff_t_btn), .o(toggle));
	 player buttonLeft (.Clock(GAME_CLOCK), .Reset, .key(ff_l_btn), .o(l));
	 player buttonRight (.Clock(GAME_CLOCK), .Reset, .key(ff_r_btn), .o(r));
	 player buttonUp (.Clock(GAME_CLOCK), .Reset, .key(ff_u_btn), .o(u));
	 player buttonDown (.Clock(GAME_CLOCK), .Reset, .key(ff_d_btn), .o(d));
	 
	 // module that takes the input and board size and outputs the next x and y based on the present x and y state
	 coordinate_select coord (.Clock(GAME_CLOCK), .Reset, .l, .r, .u, .d, .board, .px, .py, .nx, .ny);
	 //Gives the switches lights to show they're active
	 assign LEDR[9:7] = SW[9:7];
	 //generate loop that instantiates the center cases for the for the game of life
	 generate
	 genvar i, j;
		for (i = 1; i < boardEdge - 1; i = i + 1) begin : rows
		   for (j = 1; j < boardEdge - 1; j = j + 1) begin : columns

				pixel_state ps_inst (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[i + 1][j]), .ne(GrnPixels[i + 1][j + 1]), .e(GrnPixels[i][j + 1]), .se(GrnPixels[i - 1][j + 1]), .s(GrnPixels[i - 1][j]), .sw(GrnPixels[i - 1][j - 1]), .w(GrnPixels[i][j - 1]), .nw(GrnPixels[i + 1][j - 1]), .toggle, .light_sel(RedPixels[i][j]), .setup, .g_light(GrnPixels[i][j]) );
			end
		end
	 endgenerate
	 // edge cases
	 generate
	 genvar k;
		for (k = 1; k < boardEdge - 1; k = k + 1) begin : edges
			pixel_state ps_rcol (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[k + 1][0]), .ne(GrnPixels[k + 1][1]), .e(GrnPixels[k][1]), .se(GrnPixels[k - 1][1]), .s(GrnPixels[k - 1][0]), .sw(GrnPixels[k - 1][boardEdge - 1]), .w(GrnPixels[k][boardEdge - 1]), .nw(GrnPixels[k + 1][boardEdge - 1]), .toggle, .light_sel(RedPixels[k][0]), .setup, .g_light(GrnPixels[k][0]) );
			pixel_state ps_trow (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[1][k]), .ne(GrnPixels[1][k + 1]), .e(GrnPixels[0][k + 1]), .se(GrnPixels[boardEdge - 1][k + 1]), .s(GrnPixels[boardEdge - 1][k]), .sw(GrnPixels[boardEdge - 1][k - 1]), .w(GrnPixels[0][k - 1]), .nw(GrnPixels[1][k - 1]), .toggle, .light_sel(RedPixels[0][k]), .setup, .g_light(GrnPixels[0][k]) );
			pixel_state ps_lcol (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[k + 1][boardEdge - 1]), .ne(GrnPixels[k + 1][0]), .e(GrnPixels[k][0]), .se(GrnPixels[k - 1][0]), .s(GrnPixels[k - 1][boardEdge - 1]), .sw(GrnPixels[k - 1][boardEdge - 2]), .w(GrnPixels[k][boardEdge - 2]), .nw(GrnPixels[k + 1][boardEdge - 2]), .toggle, .light_sel(RedPixels[k][boardEdge - 1]), .setup, .g_light(GrnPixels[k][boardEdge - 1]) );
			pixel_state ps_brow (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[0][k]), .ne(GrnPixels[0][k + 1]), .e(GrnPixels[boardEdge - 1][k + 1]), .se(GrnPixels[boardEdge - 2][k + 1]), .s(GrnPixels[boardEdge - 2][k]), .sw(GrnPixels[boardEdge - 2][k - 1]), .w(GrnPixels[boardEdge - 1][k - 1]), .nw(GrnPixels[0][k - 1]), .toggle, .light_sel(RedPixels[boardEdge - 1][k]), .setup, .g_light(GrnPixels[boardEdge - 1][k]) );
		end
	endgenerate
	// corner cases
	pixel_state ps_tr (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[1][0]), .ne(GrnPixels[1][1]), .e(GrnPixels[0][1]), .se(GrnPixels[boardEdge - 1][1]), .s(GrnPixels[boardEdge - 1][0]), .sw(GrnPixels[boardEdge - 1][boardEdge - 1]), .w(GrnPixels[0][boardEdge - 1]), .nw(GrnPixels[1][boardEdge - 1]), .toggle, .light_sel(RedPixels[0][0]), .setup, .g_light(GrnPixels[0][0]) );
	pixel_state ps_bl (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[0][boardEdge - 1]), .ne(GrnPixels[0][0]), .e(GrnPixels[boardEdge - 1][0]), .se(GrnPixels[boardEdge - 2][0]), .s(GrnPixels[boardEdge - 2][boardEdge - 1]), .sw(GrnPixels[boardEdge - 2][boardEdge - 2]), .w(GrnPixels[boardEdge - 1][boardEdge - 2]), .nw(GrnPixels[0][boardEdge - 6]), .toggle, .light_sel(RedPixels[boardEdge - 1][boardEdge - 1]), .setup, .g_light(GrnPixels[boardEdge - 1][boardEdge - 1]) );
	pixel_state ps_tl (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[1][boardEdge - 1]), .ne(GrnPixels[1][0]), .e(GrnPixels[0][0]), .se(GrnPixels[boardEdge - 1][0]), .s(GrnPixels[boardEdge - 1][boardEdge - 1]), .sw(GrnPixels[boardEdge - 1][boardEdge - 2]), .w(GrnPixels[0][boardEdge - 2]), .nw(GrnPixels[1][boardEdge - 2]), .toggle, .light_sel(RedPixels[0][boardEdge - 1]), .setup, .g_light(GrnPixels[0][boardEdge - 1]) );
	pixel_state ps_br (.Clock(GAME_CLOCK), .Reset, .n(GrnPixels[0][0]), .ne(GrnPixels[0][1]), .e(GrnPixels[boardEdge - 1][1]), .se(GrnPixels[boardEdge - 2][1]), .s(GrnPixels[boardEdge - 2][0]), .sw(GrnPixels[boardEdge - 2][boardEdge - 1]), .w(GrnPixels[boardEdge - 1][boardEdge - 1]), .nw(GrnPixels[0][boardEdge - 1]), .toggle, .light_sel(RedPixels[boardEdge - 1][0]), .setup, .g_light(GrnPixels[boardEdge - 1][0]) );
endmodule
