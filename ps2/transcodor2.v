module transcodor (
						input [3:0] data_in,
						output reg [6:0] data_out
						);
						
						always@(*)
								case(data_in)
										
										8'h0 : data_out =7'b1000000; 
									   8'h1 : data_out = 7'b1111001;  
										8'h2:  data_out = 7'b0100100;   //2
										8'h3:  data_out = 7'b0110000;
    									8'h4:  data_out = 7'b0011001;
									   8'h5:  data_out = 7'b0010010;
									   8'h6:  data_out = 7'b0000010;
										8'h7:  data_out = 7'b1111000;
										8'h8:  data_out = 7'b0000000;
										8'h9:  data_out = 7'b0010000;
										8'hA: data_out = 7'b0001000;
										8'hB: data_out = 7'b0000011;	//B
										8'hC: data_out = 7'b1000110;
										8'hD: data_out = 7'b0100001;
										8'hE: data_out = 7'b0000110;
										8'hF: data_out = 7'b0001110;
										default : data_out = 7'b1111111;
													 
										endcase
										
endmodule
