module spi (
				input clock,
				input rst,
				input MOSI,
				input [7:0] data_in,
				input SS,
				input SCLK,
				
				output reg MISO,
				output [7:0] data_out,
				output rxd_flag
				);
				
				wire sck_pos_detect, sck_neg_detect;
				wire SS_pos_detect, SS_neg_detect;
				wire rxd_flag_pos_detect,rxd_flag_neg_detect;
				
				reg rxd_flag_r=1'b0;
				reg [7:0] rxd_data;
				reg [3:0] rxd_data_cnt;
				reg [7:0] txd_data_buf= 8'd0;
				reg [3:0] txd_data_cnt = 4'd0;
				
				edge_detector SCLK_detect(.clock(clock),
											    .rst(rst),
												 .semnal(SCLK),                    
												 .pos_detected(sck_pos_detect),
												 .neg_detected(sck_neg_detect)
												 );
				edge_detector SS_detect(.clock(clock),
											    .rst(rst),
												 .semnal(SS),                    
												 .pos_detected(SS_pos_detect),
												 .neg_detected(SS_neg_detect)
												 );
				edge_detector rxd_flag_detect(.clock(clock),
											    .rst(rst),
												 .semnal(rxd_flag_r),                    
												 .pos_detected(rxd_flag_pos_detect),
												 .neg_detected(rxd_flag_neg_detect)
												 );								 
				//RECEIVE DATA -> on posedge of SCLK	
				always@(posedge clock or negedge rst) begin
						if (~rst) begin
									rxd_data <= 8'd0;
									rxd_data_cnt <= 4'd0;
									rxd_flag_r <= 1'b0;
									 end
									 else if (sck_pos_detect & ~SS &  rxd_data_cnt != 4'd7) begin
												 rxd_data <= {rxd_data[6:0], MOSI};
												 rxd_data_cnt <= rxd_data_cnt + 1'b1;
												end
												 else if (sck_pos_detect & ~SS & rxd_data_cnt == 4'd7) begin
															rxd_data <= {rxd_data[6:0], MOSI};
														end
														 else if (SS_neg_detect) begin
																	 rxd_flag_r <= 1'b0;
																	end
																else if (SS_pos_detect) begin
																			rxd_data_cnt <= 4'd0;
																			rxd_flag_r <= 1'b1;
																			end
																			else begin
																					rxd_data <= rxd_data;
																					rxd_data_cnt <= rxd_data_cnt;
																					rxd_flag_r <= rxd_flag_r;
																				  end
												end
					//SEND DATA ON NEGEDGE OF SCLK
						always@(posedge clock or negedge rst) begin
									if (~rst) begin
												 txd_data_buf <= 8'd0;
												 txd_data_cnt <= 4'd0;
												 end
												 else if (SS_neg_detect) begin
															 txd_data_buf <= data_in;
															end
															else if (sck_neg_detect & ~SS & txd_data_cnt !=7 ) begin
																		MISO <= txd_data_buf[7];
																		txd_data_buf <= {txd_data_buf[6:0], 1'b0};
																		txd_data_cnt <= txd_data_cnt + 1'b1;
																		end
																		else if (sck_neg_detect & ~SS & txd_data_cnt == 7) begin
																					MISO <= txd_data_buf[7];
																					txd_data_cnt <= 4'd0;
																					end
																					else begin
																							txd_data_cnt <= txd_data_cnt;
																							txd_data_buf <= txd_data_buf;
																						end

					end
					
					assign rxd_flag = rxd_flag_pos_detect;
					assign data_out = rxd_data;
endmodule				