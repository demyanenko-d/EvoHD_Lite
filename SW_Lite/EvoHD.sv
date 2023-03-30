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
	inout		reg	[2:0]	GPIO
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


wire			rdy, tv_mode, vga_mode;
wire [1:0]	mode;

reg [1:0]	hs_sync, vs_sync;

always @ (posedge VID_CLK)
begin	
	hs_sync = {hs_sync[0], VID_HS};
	vs_sync = {vs_sync[0], VID_VS};
end


sync_detect inst0(
	.clk_i		(VID_CLK),
	.hsi_i		(VID_HS),
	.vsi_i		(VID_VS),

	.tv_mode_o	(tv_mode),
	.vga_mode_o	(vga_mode),
	.rdy_o		(rdy),	
	.mode_o		(mode)
);


logic [23:0] rgb;
logic [9:0] cx, cy;

hdmi #(
	.VIDEO_ID_CODE(17)
) hdmi(
	.clk_pixel_x5(clk_pixel_x5), 
	.clk_pixel(clk_pixel), 
	.rgb(rgb), 
	
	//.v_mode(mode),
	//.ext_sync(vs_sync == 2'b10),
	//.reset(),
	.hs_ext(VID_HS),
	.vs_ext(VID_VS),
	.mode_ext(mode),
	
	.tmds(HDMI_TX), 
	.tmds_clock(HDMI_CLK),
	.tmds1(HDMI1_TX), 
	.tmds1_clock(HDMI1_CLK)
);


assign rgb = {VID_R, 3'b0, VID_G, 3'b0, VID_B, 3'b0}; 


endmodule

