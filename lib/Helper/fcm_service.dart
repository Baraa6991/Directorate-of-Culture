import 'dart:io';
import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// خدمة إدارة إشعارات Firebase Cloud Messaging.
/// تتكامل مباشرة مع الباك اند: تسجّل توكن الجهاز في /device-tokens،
/// وتعرض إشعارات محلية عند فتح التطبيق (foreground)،
/// وتوفّر دالة للتنقل عند الضغط على أي إشعار.
class FcmService {
  final ApiClient _apiClient;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// يُستدعى عند الضغط على أي إشعار (foreground/background/terminated)
  /// مع تمرير قيمة action_url القادمة من الباك اند للتنقل إليها.
  void Function(String actionUrl)? onNotificationTap;

  FcmService(this._apiClient);

  Future<void> init() async {
    // 1) طلب إذن الإشعارات (ضروري لـ iOS، ولأندرويد 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // 🔍 تشخيصي: تأكد بنفسك من قيمة authorizationStatus هنا أثناء أول تشغيل
    // بعد إعادة التثبيت. القيم الممكنة: authorized / denied / notDetermined /
    // provisional. إن كانت denied، لن يظهر أي إشعار مهما كان الكود صحيحاً،
    // ويجب حينها فتح إعدادات النظام يدوياً لمنح الإذن (لا يمكن للتطبيق
    // إعادة طلبه تلقائياً بعد الرفض الأول على أغلب الأجهزة).
    debugPrint('🔔 FCM permission status: ${settings.authorizationStatus}');

    // 2) تهيئة الإشعارات المحلية (لعرضها أثناء فتح التطبيق)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onNotificationTap?.call(payload);
        }
      },
    );

    // إنشاء قناة إشعارات أندرويد (مطلوبة لعرض إشعارات foreground بشكل صحيح)
    const androidChannel = AndroidNotificationChannel(
      'default_channel',
      'الإشعارات',
      description: 'إشعارات مديرية الثقافة',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // 3) الحصول على التوكن الحالي وإرساله للباك اند
    final token = await _messaging.getToken();
    debugPrint("FCM TOKEN: $token");
    if (token != null) await _registerToken(token);

    // 4) الاستماع لأي تحديث للتوكن (يحدث أحيانًا) وإعادة إرساله تلقائيًا
    _messaging.onTokenRefresh.listen(_registerToken);

    // 5) عرض إشعار محلي عندما يكون التطبيق مفتوحًا (foreground)
    //    لأن نظام التشغيل لا يعرض الإشعار تلقائيًا في هذه الحالة.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('📩 onMessage استُلمت رسالة: ${message.notification?.title}');
      final notification = message.notification;
      if (notification == null) {
        debugPrint('⚠️ الرسالة وصلت بدون حقل notification (data-only message)');
        return;
      }
      try {
        await _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'الإشعارات',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data['action_url'] as String?,
        );
        debugPrint('✅ تم عرض الإشعار المحلي بنجاح');
      } catch (e, st) {
        // ⚠️ هذا هو التشخيص الحاسم: لو ظهر هذا السطر بالـconsole، فالمشكلة
        // فعلياً بالكود/المكتبة نفسها، وليست بإعدادات النظام أو MIUI.
        debugPrint('💥 فشل عرض الإشعار المحلي: $e');
        debugPrint('$st');
      }
    });

    // 6) الضغط على الإشعار والتطبيق في الخلفية (background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);

    // 7) فتح التطبيق من إشعار وهو مغلق تمامًا (terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteMessageTap(initialMessage);
    }
  }

  void _handleRemoteMessageTap(RemoteMessage message) {
    final actionUrl = message.data['action_url'] as String?;
    if (actionUrl != null && actionUrl.isNotEmpty) {
      onNotificationTap?.call(actionUrl);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _apiClient.post(
        ApiConstants.deviceTokens(),
        data: {'token': token, 'platform': Platform.isIOS ? 'ios' : 'android'},
      );
      debugPrint('✅ تم تسجيل توكن الجهاز بالباك اند بنجاح');
    } catch (e) {
      debugPrint('💥 فشل تسجيل توكن الجهاز: $e');
    }
  }

  /// يُستدعى عند تسجيل الخروج لحذف توكن هذا الجهاز من الباك اند.
  Future<void> unregisterToken() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    try {
      await _apiClient.delete(ApiConstants.deviceTokens(), data: {'token': token});
    } catch (e) {
      debugPrint('💥 فشل حذف توكن الجهاز: $e');
    }
  }
}