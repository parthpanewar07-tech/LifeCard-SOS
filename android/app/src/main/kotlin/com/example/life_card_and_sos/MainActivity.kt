package com.example.life_card_and_sos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.telephony.SmsManager
import android.os.Build
import android.util.Log

import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.media.AudioManager
import android.content.Context
import java.util.Timer
import java.util.TimerTask

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.life_card_and_sos/sms"
    private val DEVICE_CHANNEL = "com.lifecard.sos/device"

    // Flashlight blinking state
    private var cameraManager: CameraManager? = null
    private var cameraId: String? = null
    private var flashTimer: Timer? = null
    private var isFlashOn = false

    // Siren alarm state
    private var audioTrack: AudioTrack? = null
    private var alarmThread: Thread? = null
    @Volatile private var isAlarmRunning = false
    private var originalAlarmVolume: Int? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // SMS channel setup
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                if (phoneNumber != null && message != null) {
                    try {
                        var smsManager: SmsManager? = null
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            smsManager = applicationContext.getSystemService(SmsManager::class.java)
                        }
                        if (smsManager == null) {
                            @Suppress("DEPRECATION")
                            smsManager = SmsManager.getDefault()
                        }
                        
                        if (smsManager != null) {
                            val parts = smsManager.divideMessage(message)
                            smsManager.sendMultipartTextMessage(phoneNumber, null, parts, null, null)
                            result.success("SMS Sent Successfully")
                        } else {
                            Log.e("MainActivity", "SmsManager is null and cannot be resolved")
                            result.error("SMS_FAILED", "SmsManager is null and cannot be resolved", null)
                        }
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Failed to send SMS to $phoneNumber", e)
                        result.error("SMS_FAILED", "Failed to send SMS: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Phone number or message is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Device channel setup
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startFlashlightBlink" -> {
                    startFlashlightBlink()
                    result.success(null)
                }
                "stopFlashlightBlink" -> {
                    stopFlashlightBlink()
                    result.success(null)
                }
                "startAlarm" -> {
                    startAlarm()
                    result.success(null)
                }
                "stopAlarm" -> {
                    stopAlarm()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startFlashlightBlink() {
        try {
            if (cameraManager == null) {
                cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
                for (id in cameraManager!!.cameraIdList) {
                    val characteristics = cameraManager!!.getCameraCharacteristics(id)
                    val hasFlash = characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) ?: false
                    if (hasFlash) {
                        cameraId = id
                        break
                    }
                }
                if (cameraId == null) {
                    cameraId = cameraManager?.cameraIdList?.firstOrNull()
                }
            }
            if (cameraId == null) {
                Log.e("MainActivity", "Camera ID is null - no camera found on device")
                return
            }
            stopFlashlightBlink()
            flashTimer = Timer()
            flashTimer?.scheduleAtFixedRate(object : TimerTask() {
                override fun run() {
                    runOnUiThread {
                        try {
                            isFlashOn = !isFlashOn
                            cameraManager?.setTorchMode(cameraId!!, isFlashOn)
                        } catch (e: Exception) {
                            Log.e("MainActivity", "Error setting torch mode", e)
                        }
                    }
                }
            }, 0, 500)
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to start flashlight blink", e)
        }
    }

    private fun stopFlashlightBlink() {
        flashTimer?.cancel()
        flashTimer = null
        isFlashOn = false
        runOnUiThread {
            try {
                if (cameraId != null) {
                    cameraManager?.setTorchMode(cameraId!!, false)
                }
            } catch (e: Exception) {}
        }
    }

    private fun generateSirenBuffer(): Pair<ShortArray, ShortArray> {
        val sampleRate = 44100
        val durationMs = 500
        val numSamples = (sampleRate * (durationMs / 1000.0)).toInt() // 22050
        
        val highTone = ShortArray(numSamples)
        val mediumTone = ShortArray(numSamples)
        
        // 1319 Hz tone: 125ms ON, 125ms OFF, 125ms ON, 125ms OFF
        val segmentLength = (sampleRate * 0.125).toInt() // 5512 samples
        for (i in 0 until numSamples) {
            val segmentIndex = i / segmentLength
            val isSegmentOn = (segmentIndex % 2 == 0)
            if (isSegmentOn && i < 3 * segmentLength) {
                val angle = 2.0 * Math.PI * 1319.0 * i / sampleRate
                highTone[i] = (Math.sin(angle) * Short.MAX_VALUE).toInt().toShort()
            } else {
                highTone[i] = 0
            }
        }
        
        // 941 Hz tone: 400ms ON, 100ms OFF
        val activeLength = (sampleRate * 0.400).toInt() // 17640 samples
        for (i in 0 until numSamples) {
            if (i < activeLength) {
                val angle = 2.0 * Math.PI * 941.0 * i / sampleRate
                mediumTone[i] = (Math.sin(angle) * Short.MAX_VALUE).toInt().toShort()
            } else {
                mediumTone[i] = 0
            }
        }
        
        return Pair(highTone, mediumTone)
    }

    private fun startAlarm() {
        stopAlarm()
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            originalAlarmVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)

            val (highTone, mediumTone) = generateSirenBuffer()
            val minBufferSize = AudioTrack.getMinBufferSize(
                44100,
                AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT
            )
            val bufferSize = Math.max(minBufferSize, 22050 * 2)

            audioTrack = AudioTrack.Builder()
                .setAudioAttributes(AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build())
                .setAudioFormat(AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(44100)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build())
                .setBufferSizeInBytes(bufferSize)
                .setTransferMode(AudioTrack.MODE_STREAM)
                .build()

            audioTrack?.play()

            isAlarmRunning = true
            alarmThread = Thread {
                var isToggle = false
                while (isAlarmRunning) {
                    try {
                        val buffer = if (isToggle) highTone else mediumTone
                        isToggle = !isToggle
                        audioTrack?.write(buffer, 0, buffer.size)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error in alarm thread writing data", e)
                        break
                    }
                }
            }
            alarmThread?.start()
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to start alarm", e)
        }
    }

    private fun stopAlarm() {
        isAlarmRunning = false
        alarmThread?.interrupt()
        alarmThread = null
        try {
            audioTrack?.stop()
            audioTrack?.release()
            audioTrack = null
        } catch (e: Exception) {}
        try {
            if (originalAlarmVolume != null) {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, originalAlarmVolume!!, 0)
                originalAlarmVolume = null
            }
        } catch (e: Exception) {}
    }

    override fun onDestroy() {
        stopFlashlightBlink()
        stopAlarm()
        super.onDestroy()
    }
}
