import Flutter
import UIKit

public class RoomplanLauncherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "in.yashodhankillekar/roomplan_launcher", binaryMessenger: registrar.messenger())
    let instance = RoomplanLauncherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    switch call.method {
    case "launchRoomPlan":
        DispatchQueue.main.async {
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController
        let roomVC = RoomCaptureViewController()
        roomVC.modalPresentationStyle = .fullScreen
        rootVC?.present(roomVC, animated: true, completion: nil)
      }
      result(nil)
    case "isSupported":
      result(RoomCaptureViewController.isSupported())
    case "usdzResultsPath":
      result(usdzResultsPath())
    case "lastUsdzResultFilePath":
      result(lastUsdzResultFilePath())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // Returns the directory path where USDZ files are stored
  private func usdzResultsPath() -> String {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let folderPath = documentsPath.appendingPathComponent("room_scans").path
    return folderPath
  }

  // Returns the path to the latest USDZ file in the directory, based on filename timestamps
  private func lastUsdzResultFilePath() -> String? {
    let folderPath = usdzResultsPath()
    
    do {
        let fileNames = try FileManager.default.contentsOfDirectory(atPath: folderPath)
        let usdzFiles = fileNames
            .filter { $0.hasSuffix(".usdz") && $0.hasPrefix("scan_") }
            .sorted()  // Sorted by filename (timestamp increases → file name increases)
        
        guard let latestFile = usdzFiles.last else { return nil }
        return (folderPath as NSString).appendingPathComponent(latestFile)
    } catch {
        print("Error retrieving USDZ files: \(error)")
        return nil
    }
  }
}