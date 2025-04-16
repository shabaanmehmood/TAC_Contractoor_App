import Flutter
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let key = Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] as? String {
      GMSServices.provideAPIKey(key)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
