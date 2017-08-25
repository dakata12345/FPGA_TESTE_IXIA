module clk_view(
					//input CLK_24,
					input rst,
					input CLK_50,
					output reg clk
					//output clk_50
					
					);
					reg [16:0] cnt;
					//assign clk_50 = CLK_50;
					
					
					always@(posedge CLK_50)
								if (~rst) begin
											 cnt <= 0;
											 clk <= 0;
											 end
									else if (cnt == 17'd99999) begin
												cnt <= 0;
												clk <= ~clk;
												end
												else cnt <= cnt + 1'b1;
endmodule
