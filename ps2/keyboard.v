module keyboard(input clk_kb,
 	              input data_kb,
 	              output reg [7:0] out_reg
 	              output data_valid
 	              );

reg [3:0] counter;
reg [7:0] data_curr;
reg [7:0] data_pre;
reg flag;




always @(negedge clk_kb or negedge rst)
  if (~rst) begin
     counter = 4'h1;
	   data_curr = 8'hf0;
	   data_pre = 8'hf0;
	   flag = 1'b0;
	   out_reg = 8'hf0;
	   end
	 else begin
	   case (counter)
	   	1:;
		  2: 	data_curr[0] <= data_kb;
		  3: 	data_curr[1] <= data_kb;	
		  4: 	data_curr[2] <= data_kb;
		  5: 	data_curr[3] <= data_kb;	
		  6: 	data_curr[4] <= data_kb;
		  7: 	data_curr[5] <= data_kb;	
		  8: 	data_curr[6] <= data_kb;
		  9: 	data_curr[7] <= data_kb;
		  10:	flag <= 1'b1;
		  11: flag <= 1'b0;
	    endcase

	if (counter <= 10)
		counter <= counter + 4'h1;
	else 
		counter <= 4'h1;
end

always @(posedge flag)
begin
	if (data_curr == 8'hf0)
		out_reg <= data_pre;
	else
		data_pre <= data_curr;
end

	assign data_valid = flag;
endmodule 