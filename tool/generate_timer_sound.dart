// Run once:  dart run tool/generate_timer_sound.dart
//
// Writes android/app/src/main/res/raw/timer_alarm.wav, the sound cooking
// timers ring with (in the notification and inside the app). It is generated
// here instead of downloaded so there is no licence to track. The clip is
// four short beeps and a pause; Android loops it until the timer is dismissed.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const int sampleRate = 22050;
const int beeps = 4;
const double beepSeconds = 0.11;
const double gapSeconds = 0.09;
const double pauseSeconds = 0.6;
const double toneHz = 1500;
const double fadeSeconds = 0.005;
const double volume = 0.8;

void main() {
  final samples = <int>[];
  for (var beep = 0; beep < beeps; beep++) {
    samples
      ..addAll(_tone(beepSeconds))
      ..addAll(_silence(gapSeconds));
  }
  samples.addAll(_silence(pauseSeconds));

  final file = File('android/app/src/main/res/raw/timer_alarm.wav')
    ..createSync(recursive: true)
    ..writeAsBytesSync(_wav(samples));
  stdout.writeln('Wrote ${file.path} (${file.lengthSync()} bytes).');
}

List<int> _tone(double seconds) {
  final count = (seconds * sampleRate).round();
  final fade = (fadeSeconds * sampleRate).round();
  return List.generate(count, (i) {
    final t = i / sampleRate;
    // A quieter second harmonic makes the beep carry on small phone speakers.
    final wave = 0.75 * sin(2 * pi * toneHz * t) +
        0.25 * sin(2 * pi * toneHz * 2 * t);
    // Short fade in and out so the beep starts and ends without a click.
    final envelope = min(1.0, min(i, count - 1 - i) / fade);
    return (wave * envelope * volume * 32767).round();
  });
}

List<int> _silence(double seconds) =>
    List.filled((seconds * sampleRate).round(), 0);

/// 16-bit mono PCM WAV.
Uint8List _wav(List<int> samples) {
  final dataBytes = samples.length * 2;
  final header = ByteData(44)
    ..setUint32(0, 0x52494646) // "RIFF"
    ..setUint32(4, 36 + dataBytes, Endian.little)
    ..setUint32(8, 0x57415645) // "WAVE"
    ..setUint32(12, 0x666d7420) // "fmt "
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little) // PCM
    ..setUint16(22, 1, Endian.little) // mono
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, sampleRate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little)
    ..setUint32(36, 0x64617461) // "data"
    ..setUint32(40, dataBytes, Endian.little);
  final data = ByteData(dataBytes);
  for (var i = 0; i < samples.length; i++) {
    data.setInt16(i * 2, samples[i], Endian.little);
  }
  return Uint8List.fromList([
    ...header.buffer.asUint8List(),
    ...data.buffer.asUint8List(),
  ]);
}
