# Guava Finance

Guava Finance is a modern, secure, and user-friendly financial application built with Flutter. The application provides a comprehensive suite of financial services including transfers, account management, KYC verification, and more.

## 🚀 Features

- **Secure Authentication**: Local authentication support with biometric verification
- **KYC Integration**: Built-in KYC verification using Dojah
- **Real-time Updates**: PubNub integration for real-time notifications and updates
- **Analytics**: Comprehensive analytics using Mixpanel, PostHog, and Amplitude
- **Crash Reporting**: Firebase Crashlytics integration for robust error tracking
- **Code Push**: Shorebird integration for seamless updates
- **QR Code Support**: QR code generation and scanning capabilities
- **Cross-platform**: Supports both iOS and Android platforms

## 🛠️ Technical Stack

- **Framework**: Flutter (SDK ^3.5.4)
- **State Management**: Flutter Riverpod
- **Navigation**: Go Router
- **Networking**: Dio
- **Local Storage**: Flutter Secure Storage
- **Analytics & Monitoring**:
  - Firebase Analytics
  - Mixpanel
  - PostHog
  - Amplitude
- **Crash Reporting**: Firebase Crashlytics
- **Real-time Communication**: PubNub
- **KYC Integration**: Dojah
- **Code Push**: Shorebird

## 📱 Features Breakdown

### Core Features
- Home Dashboard
- Account Management
- Transfer System
- Receive Payments
- Onboarding Flow
- KYC Verification
- Real-time Notifications

### Security Features
- Biometric Authentication
- Secure Storage
- Encrypted Communications
- KYC Verification

## 🏗️ Project Structure

```
lib/
├── core/           # Core functionality and utilities
│   ├── cache/      # Caching mechanisms
│   ├── resources/  # Shared resources
│   ├── routes/     # Navigation routes
│   ├── styles/     # App-wide styling
│   ├── error/      # Error handling
│   └── usecase/    # Business logic
├── features/       # Feature modules
│   ├── home/       # Home screen
│   ├── account/    # Account management
│   ├── transfer/   # Transfer functionality
│   ├── receive/    # Payment receiving
│   ├── onboarding/ # User onboarding
│   ├── kyc/        # KYC verification
│   └── dashboard/  # Dashboard features
├── widgets/        # Reusable widgets
└── domain/         # Domain models and interfaces
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.5.4
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Dojah account for KYC
- PubNub account
- Mixpanel account
- PostHog account
- Amplitude account

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd guavafinance
```

2. Run the setup script to create the `.env` file:
```bash
./setup_env.sh
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run Build Runner:
To generate necessary code (service locator setup and `env.g.dart`):
```bash
dart run build_runner build
```
> Note: Use `--delete-conflicting-outputs` if conflicts arise.

5. Set up Asset Management:

a. Install `flutter_asset_generator` globally:
```bash
dart pub global activate -s git https://github.com/fluttercandies/flutter_asset_generator.git
dart pub global activate flutter_asset_generator
```

b. To activate real-time asset monitoring, run in VS Code terminal:
```bash
fgen
```

c. Using `flutter_asset_manager` for structured asset management:
```bash
dart run flutter_asset_manager --no-default <folder_name>
```
This creates `<folder_name>` under the `assets` folder and registers it in `pubspec.yaml` automatically.

6. Configure environment variables:
   - Create a `.env` file in the root directory
   - Add necessary API keys and configuration values

7. Run the app:
```bash
flutter run
```

### Troubleshooting

- **Flutter Issues**: If you encounter issues with Flutter, ensure your environment is correctly set up by running:
  ```bash
  flutter doctor
  ```

- **Asset Usage Example**:
  ```dart
  Image.asset(R.ASSETS_ONBOARD_IMAGE_1)
  ```

## 🔧 Configuration

### Firebase Setup
1. Create a new Firebase project
2. Add Android and iOS apps to the project
3. Download and add the configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS

### KYC Integration
1. Set up a Dojah account
2. Configure the KYC settings in the app
3. Add necessary API keys to the environment variables

### Analytics Setup
1. Configure Mixpanel
2. Set up PostHog
3. Initialize Amplitude

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🔐 Security Considerations

- All sensitive data is encrypted using the `encrypt` package
- Secure storage is implemented using `flutter_secure_storage`
- Biometric authentication is available through `local_auth`
- KYC verification is handled through Dojah
- All API communications are secured with proper encryption

## 📊 Analytics and Monitoring

The app implements multiple analytics platforms for comprehensive tracking:
- Firebase Analytics for general usage metrics
- Mixpanel for detailed user behavior analysis
- PostHog for product analytics
- Amplitude for user engagement tracking
- Firebase Crashlytics for crash reporting

## 🔄 Code Push Updates

The app uses Shorebird for code push updates, allowing for:
- Instant updates without app store approval
- Rollback capabilities
- Version management
- Update tracking

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is proprietary and confidential. All rights reserved.

## 👥 Team

[Add team information here]

## 📞 Support

For support, please contact [support contact information]
