import 'package:bip39/bip39.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guavafinance/core/app_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:solana/solana.dart';

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

  /// The [mnenomic] is gotten from secure storage and together with the
  /// derivative path the private public key pair is gotten
  Future<String> walletAddress();

  /// Display Mnenomics to user for backup
  Future<String> showMnenomics();
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
    final mnemonic = generateMnemonic(strength: walletStrength);

    /// This saves the secret phrase to a secure storage on the user's device
    await secureStorage.write(key: Strings.mnenomics, value: mnemonic);

    /// Generate a standard wallet address that can be used on various
    /// Wallet app such as Phantom e.t.c.
    final wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonic),
      hdPath: Strings.derivativePath,
    );

    /// return wallets public key for display
    return wallet.address;
  }

  @override
  Future<String> restoreAWallet(String mnenomics) async {
    final noOfMnenomics = mnenomics.split(' ').toList();

    if (noOfMnenomics.length != 12 || noOfMnenomics.length != 24) {
      throw Exception('Invalid Mnenomics');
    }

    /// Save correct Mnenomics to a secure storage on User's device
    await secureStorage.write(key: Strings.mnenomics, value: mnenomics);

    final wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnenomics),
      hdPath: Strings.derivativePath,
    );

    /// Display the public address of user's wallet
    return wallet.address;
  }

  @override
  Future<String> walletAddress() async {
    final mnenomics = await secureStorage.read(key: Strings.mnenomics);

    /// Ensure there's a Mnenomic to read so that the correct wallet can be gotten
    if (mnenomics != null) {
      final wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: mnemonicToSeed(mnenomics),
        hdPath: Strings.derivativePath,
      );

      return wallet.address;
    }

    throw Exception('No wallet found');
  }

  @override
  Future<String> showMnenomics() async {
    final mnenomics = await secureStorage.read(key: Strings.mnenomics);

    if (mnenomics != null) {
      return mnenomics;
    }

    throw Exception('Oops! Nothing here');
  }
}
