module EvoHD(

	// HDMI Video
	output	wire	[2:0]	HDMI_TX,
	output	wire			HDMI_CLK,
	
	// HDMI 1 Video
	output	wire	[2:0]	HDMI1_TX,
	output	wire			HDMI1_CLK,

	
	// BUS
	input		wire	[4:0]	VID_R,
	input		wire	[4:0]	VID_G,
	input		wire	[4:0]	VID_B,
	input		wire			VID_MODE,
	input		wire			VID_VS,
	input		wire	 		VID_HS,
	input		wire			VID_CLK,
	
	// GPIO
	inout		wire	[2:0]	GPIO
);

wire clk_pixel_x5;
wire clk_pixel;
wire clk_audio;
	
MainPLL ppl0(
	.inclk0(VID_CLK),
	.c0(clk_pixel_x5),
	.c1(clk_pixel),
	.c2(clk_audio)
);


logic [23:0] rgb;
logic [9:0] cx, cy;

hdmi #(
	.VIDEO_ID_CODE(17),
	.DVI_OUTPUT(1'b1)
) hdmi(
	.clk_pixel_x5(clk_pixel_x5), 
	.clk_pixel(clk_pixel), 
	.rgb(rgb), 
	
	.tmds(HDMI_TX), 
	.tmds_clock(HDMI_CLK),
	.tmds1(HDMI1_TX), 
	.tmds1_clock(HDMI1_CLK),
	
	.cx(cx), 
	.cy(cy)
);

reg [7:0] rv, gv, bv, val;

always @ *
begin
	val = cy[8] ? (255 - cx[8:1]) : cx[8:1];
	
	rv = cy[5] ? val : 8'b0;
	gv = cy[6] ? val : 8'b0;
	bv = cy[7] ? val : 8'b0;
end


assign rgb = {VID_R, 3'b0, VID_G, 3'b0, VID_B, 3'b0}; 


endmodule

