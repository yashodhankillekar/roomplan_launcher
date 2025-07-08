import 'package:roomplan_launcher/roomplan_launcher_platform_interface.dart';
import 'package:roomplan_launcher/types.dart';

Future<void> launchRoomplan() async {
  await RoomplanLauncherPlatform.instance.launch();
}

abstract class RoomplanLauncher {
  static void onRoomCaptureFinished(CaptureFinishedHandler handler) {
    RoomplanLauncherPlatform.instance.onRoomCaptureFinished(handler);
  }

  static Future<void> launch() async {
    await RoomplanLauncherPlatform.instance.launch();
  }

  //Utility method to check support
  Future<bool> isSupported() {
    return RoomplanLauncherPlatform.instance.isSupported();
  }

  /// Returns the path of the directory containing the resulted USDZ files.
  /// Returns null if no scan has been completed or if the export failed.
  Future<String?> usdzResultsPath() {
    throw UnimplementedError('usdzResultsPath() has not been implemented.');
  }

  /// Returns the file path of the exported USDZ file from the last room scan.
  /// Returns null if no scan has been completed or if the export failed.
  Future<String?> lastUsdzResultFilePath() {
    return RoomplanLauncherPlatform.instance.lastUsdzResultFilePath();
  }
}
