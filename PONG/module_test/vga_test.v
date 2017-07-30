module vga_testbench();
  
  reg clk,reset;
  wire [9:0] x_pos, y_pos;
  wire active_zone;
  wire h_sync, v_sync;
  
  vga vga_test(.clock(clk),
                    .rst(reset),
                    .x_pos(x_pos),
                    .y_pos(y_pos),
                    .active_zone(active_zone),
                    .h_sync(h_sync),
                    .v_sync(v_sync));
  
  initial 
  begin clk=0;
    
    forever #10 clk=~clk;
    
  end
  
  initial begin
     reset = 0;
     #15 reset = 1;
     #100000000 $stop;
     
  end

endmodule 