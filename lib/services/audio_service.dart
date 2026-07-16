import 'dart:async';
import 'package:flutter/services.dart';

class AudioService {
  AudioService._();

  static const MethodChannel _channel = MethodChannel('com.lifecard.sos/device');
  static bool _isPlaying = false;
  static Timer? _sirenTimer;

  static bool get isPlaying => _isPlaying;

  static Future<void> playSiren() async {
    if (_isPlaying) return;
    _isPlaying = true;

    // Siren haptic frequency loop
    _sirenTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        return;
      }
      HapticFeedback.heavyImpact();
    });

    try {
      await _channel.invokeMethod('startAlarm');
    } catch (_) {
      // Fallback or ignore
    }
  }

  static Future<void> stopSiren() async {
    _isPlaying = false;
    _sirenTimer?.cancel();
    _sirenTimer = null;
    try {
      await _channel.invokeMethod('stopAlarm');
    } catch (_) {
      // Fallback or ignore
    }
  }
}
