module keyboard( input clock,
						input ps2_clock,
						input ps2_data,
						
            output reg done,
            output reg [7:0] tasta);



reg [3:0] count; 
reg skip;
reg parity;
reg clock_new;
reg start;
reg stop; 
	

always @(posedge clock) begin

	 if(ps2_clock == 1) begin
		clock_new <= 1;
	end else begin
		clock_new <= 0;
	end
end
initial begin
				count <= 4'h1; 
				done <= 1'b0; 
				tasta <= 8'hf0;
				skip <= 0;
				start = 0;
				stop = 0;
				end

				
 
always @(negedge clock_new) 
begin 
		
		
		case(count) 
		1: begin
		   done <= 0;
		   start <= ps2_data;
		   end	  
		2: tasta[0]<=ps2_data; 
		3: tasta[1]<=ps2_data; 
		4: tasta[2]<=ps2_data; 
		5: tasta[3]<=ps2_data; 
		6: tasta[4]<=ps2_data; 
		7: tasta[5]<=ps2_data; 
		8: tasta[6]<=ps2_data; 
		9: tasta[7]<=ps2_data; 
		10: parity <= ps2_data;
		11:begin
			stop <= ps2_data;
			if ((parity == ~(tasta[7]^tasta[6]^tasta[5]^tasta[4]^tasta[3]^tasta[2]^tasta[1]^tasta[0]) & stop)) begin	  
		   	 if(tasta == 8'hF0)
						skip <= 1;
			    else if (!skip)
						done <= 1; 
				 else
				   skip <= 0;				
		   	end
				else begin
						skip <= 0;
						done<=0;
						end
			end	
	endcase 
	
	if (count <= 10 & ~start)
		count <= count+1;  
	else if(count==11 | stop) 
		count <= 1; 
	end	

endmodule