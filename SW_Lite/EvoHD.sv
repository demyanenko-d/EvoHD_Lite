module EvoHD(

	// HDMI Video
	output	wire	[2:0]	HDMI_TX,
	output	wire			HDMI_CLK,

	
	// BUS
	input	wire		[4:0]VID_R,
	input	wire		[4:0]VID_G,
	input	wire		[4:0]VID_B,
	input	wire		VID_MODE,
	input	wire		VID_VS,
	input	wire	 	VID_HS,
	input	wire		VID_CLK,
	
	// GPIO
	inout	wire		GPIO[3:0],
	output	wire		LED,
	
	// I2S
	output	wire 		DAC_BCK,
	output	wire    	DAC_WS,
	output	wire		DAC_D,
	
	// ESP32
	
	// HSPI
	input	wire		H_SPI_CLK,
	input	wire		H_SPI_SS,
	input	wire		H_SPI_MOSI,
	output	wire		H_SPI_MISO,
	
	// VSPI
	input	wire		V_SPI_CLK,
	input	wire		V_SPI_SS,
	input	wire		V_SPI_MOSI,
	output	wire		V_SPI_MISO,
	
	// misc
	input	wire		ESP32_CLK,
	input	wire		ESP32_IO2,
	input	wire		ESP32_IO4,
	input	wire		ESP32_IO21,
	input	wire		ESP32_IO22,
	
	output	wire		ESP32_IO34,
	output	wire		ESP32_IO35
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
	//.VIDEO_ID_CODE(4),
	.VIDEO_ID_CODE(17),
	.DVI_OUTPUT(1'b1)
) hdmi(
	.clk_pixel_x5(clk_pixel_x5), 
	.clk_pixel(clk_pixel), 
	.rgb(rgb), 
	.tmds(HDMI_TX), 
	.tmds_clock(HDMI_CLK),
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

