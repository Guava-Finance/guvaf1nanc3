class MixpanelEvents {
  // Wallet Setup
  static const walletCreated = 'wallet_created';
  static const walletRestored = 'wallet_restored';
  static const seedPhraseViewed = 'seed_phrase_viewed';
  static const seedPhraseBackedUp = 'seed_phrase_backed_up';
  static const usernameSet = 'username_set';
  static const passcodeSet = 'passcode_set';

  // Identity & KYC
  static const kycStarted = 'kyc_started';
  static const kycSubmitted = 'kyc_submitted';
  static const kycClosed = 'kyc_closed';
  static const kycError = 'kyc_error';

  // Payments & Transfers
  static const sendViaWallet = 'send_usdc_wallet_address';
  static const sendViaUsername = 'send_usdc_username';
  static const sendViaSolanaPay = 'send_usdc_solanapay_scan';
  static const transactionSuccess = 'transaction_success';
  static const transactionFailed = 'transaction_failed';

  // On-Ramp / Off-Ramp
  static const depositInitiated = 'bank_deposit_initiated';
  static const depositCompleted = 'bank_deposit_completed';
  static const transferToBankInitiated = 'transfer_to_bank_initiated';
  static const transferToBankCompleted = 'transfer_to_bank_completed';
  static const rampFailed = 'ramp_failed';

  // User Behavior & Retention
  static const appOpened = 'app_opened';
  static const viewedDashboard = 'viewed_dashboard';
  static const checkedBalance = 'checked_balance';
  static const viewedTransactionHistory = 'tapped_on_transaction_history';
  static const returnedAfterInactivity = 'returned_after_inactivity';
}
