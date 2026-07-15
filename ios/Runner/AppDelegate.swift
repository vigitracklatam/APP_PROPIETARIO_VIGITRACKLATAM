import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    GMSServices.provideAPIKey("AIzaSyCJ8BazUPx9gsywvwpyTXMTXo2P0BGF_WM")
    //GMSServices.setMetalRendererEnabled(true)

    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }
}