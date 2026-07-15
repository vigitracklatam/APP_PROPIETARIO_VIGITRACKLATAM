import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'localnotification.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? tokenFCM;
  //static LocalNotification LocalNotification = LocalNotification();

  /*static StreamController<String> _streamMessageController =
      new StreamController.broadcast();

  static Stream<String> get messageStream => _streamMessageController.stream;*/

  static Future initializeApp() async {
    //Push Notification
    await Firebase.initializeApp();
    
    tokenFCM = await FirebaseMessaging.instance.getToken();
    print("************************ token FCM *******************");
    print(tokenFCM);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    var request = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (request.authorizationStatus == AuthorizationStatus.authorized ||
        request.authorizationStatus == AuthorizationStatus.provisional) {
      LocalNotification.initLocalNotification();
      //setupInteractedMessage();
    }

    /**Cuando la app esta terminada**/
    FirebaseMessaging.onBackgroundMessage(_backgrounHandler);

    /**CUANDO LA APP ESTA EN BACKGROUND(SE PRESIONO EL HOME ETC)**/
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    /** CUANDO LA APP ESTA EN USO**/
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<void> _backgrounHandler(RemoteMessage message) async {
    await LocalNotification.initLocalNotification();

    final data = message.data;
    final type = data['type'] ?? '';

    print('BACKGROUND HANLDER ${message.messageId}');
    print("NOTIFICATIOB TITLE ${message.notification!.title}");
    print("NOTIFICATIOB TITLE ${message.notification!.body}");

    LocalNotification.showNotificationSimple(
      message.notification == null ? "NO TITLE" : message.notification!.title,
      message.notification == null ? "NO BODY" : message.notification!.body,
      "",
      type,
    );
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    print('onMessage HANLDER ${message.messageId}');
    print("NOTIFICATIOB TITLE ${message.notification!.title}");
    print("NOTIFICATIOB TITLE ${message.notification!.body}");

    final data = message.data;
    final type = data['type'] ?? '';

    LocalNotification.showNotificationSimple(
      message.notification == null ? "NO TITLE" : message.notification!.title,
      message.notification == null ? "NO BODY" : message.notification!.body,
      "",
      type,
    );
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp HANLDER ${message.messageId}');
    print("NOTIFICATIOB TITLE ${message.notification!.title}");
    print("NOTIFICATIOB BODY ${message.notification!.body}");
    final data = message.data;
    final type = data['type'] ?? '';

    LocalNotification.showNotificationSimple(
      message.notification == null ? "NO TITLE" : message.notification!.title,
      message.notification == null ? "NO BODY" : message.notification!.body,
      "",
      type,
    );
  }
}
