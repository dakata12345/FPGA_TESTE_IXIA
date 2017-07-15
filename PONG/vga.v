module vga(
				input clock,
				input rst,
				output  h_sync,
				output  v_sync,
				output  active_zone,
				output [9:0] x_pos, y_pos);
				
			
				localparam h_visible_area = 640;
				localparam h_front_porch = 16;
				localparam h_back_porch = 48;
				localparam h_sync_pulse = 96;
				localparam h_total_pixels = 800;
					
				localparam v_visible_area = 480;
				localparam v_front_porch = 10;
				localparam v_back_porch = 33;
				localparam v_sync_pulse = 2;
				localparam v_total_pixels = 525;

				
				reg [9:0] h_counter;
				reg [9:0] v_counter;
				
				
				always @(posedge clock or negedge rst) begin
				if(~rst) begin
							h_counter <=10'b0;
							v_counter <=10'b0;
							end
				else begin
						if (h_counter < h_total_pixels - 1)
									h_counter <= h_counter + 1'b1;
									else 	begin
											h_counter <= 10'b00;
											if(v_counter < v_total_pixels - 1) 
													v_counter <= v_counter + 1'b1;
											  else v_counter <= 10'b0;
											 end 
					 	end
				end						
				
				
				assign h_sync = ((h_counter < (h_visible_area + h_front_porch)) | (h_counter > (h_visible_area + h_front_porch + h_sync_pulse))) ? 1'b1 : 1'b0;
				assign v_sync = ((v_counter < (v_visible_area + v_front_porch)) | (v_counter > (v_visible_area + v_front_porch + v_sync_pulse))) ? 1'b1 : 1'b0;
				assign active_zone = ((h_counter < h_visible_area) & (v_counter < v_visible_area)) ? 1'b1 : 1'b0;		
					   
				
				assign x_pos = active_zone ?  h_counter : 10'bz;
				assign y_pos = active_zone  ? v_counter : 10'bz;	
endmodule