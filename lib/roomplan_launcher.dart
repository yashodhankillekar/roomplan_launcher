import 'package:flutter/services.dart';

class RoomplanLauncher {
  static const MethodChannel _channel = MethodChannel('in.yashodhankillekar/roomplan_launcher');

  static Future<void> launch() async {
    await _channel.invokeMethod('launchRoomPlan');
  }
}
