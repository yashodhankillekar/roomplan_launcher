# roomplan_launcher

A Flutter plugin to launch the native **iOS RoomPlan** scanner using **ARKit** and **RoomPlan SDK**. This plugin allows you to capture the 3D geometry of a room and returns structured **JSON output** directly to your Flutter app — perfect for AR-based measurement, interior design, construction, and smart home apps.

> ⚠️ Requires iOS 16+ and an ARKit-compatible device.

---

## ✨ Features

- Launches native `RoomCaptureViewController` with full-screen AR scanning.
- Live room scanning with real-time geometry capture.
- Automatically processes results and returns structured `CapturedRoom` JSON back to Flutter.
- Lightweight and easy to integrate — no storyboard or navigation controller required.

---

## 📸 Demo

<img src="https://developer.apple.com/roomplan/images/roomplan-hero.png" width="100%">

---

## 🚀 Getting Started

### 1. Install the plugin

Add to your `pubspec.yaml`:

```yaml
dependencies:
  roomplan_launcher: ^0.0.1
```

### 2. iOS Setup

Ensure your iOS project meets the following requirements:

- 📱 **Deployment target:** iOS **16.0+**

- 📷 **Camera usage permission:** Add the following entry to your `Info.plist`:

```xml
  <key>NSCameraUsageDescription</key>
  <string>Room scanning requires camera access</string>
```