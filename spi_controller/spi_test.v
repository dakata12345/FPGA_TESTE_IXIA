module spi_test();

reg rst,clk,miso,en,cpha,cpol;
reg  	[7:0] tx_data,clk_div;
wire [7:0] rx_data;
wire sclk,busy,mosi,ss;	

initial begin
clk = 0;
forever #5 clk = ~clk;
end

 spi inst_1(.clk(clk),.rst(rst),.miso(miso),.en(en),.cpha(cpha),.cpol(cpol),.tx_data(tx_data),.clk_div(clk_div),.rx_data(rx_data),.sclk(sclk),.busy(busy),.ss(ss),.mosi(mosi));

initial begin
		
		rst = 0;
		en = 1;
 		cpol = 0;
		cpha = 0;
		miso = 1;
		tx_data = 20;
		clk_div = 10;
		
		#20
		@(posedge clk) rst = 1;
		#10
		     en = 0 ;
		     cpol = 0;
			cpha = 0;
			miso = 1;
			tx_data = 20;
				
		repeat(7) @(posedge clk);
			en = 0 ;
		  	cpol = 1;
			cpha = 0;
			miso = 0;
			tx_data = 10;
		repeat(50) @(posedge clk);
			en = 1 ;
		  	cpol = 1;
			cpha = 0;
			miso = 1;
			tx_data = 20;
		repeat(50) @(posedge clk);
			en = 0;
		  	cpol = 0;
			miso = 0;
			tx_data = 30;
		repeat(50) @(posedge clk);
			en = 1;
		  	cpol = 1;
			miso = 1;
			tx_data = 5;
			#4 miso = 0;
			#6 miso = 1;
			#4 miso = 0;
			#6 miso = 1;
		#50000 $stop;
end			

endmodule