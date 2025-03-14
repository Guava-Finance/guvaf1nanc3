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
Execute the script to create the .env file:
```bash
./setup_env.sh
```

### Installing Dependencies

After setting up the environment variables, install the project dependencies:
```bash
flutter pub get
```

### Running Build Runner
To generate the code needed to successfully run the project uses code generation (i.e. Service locator setup and env.g.dart), you'll need to run build_runner:
```bash
dart run build_runner build
```
> Note: `--delete-conflicting-outputs` might be required to override conflicts.

### Running the Application
Once everything is set up, you can run the application:
```bash
flutter run
```

### Troubleshooting
Flutter Issues: If you encounter issues with Flutter, ensure your environment is correctly set up by running flutter doctor.

Solana Issues: If you have trouble with Solana, check the Solana CLI documentation or community forums for assistance.


