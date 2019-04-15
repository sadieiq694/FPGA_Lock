`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:40 04/15/2019 
// Design Name: 
// Module Name:    lockMain 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ASM (input clk, input rst, input clr, input ent, input change, output reg [5:0] led, output reg [19:0] ssd, input [3:0] sw); 

	//registers
	reg [15:0] password; 
	reg [15:0] inpassword;
	reg [5:0] current_state;
	reg [5:0] next_state;	

	// parameters for States, you will need more states obviously
	parameter IDLE = 5'b00000; //idle state 
	parameter GETFIRSTDIGIT_LOCKED = 5'b00001; // get_first_input_state // this is not a must, one can use counter instead of having another step, design choice
	parameter GETSECONDIGIT_LOCKED = 5'b00010; //get_second input state
	parameter GETTHIRDDIGIT_LOCKED = 5'b00011; // get 
	parameter GETFOURTHDIGIT_LOCKED = 5'b00100; // get
	parameter OPEN_STATE = 5'b00101;
	parameter CHANGEFIRSTDIGIT = 5'b00110;
	parameter CHANGESECONDDIGIT = 5'b00111;
	parameter CHANGETHIRDDIGIT = 5'b01000;
	parameter CHANGEFOURTHDIGIT = 5'b01001;
	parameter GETFIRSTDIGIT_UNLOCKED	= 5'b01010; // get_first_input_state // this is not a must, one can use counter instead of having another step, design choice
	parameter GETSECONDIGIT_UNLOCKED = 5'b01011; //get_second input state
	parameter GETTHIRDDIGIT_UNLOCKED = 5'b01100; // get 
	parameter GETFOURTHDIGIT_UNLOCKED = 5'b01101;
	parameter BACKDOOR = 5'b01110;
	
	// parameters for output, you will need more obviously
	parameter n_0 = 5'b00000;
	parameter n_1 = 5'b00001; 
	parameter n_2 = 5'b00010;
	parameter n_3 = 5'b00011;
   parameter n_4 = 5'b00100;
	parameter n_5 = 5'b00101; 
	parameter n_6 = 5'b00110;
	parameter n_7 = 5'b00111;
	parameter n_8 = 5'b01000;
	parameter n_9 = 5'b01001;
	parameter A = 5'b01010;
	parameter B = 5'b01011;
	parameter C = 5'b01100;
	parameter d = 5'b01101;
	parameter E = 5'b01110;
	parameter F = 5'b01111;
	parameter L = 5'b10000;
	parameter S = 5'b10001;
	parameter O = 5'b10010;
	parameter P = 5'b10011;
	parameter n = 5'b10100;
	parameter tire = 5'b10101; // hyphen
	parameter blank = 5'b10110; // nothing
	parameter V = 5'b10111;


//Sequential part for state transitions
	always @ (posedge clk or posedge rst)
	begin
		// your code goes here
		if(rst==1)
		current_state<= IDLE;
		else
		current_state<= next_state;
		
	end

	// combinational part - next state definitions
	always @ (*)
	begin
		if(current_state == IDLE)
		begin
			//assign password[15:0]=16'b0000000000000000;
			// your code goes here
			if(ent == 1)
				next_state = GETFIRSTDIGIT_LOCKED;
			else 
				next_state = current_state;
		end
		// UNLOCKING
		else if (current_state == GETFIRSTDIGIT_LOCKED)
			if (ent == 1)
			 	next_state = GETSECONDIGIT_LOCKED;
			else
			 	next_state = current_state;
				
		else if (current_state == GETSECONDDIGIT_LOCKED)
			if (ent == 1)
				next_state = GETTHIRDDIGIT_LOCKED;
			else
				next_state = current_state;
		
		else if (current_state == GETTHIRDDIGIT_LOCKED)
			if (ent == 1)
				next_state = GETFOURTHDIGIT_LOCKED;
		   else
				next_state = current_state;
				
		else if (current_state == GETFOURTHDIGIT_LOCKED)
			if(ent == 1)
				if(password == inpassword) // PSEUDO
					next_state = OPEN_STATE;
				else
					next_state = IDLE;
			else
				next_state = current_state
				
		// IN OPEN STATE
		else if (current_state == OPEN_STATE)
			if(ent == 1)
				next_state = GETFIRSTDIGIT_UNLOCKED
			else if (change == 1)
				next_state = CHANGEFIRSTDIGIT;
			else 
				next_state = current_state;
		
		// CHANGING PASSWORD
		else if (current_state == CHANGEFIRSTDIGIT)
			if(ent == 1)
				next_state = CHANGESECONDDIGIT;
			else
				next_state = current_state; 
		else if (current_state == CHANGESECONDDIGIT)
			if(ent == 1)
				next_state = CHANGETHIRDDIGIT;
			else
				next_state = current_state; 
		else if (current_state == CHANGETHIRDDIGIT)
			if(ent == 1)
				next_state = CHANGEFOURTHDIGIT;
			else
				next_state = current_state;
		else if (current_state == GETFOURTHDIGIT_LOCKED)
			if(ent == 1)
				// CHANGE PASSWORD TO NEWLY ENTERED STUFF
				next_state = OPEN_STATE;
			else
				next_state = current_state;
		
		// RELOCKING
		else if (current_state == GETFIRSTDIGIT_UNLOCKED)
			if (ent == 1)
			 	next_state = GETSECONDIGIT_UNLOCKED;
			else
			 	next_state = current_state;
				
		else if (current_state == GETSECONDDIGIT_UNLOCKED)
			if (ent == 1)
				next_state = GETTHIRDDIGIT_UNLOCKED;
			else
				next_state = current_state;
		
		else if (current_state == GETTHIRDDIGIT_UNLOCKED)
			if (ent == 1)
				next_state = GETFOURTHDIGIT_LOCKED;
		   else
				next_state = current_state;
				
		else if (current_state == GETFOURTHDIGIT_UNLOCKED)
			if(ent == 1)
				if(password == inpassword) // PSEUDO
					next_state = IDLE;
				else
					next_state = OPEN_STATE;
			else
				next_state = current_state
		
		// BACKDOOR... IMPLEMENT LATER
	
		else
			next_state = current_state;

	end

	/*
		you have to complete the rest, in this combinational part, DO NOT ASSIGN VALUES TO OUTPUTS DO NOT ASSIGN VALUES TO REGISTERS
		just determine the next_state, that is all. password = 0000 -> this should not be there for instance or LED = 1010 this should not be there as well
		else if 
		else if
		*/

	 //Sequential part for control registers, this part is responsible for assigning control registers or stored values
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			inpassword[15:0]<=0; // password which is taken coming from user, 
			password[15:0]<=0;
		end

		else 
			if(current_state == IDLE)
			begin
			 	password[15:0] <= 16'b0000000000000000; // Built in reset is 0, when user in IDLE state... SHOULDN'T ALWAYS DO THIS, DELETE AT SOME POINT
				 // you may need to add extra things here.
			end
		
			// ENTERING PASSWORD -- LOCKED
			else if(current_state == GETFIRSTDIGIT_LOCKED)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0]; // inpassword is the password entered by user, first 4 digin will be equal to current switch values
			end

			else if (current_state == GETSECONDIGIT_LOCKED)
			begin
				if(ent==1)
					inpassword[11:8]<=sw[3:0]; // inpassword is the password entered by user, second 4 digit will be equal to current switch values
			end
			
			else if (current_state == GETTHIRDDIGIT_LOCKED)
			begin
				if(ent==1)
					inpassword[7:4]<=sw[3:0];
			end
			
			else if (current_state == GETFOURTHDIGIT_LOCKED)
			begin
				if(ent==1)
					inpassword[3:0]<=sw[3:0];
		   else
			
			// OPEN STATE????
			
			// CHANGING PASSWORD
			else if (current_state == CHANGEFIRSTDIGIT)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0];
			end
						
			else if (current_state == CHANGEFIRSTDIGIT)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0];
			end
			
			else if (current_state == CHANGEFIRSTDIGIT)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0];
			end

			else if (current_state == CHANGEFIRSTDIGIT)
			begin
				if(ent==1)
					inpassword[15:12]<=sw[3:0];
			end


		/*

		Complete the rest of ASM chart, in this section, you are supposed to set the values for control registers, stored registers(password for instance)
		number of trials, counter values etc... 

		*/

	end


	// Sequential part for outputs; this part is responsible from outputs; i.e. SSD and LEDS


	always @(posedge clk)
	begin

		if(current_state == IDLE)
		begin
		ssd <= {C, L, five, d};	//CLSD
		end

		else if(current_state == GETFIRSTDIGIT)
		begin
		ssd <= { 0,sw[3:0], blank, blank, blank};	// you should modify this part slightly to blink it with 1Hz. The 0 is at the beginning is to complete 4bit SW values to 5 bit.
		end

		else if(current_state == GETSECONDIGIT)
		begin
		ssd <= { tire , 0,sw[3:0], blank, blank};	// you should modify this part slightly to blink it with 1Hz. 0 after tire is to complete 4 bit sw to 5 bit. Padding 4 bit sw with 0 in other words.	
		end
		/*
		 You need more else if obviously

		*/
	end


endmodule