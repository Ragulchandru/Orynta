// ignore_for_file: prefer_const_declarations, avoid_print

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

void main() {
  final sampleRate = 16000;
  final duration = 2.0;
  final numSamples = (sampleRate * duration).toInt();
  final dataSize = numSamples * 2;
  
  final header = ByteData(44);
  // RIFF header
  header.setUint8(0, 0x52); // R
  header.setUint8(1, 0x49); // I
  header.setUint8(2, 0x46); // F
  header.setUint8(3, 0x46); // F
  header.setUint32(4, 36 + dataSize, Endian.little);
  // WAVE header
  header.setUint8(8, 0x57); // W
  header.setUint8(9, 0x41); // A
  header.setUint8(10, 0x56); // V
  header.setUint8(11, 0x45); // E
  // fmt chunk
  header.setUint8(12, 0x66); // f
  header.setUint8(13, 0x6d); // m
  header.setUint8(14, 0x74); // t
  header.setUint8(15, 0x20); // space
  header.setUint32(16, 16, Endian.little); // chunk size
  header.setUint16(20, 1, Endian.little); // PCM format
  header.setUint16(22, 1, Endian.little); // Mono
  header.setUint32(24, sampleRate, Endian.little); // Sample rate
  header.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
  header.setUint16(32, 2, Endian.little); // Block align
  header.setUint16(34, 16, Endian.little); // 16 bits
  // data chunk
  header.setUint8(36, 0x64); // d
  header.setUint8(37, 0x61); // a
  header.setUint8(38, 0x74); // t
  header.setUint8(39, 0x61); // a
  header.setUint32(40, dataSize, Endian.little);

  final buffer = Uint8List(44 + dataSize);
  buffer.setRange(0, 44, header.buffer.asUint8List());

  final frequency = 523.25; // C5 note (clear soft chime)
  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    // Exponential decay (soft fading envelope)
    final envelope = math.exp(-3.0 * t);
    // Sine wave
    final sampleValue = (32767 * envelope * math.sin(2 * math.pi * frequency * t)).toInt();
    
    final offset = 44 + i * 2;
    buffer[offset] = sampleValue & 0xFF;
    buffer[offset + 1] = (sampleValue >> 8) & 0xFF;
  }

  // Write to Android raw resources
  // Note: Android raw resource identifiers ignore file extensions.
  // To avoid duplicate resource errors (e.g. R.raw.orynta_alert), only one format must exist.
  // We keep ONLY orynta_alert.mp3 on Android.
  final oldAndroidWavFile = File('android/app/src/main/res/raw/orynta_alert.wav');
  if (oldAndroidWavFile.existsSync()) {
    oldAndroidWavFile.deleteSync();
    print('Cleaned up legacy Android WAV alert: ${oldAndroidWavFile.path}');
  }

  final androidMp3File = File('android/app/src/main/res/raw/orynta_alert.mp3');
  androidMp3File.createSync(recursive: true);
  androidMp3File.writeAsBytesSync(buffer);
  print('Wrote Android alert MP3 asset: ${androidMp3File.path}');

  // Write to iOS Runner bundle
  // iOS expects the complete filename including .wav.
  final iosFile = File('ios/Runner/orynta_alert.wav');
  iosFile.createSync(recursive: true);
  iosFile.writeAsBytesSync(buffer);
  print('Wrote iOS alert WAV asset: ${iosFile.path}');
}


