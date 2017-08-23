module clk_div(
					input clk,
					input en,
					input [7:0] clk_div,
					
					output reg clk_out
					);
					reg [7:0] cnt;
					always@(posedge clk)
							  if (~en) begin
											cnt <= 8'b0;
											clk_out <= 1'b0;
											end
											else if (cnt == clk_div) begin
														cnt <= 8'b0;
														clk_out<= ~clk_out;
														end
														else cnt <= cnt + 1'b1;
				endmodule	
				