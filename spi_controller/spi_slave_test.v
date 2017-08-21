module spi_slave_tb();

	parameter N = 8;
	integer i;
	
	reg [N-1:0] din;
	wire [N-1:0] dout;
	reg [N-1:0] gotback;
	reg [N-1:0] tosend;
	
	wire miso;
	reg mosi,sclk,ssbar;
	
	task send;
	input [N-1:0] dataout;
	output [N-1:0] gotdata;
	
	reg [N-1:0] temp;
	begin
		#10;
		ssbar = 0;
		for(i=N-1;i>=0;i = i - 1) begin
			sclk = 0;
			mosi = dataout[i];
			#10;
			sclk = 1;
			temp = { temp[N-2:0], miso };
			#10;
		end
		sclk = 0;
		ssbar = 1;
		gotdata = temp;
		#10;
	end
	endtask
	
	spi_slave U0(
		.mosi(mosi),
		.sclk(sclk),
		.ssbar(ssbar),
		.miso(miso),
		.din(din),
		.dout(dout)
		);
	
	initial begin
		$dumpfile("op.vcd");
		$dumpvars;
		
		mosi = 0;
		ssbar = 1;
		sclk = 0;
		din = 0;
		gotback = 0;
		#100;
		
		din = 1;	
		tosend = 8'h12;
		send(tosend,gotback);
		
		#100;
		din = 20;
		tosend = 55;
		send(tosend,gotback);
		
		#100;
		$finish;
	end

endmodule
