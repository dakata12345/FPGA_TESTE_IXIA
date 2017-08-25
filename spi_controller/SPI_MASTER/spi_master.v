module spi(
		input clk,
		input rst,
		input [7:0] data_in,
		input w_en,
		input MISO,

		output [7:0] data_out,
		output MOSI,
		output SS,
		output SCLK
		output SPI_done,
		output SPI_idle);
		
		localparam STATE_IDLE = 2'b00;
		localparam STATE_SCLK0 = 2'b01;
		localparam STATE_SCLK1 = 2'b10;
		localparam dvsr = 8'b4;

		reg [1:0] state,next_state;
		reg [7:0] c_reg,c_next;
		reg spi_clk_reg,spi_idle_i,spi_done;
		wire spi_clk_next;
		reg[2:0] bit_reg,bit_next;
		reg [7:0] sin_reg,sin_next,sout_reg,sout_next;
		
		always@(posedge clk or negedge rst)
			   if (~rst) begin
						state <= STATE_IDLE;
						c_reg <= 0;
						bit_reg <= 0;
						sin_reg <= 0;
						sout_reg <=0;
						spi_clk_reg <= 0;
						end
					else begin
						state <= next_state;
						c_reg <= c_next;
						bit_reg <= bit_next;
						sin_reg <= sin_next;
						sout_reg <= sout_next;
						spi_clk_reg <= spi_clk_next;
						end
		always@(*)
			begin
			state_next = state_reg;
			c_next = c_reg + 1'b1;
			bit_next = bit_reg;
			sin_next = sin_reg;
			sout_next = sout_reg;
			spi_idle_i = 1'b0;
			spi_done = 1'b0;
			case(state)
				STATE_IDLE: begin
						  spi_idle_i = 1'b1;
						  if (~w_en) begin
							  sout_next = data_in;
							  next_state = STATE_SCLK0;
							 bit_next = 0;
							c_next = 8'b1;
						   end
						  end
				
				STATE_SCLK0: begin
						   if(c_reg == dvsr) begin
							next_state = STATE_SCLK1;
							sin_next = {sin_reg[6:0],MISO};
c_next = 8'b1;
end

				STATE_SCLK1: begin
						   if (c_reg == dvsr)
							if (bit_reg == 3'b111) 								begin
								spi_done = 1'b1;
								next_state = STATE_IDLE;
								end
							else begin
								sout_next = {sout_reg[6:0],1'b0};
next_state = STATE_SCLK0;
bit_next = bit_reg + 1'b1;
c_next = 8'b1;

						   end	
				endcase
end
	assign spi_clk_next = (next_state == STATE_SCLK1);
	
	assign data_out = sin_reg;
	assign MOSI = sout_reg[7];
	assign SCLK = spi_clk_reg;
	assign SPI_idle = spi_idle_i;
	assign SPI_done = spi_done;
					  
endmodule
		