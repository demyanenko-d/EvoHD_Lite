
module hdevo (
	input	wire			HDMI_CLK,

	input	wire            VID_CLK,
	input	wire    [4:0]	VID_R,
	input	wire    [4:0]	VID_G,
	input	wire    [4:0]	VID_B,
	input	wire            VID_HS,
	input	wire            VID_VS,

	output  wire	[1:0]   HDMI_CK,
	output  wire	[1:0]   HDMI_D0,
	output  wire	[1:0]   HDMI_D1,
	output  wire    [1:0]   HDMI_D2
);

wire    [9:0]   TMDS_RED, TMDS_GRN, TMDS_BLU;
reg     [9:0]   SHIFT_RED, SHIFT_GREEN, SHIFT_BLUE, SHIFT_CLK;

wire      iDE = !(VID_HS | VID_VS);

TMDS_ENCODE blu_inst
(
  .iCLK(VID_CLK),
  .iCTL({VID_VS,VID_HS}),
  .iBLANK(!iDE),
  .iDATA(VID_B),
  .oDATA(TMDS_BLU)
);

TMDS_ENCODE grn_inst
(
  .iCLK(VID_CLK),
  .iCTL({VID_VS,VID_HS}),
  .iBLANK(!iDE),
  .iDATA(VID_G),
  .oDATA(TMDS_GRN)
);

TMDS_ENCODE red_inst
(
  .iCLK(VID_CLK),
  .iCTL({VID_VS,VID_HS}),
  .iBLANK(!iDE),
  .iDATA(VID_R),
  .oDATA(TMDS_RED)
);

initial SHIFT_CLK <= 10'b0000011111;

always @(posedge HDMI_CLK)
begin
  if (SHIFT_CLK==10'b0000011111)
  begin
    SHIFT_RED<= TMDS_RED;
    SHIFT_GREEN<= TMDS_GRN;
    SHIFT_BLUE<= TMDS_BLU;
  end
  else begin
    SHIFT_RED<= {2'b0,SHIFT_RED[9:2]};
    SHIFT_GREEN<= {2'b0,SHIFT_GREEN[9:2]};
    SHIFT_BLUE<= {2'b0,SHIFT_BLUE[9:2]};
  end
  SHIFT_CLK <= {SHIFT_CLK[1:0],SHIFT_CLK[9:2]};
end

  altddio_out ddio_inst_p (
        .dataout ({HDMI_CK[1],HDMI_D2[1], HDMI_D1[1], HDMI_D0[1]}),
        .outclock (HDMI_CLK),
        .datain_h ({SHIFT_CLK[0], SHIFT_RED[0], SHIFT_GREEN[0], SHIFT_BLUE[0]}),
        .datain_l ({SHIFT_CLK[1], SHIFT_RED[1], SHIFT_GREEN[1], SHIFT_BLUE[1]}),
        .aclr (1'b0),
        .aset (1'b0),
        .outclocken (1'b1),
        .sclr (1'b0),
        .sset (1'b0));
  defparam
    //ddio_inst.intended_device_family = "Cyclone 10 LP",
    ddio_inst_p.invert_input_clocks = "OFF",
    ddio_inst_p.lpm_hint = "UNUSED",
    ddio_inst_p.lpm_type = "altddio_out",
    ddio_inst_p.power_up_high = "OFF",
    ddio_inst_p.width = 4;

altddio_out ddio_inst_n (
        .dataout ({HDMI_CK[0],HDMI_D2[0], HDMI_D1[0], HDMI_D0[0]}),
        .outclock (HDMI_CLK),
        .datain_h ({!SHIFT_CLK[0], !SHIFT_RED[0], !SHIFT_GREEN[0], !SHIFT_BLUE[0]}),
        .datain_l ({!SHIFT_CLK[1], !SHIFT_RED[1], !SHIFT_GREEN[1], !SHIFT_BLUE[1]}),
        .aclr (1'b0),
        .aset (1'b0),
        .outclocken (1'b1),
        .sclr (1'b0),
        .sset (1'b0));
  defparam
    //ddio_inst.intended_device_family = "Cyclone 10 LP",
    ddio_inst_n.invert_input_clocks = "OFF",
    ddio_inst_n.lpm_hint = "UNUSED",
    ddio_inst_n.lpm_type = "altddio_out",
    ddio_inst_n.power_up_high = "OFF",
    ddio_inst_n.width = 4;


endmodule
