import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Tapping the notification triggers action
      },
    );
    _initialized = true;
  }

  static Future<void> showPersistentNotification() async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'lifecard_persistent_channel',
      'LifeCard Status',
      channelDescription: 'Persistent status notification showing LifeCard is active.',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      playSound: false,
      enableVibration: false,
      showWhen: false,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 888,
      title: 'LifeCard SOS is Active',
      body: 'Your emergency medical profile is ready.',
      notificationDetails: details,
    );
  }

  static Future<void> showSosNotification() async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'lifecard_sos_channel',
      'SOS Active Alert',
      channelDescription: 'Notification shown when SOS emergency is triggered.',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      playSound: true,
      fullScreenIntent: true,
      enableVibration: true,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 999,
      title: 'EMERGENCY SOS MODE ACTIVE',
      body: 'SOS details are broadcasted to your emergency contacts.',
      notificationDetails: details,
    );
  }

  static Future<void> cancelPersistent() async {
    await _notifications.cancel(id: 888);
  }

  static Future<void> cancelSos() async {
    await _notifications.cancel(id: 999);
  }
}
