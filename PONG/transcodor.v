module transcodor( output reg[6:0] out,
		   input  [3:0] in);
		always@(in) begin
		  case(in)
		 8'h0 : out =7'b1000000; 
		 8'h1 : out = 7'b1111001;  
		 8'h2:  out = 7'b0100100;   //2
		 8'h3:  out = 7'b0110000;
		 8'h4:  out = 7'b0011001;
		 8'h5:  out = 7'b0010010;
		 8'h6:  out = 7'b0000010;
		 8'h7:  out = 7'b1111000;
		 8'h8:  out = 7'b0000000;
		 8'h9:  out = 7'b0010000;
		 default: out = 7'b1111111;
		  endcase
		  end
  endmodule
