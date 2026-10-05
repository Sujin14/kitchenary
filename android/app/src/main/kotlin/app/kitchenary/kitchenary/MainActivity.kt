package app.kitchenary.kitchenary

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val alarmSound by lazy { AlarmSoundPlayer(this) }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_SOUND_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "play" -> {
                        alarmSound.play()
                        result.success(null)
                    }
                    "stop" -> {
                        alarmSound.stop()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        alarmSound.stop()
        super.onDestroy()
    }

    private companion object {
        /** Must match `PlatformAlarmSoundService.channelName` in Dart. */
        const val ALARM_SOUND_CHANNEL = "app.kitchenary/alarm_sound"
    }
}
