module top(
			input  clock, reset,
			input  ps2d, ps2c,
			output reg done,
			output  reg data_valid,
			output [6:0] data_out,
			output [6:0] data_out_second
			);
			wire [7:0] tasta;
			
			ps2 keyboard(.clock(clock),.reset(reset),.ps2d(ps2d), .ps2c(ps2c),.done(done),.data_valid(data_valid),.tasta(tasta));
			transcodor trans(.data_in(tasta),.data_out(data_out),.data_out_second(data_out_second));
			
			endmodule
			