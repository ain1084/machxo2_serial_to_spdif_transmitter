`default_nettype none

module serial_to_spdif_transmitter(
    input wire reset,           // reset
    input wire clk128,          // master clock (x128 fs)
    input wire lrclk,           // LR clock (x1 fs)
    input wire sclk,            // Serial data clock (eg. 16bit-x32fs or 32bit-x64fs)
    input wire sdin,            // Serial data in
    input wire is_i2s,   		 // 1'b0 : Left Justfied / 1'b1 : I2S
    input wire lrclk_polarity,  // 1'b0 : lrclk is Low = Left / 1'b1 : lrclk is Low = Right
    output wire [8:0] sub_frame_number,
    output wire spdif);         // S/PDIF out

    wire decoder_to_buffer_valid;
    wire buffer_to_decoder_ready;
    wire buffer_to_encoder_valid;
    wire encoder_to_buffer_ready;
    wire is_buffer_left;
	wire is_decoder_left;
    wire [31:0] decoder_audio;
    wire [23:0] buffer_audio;
	wire is_error;

    dual_clock_buffer #(.width(25)) buffer_ (
        .reset(reset),
        .i_clk(sclk),
        .i_valid(decoder_to_buffer_valid),
        .i_ready(buffer_to_decoder_ready),
        .i_data({ is_decoder_left, decoder_audio[31:8] }),
        .o_clk(clk128),
        .o_valid(buffer_to_encoder_valid),
        .o_ready(encoder_to_buffer_ready),
        .o_data({ is_buffer_left, buffer_audio })
    );

    serial_audio_decoder decoder_(
        .sclk(sclk),
        .reset(reset),
        .lrclk(lrclk),
        .sdin(sdin),
        .is_i2s(is_i2s),
		.is_error(is_error),
        .lrclk_polarity(lrclk_polarity),
        .o_valid(decoder_to_buffer_valid),
        .o_ready(buffer_to_decoder_ready),
        .o_is_left(is_decoder_left),
        .o_audio(decoder_audio));	
                    
    spdif_frame_encoder encoder_(
        .clk128(clk128),
        .reset(reset | is_error),
        .sub_frame_number(sub_frame_number),
        .i_valid(buffer_to_encoder_valid),
        .i_ready(encoder_to_buffer_ready),
        .i_is_left(is_buffer_left),
        .i_audio(buffer_audio),
        .i_user(1'b0),
        .i_control(1'b0),
        .spdif(spdif));

endmodule
