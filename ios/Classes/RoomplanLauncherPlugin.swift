import Flutter
import UIKit

public class RoomplanLauncherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "in.yashodhankillekar/roomplan_launcher", binaryMessenger: registrar.messenger())
    let instance = RoomplanLauncherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "launchRoomPlan" {
      DispatchQueue.main.async {
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController
        let roomVC = RoomCaptureViewController()
        rootVC?.present(roomVC, animated: true, completion: nil)
      }
      result(nil)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}