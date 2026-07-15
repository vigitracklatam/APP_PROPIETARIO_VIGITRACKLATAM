import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/textos.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin oFlutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails oAndroidNotificationDetail =
      AndroidNotificationDetails(
        channelId, // channelId
        channelName, // channelName
        channelDescription: 'This channel is used for important notifications.',
        priority: Priority.high,
        playSound: true,
        importance: Importance.high,
        styleInformation: BigTextStyleInformation(''),
        ongoing: false,
      );

  /// Canal para notificaciones Panico
  static const AndroidNotificationDetails oAndroidNotificationDetailPanico =
      AndroidNotificationDetails(
        channelIdPanico, // canal único
        channelNamePanico,
        channelDescription: 'Notificaciones Panico de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
          'panico',
        ), // general.wav en res/raw/
      );

  static Future<void> initLocalNotification() async 
  {
    if (oFlutterLocalNotificationsPlugin != null) {
      await oFlutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()!
          .requestNotificationsPermission();
      /*await oFlutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()!
          .requestExactAlarmsPermission();*/

      await oFlutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // ⚡ Icono para Android (debe existir en mipmap/)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
        );

    await oFlutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      // callback cuando el usuario toca la notificación
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Aquí manejas navegación, abrir pantalla, etc.
        final payload = response.payload;
        print("Notificación tocada con payload: $payload");
      },
    );
  }

  static Future<void> showNotificationSimple(
    String? titulo,
    String? body,
    String? payload,
    String? type,
  ) async {
    print(type);
    await oFlutterLocalNotificationsPlugin.show(
      id: 1,
      title: titulo,
      body: body,
      notificationDetails:
          type == 'alerta_panico'
              ? const NotificationDetails(
                android: oAndroidNotificationDetailPanico,
              )
              : const NotificationDetails(android: oAndroidNotificationDetail),
      payload: payload,
    );
  }
}
