module main #(FPGAFREQ = 50_000_000)(
	input logic CLK,
	input logic nRST,
	input logic nPBTON,
	output logic hsync,
	output logic vsync,
	output logic [11:0] rgb_out);
	
	logic RST;
	logic PBTON;
	logic clkdiv0;
	logic [9:0] counter;
	logic [3:0] units, tens, hundreds;
	
	logic PAINTU;
	logic PAINTD;
	logic PAINTC;
	logic PAINT34SEG;
	
	//Señales de driver VGA
	logic [10:0] sig_pixel_x, sig_pixel_y; // 11 bits for pixel counters
	logic [11:0] color;
	logic black;
	
	assign RST = ~nRST;
	assign PBTON = ~nPBTON;
	
	///////////Bloque N1 ///////////////////////
	cntdiv_n #(FPGAFREQ) cntDiv0(CLK, RST, clkdiv0);
   // Instancia driver VGA
   vga_ctrl_640x480_60Hz vga_ctrl_inst (RST, CLK,color,hsync, vsync, sig_pixel_x,sig_pixel_y,rgb_out,black);
	// Display 7 segmentos
	display #(20, 100, 160, 440,240) displayU(sig_pixel_x,sig_pixel_y,units,PAINTU);  //unidades 
	display #(10,50,80, 345,320) displayD(sig_pixel_x,sig_pixel_y,tens,PAINTD);  // decenas
	display #(40,200,320,100,80) displayC(sig_pixel_x,sig_pixel_y,hundreds,PAINTC);  //centenas
	// Display 34 segmentos
	display34segm #(5,200) display34(500,10,34'hfffffffff,sig_pixel_x,sig_pixel_y,PAINT34SEG);
	
	//Pintando los displays de un color  
	always_comb begin
		color = 12'h000;
		if (PAINTC) begin
		  color = 12'hFF0;
		end else if (PAINTD) begin
		  color = 12'h00F; 
		end else if (PAINTU) begin
		  color = 12'hF00;
		end else if (PAINT34SEG) begin
			color = 12'h8F0; 
		end 
	end

	
	/////////// Bloque N2////////////////////
	always_ff @(posedge clkdiv0, posedge RST) begin
		if(RST)begin
			counter <= 10'b00_0000_0000;
		end else begin
			if(PBTON)begin
				if(counter == 999)
					counter <= 10'b00_0000_0000;
				else
					counter <= counter + 1'b1;
			end else 
				counter <= counter;
		end
	end
	
	/////////// Bloque N3////////////////////
	always_comb begin
		units = 4'(counter % 10'd10);
		tens = 4'((counter / 10'd10)%10'd10);
		hundreds = 4'(counter / 10'd100);
	end
		
endmodule