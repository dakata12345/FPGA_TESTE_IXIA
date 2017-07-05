module spi(
				input clk,
				input rst,
				input miso,
				input en,
				input cpha,
				input cpol,
				input [7:0] tx_data,
				input [7:0] clk_div,
				output [7:0] rx_data,
				output  sclk,
				output reg busy,
				output  ss,
				output  mosi);
				
				localparam STATE_RST = 2'b00;
				localparam STATE_IDLE = 2'b01;
				localparam STATE_RUNNING = 2'b10;
				
				reg [7:0] rx_data_reg;
				reg [1:0] next_state,state;
				reg [7:0] cnt;
				reg [2:0] cnt_2;
				reg ss_reg,mosi_reg;
				reg clk_out;
				
				always@(posedge clk)
							if (~ss_reg) cnt_2 <=0;
									else if (cnt_2 == 7) cnt_2 = 3'bz;
										else cnt_2 <= cnt_2 + 1;
				
				always@(posedge clk)
						if ((~ss_reg) & (cnt_2 !=3'bz)) mosi_reg <= tx_data[cnt_2];		
				    			else mosi_reg <= 1'bz;
								
				
				always@(posedge clk)
							if (~rst) begin
										 cnt<=0;
										 clk_out <=cpol;
										 end
								 else if (cnt == clk_div) begin
													cnt <=0;
													clk_out = ~clk_out;
													end
										else cnt = cnt + 1;
										
				always@(posedge clk)
							if (~rst) state <= STATE_RST;
								else state <= next_state;
									
				
				always@(*)
						case(state)
						STATE_RST : begin
										busy = 1;
										ss_reg = 1;
										rx_data_reg = 0;
										next_state = STATE_IDLE;
										end
						STATE_IDLE: begin
										 rx_data_reg = 0;
										 if (en) begin
													busy = 1;
													next_state = STATE_RUNNING;
													end
													else next_state = STATE_IDLE;
										ss_reg = 1;
										busy = 0;
										 end
						STATE_RUNNING:	begin
											busy = 1;
											ss_reg = 0;
											rx_data_reg = 0;
											if (cnt_2 == 3'bz)
										      	begin
													busy = 0;
													ss_reg = 1;
													next_state = STATE_IDLE;
													end
											else next_state = STATE_RUNNING;
											end	
						default : begin
										busy = 1;
										ss_reg = 1;
										rx_data_reg = 0;
										next_state = STATE_IDLE;
										end					
						endcase
						
						assign mosi = mosi_reg;
						assign sclk = (~ss_reg) ? 1'bz : clk_out;
						assign rx_data = rx_data_reg;
						assign ss = ss_reg;
	endmodule					