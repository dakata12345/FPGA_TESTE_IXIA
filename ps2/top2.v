module top(
			input  reset,
			input  ps2d, ps2c,
			output  data_valid,
			output [6:0] data_out,
			output [6:0] data_out_second
			);
			wire [7:0] tasta;
			
			ps2 keyboard(.rst(reset),.data_kb(ps2d), .clk_kb(ps2c),.data_valid(data_valid),.out_reg(tasta));
			transcodor trans1(.data_in(tasta[3:0]),.data_out(data_out));
			transcodor trans2(.data_in(tasta[7:4]),.data_out(data_out_second));
			endmodule
			
