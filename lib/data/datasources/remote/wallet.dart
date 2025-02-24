/// This class would handle everything from Signing of Transaction and
/// Setup of SPL Token
/// This makes the wallet fully decentralized
abstract class RemoteWalletFunctions {
  /// This method check whether user has already created SPLToken account
  /// To avoid trying to recreate it
  /// SPLToken account is created only once
  Future<bool> doesSPLTokenAccountExist(String tokenMintAddress);

  /// This method sets up SPLToken account for Solana Wallet
  /// Newly created wallet would be pre-funded by the system to enable
  /// wallet create the USDC SPL Token account on the blockchain
  Future<void> enableUSDCForWallet();

  /// The splToken address is passed and the balance is gotten from
  /// Solana blockchain via RPC network call
  Future<dynamic> checkBalance(String publicAddress) async {}

  /// The amount would be converted to [lamport] the unit of measurement on solana
  /// And the transaction would be signed locally using the user's
  /// private key securely kept on the device.
  Future<dynamic> transferUSDC(String publicAddress) async {}

  /// The user's Sol balance is checked to know if it can cover the gas fee
  /// else the user would be pre-funded before proceed to send the transaction.
  /// The amount would be converted to [lamport] to unit of measurement for solana
  Future<dynamic> isGasFeeSufficient(double amount);
}
