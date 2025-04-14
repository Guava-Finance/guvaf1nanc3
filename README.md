# GuavaFinance

GuavaFinance is a fintech cross-border payment and wallet solution for individuals and SMEs, powered by the Solana blockchain and leveraging the USDC stablecoin for payments. This project is built using Flutter, providing a seamless and efficient user experience.

## Getting Started

This project is a starting point for a Flutter application. Below are the steps to set up the project on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Comes bundled with Flutter.
- **Git**: [Install Git](https://git-scm.com/downloads)

---

### Cloning the Repository

To get started, clone the repository to your local machine:

```bash
git clone https://github.com/your-username/guavafinance.git
cd guavafinance
```

### Run the Script:
Execute the script to create the `.env` file:
```bash
./setup_env.sh
```

### Installing Dependencies

After setting up the environment variables, install the project dependencies:
```bash
flutter pub get
```

### Running Build Runner
To generate the code needed to successfully run the project, such as service locator setup and `env.g.dart`, you'll need to run build_runner:
```bash
dart run build_runner build
```
> Note: Use `--delete-conflicting-outputs` if conflicts arise.

### Installing `flutter_asset_generator`

To automatically manage assets, install `flutter_asset_generator` globally:
```bash
dart pub global activate -s git https://github.com/fluttercandies/flutter_asset_generator.git
```
This package monitors the project and automatically handles asset management, including additions, removals, or path changes. It ensures that asset paths are managed automatically in `lib/const/resources.dart`.

```bash
dart pub global activate flutter_asset_generator
```

To activate real-time asset monitoring, run:
```bash
fgen
```
in a terminal within VS Code.

#### Usage Example:
To use assets in the project:
```dart
Image.asset(R.ASSETS_ONBOARD_IMAGE_1)
```

### Using `flutter_asset_manager`

For structured asset management, use `flutter_asset_manager` to create and register asset folders automatically:
```bash
dart run flutter_asset_manager --no-default <folder_name>
```
This will create `<folder_name>` under the `assets` folder and register it in `pubspec.yaml` automatically.

### Running the Application
Once everything is set up, you can run the application:
```bash
flutter run
```

### Troubleshooting
- **Flutter Issues**: If you encounter issues with Flutter, ensure your environment is correctly set up by running:
  ```bash
  flutter doctor
  ```
- **Solana Issues**: If you have trouble with Solana, check the Solana CLI documentation or community forums for assistance.
