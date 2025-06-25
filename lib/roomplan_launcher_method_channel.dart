import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'roomplan_launcher_platform_interface.dart';

/// An implementation of [RoomplanLauncherPlatform] that uses method channels.
class MethodChannelRoomplanLauncher extends RoomplanLauncherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in.yashodhankillekar/roomplan_launcher');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
