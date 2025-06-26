import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:roomplan_launcher/types.dart';

import 'roomplan_launcher_platform_interface.dart';

/// An implementation of [RoomplanLauncherPlatform] that uses method channels.
class MethodChannelRoomplanLauncher extends RoomplanLauncherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in.yashodhankillekar/roomplan_launcher');

  CaptureFinishedHandler? _captureFinishedHandler;

  @override
  Future<void> launch() async {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onRoomCaptureFinished') {
        String jsonResult = call.arguments;
        // Do something with the JSON
        _captureFinishedHandler?.call(jsonResult);
      }
    });

    await methodChannel.invokeMethod('launchRoomPlan');
  }

  @override
  void onRoomCaptureFinished(CaptureFinishedHandler handler) {
    _captureFinishedHandler = handler;
  }
}
