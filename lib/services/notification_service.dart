import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Kênh thông báo an toàn — mức MAX để hiện dạng heads-up (popup) khi có nguy hiểm.
const _channel = AndroidNotificationChannel(
  'safety_alerts',
  'Cảnh báo an toàn',
  description: 'Cảnh báo cháy / gas / khói nguy hiểm tại bếp',
  importance: Importance.max,
);

/// Nhận cảnh báo đẩy (FCM) khi app đóng/nền → hệ thống tự hiện popup; khi app
/// đang mở → tự hiện bằng local notification. Server (Cloud Function) gửi tới
/// topic 'alerts'. Best-effort: lỗi (chưa cấu hình FCM) không làm chết app.
class NotificationService {
  NotificationService._();

  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _local.initialize(
        settings: const InitializationSettings(android: androidInit),
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      await FirebaseMessaging.instance.subscribeToTopic('alerts');

      // App đang mở: FCM không tự hiện → tự bắn local notification.
      FirebaseMessaging.onMessage.listen(_showForeground);
    } catch (_) {
      // FCM chưa bật / thiếu google-services → bỏ qua, app vẫn chạy.
    }
  }

  static void _showForeground(RemoteMessage m) {
    final n = m.notification;
    if (n == null) return;
    _local.show(
      id: n.hashCode,
      title: n.title ?? 'Cảnh báo an toàn bếp',
      body: n.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
