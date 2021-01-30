module machxo2_serial_to_spdif_transmitter_top(
    input wire nreset,
    input wire clk256,		/* x256 fs */
    input wire lrclk,
    input wire sclk,
    input wire sdin,
    output wire spdif);

    wire reset = !nreset;
    
    GSR GSR_INST(.GSR(reset));

    reg clk128;
    always @(posedge clk256 or posedge reset) begin
        if (reset)
            clk128 <= 0;
        else
            clk128 <= ~clk128;
    end

    serial_to_spdif_transmitter transmitter_inst(
        .reset(reset),
        .clk128(clk128),
        .lrclk(lrclk),
        .sclk(sclk),
        .sdin(sdin),
        .is_i2s(1'b0),       		// Left justified format
        .lrclk_polarity(1'b1),     // Left is High
		.sub_frame_number(),
        .spdif(spdif));

endmodule
