module serializer
#(
    parameter int NUM_CHANNELS = 3
)
(
    input logic clk_pixel,
    input logic clk_pixel_x5,
    input logic reset,
    input logic [9:0] tmds_internal [NUM_CHANNELS-1:0],
    output logic [2:0] tmds,
    output logic tmds_clock
);
	  logic [9:0] tmds_reversed [NUM_CHANNELS-1:0];
	  genvar i, j;
	  generate
			for (i = 0; i < NUM_CHANNELS; i++)
			begin: tmds_rev
				 for (j = 0; j < 10; j++)
				 begin: tmds_rev_channel
					  assign tmds_reversed[i][j] = tmds_internal[i][9-j];
				 end
			end
	  endgenerate


	 altlvds_tx	ALTLVDS_TX_component (
		  .tx_in ({10'b1111100000, tmds_reversed[2], tmds_reversed[1], tmds_reversed[0]}),
		  .tx_inclock (clk_pixel_x5),
		  .tx_out ({tmds_clock, tmds[2], tmds[1], tmds[0]}),
		  .tx_outclock (),
		  .pll_areset (1'b0),
		  .sync_inclock (1'b0),
		  .tx_coreclock (),
		  .tx_data_reset (reset),
		  .tx_enable (1'b1),
		  .tx_locked (),
		  .tx_pll_enable (1'b1),
		  .tx_syncclock (clk_pixel));
	 defparam
		  ALTLVDS_TX_component.center_align_msb = "UNUSED",
		  ALTLVDS_TX_component.common_rx_tx_pll = "OFF",
		  ALTLVDS_TX_component.coreclock_divide_by = 1,
		  // ALTLVDS_TX_component.data_rate = "800.0 Mbps",
		  ALTLVDS_TX_component.deserialization_factor = 10,
		  ALTLVDS_TX_component.differential_drive = 0,
		  ALTLVDS_TX_component.enable_clock_pin_mode = "UNUSED",
		  ALTLVDS_TX_component.implement_in_les = "OFF",
		  ALTLVDS_TX_component.inclock_boost = 0,
		  ALTLVDS_TX_component.inclock_data_alignment = "EDGE_ALIGNED",
		  ALTLVDS_TX_component.inclock_phase_shift = 0,
		  // ALTLVDS_TX_component.intended_device_family = "Cyclone V",
		  ALTLVDS_TX_component.lpm_hint = "CBX_MODULE_PREFIX=altlvds_tx_inst",
		  ALTLVDS_TX_component.lpm_type = "altlvds_tx",
		  ALTLVDS_TX_component.multi_clock = "OFF",
		  ALTLVDS_TX_component.number_of_channels = 4,
		  // ALTLVDS_TX_component.outclock_alignment = "EDGE_ALIGNED",
		  // ALTLVDS_TX_component.outclock_divide_by = 1,
		  // ALTLVDS_TX_component.outclock_duty_cycle = 50,
		  // ALTLVDS_TX_component.outclock_multiply_by = 1,
		  // ALTLVDS_TX_component.outclock_phase_shift = 0,
		  // ALTLVDS_TX_component.outclock_resource = "Dual-Regional clock",
		  //ALTLVDS_TX_component.output_data_rate = int'(VIDEO_RATE * 10.0),
		  ALTLVDS_TX_component.pll_compensation_mode = "AUTO",
		  ALTLVDS_TX_component.pll_self_reset_on_loss_lock = "OFF",
		  ALTLVDS_TX_component.preemphasis_setting = 0,
		  // ALTLVDS_TX_component.refclk_frequency = "20.000000 MHz",
		  ALTLVDS_TX_component.registered_input = "OFF",
		  ALTLVDS_TX_component.use_external_pll = "ON",
		  ALTLVDS_TX_component.use_no_phase_shift = "ON",
		  ALTLVDS_TX_component.vod_setting = 0,
		  ALTLVDS_TX_component.clk_src_is_pll = "off";
			

endmodule