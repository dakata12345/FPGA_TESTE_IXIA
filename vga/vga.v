module VGA(
				input clock,
				input rst,
				output  h_sync,
				output  v_sync,
				output  active_zone,
				output [10:0] x_pos, y_pos);
				
			
				localparam h_visible_area = 800;
				localparam h_front_porch = 56;
				localparam h_back_porch = 64;
				localparam h_sync_pulse = 120;
				localparam h_total_pixels = 1040;
					
				localparam v_visible_area = 600;
				localparam v_front_porch = 37;
				localparam v_back_porch = 23;
				localparam v_sync_pulse = 6;
				localparam v_total_pixels = 666;
				
				reg [10:0] h_counter;
				reg [10:0] v_counter;
				
				
				always @(posedge clock or negedge rst) begin
				if(~rst) begin
							h_counter <=11'b0;
							v_counter <=11'b0;
							end
				else begin
						if (h_counter < h_total_pixels - 1)
									h_counter <= h_counter + 1'b1;
									else 	begin
											h_counter <= 11'b00;
											if(v_counter < v_total_pixels - 1) 
													v_counter <= v_counter + 1'b1;
											  else v_counter <= 11'b0;
											 end 
					 	end
				end						
				
				
				assign h_sync = ((h_counter < (h_visible_area + h_front_porch)) | (h_counter > (h_visible_area + h_front_porch + h_sync_pulse))) ? 1'b1 : 1'b0;
				assign v_sync = ((v_counter < (v_visible_area + v_front_porch)) | (v_counter > (v_visible_area + v_front_porch + v_sync_pulse))) ? 1'b1 : 1'b0;
				assign active_zone = ((h_counter < h_visible_area) & (v_counter < v_visible_area)) ? 1'b1 : 1'b0;		
					   
				
				assign x_pos = (active_zone) ? h_counter : 11'bz;
				assign y_pos = (active_zone) ? v_counter : 11'bz;				

endmodule
