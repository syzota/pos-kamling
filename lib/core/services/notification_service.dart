import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId   = 'rt_digital_channel';
  static const _channelName = 'RT Digital';
  static const _channelDesc = 'Notifikasi dari aplikasi RT Digital';

  Future<void> init() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onNotifTapped,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            ledColor: Color(0xFF2196F3),
          ),
        );

    FirebaseMessaging.onMessage.listen(_showFromRemote);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      await Future.delayed(const Duration(seconds: 1));
      _handleTap(initial);
    }

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> _showFromRemote(RemoteMessage message) async {
    final notif    = message.notification;
    final title    = notif?.title ?? message.data['title'] as String? ?? 'RT Digital';
    final body     = notif?.body  ?? message.data['body']  as String? ?? '';
    final imageUrl = message.data['image_url'] as String?;

    if (title.isEmpty && body.isEmpty) return;

    final bitmap = imageUrl != null && imageUrl.isNotEmpty
        ? await _downloadBitmap(imageUrl)
        : null;

    await _plugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          styleInformation: bitmap != null
              ? BigPictureStyleInformation(
                  bitmap,
                  contentTitle: title,
                  summaryText: body,
                  hideExpandedLargeIcon: true,
                )
              : BigTextStyleInformation(body),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: imageUrl != null && imageUrl.isNotEmpty
              ? [DarwinNotificationAttachment(imageUrl)]
              : null,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<AndroidBitmap<Object>?> _downloadBitmap(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return ByteArrayAndroidBitmap(response.bodyBytes);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void _onNotifTapped(NotificationResponse response) {
    if (response.payload == null) return;
    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateFromData(data);
      });
    } catch (_) {}
  }

  void _handleTap(RemoteMessage message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateFromData(message.data);
    });
  }

  void _navigateFromData(Map<String, dynamic> data) {
    final type   = data['type']    as String?;
    final tanggal = data['tanggal'] as String?;

    switch (type) {
      case 'pengumuman':
        Get.toNamed('/warga/announcement');
        break;

      case 'kegiatan':
        final selectedDate = tanggal != null
            ? DateTime.tryParse(tanggal) ?? DateTime.now()
            : DateTime.now();

        Get.toNamed(
          '/warga/calendar',
          arguments: {'selected_date': selectedDate},
        );
        break;

      case 'surat':
        Get.toNamed('/warga/letter');
        break;

      case 'keuangan':
        Get.toNamed('/warga/finance');
        break;

      default:
        break;
    }
  }
}