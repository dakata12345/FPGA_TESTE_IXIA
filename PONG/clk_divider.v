module clk_divider(input clk,
						 input rst,
						 output clk_25 
							);
								reg [1:0] cnt;
								always@(posedge clk)
											if (~rst) cnt <= 2'b0;
											    else cnt <= cnt + 1'b1;
								assign clk_25 = cnt[0];				 
endmodule							