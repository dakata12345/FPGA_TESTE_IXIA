module top (
				input clk,
				input rst,
				output h_sync,
				output v_sync,
				output  we_n_out,//write enable
				output  ce_n_out,//chip enable
				output  oe_n_out,//output_enable active low
				output  lb_n_out,// lower byte control
				output  ub_n_out,// upper byte control
				output reg [3:0] red,
				output reg [3:0] green,
				output reg [3:0] blue,
				output [17:0] addr_out,
				inout  [15:0] data_io
				);
				
				wire active_zone;
				wire [10:0] x_pos, y_pos;
				wire trig_in,rw_in,done_out;
				wire [18:0] addr_in;
				wire [7:0] w_data_in;
				wire [7:0] r_data_out;
				reg [18:0] cnt;
				
				
				always@(posedge clk)
							if (~rst) cnt <=19'b0;
								else if (cnt == 19'd480000) cnt<=19'b0;
										else if (active_zone) cnt <= cnt + 1'b1;
				
				assign w_data_in = 1'b0;
				assign trig_in = 1'b1;
				assign rw_in = 1'b1;
				assign addr_in = cnt;
				
				
				
				/*always@(*) begin
						if (active_zone) begin
								if (lb_n_out)begin
												red[3:1] = data_io[15:13];
												green[3:2] = data_io[12:11];
												blue[3:1] = data_io[10:8];
												end
										else begin
											  red[3:1] = data_io[2:0];
											  green[3:2] = data_io[4:3];
											  blue[3:1] = data_io[7:5];
											  end
							end
							else begin
									red[3:1] = 3'b0;
									green[3:2] = 2'b0;
									blue[3:1] = 3'b0;
									end
				
				 red[0] = 1'b0;
				 green[1:0] = 1'b0;
				 blue[0] = 1'b0; 
				end
				*/
				always@(*) begin
						if (active_zone) begin
												red[3:1] = r_data_out[2:0];
												green[3:2] = data_io[4:3];
												blue[3:1] = data_io[7:5];
												end
										
							
							else begin
									red[3:1] = 3'b0;
									green[3:2] = 2'b0;
									blue[3:1] = 3'b0;
									end
				
				 red[0] = 1'b0;
				 green[1:0] = 1'b0;
				 blue[0] = 1'b0; 
				end
			
				VGA vga(.clock(clk),
								 .rst(rst),
								 .h_sync(h_sync),
								 .v_sync(v_sync),
								 .active_zone(active_zone),
								 .x_pos(x_pos),
								 .y_pos(y_pos));
			   
				sramctrl sram(.clk(clk),
								 .rst(rst),
								 .trig_in(trig_in),
								 .rw_in(rw_in),
								 .addr_in(addr_in),
								 .w_data_in(w_data_in),
								 .r_data_out(r_data_out),
								 .done_out(done_out),
								 .we_n_out(we_n_out),
								 .ce_n_out(ce_n_out),
								 .oe_n_out(oe_n_out),
								 .lb_n_out(lb_n_out),
								 .ub_n_out(ub_n_out),
								 .addr_out(addr_out),
								 .data_io(data_io));
				
				
				
				
				
				/*assign red = (active_zone) ? 4'b1111 : 4'b0000;
				assign green = 4'b0000;
				assign blue = 4'b0000;
				
				*/
				
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
				