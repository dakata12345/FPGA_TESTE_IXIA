module spi(
			 input clk,
			 input rst,
			 //input MISO,
			 input en,
			 input div_en,
			 input [7:0] data_in,
			 
			 
			 output SCLK,
			 output reg  MOSI,
			 output reg  SS
			 );
			 wire clk_out,posedge_detected,negedge_detected,posedge_detected_SCLK,negedge_detected_SCLK;
			 reg [7:0] clk_div;
			 clk_div div(.clk(clk),
							 .en(en),
							 .clk_div(8'd4),					
							 .clk_out(clk_out));
			 
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
			 
			 localparam STATE_IDLE = 2'b00;
			 localparam STATE_SEND = 2'b01;
			 localparam STATE_END = 2'b10;
			 
			 reg [1:0] state;
			 reg SCLK_reg;
			 reg [7:0] data_buffer;
			 reg [3:0] cnt = 0;
			 
			 
						
			 
			
			 always@(posedge clk)
						if (~div_en) clk_div <= data_in;
							 else clk_div <= 8'b0;
			
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
											if (negedge_detected_SCLK)begin
											MOSI <= data_buffer[7];
											data_buffer <= {data_buffer[6:0],1'b0};
											end
											if (cnt == 8) state <= STATE_END;
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
							
				assign SCLK = (state == STATE_SEND) ? SCLK_reg : 1'b0;			
	endmodule						
											