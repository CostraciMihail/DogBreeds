import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    
    #if APPCLIP
    let flutterVC = FlutterViewController(project: nil,
                                          initialRoute: "/main-screen",
                                          nibName: nil,
                                          bundle: nil)
    
    window.rootViewController = flutterVC
    window.makeKeyAndVisible()
    #endif
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
