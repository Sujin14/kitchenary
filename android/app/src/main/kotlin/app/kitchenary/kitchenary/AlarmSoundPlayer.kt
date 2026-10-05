package app.kitchenary.kitchenary

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer

/** Loops the timer sound on the alarm stream while a finished timer is shown. */
class AlarmSoundPlayer(context: Context) {
    private val context = context.applicationContext
    private var player: MediaPlayer? = null

    fun play() {
        if (player != null) return
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val audioManager = context.getSystemService(AudioManager::class.java)
        player = MediaPlayer.create(
            context,
            R.raw.timer_alarm,
            attributes,
            audioManager.generateAudioSessionId(),
        )?.apply {
            isLooping = true
            start()
        }
    }

    fun stop() {
        player?.run {
            stop()
            release()
        }
        player = null
    }
}
