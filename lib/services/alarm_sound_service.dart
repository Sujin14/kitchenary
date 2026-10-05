/// Rings inside the app when a cooking timer finishes while the app is open.
abstract interface class AlarmSoundService {
  /// Starts the alarm sound, looping until [stop]. Does nothing if it is
  /// already ringing.
  Future<void> play();

  Future<void> stop();
}
