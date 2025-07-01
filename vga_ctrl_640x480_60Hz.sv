module vga_ctrl_640x480_60Hz (rst, clk,rgb_in,HS, VS, hcount,vcount,rgb_out,blank);
	input logic rst, clk;
   input logic [11:0] rgb_in;
   output logic HS, VS;
	output logic [10:0] hcount;
	output logic [10:0] vcount;
	output logic [11:0] rgb_out; //R3R2R1R0GR3GR3GR3GR3B3B2B1B0
	output logic blank;
	
	// CONSTANTS

	// maximum value for the horizontal pixel counter
	localparam logic [10:0] HMAX  = 11'd800; // 800
	// maximum value for the vertical pixel counter
	localparam logic [10:0] VMAX  = 11'd525; // 525
	// total number of visible columns
	localparam logic [10:0] HLINES = 11'd640; // 640
	// value for the horizontal counter where front porch ends
	localparam logic [10:0] HFP   = 11'd655; // 648
	// value for the horizontal counter where the synch pulse ends
	localparam logic [10:0] HSP   = 11'd751; // 744
	// total number of visible lines
	localparam logic [10:0] VLINES = 11'd480; // 480
	// value for the vertical counter where the front porch ends
	localparam logic [10:0] VFP   = 11'd489; // 482
	// value for the vertical counter where the synch pulse ends
	localparam logic [10:0] VSP   = 11'd491; // 484
	// polarity of the horizontal and vertical synch pulse
	localparam logic SPP = 1'b0;
	
	// SIGNALS

	// horizontal and vertical counters
	logic [10:0] hcounter = 11'b0;
	logic [10:0] vcounter = 11'b0;

	// active when inside visible screen area.
	logic video_enable;
	logic clk_25MHz;
	
	cntdiv_n #(2) cntdiv_0 (clk,rst, clk_25MHz);
	
	// output horizontal and vertical counters
	assign hcount = hcounter;
	assign vcount = vcounter;

	// blank is active when outside screen visible area
	// color output should be blacked (put on 0) when blank is active
	// blank is delayed one pixel clock period from the video_enable
	// signal to account for the pixel pipeline delay.
	always_ff @(posedge clk_25MHz) begin
		 blank <= ~video_enable;
	end
	
	// increment horizontal counter at clk_25MHz rate
	// until HMAX is reached, then reset and keep counting
	always_ff @(posedge clk_25MHz) begin
		 if (rst == 1'b1) begin
			  hcounter <= 11'b0;
		 end else if (hcounter == HMAX) begin
			  hcounter <= 11'b0;
		 end else begin
			  hcounter <= hcounter + 1'b1;
		 end
	end
	
	// increment vertical counter when one line is finished
	// (horizontal counter reached HMAX)
	// until VMAX is reached, then reset and keep counting
	always_ff @(posedge clk_25MHz) begin
		 if (rst == 1'b1) begin
			  vcounter <= 11'b0;
		 end else if (hcounter == HMAX) begin
			  if (vcounter == VMAX) begin
					vcounter <= 11'b0;
			  end else begin
					vcounter <= vcounter + 1'b1;
			  end
		 end
	end
	
	// generate horizontal synch pulse
	// when horizontal counter is between where the
	// front porch ends and the synch pulse ends.
	// The HS is active (with polarity SPP) for a total of 96 pixels.
	always_ff @(posedge clk_25MHz) begin
		 if (hcounter >= HFP && hcounter < HSP) begin
			  HS <= SPP;
		 end else begin
			  HS <= ~SPP;
		 end
	end
	
	// generate vertical synch pulse
	// when vertical counter is between where the
	// front porch ends and the synch pulse ends.
	// The VS is active (with polarity SPP) for a total of 2 video lines
	// = 2*HMAX = 1600 pixels.
	always_ff @(posedge clk_25MHz) begin
		 if (vcounter >= VFP && vcounter < VSP) begin
			  VS <= SPP;
		 end else begin
			  VS <= ~SPP;
		 end
	end
	
	// enable video output when pixel is in visible area
	assign video_enable = (hcounter < HLINES && vcounter < VLINES) ? 1'b1 : 1'b0;
	
	always_ff @(posedge clk_25MHz) begin
		 if (video_enable == 1'b0) begin
			  rgb_out <= 12'b000000000000;
		 end else begin
			  rgb_out <= rgb_in;
		 end
	end

endmodule
