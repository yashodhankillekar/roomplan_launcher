import 'package:flutter/services.dart';

class RoomplanLauncher {
  final MethodChannel _channel = MethodChannel('in.yashodhankillekar/roomplan_launcher');

  void Function(String jsonResult) onRoomCaptureFinished;

  RoomplanLauncher({required this.onRoomCaptureFinished}) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onRoomCaptureFinished') {
        String jsonResult = call.arguments;
        // Do something with the JSON
        onRoomCaptureFinished.call(jsonResult);
      }
    });
  }

  Future<void> launch() async {
    await _channel.invokeMethod('launchRoomPlan');
  }
}
