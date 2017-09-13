

module sram
	(
		input  clk,
		input  rst,
		input  trig_in,
		input  rw_in,// rw_in = 1 => read,rw_in = 0 =>write
		input  [18:0] addr_in,
		input  [7:0] w_data_in,
		
		output reg [7:0] r_data_out,
		output reg done_out,
		output reg we_n_out,//write enable
		output reg ce_n_out,//chip enable
		output reg oe_n_out,//output_enable active low
		output reg lb_n_out,// lower byte control
		output reg ub_n_out,// upper byte control
		output reg [17:0] addr_out,
		inout  [15:0] data_io
	);
	
		reg [2:0] state;
		
		localparam 	init=3'b000,
						idle=3'b001,
						read=3'b010,
						write=3'b011,
						latch=3'b100;
						
		reg [15:0] data_io_reg;
		reg [15:0] r_data,w_data;
		
		
		
		  
		always@(posedge clk or negedge rst) begin
			if(~rst) begin
				state<=init;
			end else begin
				case(state)
				init: begin
					oe_n_out	<=	1'b1;
					ce_n_out	<=	1'b1;
					we_n_out	<=	1'b1;
					addr_out	<=	18'b0;
					data_io_reg<=16'b0;
					state		<=	idle;
				end
				idle: begin
					we_n_out	<=	1'b1;
					if(trig_in) begin
						if(rw_in) begin
							oe_n_out	<=	1'b0;
							addr_out	<=addr_in[17:0];
							data_io_reg		<=16'bz;
							done_out		<=1'b1;
							state		<=read;
						end else begin
							oe_n_out	<=	1'b1;
							addr_out	<=addr_in[17:0];
							data_io_reg<=w_data;
							done_out<=1'b1;
							state<=write;
						end
					end else begin
						oe_n_out	<=	1'b1;
						ce_n_out	<=	1'b1;
						we_n_out	<=	1'b1;
						done_out	<=	1'b1;
						addr_out	<=	18'bz;
						state		<=	idle;
					end
				end
				read: begin
					ce_n_out	<=	1'b0;
					oe_n_out	<=	1'b0;
					we_n_out	<=	1'b1;
					r_data	<=	data_io;
					done_out	<=	1'b0;
					state		<=	idle;
				end
				write: begin
					ce_n_out	<=	1'b0;
					oe_n_out	<=	1'b1;
					we_n_out	<=	1'b0;
					done_out	<=	1'b0;
					state		<=idle;
				end
			  
			  default: begin
					state<=init;
				end
				endcase
			end
		end
	
	always@(*) begin
		if(~rw_in) begin
			if(addr_in[18]) begin
				ub_n_out=1'b0;
				lb_n_out=1'b1;
				w_data[7:0] = 8'bz;
				w_data[15:8]=w_data_in;
				r_data_out = 8'bz;
				end 
			else begin
				  ub_n_out<=1'b1;
				  lb_n_out<=1'b0;
				  w_data[7:0]<=w_data_in;
				  w_data[15:8]=8'bz;
				  r_data_out = 8'bz;
				  end
		end 
			else begin
				if(addr_in[18]) begin
						ub_n_out=1'b0;
						lb_n_out=1'b1;
						r_data_out[7:0] =r_data[15:8];
						w_data = 16'bz;
						end 
					else begin
							ub_n_out=1'b1;
							lb_n_out=1'b0;
							r_data_out[7:0] =r_data[7:0];
							w_data = 16'bz;
							end
				 end
	end
		assign data_io=data_io_reg;

endmodule