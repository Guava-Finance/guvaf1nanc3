// ignore_for_file: lines_longer_than_80_chars

class Strings {
  Strings._();

  // Keys
  static const String title = 'guava';
  static const String mnemonics = 'my_wallet_mnemonic_';
  static const String privateKey = 'my_wallet_private_';
  static const String accessCode = 'my_access_code_';
  static const String myAccount = 'my_account_';
  static const String exchangeRate = 'exchange_rate_';
  static const String showBalance = 'show_balance_';

  // todo: Fetch from Config
  static String derivativePath = 'm/44\'/501\'/0\'/0\'';
  static String usdcMintTokenAddress =
      '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU';

  //Pages
  static const root = '/';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const setupPin = '/setup-pin';
  static const addConnectWallet = '/add-connect-wallet';
  static const importRecoveryPhrase = '/import-recovery-phrase';
  static const importPrivateKey = '/import-private-key';
  static const fullscreenLoader = '/fullscreen-loader';
  static const transfer = '/transfer';
  static const enterAmountWallet = '/enterAmountWallet';
  static const enterAmountBank = '/enterAmountBank';

  // Home Banners
  static const connectWallet = 'WalletConnect';
  static const createUsername = 'UsernameCreation';
  static const backupPhrase = 'MnenomicsBackup';
  static const kycVerification = 'KYCVerification';
}
