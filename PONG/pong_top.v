	module pong(
			 input clock,
			 input ps2_data, 
			 input ps2_clock,
			 input reset,
			 output h_sync,
			 output v_sync,
			 output [11:0]color,
			 output [6:0] out_1,
			 output [6:0] out_2
			);
			
			wire clk_25,active_zone,done;
			wire [9:0] x_pos,y_pos;
			wire [7:0] tasta;
			wire [3:0] score_1,score_2;
			
			clk_divider divider(.clk(clock),
									  .rst(reset),
									  .clk_25(clk_25));
			
			vga vga (.clock(clk_25),
						.rst(reset),
						.h_sync(h_sync),
						.v_sync(v_sync),
						.active_zone(active_zone),
						.x_pos(x_pos),
						.y_pos(y_pos));
			keyboard keyboard(.clock(clock),
									.ps2_clock(ps2_clock),
									.ps2_data(ps2_data),
									.done(done),
									.tasta(tasta));
						
			game_FSM game(.clock(clock),
							  .reset(reset),
							  .active_zone(active_zone),
							  .done(done),.tasta(tasta),
							  .x_pos(x_pos),
							  .y_pos(y_pos),
							  .color(color),
							  .score_player_1(score_1),
							  .score_player_2(score_2));
						
			transcodor score1(.in(score_1),.out(out_1));
			
			transcodor score2(.in(score_2),.out(out_2));

endmodule									