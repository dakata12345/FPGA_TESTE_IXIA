module ps2_transmiter(
					input clk,
					input rst,
					input w_ps2,
					input [7:0] data_in,
					inout ps2_clk,
					inout ps2_data,
					output reg transmiter_idle,
					output reg transmiter_done_tick
					);
					
					// STATES
					localparam STATE_IDLE = 3'b000;
					localparam STATE_REQUEST2_SEND = 3'b001;
					localparam STATE_START = 3'b010;
					localparam STATE_SEND_DATA = 3'b100;
					localparam STATE_STOP = 3'b101;
					
					
					// REG DECLARATIONS
					
					reg [2:0] state,next_state;
					reg [7:0] filter_reg;
					reg ps2_c_filter_reg;
					reg [8:0] frame_reg;
					reg [8:0] frame_next;
					reg [12:0] counter_reg;
					reg [12:0] counter_next;
					reg [3:0] data_counter_reg;
					reg ps2c_out,ps2d_out,ps2_c_en,ps2_d_en;
					reg [3:0] data_counter_next;
					
					wire [7:0] filter_next;
					wire ps2_c_filter_next;
					wire fall_edge;
					
					wire parity;
					
					
					assign parity = ~(^data_in);
					
					// FILTERING PS2_CLOCK
					
					always@(posedge clk)
							if (~rst) begin
									filter_reg = 8'b0;
									ps2_c_filter_reg = 1'b0;
									end
									else begin
											filter_reg = filter_next;
											ps2_c_filter_reg = ps2_c_filter_next;
											end
					assign filter_next = {ps2_clk,filter_reg[7:1]};
					assign ps2_c_filter_next = (filter_reg == 8'hff) ? 1'b1 : (filter_reg == 8'h0) ? 1'b0 : ps2_c_filter_reg;
			
					assign fall_edge = ps2_c_filter_reg & ~ps2_c_filter_next;
					
					
					
					// FSM
					
					// STATE REG
					always@(posedge clk)
							  if (~rst) begin
											state <= STATE_IDLE;
											frame_reg <= 9'b0;
											counter_reg <= 13'b0;
											data_counter_reg <= 4'b0;
											end
									else begin
											state <= next_state;		
											data_counter_reg <= data_counter_next;
											counter_reg <= counter_next;
											frame_reg <= frame_next;
											end
					always@(*) begin
							next_state = state;
							frame_next = frame_reg;
							counter_next = counter_reg;
							data_counter_next = data_counter_reg;
							transmiter_done_tick = 1'b0;
							ps2c_out = 1'b1;
							ps2d_out = 1'b1;
							ps2_c_en = 1'b0;
							ps2_d_en = 1'b0;
							transmiter_idle = 1'b0;
							case(state)
									STATE_IDLE : begin
													transmiter_idle = 1'b1;
												   if (w_ps2) begin
																 frame_next = {parity,frame_reg[7:1]};
																 counter_next = 13'h1fff;
																 next_state = STATE_REQUEST2_SEND;
																 end
														 else next_state = STATE_IDLE;
													end
									STATE_REQUEST2_SEND : begin
																  ps2c_out = 1'b0;
																  ps2_c_en = 1'b1;
																  counter_next = counter_reg - 1'b1;
																  if (counter_reg == 0) next_state = STATE_SEND_DATA;
																		else next_state = STATE_REQUEST2_SEND;
																	end
									STATE_START : begin
														ps2d_out = 1'b0;
														ps2_d_en = 1'b1;
														if (fall_edge) begin
																data_counter_next = 4'd8;
																next_state = STATE_SEND_DATA;
																end
																else next_state = STATE_START;
														end
									STATE_SEND_DATA : begin
												         ps2d_out = frame_reg[0];
															ps2_d_en = 1'b1;
															if (fall_edge) begin
																	frame_next = {1'b0,frame_reg[8:1]};
																	if (data_counter_reg == 0) next_state = STATE_STOP;
																		else begin
																				next_state = STATE_SEND_DATA;
																				data_counter_next = data_counter_reg - 1'b1;
																				end
																			
																end
																else next_state = STATE_SEND_DATA;	
															end
									STATE_STOP: if (fall_edge) begin
															next_state = STATE_IDLE;
															transmiter_done_tick = 1'b1;
															end
															else next_state = STATE_STOP;
									default : next_state = STATE_IDLE;						
								endcase						
																	
							end



							
							assign ps2_clk = ps2_c_en ? ps2c_out : 1'bz;
							assign ps2_data = ps2_d_en ? ps2d_out : 1'bz;
							
endmodule
