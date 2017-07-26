module game_FSM(
					input clock,
					input reset,
					input active_zone,
					input done,
					input [7:0] tasta,
				        input [9:0] x_pos,
					input [9:0] y_pos,
					output reg [11:0]color,
					output reg [3:0] score_player_1,
					output reg [3:0] score_player_2
					);

					//STATES
					// 0: reset
					// 1: player_select (keyboard 1 or 2)
					// 2: game (space keyboard to begin)
					// 3: pause (space keyboard to rebegin game / esc to reset)
					localparam STATE_RESET = 3'b000;
					localparam STATE_PLAYER_SELECT = 3'b001;
					localparam STATE_GAME = 3'b010;
					localparam STATE_PAUSE = 3'b011;
					localparam STATE_PLAYER1_SCORE = 3'b100;
					localparam STATE_PLAYER2_SCORE = 3'b101;
					
					//PLAYER 1 KEYS
					localparam PLAYER_1_RIGHT = 8'h23; //D
				   	localparam 	PLAYER_1_LEFT= 8'h1C; //A
					
					//PLAYER 2 KEYS
					localparam PLAYER_2_RIGHT = 8'h4B; //L
				   	localparam 	PLAYER_2_LEFT= 8'h3B; //J
					
					//CONTROL KEYS
					localparam ESC_key = 8'h76; //ESC
					localparam SPACE_key = 8'h29; // SPACE 
					localparam key_1 =8'h16; // 1
					localparam key_2 =8'h1E; //2 Helps between chosing game modes ( single player vs multiplayer)
					
					//GAME DETAILS
					
					// PADDLE DIMENSIONS => pixels
					localparam paddle_width =10'd64;
					localparam paddle_height= 10'd8;
					
					//BALL DIMENSIONS => pixels
					localparam ball_width= 10'd8;
					localparam ball_height= 10'd8;

					// SCREEN DIMENSIONS
					localparam screen_width =10'd640;
					localparam screen_height =10'd480;
					
					// BORDER and FEATURE size
					localparam border_size =10'd6;
					localparam feature_size =10'd11;

					// SPED for computer player
					localparam computer_speed_default= 6'd4;
					
					// COLORS
				   	localparam  color_red =12'b111100000000;
					localparam  color_blue =12'b000000001111;
					localparam	color_white =12'b111111111111;
				   	localparam  color_black =12'b000000000000;
				   	localparam  color_pink =12'b111001110110;
					
					//REG and WIRES declarations
					
					reg old_done; // used to determine whether to recieve data from keyboard or not
					reg [7:0] key_pressed; // key pressed by the user
					reg game_or_pause; // 1 if game 0 if pause
					reg [9:0] ball_x; // ball position on x axis
					reg [9:0] ball_y; // ball position on y axis
					reg ball_dx;// ball direction  x 
					reg ball_dy;// ball direction y	
					reg [9:0] paddle1_x, paddle1_y; // player1 paddle position on x,y
					reg [9:0] paddle2_x, paddle2_y; // player 2 paddle position on x,y
					reg [5:0] speed_counter; // counter for speed
					reg [5:0] ball_speed; //register for ball speed
					reg [5:0] computer_counter; // counter for computer player
					reg [5:0] computer_speed; // computer speed register
					reg player_mode; // 0 = single player ; 1 = multiplayer - 2 players
					reg [2:0] state; // state , next_state register
			
	always @(posedge clock or negedge reset)
		if (~reset) begin
		   ball_speed <= 6'd5;
	   	   score_player_1 <= 4'd0;
		   score_player_2 <= 4'd0;
		   computer_speed <= computer_speed_default;
		   state <= STATE_RESET;
		   end
		 else begin
		      if(active_zone) begin
			 if(old_done != done) begin
			    if(done) begin
				key_pressed <= tasta;
				end
				else old_done <= done;
				end
			  computer_speed <= computer_speed_default;
			  if(x_pos == 1 && y_pos == 1) begin
   			     case (state)
			     STATE_RESET : begin
				 	   ball_x <= screen_width >>1; // ball in the center of screen 
					   ball_y <= screen_height >> 1;
				  	   paddle2_x <= screen_width >> 1; // paddle2 up in center y coordonate stays the same
					   paddle2_y <= border_size << 2;
				 	   paddle1_x <= screen_width >> 1; // paddle 1 position in center of screen bottom with respect to border on y
					   paddle1_y <= screen_height - (border_size << 2);
				 	   state <= STATE_PLAYER_SELECT; // next state chosse whether single or multiplayer
					   score_player_1 <= 4'd0;//reset player scores
					   score_player_2 <= 4'd0;
					   speed_counter <= 6'd0;
					   computer_counter <= 6'd0;
				     	   player_mode <= 1'b0;	
					   end
			    STATE_PLAYER_SELECT :begin
						 if (key_pressed == key_1) begin
						    player_mode <= 1'b0;
						    key_pressed <= 8'b0;
						    end else if (key_pressed == key_2) begin
								  player_mode <=1'b1;
								  key_pressed <= 8'b0;
								  end else if (key_pressed == SPACE_key) begin
										key_pressed <= 8'b0;
										state <= STATE_GAME;		
										ball_dx <= 1'b1;//set ball speed and direction
										ball_dy <= 1'b1;
										ball_speed <= 6'd5;
								                end
						   end
			    STATE_GAME : begin
					  if (key_pressed == SPACE_key) begin
						state <= STATE_PAUSE;
						key_pressed <= 8'b0;
						end
						else if (key_pressed == ESC_key) begin
											    state <= STATE_RESET;
											    key_pressed <= 8'b0;
											    end	
							else if (key_pressed == PLAYER_1_LEFT) begin 
							if (paddle1_x >= feature_size + ball_width + (paddle_width >> 1)) // check for overflow
								paddle1_x <= paddle1_x - ball_width; // move the paddle with ball width pixels to the left
								key_pressed <= 8'b0;
								end
								else if (key_pressed == PLAYER_1_RIGHT) begin
									if (paddle1_x <= screen_width - feature_size - ball_width - (paddle_width >> 1))
									    paddle1_x <= paddle1_x + ball_width;
									    key_pressed <= 8'b0;
									    end 
									    else if (key_pressed == PLAYER_2_LEFT) begin
									        	if(player_mode)
										  	  if (paddle2_x >= feature_size + ball_width + (paddle_width >> 1))
												paddle2_x <= paddle2_x - ball_width;
											 	key_pressed <= 8'b0;
												end
												else if (key_pressed == PLAYER_2_RIGHT) begin
													 if(player_mode)
													   if (paddle2_x <= screen_width - feature_size - ball_width - (paddle_width >> 1))
														paddle2_x <= paddle2_x + ball_width;
														key_pressed <= 8'b0;
														end
						 if(speed_counter == ball_speed) begin
								speed_counter <= 6'd0;
								if(ball_dx) // to right
								  if (ball_x <= screen_width - feature_size - border_size) // check for overflow
									ball_x <= ball_x + ball_width;
								    else ball_dx <= 1'b0;
								   else if (ball_x >= feature_size + border_size)
									    ball_x <= ball_x - ball_width;
									   else ball_dx <= 1'b1;
								if(ball_dy) // to down
								    if ((ball_x >= paddle1_x - (paddle_width >> 1)) && (ball_x <= paddle1_x + (paddle_width >> 1)) && (ball_y == paddle1_y - ball_width)) begin
									 ball_dy <= 1'b0;	
									 if(ball_speed > 1)
									    ball_speed <= ball_speed - 1'b1;
									end
									else if (ball_y <= screen_height - feature_size - border_size)
										  ball_y <= ball_y + ball_width;
										else begin
										      ball_dy <= 1'b1;
										      ball_x <= screen_width >> 1; 
										      ball_y <= screen_height >> 1;
										      ball_speed <= 6'd5;
												paddle2_x <= screen_width >> 1; 
												paddle2_y <= border_size << 2;
												paddle1_x <= screen_width >> 1; 
												paddle1_y <= screen_height - (border_size << 2);
										      score_player_2 <= score_player_2 + 1'b1;
												state <= STATE_PLAYER2_SCORE;
										     
										     end
									else if ((ball_x >= paddle2_x - (paddle_width >> 1)) && (ball_x <= paddle2_x + (paddle_width >> 1)) && (ball_y == paddle2_y + ball_width)) begin
											ball_dy <= 1'b1;
											if(speed_counter > 1)
												speed_counter <= speed_counter - 1'b1;
											end 
									     else if (ball_y >= feature_size + border_size)
												ball_y <= ball_y - ball_width;
											else begin
												ball_dy <= 1'b0;
												ball_x <= screen_width >> 1; 
												ball_y <= screen_height >> 1;
												ball_speed <= 6'd5;
												paddle2_x <= screen_width >> 1; 
												paddle2_y <= border_size << 2;
												paddle1_x <= screen_width >> 1; 
												paddle1_y <= screen_height - (border_size << 2);
												score_player_1 <= score_player_1 + 1'b1;
												state <= STATE_PLAYER1_SCORE;
												end
									 
										end
										else speed_counter <= speed_counter + 1'b1;
				
									 if(!player_mode) begin // computer player logic
										if(computer_counter == computer_speed) begin
											computer_counter <= 6'd0;
											if(ball_x > paddle2_x) // move right
												if (paddle2_x <= screen_width - feature_size - border_size - (paddle_width >> 1))
														paddle2_x <= paddle2_x + ball_width;
							
											if(ball_x < paddle2_x) //move left
												if (paddle2_x >= feature_size + border_size + (paddle_width >> 1))
														paddle2_x <= paddle2_x - ball_width;
										end
											else computer_counter <= computer_counter + 1'b1;
										end
									end
								STATE_PLAYER2_SCORE : begin
										      if (score_player_2 == 4'd9) 
											  state <= STATE_RESET;
										      if (key_pressed == SPACE_key) begin
												state <= STATE_GAME;
												key_pressed <= 8'b0;
												end
										      if (key_pressed == ESC_key) begin
											     state <= STATE_RESET;
											     key_pressed <= 8'b0;
											     end	
											end		
								STATE_PLAYER1_SCORE : begin
										      if (score_player_1 == 4'd9) 
											  state <= STATE_RESET;									
										      if (key_pressed == SPACE_key) begin
											  state <= STATE_GAME;
											  key_pressed <= 8'b0;
											  end
										      if (key_pressed == ESC_key) begin
											  state <= STATE_RESET;
											  key_pressed <= 8'b0;
											  end	
										      end	
								STATE_PAUSE : begin
									      if (key_pressed == SPACE_key) begin
										   state <= STATE_GAME;
										   key_pressed <= 8'b0;
										   end
										   else if (key_pressed == ESC_key) begin
											    state <= STATE_RESET;
											    key_pressed <= 8'b0;
											    end
									     end
								default : state <=STATE_RESET;
								endcase
								end
								
					end
end

	 always@(posedge clock) begin
  	if (active_zone) begin	//border
		 if (x_pos <= border_size || x_pos >= screen_width - border_size || (y_pos <= border_size) || y_pos >= screen_height - border_size) 
				color <= color_white;
				else if (x_pos <= feature_size || x_pos >= screen_width - feature_size || (y_pos <= feature_size) || y_pos >= screen_height - feature_size) 
						color <= color_pink;
						
						//paddle1 bottom	
					else if (x_pos >= paddle1_x  - (paddle_width >> 1) && x_pos <= paddle1_x + (paddle_width >> 1) && y_pos >= paddle1_y - (paddle_height >> 1) && y_pos <= paddle1_y  + (paddle_height >> 1))
								color <= color_red;
				
						//paddle2 top
						else if (x_pos >= paddle2_x  - (paddle_width >> 1) && x_pos <= paddle2_x + (paddle_width >> 1) && y_pos >= paddle2_y - (paddle_height >> 1) && y_pos <= paddle2_y  + (paddle_height >> 1))
									if(state == STATE_PLAYER_SELECT)
										if(player_mode)
											color <= color_red;
											else	color <= color_black;
									else	color <= color_red;
				
							//ball
							else if (x_pos >= ball_x  - (ball_width >> 1) && x_pos <= ball_x + (ball_width >> 1) && y_pos >= ball_y - (ball_height >> 1) && y_pos <= ball_y  + (ball_height >> 1))
									color <= color_white;
				// background
								else color <= color_black;
						end
						else color <= color_black;
				  end
endmodule
