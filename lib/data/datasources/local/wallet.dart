import 'package:injectable/injectable.dart';

/// This class would handle everything from Wallet creation, restoration
/// Because it's a Non-Custodian Wallet
/// This makes the wallet fully decentralized
abstract class LocalWalletFunctions {
  /// Using [bip39] either 12 or 24 secret phrases is generated
  /// The secret phrase i.e. [Mnenomics] would be kept securely within the device
  Future<String> createANewWallet({int walletStrength = 128});

  /// The [mnenomics] is reversed to generate the wallet private key
  /// This mnenomics should be kept securely to avoid lost of money
  /// And it should be kept locally within the user's device to ensure decentralization
  Future<String> restoreAWallet(String mnenomics);
}

@LazySingleton(as: LocalWalletFunctions)
class LocalWalletFunctionsImpl extends LocalWalletFunctions {
  @override
  Future<String> createANewWallet({int walletStrength = 128}) async {
    // TODO: implement createANewWallet
    throw UnimplementedError();
  }

  @override
  Future<String> restoreAWallet(String mnenomics) async {
    // TODO: implement restoreAWallet
    throw UnimplementedError();
  }
}
