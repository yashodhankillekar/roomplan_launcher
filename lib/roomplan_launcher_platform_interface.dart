import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:roomplan_launcher/types.dart';

import 'roomplan_launcher_method_channel.dart';

abstract class RoomplanLauncherPlatform extends PlatformInterface {
  /// Constructs a RoomplanLauncherPlatform.
  RoomplanLauncherPlatform() : super(token: _token);

  static final Object _token = Object();

  static RoomplanLauncherPlatform _instance = MethodChannelRoomplanLauncher();

  /// The default instance of [RoomplanLauncherPlatform] to use.
  ///
  /// Defaults to [MethodChannelRoomplanLauncher].
  static RoomplanLauncherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RoomplanLauncherPlatform] when
  /// they register themselves.
  static set instance(RoomplanLauncherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void onRoomCaptureFinished(CaptureFinishedHandler handler) {
    throw UnimplementedError('onRoomCaptureFinished() has not been implemented.');
  }

  Future<void> launch() async {
    throw UnimplementedError('launch() has not been implemented.');
  }

  Future<bool> isSupported() {
    throw UnimplementedError('isSupported() has not been implemented.');
  }

  Future<String?> usdzResultsPath() {
    throw UnimplementedError('usdzResultsPath() has not been implemented.');
  }

  Future<String?> lastUsdzResultFilePath() {
    throw UnimplementedError('lastUsdzResultFilePath() has not been implemented.');
  }
}
