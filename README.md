# machxo2_serial_to_spdif_transmitter
Serial audio (Linear PCM) to S/PDIF transmitter. Using MachXO2 (1200HC QFN32).

## 概要

+ シリアルオーディオ信号を S/PDIF へ変換出力する MachXO2 (1200HC QFN32)用のサンプルデザインです。
+ Sub module として [serial_audio_decoder](https://github.com/ain1084/serial_audio_decoder), [dual_clock_buffer](https://github.com/ain1084/dual_clock_buffer), [spdif_frame_encoder](https://github.com/ain1084/spdif_frame_encoder) を使用しています。
+ 入力できるオーディオ信号種別は固定です(Left justified / lrclk が High の時に Left)。
+ S/PDIF サブフレーム内に含まれる U, C は 0 固定です。

## Module diagram

![machxo2_serial_to_spdif_transmitter](https://user-images.githubusercontent.com/14823909/106353249-7c4c0600-632c-11eb-9f5b-1be5138fc412.png)
