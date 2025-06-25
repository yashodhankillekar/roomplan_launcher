// import 'package:flutter_test/flutter_test.dart';
// import 'package:roomplan_launcher/roomplan_launcher.dart';
// import 'package:roomplan_launcher/roomplan_launcher_platform_interface.dart';
// import 'package:roomplan_launcher/roomplan_launcher_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockRoomplanLauncherPlatform
//     with MockPlatformInterfaceMixin
//     implements RoomplanLauncherPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final RoomplanLauncherPlatform initialPlatform = RoomplanLauncherPlatform.instance;

//   test('$MethodChannelRoomplanLauncher is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelRoomplanLauncher>());
//   });

//   test('getPlatformVersion', () async {
//     RoomplanLauncher roomplanLauncherPlugin = RoomplanLauncher();
//     MockRoomplanLauncherPlatform fakePlatform = MockRoomplanLauncherPlatform();
//     RoomplanLauncherPlatform.instance = fakePlatform;

//     expect(await roomplanLauncherPlugin.getPlatformVersion(), '42');
//   });
// }
