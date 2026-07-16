# LifeCard SOS — Emergency Medical ID & SOS Tracker

[![Flutter](https://img.shields.io/badge/Flutter-v3.12.1+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: Private](https://img.shields.io/badge/License-Private-red.svg)](https://pub.dev)

**LifeCard SOS** is a secure, offline-first Emergency Medical ID and SOS tracking application built with Flutter. It is designed to safeguard critical medical details and facilitate life-saving assistance in critical situations. 

All sensitive personal information (allergies, medical conditions, blood group, active medications, and primary emergency contacts) is stored securely on-device with zero cloud exposure.

---

## 🚀 Key Features

- 🔒 **AES Encrypted, On-Device Storage**: Data is locked using `Hive CE` combined with AES encryption, with keys securely stored in the system Keystore (Android) or Keychain (iOS).
- 🚨 **SOS Trigger System**: Includes a customisable countdown panic button. When triggered, it initiates a loud audio siren, flashes the device flashlight, and flashes warning visuals on the screen.
- 📍 **Geolocated SMS Updates**: Retrieves accurate GPS coordinates locally and formats automated emergency SMS alerts for pre-configured emergency contacts.
- 📱 **Lock Screen Widgets**: Seamless integration via `home_widget` to display critical health details on the lock screen for first responders.
- 🩺 **Medical ID Cards**: A comprehensive dashboard allowing users to view, manage, and edit their medical profile, chronic conditions, medication schedules, and allergies.
- 🎨 **Adaptive Themes**: Beautiful UI design with Light, Dark, and AMOLED Black modes, leveraging `dynamic_color` where available.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.12.1`)
- **State Management**: [Riverpod](https://riverpod.dev) (`flutter_riverpod` + code generation via `riverpod_annotation`)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (`go_router`)
- **Local Database**: [Hive CE](https://pub.dev/packages/hive_ce) (`hive_ce` for offline-first storage)
- **Encryption & Key Management**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- **Location Services**: [Geolocator](https://pub.dev/packages/geolocator)
- **Mapping**: [Flutter Map](https://pub.dev/packages/flutter_map) + [LatLong2](https://pub.dev/packages/latlong2)
- **Code Generation**: [Freezed](https://pub.dev/packages/freezed), [JSON Serializable](https://pub.dev/packages/json_serializable), and [Build Runner](https://pub.dev/packages/build_runner)
- **UI & Animations**: [Google Fonts](https://pub.dev/packages/google_fonts), [Lottie](https://pub.dev/packages/lottie), and [Flutter Animate](https://pub.dev/packages/flutter_animate)

---

## 📂 Folder & File Structure

The project follows a feature-first architectural structure for scalability and maintainability:

```yaml
lib/
├── main.dart                      # App entry point (initializes DB, theme & Riverpod scopes)
├── core/                          # Cross-cutting concerns & shared infrastructure
│   ├── constants/                 # App color palettes and style constants
│   ├── database/                  # Encrypted database initializer (Hive CE + KeyStore)
│   ├── extensions/                # BuildContext and style helper extensions
│   ├── routing/                   # Route configuration using GoRouter
│   ├── security/                  # Cryptography and AES key helpers
│   └── theme/                     # Light, Dark, and AMOLED themes
├── features/                      # UI screens and feature-specific logic
│   ├── contacts/                  # Emergency contacts viewer and editor
│   ├── home/                      # Tab-bar layout, dashboard grid, and quick actions
│   ├── medical/                   # Detailed Medical ID card views and editor pages
│   ├── onboarding/                # App welcome tutorial and permission setup flows
│   ├── profile/                   # Basic personal details editor
│   ├── settings/                  # Countdown duration, theme, and language toggles
│   └── sos/                       # Panic countdown, siren alarm, and visual controls
├── models/                        # Serialized schemas and models with Freezed annotations
├── repositories/                  # DB data access layer (profile, settings, helplines)
├── services/                      # Low-level system services (Audio alarm, Geolocating, Notifications)
└── shared/                        # Shared Riverpod providers and utility configurations
```

---

## ⚙️ Getting Started & Setup

Follow these steps to run the application locally on your machine.

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.12.1` or higher recommended).
2. Set up your target simulator/emulator (Android Studio or Xcode) or connect a physical debugging device.

### Installation

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository-url>
   cd life_card_and_sos
   ```

2. Fetch all dependencies:
   ```bash
   flutter pub get
   ```

3. Generate the required serializable models and dependency injection providers:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the project in debug mode:
   ```bash
   flutter run
   ```

---

## 📦 Building for Production

### Android Build
Generate a release Android App Bundle (AAB):
```bash
flutter build appbundle
```
Or generate a release APK:
```bash
flutter build apk
```

### iOS Build
Generate an iOS build archive:
```bash
flutter build ipa
```

---

## 🧹 Recent Streamlining

To improve user onboarding and reduce device permission requirements, **we removed the QR Code export/scanner feature and its camera permissions**.
- **Camera Access Not Required**: The app no longer requests or checks for camera hardware permissions.
- **Removed Dependencies**: Cleaned up dependencies like `mobile_scanner`, `qr_flutter`, and `share_plus` to minimize build size.
- **Improved UI Layout**: The Dashboard has been redesigned to support a full-width **Trigger SOS** card and side-by-side **Medical Card** and **Contacts** modules.
