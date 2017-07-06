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
				
				localparam STATE_RST = 2'd0;
				localparam STATE_IDLE = 2'd1;
				localparam STATE_RUNNING = 2'd2;
				
				reg [7:0] rx_data_reg;
				reg [1:0] next_state,state;
				reg [7:0] cnt;
				reg [3:0] cnt_2;
				reg ss_reg,mosi_reg;
				reg clk_out;
				reg ok;
				reg data_transmited;
	
	always@(posedge sclk)
				if (ok) cnt_2 <=0;
							else if (cnt_2 == 8) cnt_2 <= 4'bz;
	             								else cnt_2 <= cnt_2 + 1;
				
  always@(posedge sclk)
		  	if (~ss_reg) begin
						  	mosi_reg <= tx_data[cnt_2];
						  	rx_data_reg[cnt_2] <= miso;
							 end
	    			else mosi_reg <= 1'bz;
								
				
  always@(posedge clk)
			if (~rst) begin
					 cnt<=0;
					 clk_out <=cpol;
					 end
   			 else if (cnt == clk_div) begin
								    cnt <=0;
								    clk_out <= ~clk_out;
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
		            data_transmited = 0;
		            next_state = STATE_IDLE;
		            end
		
		STATE_IDLE: begin
		            ss_reg = 1;
		            busy = 0;
		            data_transmited = 0;
		            if (en) begin
		              busy = 1;
		              ss_reg = 0;
		              next_state = STATE_RUNNING;
		            end
		               else next_state = STATE_IDLE;
		          	     
		            end
		
		STATE_RUNNING:	begin
		               if(~data_transmited)
		    	                 ok = 1;
	                 busy = 1;
		               ss_reg = 0;
	                 if(cnt_2 == 0)begin
		                  ok = 0;
		                  data_transmited = 1;
		                  end
		               if (cnt_2 == 4'd8) begin
		                        busy = 0;
		                        ss_reg = 1;
		                        next_state = STATE_IDLE;
		                        data_transmited = 0;
		                        end
		                    else next_state = STATE_RUNNING;
		              end	
	  
	  default : 		begin
		            busy = 1;
		            ss_reg = 1;
		            next_state = STATE_IDLE;
		            end					
		
		endcase
		
		assign rx_data = rx_data_reg;
		assign mosi = mosi_reg;
		assign sclk = (~ss_reg) ? clk_out : 1'bz;
		assign ss = ss_reg;
	
	endmodule					