module spi(
			 input clk,
			 input rst,
			 input MISO,
			 input en,
			 input [7:0] data_in,
			 
			 
			 output SCLK,
			 output reg  MOSI,
			 output reg  SS,
			 output reg [7:0] rxd_data
			 );
			 			
			 
			 localparam STATE_IDLE = 2'b00;
			 localparam STATE_SEND = 2'b01;
			 localparam STATE_END = 2'b10;
			
		    localparam clk_div = 8'd24;
			 
			 reg [1:0] state;
			 reg SCLK_reg;
			 reg [7:0] data_buffer;
			 reg [3:0] cnt = 0;
			 reg [3:0] rxd_data_cnt = 4'd0;
			 
			 wire clk_out,posedge_detected,negedge_detected,posedge_detected_SCLK,negedge_detected_SCLK;
			 
			 
			  clk_div div(.clk(clk),
							 .en(en),
							 .clk_div(clk_div),					
							 .clk_out(clk_out)
							 );
			 
			 edge_dectector detector(.clk(clk),
											 .signal(clk_out),
											 .rst(rst),
											 .posedge_detected(posedge_detected),
											 .negedge_detected(negedge_detected)
										   );
			edge_dectector detector_1(.clk(clk),
						.signal(SCLK),
						.rst(rst),
						.posedge_detected(posedge_detected_SCLK),
						.negedge_detected(negedge_detected_SCLK)
						);
						
			 
			

			
			always@(posedge clk)
						if (negedge_detected_SCLK & state == STATE_SEND) cnt <= cnt + 1'b1;
							else if (cnt == 8) cnt <= 4'b0;
							
				always@(posedge clk) begin
						if (~en & state == STATE_IDLE) data_buffer <= data_in;
									else if (cnt == 8) data_buffer <= 8'b0;
						case(state)
							STATE_IDLE: begin
											SS <= 1'b1;
											SCLK_reg <= 1'b0;
											if (~en) state <= STATE_SEND;
													else state <= STATE_IDLE;
											end
							STATE_SEND: begin
											SS <= 1'b0;
										   SCLK_reg <= clk_out;
											case(cnt)
												0 :begin
												   MOSI <= data_buffer[7];
												   if (posedge_detected_SCLK)data_buffer <= data_buffer << 1;
												   end
												1 :begin
												   MOSI <= data_buffer[7];
												   if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end	
												2 :begin
												   MOSI <= data_buffer[7];
												  if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end	
												3 :begin
												   MOSI <= data_buffer[7];
												  if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end	
												4 :begin
												   MOSI <= data_buffer[7];
												  if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end
												5 :begin
												   MOSI <= data_buffer[7];
												   if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end	
												6 :begin
												   MOSI <= data_buffer[7];
												  if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end	
												7 :begin
												   MOSI <= data_buffer[7];
												   if (posedge_detected_SCLK) data_buffer <= data_buffer << 1;
												   end		
												default : MOSI <= 1'b0;
						 					endcase
	
											if (cnt == 8) begin
													 state <= STATE_END;
													
													end
						
													else state <= STATE_SEND;
											end
							STATE_END: begin
										  SS <= 1'b1;
										  SCLK_reg <= 1'b0;
										  state <= STATE_IDLE;
										  end
							default : state <= STATE_IDLE;
						endcase
					end
			
					
							
			always@(posedge clk or negedge rst) begin
						if (~rst) begin
									rxd_data <= 8'd0;
									rxd_data_cnt <= 4'd0;
									
									 end
									 else if (posedge_detected_SCLK & ~SS &  rxd_data_cnt < 4'd7) begin
												 rxd_data <= {rxd_data[6:0], MISO};
												 rxd_data_cnt <= rxd_data_cnt + 1'b1;
												end
												 else if (posedge_detected_SCLK & ~SS & rxd_data_cnt == 4'd7) begin
															rxd_data <= {rxd_data[6:0], MISO};
														end
														else if (state == STATE_END) begin
																			rxd_data_cnt <= 4'd0;
																			 end
																			else begin
																					rxd_data <= rxd_data;
																					rxd_data_cnt <= rxd_data_cnt;
																					end
				end
							
				assign SCLK = (state == STATE_SEND) ? SCLK_reg : 1'b0;			
	endmodule						
											