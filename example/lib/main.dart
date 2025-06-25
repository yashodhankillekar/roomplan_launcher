import 'package:flutter/material.dart';
import 'package:roomplan_launcher/roomplan_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    RoomplanLauncher.onRoomCaptureFinished = (json) {
      //Do something with the JSON here
      print(json);
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: ElevatedButton(onPressed: RoomplanLauncher.launch, child: Text("Launch RoomPlan")),
        ),
      ),
    );
  }
}
