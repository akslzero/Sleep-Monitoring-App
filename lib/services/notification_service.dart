import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/notification_messages.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static int _notificationId = 0;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showQualityNotification({
    required String quality,
    required int score,
  }) async {
    final message = QualityNotificationMessages.getMessageFor(quality);

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'quality_channel',
          'Kualitas Tidur',
          channelDescription: 'Notifikasi perubahan kualitas tidur',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          enableLights: true,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    final title = '${message.emoji} ${message.title}';
    final body = '${message.body}\nSkor: $score';

    _notificationId++;
    await _flutterLocalNotificationsPlugin.show(
      _notificationId,
      title,
      body,
      notificationDetails,
    );
  }
}
