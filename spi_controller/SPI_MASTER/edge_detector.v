module edge_dectector(
							input clk,
							input signal,
							input rst,
							
							output posedge_detected,
							output negedge_detected
							);
							
							reg signal_r0 =0,signal_r1= 0;
							always@(posedge clk)
										if (~rst) begin
													 signal_r0 <= 1'b0;
													 signal_r1 <= 1'b1;
													 end
													 else begin
															signal_r0 <= signal;
															signal_r1 <= signal_r0;
															end
							assign posedge_detected = (signal_r0 & ~signal_r1);
							assign negedge_detected = (~signal_r0 & signal_r1);
endmodule
							