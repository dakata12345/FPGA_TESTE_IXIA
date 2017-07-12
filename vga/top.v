module top (
				input clk,
				input rst,
				output h_sync,
				output v_sync,
				output [3:0] red,
				output [3:0] green,
				output [3:0] blue
				);
				
				wire active_zone;
				wire [10:0] x_pos, y_pos;
				VGA_SYNC vga(.clock(clk),.rst(rst),.h_sync(h_sync),.v_sync(v_sync),.active_zone(active_zone),.x_pos(x_pos),.y_pos(y_pos));
				assign red = (active_zone) ? 4'b1111 : 4'b0000;
				assign green = 4'b0000;
				assign blue = 4'b0000;
				
				/*always@(*)
				if (active_zone) begin
								if (x_pos == 2 & y_pos == 2) begin
										red = 4'b1111;
										green = 4'b0000;
										blue = 4'b0000;
										end
										else begin 
										red = 4'b0000;
										green = 4'b0000;
										blue = 4'b0000;
											  end	
								 end
						else begin 
										red = 4'b0000;
										green = 4'b0000;
										blue = 4'b0000;
									end
				*/					
				endmodule
				