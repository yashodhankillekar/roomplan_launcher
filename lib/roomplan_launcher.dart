import 'package:flutter/services.dart';

class RoomplanLauncher {
  static const MethodChannel _channel = MethodChannel('in.yashodhankillekar/roomplan_launcher');

  static void Function(String jsonResult)? onRoomCaptureFinished;

  static Future<void> launch() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onRoomCaptureFinished') {
        String jsonResult = call.arguments;
        // Do something with the JSON
        onRoomCaptureFinished?.call(jsonResult);
      }
    });

    await _channel.invokeMethod('launchRoomPlan');
  }
}
