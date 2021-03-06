module ps2_test();
     reg FPGA_clock,rst,PS2_sclk,PS2_data;
     wire data_valid;
     wire [7:0] data_out;
     
    /* ps2 keyboard(.clock(FPGA_clock),
							.reset(rst),
							.ps2c(PS2_sclk),
							.ps2d(PS2_data),
							.done(data_valid),
							.tasta(data_out),
							.data_valid(data_valid)					
							);*/
			keyboard keyboard(.clk_kb(PS2_sclk),.data_kb(PS2_data),.out_reg(data_out));				
		/*initial begin
		      FPGA_clock = 0;
		     forever #1 FPGA_clock = ~FPGA_clock;
		      end
		*/
		initial begin
		
		         PS2_sclk = 1;
		         rst = 0;
		         PS2_data = 0;
		         #5 rst = 1;     
		            PS2_data = 0;
		         #5 rst = 0; 
		         #20 PS2_sclk = 0;
		             rst = 1;
		         #10  PS2_sclk = 1;
		              
		         #10   PS2_sclk = 0;
		               PS2_data = 1;
		         
		         #10   PS2_sclk = 1;
		          
		         #10   PS2_sclk = 0;
		               PS2_data = 0;
		                
		         #10   PS2_sclk = 1;         
						 #10   PS2_sclk = 0;
						       PS2_data = 1;	
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;      
				
             #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0; 
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
						       PS2_data = 0;	
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1;           
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1;
					
					   #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						// break key
						
		         			#5 rst = 1;     
		            		PS2_data = 0;
		         			#5 rst = 1; 
		         			#20 PS2_sclk = 0;
		             			rst = 1;
		         			#10  PS2_sclk = 1;
		              
		         			#10   PS2_sclk = 0;
		               			 PS2_data = 0;
		         
		         #10   PS2_sclk = 1;
		          
		         #10   PS2_sclk = 0;
		               PS2_data = 0;
		                
		         #10   PS2_sclk = 1;         
						 #10   PS2_sclk = 0;
						       PS2_data = 0;	
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 0;      
				
             #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							  PS2_data = 1; 
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 1;
						       	
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							  PS2_data = 1;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1;           
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 0;
					
					   #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 
						 





						//cealalta tasta
									#5 rst = 1;     
		            		PS2_data = 0;
		         			#5 rst = 1; 
		         			#20 PS2_sclk = 0;
		             			rst = 1;
		         			#10  PS2_sclk = 1;
		              
		         			#10   PS2_sclk = 0;
		               			 PS2_data = 1;
		         
		         #10   PS2_sclk = 1;
		          
		         #10   PS2_sclk = 0;
		               PS2_data = 0;
		                
		         #10   PS2_sclk = 1;         
						 #10   PS2_sclk = 0;
						       PS2_data = 1;	
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 0;      
				
             #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0; 
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 0;
						       PS2_data = 0;	
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							  PS2_data = 1;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 0;           
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1;
					
					   #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 	#5 rst = 1;     
		            		PS2_data = 0;
		         			#5 rst = 1; 
		         			#20 PS2_sclk = 0;
		             			rst = 1;
		         			#10  PS2_sclk = 1;
		              
		         			#10   PS2_sclk = 0;
		               			 PS2_data = 0;
		         
		         #10   PS2_sclk = 1;
		          
		         #10   PS2_sclk = 0;
		               PS2_data = 0;
		                
		         #10   PS2_sclk = 1;         
						 #10   PS2_sclk = 0;
						       PS2_data = 0;	
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 0;      
				
             #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							  PS2_data = 1; 
						 
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							 PS2_data = 1;
						       	
						 #10   PS2_sclk = 1; 
						 
						 #10   PS2_sclk = 0;
							  PS2_data = 1;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1;           
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 0;
					
					   #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 #10   PS2_sclk = 0;
						       						        
						 #10   PS2_sclk = 1;
						       PS2_data = 1; 
						 
						 

						  end
						
	endmodule
						                  
						       