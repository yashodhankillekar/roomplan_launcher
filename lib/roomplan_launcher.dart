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
}
