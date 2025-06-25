# roomplan_launcher

A Flutter plugin to launch the native **iOS RoomPlan** scanner using **ARKit** and **RoomPlan SDK**. This plugin allows you to capture the 3D geometry of a room and returns structured **JSON output** directly to your Flutter app — perfect for AR-based measurement, interior design, construction, and smart home apps.

> ⚠️ Requires iOS 16+ and an ARKit-compatible device.

---

## ✨ Features

- Launches native `RoomCaptureViewController` with full-screen AR scanning.
- Automatically processes results and returns structured `CapturedRoom` JSON back to Flutter.

---

## 🚀 Getting Started

### 1. Install the plugin

Add to your `pubspec.yaml`:

```yaml
dependencies:
  roomplan_launcher: ^1.0.0
```

### 2. iOS Setup

Ensure your iOS project meets the following requirements:

- 📱 **Deployment target:** iOS **16.0+**

- 📷 **Camera usage permission:** Add the following entry to your `Info.plist`:

```xml
  <key>NSCameraUsageDescription</key>
  <string>Room scanning requires camera access</string>
```
---

## 🧠 Usage

Use the 'launch' method to invoke the native scanning screen and use the 'onRoomCaptureFinished' callback to get the result.

```dart
  void initState() {
    RoomplanLauncher.onRoomCaptureFinished = (json) {
      //Do something with the JSON here
      print(json);
    };
    super.initState();
  }
```

```dart
ElevatedButton(onPressed: RoomplanLauncher.launch, child: Text("Launch RoomPlan"))
```
---
## 📂 Output Format

The returned String is a JSON-encoded representation of Apple's CapturedRoom object.

---

## 🔧 Example App
Check the example/ directory for a full integration demo.

---

## ❗ Requirements
- iOS 16.0+
- ARKit-compatible device (e.g., iPhone 12+ or recent iPad Pro)

---

## 🙏 Credits
Built on top of Apple’s [RoomPlan SDK](https://developer.apple.com/documentation/roomplan).
Plugin maintained by [Yashodhan Killekar](https://github.com/yashodhankillekar/).