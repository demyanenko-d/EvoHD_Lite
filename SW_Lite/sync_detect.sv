module sync_detect(
	input		wire 			clk_i,
	input		wire			hsi_i,
	input		wire			vsi_i,
	
	output	reg [15:0]	line_cnt_o,
	output	reg [15:0]	line_len_o,
	
	output	reg [15:0]	hs_len_o,
	output	reg [15:0]	vs_len_o,
	
	
	output	reg			tv_mode_o,
	output	reg			vga_mode_o,
	output	reg			rdy_o,
	
	output	reg [1:0]	mode_o // 0-unknown; 1-pentagon 320 line; 2-spectrum 48 312 line; 3-spectrum 128 312 line
);

reg [15:0]	line_cnt, line_len;
reg [15:0]	vs_len;


reg [1:0]	hsi_sync;
reg [1:0]	vsi_sync;

// edge detect
always @ (posedge clk_i)
begin
	hsi_sync = {hsi_sync[0], hsi_i};
	vsi_sync = {vsi_sync[0], vsi_i};
end

always @ (posedge clk_i)
begin
	rdy_o = 0;
	
	// HS

	if (hsi_sync == 2'b10)
	begin
		line_len_o 	= line_len;
		line_len		= 0;
		
		line_cnt++;
	end
	else
		line_len++;
		
	if (hsi_sync == 2'b01)
		hs_len_o 	= line_len;
		
	// VS
	if (vsi_sync == 2'b10)
	begin
		line_cnt_o	= line_cnt;
		line_cnt		= 0;
		vs_len		= 0;
	end
	else
		vs_len++;
		
	if (vsi_sync == 2'b01)
	begin
		vs_len_o		= vs_len;
		rdy_o			= 1'b1;
		
		// detect modes
		tv_mode_o	= line_cnt <= 320;
		vga_mode_o	= line_cnt >= 624;
		
		mode_o = 0;
		
		case (line_cnt)
			320: mode_o = 1; // pentagon
			312: mode_o = 2; // spectrum 48
			311: mode_o = 3; // spectrum 128;
		endcase
	end
end


endmodule
