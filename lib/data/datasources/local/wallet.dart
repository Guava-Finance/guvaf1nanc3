import 'package:bip39/bip39.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guava/core/app_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:solana/solana.dart';

/// This class would handle everything from Wallet creation, restoration
/// Because it's a Non-Custodian Wallet
/// This makes the wallet fully decentralized
abstract class LocalWalletFunctions {
  /// Using [bip39] either 12 or 24 secret phrases is generated
  /// The secret phrase i.e. [mnemonics] would be kept 
  /// securely within the device
  Future<String> createANewWallet({int walletStrength = 128});

  /// The [mnemonics] is reversed to generate the wallet private key
  /// This mnemonics should be kept securely to avoid lost of money
  /// And it should be kept locally within the 
  /// user's device to ensure decentralization
  Future<String> restoreAWallet(String mnemonics);

  /// The [mnemonics] is gotten from secure storage and together with the
  /// derivative path the private public key pair is gotten
  Future<String> walletAddress();

  /// Display mnemonics to user for backup
  Future<String> showMnemonics();
}

@LazySingleton(as: LocalWalletFunctions)
class LocalWalletFunctionsImpl extends LocalWalletFunctions {
  LocalWalletFunctionsImpl({
    required this.secureStorage,
  });

  final FlutterSecureStorage secureStorage;

  @override
  Future<String> createANewWallet({int walletStrength = 256}) async {
    /// [walletStrength = 128] generates 12 phrases secret words
    /// [walletStrength = 256] generates 24 phrases secret words
    final String mnemonic = generateMnemonic(strength: walletStrength);

    /// This saves the secret phrase to a secure storage on the user's device
    await secureStorage.write(key: Strings.mnemonics, value: mnemonic);

    /// Generate a standard wallet address that can be used on various
    /// Wallet app such as Phantom e.t.c.
    final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonic),
      hdPath: Strings.derivativePath,
    );

    /// return wallets public key for display
    return wallet.address;
  }

  @override
  Future<String> restoreAWallet(String mnemonics) async {
    final List<String> noOfMnemonics = mnemonics.split(' ').toList();

    if (noOfMnemonics.length != 12 || noOfMnemonics.length != 24) {
      throw Exception('Invalid mnemonics');
    }

    /// Save correct mnemonics to a secure storage on User's device
    await secureStorage.write(key: Strings.mnemonics, value: mnemonics);

    final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonics),
      hdPath: Strings.derivativePath,
    );

    /// Display the public address of user's wallet
    return wallet.address;
  }

  @override
  Future<String> walletAddress() async {
    final String? mnemonics = await secureStorage.read(key: Strings.mnemonics);

    /// Ensure there's a Mnemomic to read 
    /// so that the correct wallet can be gotten
    if (mnemonics != null) {
      final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: mnemonicToSeed(mnemonics),
        hdPath: Strings.derivativePath,
      );

      return wallet.address;
    }

    throw Exception('No wallet found');
  }

  @override
  Future<String> showMnemonics() async {
    final String? mnemonics = await secureStorage.read(key: Strings.mnemonics);

    if (mnemonics != null) {
      return mnemonics;
    }

    throw Exception('Oops! Nothing here');
  }
}
