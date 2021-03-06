module spi_master_test();
	 
	reg clk,rst,en,div_en;
	reg [7:0] data_in;
	wire SCLK,MOSI,SS;
	spi uut(.clk(clk),
		 .rst(rst),
		.en(en),
		.div_en(div_en),
		.data_in(data_in),
		.SCLK(SCLK),
		.MOSI(MOSI),
		.SS(SS)
		);
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
		end

	initial begin
		rst = 0;
		div_en = 1;
		data_in = 8;
		en = 1;
		@(posedge clk)
		  rst = 1;
		  div_en = 0;
	        repeat(30)@(posedge clk)
		   data_in = 255;
		@(posedge clk)
		  en = 0;
		repeat(100)@(posedge clk)
		  en = 1;
		repeat(100) @(posedge clk)
			   
		
		repeat(40) @(posedge clk)
			   data_in = 15;
		@(posedge clk)
			en = 0;    
		@(posedge clk)
		  en = 1;
end

endmodule
