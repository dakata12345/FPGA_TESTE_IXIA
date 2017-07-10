module transcodor (
						input [7:0] data_in,
						output reg [6:0] data_out,
						output reg [6:0] data_out_second
						);
						
						always@(*)
								case(data_in)
										
										8'h45 : begin
												  data_out =7'b1000000; 
												  data_out_second	= 7'b1111111;
													end  //0
	 									8'h16 : begin
													data_out = 7'b1111001;  
													data_out_second	= 7'b1111111;
													end//1
										8'h1E: begin
												 data_out = 7'b0100100;   //2
												 data_out_second	= 7'b1111111;
												 end
										8'h26: begin
													data_out = 7'b0110000;
													data_out_second	= 7'b1111111;
													end//3
										8'h25: begin
													data_out = 7'b0011011;
												   data_out_second =7'b1111111;
													end//4
										8'h2E: begin
												  data_out = 7'b0010010;
												  data_out_second	= 7'b1111111;	
												 end //5
										8'h36: begin
												 data_out = 7'b0000010;
												 data_out_second	= 7'b1111111;
												 end //6
										8'h3D: begin
												 data_out = 7'b1111000;
												 data_out_second	= 7'b1111111;
													end//7
										8'h3E: begin
												  data_out = 7'b0000000;
													data_out_second	= 7'b1111111;
													end//8
										8'h46: begin
													data_out = 7'b0010000;
													data_out_second	= 7'b1111111;
											     end		//9
										8'h1C: begin
												 data_out = 7'b0001000;
												 data_out_second	= 7'b1111111;
												  end//A
										8'h32: begin	
												data_out = 7'b0000011;	//B
												data_out_second	= 7'b1111111;
												end
										8'h21: begin
												 data_out = 7'b1000110;
												 data_out_second	= 7'b1111111;
												 end //C
										8'h23: begin
													data_out = 7'b1000000;
													data_out_second	= 7'b1111111;
												 end		//D
										8'h24: begin
												data_out = 7'b0000110;
												data_out_second	= 7'b1111111;
												end	//E
										8'h2B: begin
												data_out = 7'b0001110;
											   data_out_second	= 7'b1111111;
													end//F
										8'h34 :	begin	
													data_out_second = 7'b0110000;
													data_out	= 7'b0011011; //G
													end
										8'h33 :	begin	
													data_out_second = 7'b0110000;
													data_out	= 7'b0110000; //H
													end			
										8'h43 :	begin	
													data_out = 7'b0110000;
													data_out_second	= 7'b0011011; //I
													end	
										8'h3B :	begin	
													data_out_second = 7'b0110000;
													data_out	= 7'b0000011; //J
													end			
										default : begin
													 data_out = 7'b1111111;
													 data_out_second	= 7'b1111111;
													 end
										endcase
										
endmodule