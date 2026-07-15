import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/app.dart';
import 'service/push_notification_services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await PushNotificationService.initializeApp();
  } catch (e) {
    print(e);
  }
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e);
  }
  runApp(AppPage());
}
