import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SmsService {
  static const MethodChannel _channel = MethodChannel('com.example.life_card_and_sos/sms');

  /// Sends an emergency SMS to a list of contacts programmatically.
  /// 
  /// Only supports programmatic sending on Android.
  /// Returns [true] if all messages were sent successfully, [false] otherwise.
  static Future<bool> sendSms({
    required List<String> recipients,
    required String message,
  }) async {
    if (recipients.isEmpty) return false;

    // Check if we can send natively on Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      bool allSuccessful = true;
      for (final recipient in recipients) {
        final cleanRecipient = _sanitizePhoneNumber(recipient);
        if (cleanRecipient.isEmpty) continue;
        try {
          final result = await _channel.invokeMethod<String>('sendSMS', {
            'phoneNumber': cleanRecipient,
            'message': message,
          });
          if (result != 'SMS Sent Successfully') {
            allSuccessful = false;
          }
        } catch (e) {
          allSuccessful = false;
          debugPrint('Failed to send native SMS to $cleanRecipient: $e');
        }
      }
      return allSuccessful;
    }

    return false; // Programmatic sending is only supported on Android
  }

  static String _sanitizePhoneNumber(String phone) {
    // Remove all whitespace, hyphens, parentheses, etc. Keep leading plus for country code.
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}
