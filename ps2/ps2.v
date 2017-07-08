module ps2(		
			input  clock, reset,
			input  ps2d, ps2c,
			output reg done,
			output  reg data_valid,
			output reg [7:0] tasta
			);

		reg [3:0] count; 
		reg skip;
		reg clock_new; 
		reg parity_bit;
		wire parity_check;
	 
     always @(posedge clock) begin 
		 if(ps2c == 1'b1) begin 
					clock_new <= 1'b1;
					end 
			 else begin
					clock_new <= 1'b0;
					end 
		end 
 
     always @(negedge clock_new or negedge reset)
		 if (~reset) begin 
				count <= 4'h1; 
				done <= 1'b0; 
				tasta <= 8'hf0;
				skip <= 1'b0;
				end
			else  begin 
					case(count) 
						1: done <= 1'b0;
						2: tasta[0]<=ps2d;
						3: tasta[1]<=ps2d; 
						4: tasta[2]<=ps2d;
						5: tasta[3]<=ps2d;
						6: tasta[4]<=ps2d; 
						7: tasta[5]<=ps2d; 
						8: tasta[6]<=ps2d; 
						9: tasta[7]<=ps2d; 
						10: parity_bit <= ps2d; 
						11: begin //Ending bit // key up 
								if(tasta == 8'hF0) skip <= 1'b1;
							   		else if (!skip) done <= 1'b1;
 											   	else skip <= 1'b0;
							end
 
				endcase
 
       if(count <= 4'd10) count <= count+1'b1;
             	  else if(count==4'd11) count <= 1'b1;
        end
		  //always@(negedge clock_new)
				/*	if (done) begin
					     if (parity_bit == parity_check) 
								        data_valid_reg <=1;
								     end   
								else data_valid_reg <=0;
		 
		 assign data_valid = data_valid_reg;		                
		 assign parity_check = (done == 1) ?  tasta[7] ^tasta[6] ^tasta[5] ^tasta[4] ^tasta[3] ^tasta[2] ^tasta[1] ^tasta[0] : 1'bz;
		 */
		 always@(negedge clock)
					if (parity_bit == parity_check) 
								data_valid <=1;
								else data_valid <=0;
		 
		 
		 assign parity_check = (done == 1) ?  tasta[7] ^tasta[6] ^tasta[5] ^tasta[4] ^tasta[3] ^tasta[2] ^tasta[1] ^tasta[0] : 1'bz;
		  
endmodule