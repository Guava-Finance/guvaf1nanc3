// ignore_for_file: lines_longer_than_80_chars

import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:convert/convert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

import 'storage.dart';

final rpcClientProvider = Provider<RpcClient>((ref) {
  return RpcClient(Env.rpcClient);
});

final solanaServiceProvider = Provider<SolanaService>((ref) {
  return SolanaService(
    rpcClient: ref.watch(rpcClientProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    networkInterceptor: ref.watch(networkInterceptorProvider),
    configService: ref.watch(configServiceProvider),
  );
});

final class SolanaService {
  SolanaService({
    required this.rpcClient,
    required this.storageService,
    required this.networkInterceptor,
    required this.configService,
  });

  final RpcClient rpcClient;
  final SecuredStorageService storageService;
  final NetworkInterceptor networkInterceptor;
  final ConfigService configService;

  /// Using [bip39] either 12 or 24 secret phrases is generated
  /// The secret phrase i.e. [mnemonics] would be kept
  /// securely within the device
  Future<String> createANewWallet({int walletStrength = 256}) async {
    final config = await configService.getConfig();

    /// [walletStrength = 128] generates 12 phrases secret words
    /// [walletStrength = 256] generates 24 phrases secret words
    final String mnemonic = generateMnemonic(strength: walletStrength);

    /// This saves the secret phrase to a secure storage on the user's device
    await storageService.writeToStorage(
      key: Strings.mnemonics,
      value: mnemonic,
    );
    /// Generate a standard wallet address that can be used on various
    /// Wallet app such as Phantom e.t.c.
    final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonic),
      hdPath: config!.walletSettings.derivativePath,
    );

    /// return wallets public key for display
    return wallet.address;
  }

  /// The [mnemonics] is reversed to generate the wallet private key
  /// This mnemonics should be kept securely to avoid lost of money
  /// And it should be kept locally within the
  /// user's device to ensure decentralization
  Future<String> restoreAWallet(String mnemonics) async {
    final config = await configService.getConfig();

    /// Save correct mnemonics to a secure storage on User's device
    await storageService.writeToStorage(
      key: Strings.mnemonics,
      value: mnemonics,
    );
    final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonics),
      hdPath: config!.walletSettings.derivativePath,
    );

    /// Display the public address of user's wallet
    return wallet.address;
  }

  /// The [privateKey] is reversed to generate the wallet private key
  /// This mnemonics should be kept securely to avoid lost of money
  /// And it should be kept locally within the
  /// user's device to ensure decentralization
  Future<String> restoreAWalletPK(String privateKey) async {
    // Validate the private key format
    if (!isValidPrivateKey(privateKey)) {
      throw FormatException('Invalid private key format');
    }

    // Process the private key (works for both hex and base58)
    final Uint8List seedBytes = processPrivateKey(privateKey);

    // Create the wallet using the private key
    final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: seedBytes,
    );

    await storageService.writeToStorage(
      key: Strings.privateKey,
      value: privateKey,
    );

    // Return the wallet's public address
    return wallet.address;
  }

  /// The [mnemonics] is gotten from secure storage and together with the
  /// derivative path the private public key pair is gotten
  Future<String> walletAddress() async {
    return (await _getWallet()).address;
  }

  /// Display mnemonics to user for backup
  Future<String> showMnemonics() async {
    final String? mnemonics = await storageService.readFromStorage(
      Strings.mnemonics,
    );

    if (mnemonics != null) {
      return mnemonics;
    }

    throw Exception('Oops! Nothing here');
  }

  /// This method check whether user has already created SPLToken account
  /// To avoid trying to recreate it
  /// SPLToken account is created only once
  Future<bool> doesSPLTokenAccountExist(String tokenMintAddress) async {
    final address = await _getTokenAddress();

    // Fetch the token account info
    final accountInfo = await rpcClient.getAccountInfo(
      address.toBase58(),
      encoding: Encoding.base64,
    );

    /// Check if the account exists and is initialized
    // todo: Cross check this implementation
    if (accountInfo.value != null && accountInfo.value?.data != null) {
      return true;
    } else {
      return false;
    }
  }

  /// This method sets up SPLToken account for Solana Wallet
  /// Newly created wallet would be pre-funded by the system to enable
  /// wallet create the USDC SPL Token account on the blockchain
  /// ANd it return the transactionId after creating
  Future<String> enableUSDCForWallet() async {
    final config = await configService.getConfig();
    final wallet = await _getWallet();

    final usdcMint = Ed25519HDPublicKey.fromBase58(
      config!.walletSettings.usdcMintAddress,
    );

    /// This get the associated wallet address for that token mint
    final address = await findAssociatedTokenAddress(
      owner: wallet.publicKey,
      mint: usdcMint,
    );

    /// The token SPL account creation instruction is created
    /// the token wallet is a non-custodian wallet meaning the user is the
    /// owner of all wallet account that's why transactions are signed locally
    final AssociatedTokenAccountInstruction instruction =
        AssociatedTokenAccountInstruction.createAccount(
      funder: wallet.publicKey,
      address: address,
      owner: wallet.publicKey,
      mint: usdcMint,
    );

    /// User signs and send transaction to block chain
    /// this activity cost over [0.00002 SOL] by estimation
    final String transactionId = await rpcClient.signAndSendTransaction(
      Message.only(instruction),
      [wallet],
    );

    return transactionId;
  }

  /// The user's Sol balance is checked to know if it can cover the gas fee
  /// else the user would be pre-funded before proceed to send the transaction.
  /// The amount would be converted to [lamport] to unit of measurement for solana ///
  Future<bool> isGasFeeSufficient({int noOfSignatures = 1}) async {
    try {
      final wallet = await _getWallet();

      /// Checks whether there's enough [sol] in the wallet to pay gas fee
      final walletBalance = await rpcClient.getBalance(wallet.address);

      /// [0.000005] is the standard gas fee for a Solana transaction
      /// gas fee is multiplied by no of signer for the transaction
      if (walletBalance.value >= (noOfSignatures * 0.000005)) {
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// The splToken address is passed and the balance is gotten from
  /// Solana blockchain via RPC network call
  Future<TokenAmount> checkBalance() async {
    final Ed25519HDPublicKey tokenAddress = await _getTokenAddress();

    final TokenAmountResult tokenBalance =
        await rpcClient.getTokenAccountBalance(
      tokenAddress.toBase58(),
    );

    return tokenBalance.value;
  }

  /// The amount would be converted to [lamport] the unit of measurement
  /// on solana
  /// And the transaction would be signed locally using the user's
  /// private key securely kept on the device.
  Future<String> transferUSDC({
    required double amount,
    required String receiverAddress,
    double? transactionFee,
    String? narration,
  }) async {
    final config = await configService.getConfig();

    final Ed25519HDKeyPair wallet = await _getWallet();

    final Ed25519HDPublicKey senderUSDCWallet =
        await findAssociatedTokenAddress(
      owner: wallet.publicKey,
      mint: Ed25519HDPublicKey.fromBase58(
        config!.walletSettings.usdcMintAddress,
      ),
    );

    final Ed25519HDPublicKey recipientUSDCWallet =
        await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(receiverAddress),
      mint: Ed25519HDPublicKey.fromBase58(
        config.walletSettings.usdcMintAddress,
      ),
    );

    final Ed25519HDPublicKey companyUSDCWallet =
        await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(
        config.companySettings.companyWalletAddress,
      ),
      mint: Ed25519HDPublicKey.fromBase58(
        config.walletSettings.usdcMintAddress,
      ),
    );

    // Transfer to Recipient
    final TokenInstruction instruction = TokenInstruction.transfer(
      amount: (amount * lamportsPerSol).toInt(),
      source: senderUSDCWallet,
      destination: recipientUSDCWallet,
      owner: wallet.publicKey,
    );

    late TokenInstruction txnFeeInstruction;

    if (transactionFee != null) {
      // Transfer to Companies wallet
      txnFeeInstruction = TokenInstruction.transfer(
        amount: (transactionFee * lamportsPerSol).toInt(),
        source: senderUSDCWallet,
        destination: companyUSDCWallet,
        owner: wallet.publicKey,
      );
    }

    final MemoInstruction memoInstruction = MemoInstruction(
      memo: narration ??
          'Transfer of $amount USDC on ${DateTime.now().toIso8601String()}',
      signers: <Ed25519HDPublicKey>[wallet.publicKey],
    );

    final Message message = Message(
      instructions: [
        instruction,
        if (transactionFee != null) txnFeeInstruction,
        memoInstruction,
      ],
    );

    /// Sign the message instructions and send the encode SignedTx
    /// to the backend for submission
    final SignedTx signedTx = await wallet.signMessage(
      message: message,
      recentBlockhash: (await rpcClient.getLatestBlockhash()).value.blockhash,
    );

    return signedTx.encode();
  }

  bool isMnemonicValid(String mnemonic) {
    return validateMnemonic(mnemonic);
  }

  Future<Ed25519HDKeyPair> _getWallet() async {
    final config = await configService.getConfig();

    // First, try to get wallet from mnemonics
    final String? mnemonics = await storageService.readFromStorage(
      Strings.mnemonics,
    );

    if (mnemonics != null && mnemonics.isNotEmpty) {
      final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: mnemonicToSeed(mnemonics),
        hdPath: config!.walletSettings.derivativePath,
      );
      return wallet;
    }

    // If no mnemonics, try to get wallet from private key
    final String? privateKey = await storageService.readFromStorage(
      Strings.privateKey,
    );

    if (privateKey != null && privateKey.isNotEmpty) {
      // Process the private key based on format (hex or base58)
      final Uint8List seedBytes = processPrivateKey(privateKey);

      // Create wallet from private key
      final Ed25519HDKeyPair wallet =
          await Ed25519HDKeyPair.fromPrivateKeyBytes(
        privateKey: seedBytes,
      );

      return wallet;
    }

    // If we get here, no wallet information was found
    throw Exception('No wallet found. Please create or import a wallet first.');
  }

  Future<Ed25519HDPublicKey> _getTokenAddress() async {
    final config = await configService.getConfig();

    final Ed25519HDKeyPair wallet = await _getWallet();

    final Ed25519HDPublicKey usdcMint = Ed25519HDPublicKey.fromBase58(
      config!.walletSettings.usdcMintAddress,
    );

    /// This get the associated wallet address for that token mint
    final Ed25519HDPublicKey address = await findAssociatedTokenAddress(
      owner: wallet.publicKey,
      mint: usdcMint,
    );

    return address;
  }

  /// Processes the private key into the format needed by Ed25519HDKeyPair
  Uint8List processPrivateKey(String privateKey) {
    // First, check if the private key is in hex format
    if (isHexFormat(privateKey)) {
      // Remove any '0x' prefix if present
      if (privateKey.toLowerCase().startsWith('0x')) {
        privateKey = privateKey.substring(2);
      }
      // Convert the hex string to bytes
      return Uint8List.fromList(hex.decode(privateKey));
    } else {
      // Assume it's base58 encoded
      return processBase58PrivateKey(privateKey);
    }
  }

  /// Checks if the private key is in hex format
  bool isHexFormat(String privateKey) {
    String sanitizedKey = privateKey;
    // Remove '0x' prefix if present
    if (privateKey.toLowerCase().startsWith('0x')) {
      sanitizedKey = privateKey.substring(2);
    }

    // Check if the string contains only hex characters
    final hexRegExp = RegExp(r'^[0-9a-fA-F]+$');
    return hexRegExp.hasMatch(sanitizedKey);
  }

  /// Processes a base58 encoded private key
  Uint8List processBase58PrivateKey(String privateKey) {
    // Decode base58 private key
    final List<int> decodedKey = base58decode(privateKey);

    // Ensure we have a 32-byte seed
    Uint8List seedBytes;

    if (decodedKey.length == 32) {
      seedBytes = Uint8List.fromList(decodedKey);
    } else if (decodedKey.length > 32) {
      // If longer than 32 bytes, take the first 32 bytes
      seedBytes = Uint8List.fromList(decodedKey.sublist(0, 32));
    } else {
      // If shorter than 32 bytes, pad with zeros
      seedBytes = Uint8List(32);
      for (int i = 0; i < decodedKey.length; i++) {
        seedBytes[32 - decodedKey.length + i] = decodedKey[i];
      }
    }

    return seedBytes;
  }

  /// Validates if the provided string is a valid private key
  bool isValidPrivateKey(String privateKey) {
    // For hex keys
    if (isHexFormat(privateKey)) {
      String sanitizedKey = privateKey;
      if (privateKey.toLowerCase().startsWith('0x')) {
        sanitizedKey = privateKey.substring(2);
      }

      // Check hex key length
      final length = sanitizedKey.length;
      return length >= 32 && length <= 128 && length % 2 == 0;
    } else {
      // For base58 keys, we'll do basic validation (non-empty)
      // A more rigorous check would be to try to decode and check length
      return privateKey.isNotEmpty;
    }
  }

  // String _newMnemonicFromPrivateKey(Uint8List privateKeyBytes) {
  //   // Note: This is a complex cryptographic operation that isn't truly reversible
  //   // We're creating a new mnemonic that, when used with path m/44'/501'/0'/0',
  //   // will hopefully result in a key that matches our original private key

  //   // For proper mnemonic generation, we need entropy that's a multiple of 32 bits
  //   // A standard BIP39 mnemonic uses either 128 or 256 bits of entropy

  //   // Create entropy from the private key bytes (ensuring it's 16 bytes/128 bits)
  //   final entropy = Uint8List(16);

  //   // Use as much of the private key as fits, up to 16 bytes
  //   final bytesToUse = min(privateKeyBytes.length, 16);
  //   for (int i = 0; i < bytesToUse; i++) {
  //     entropy[i] = privateKeyBytes[i];
  //   }

  //   // Convert entropy to hex string (required by entropyToMnemonic)
  //   final entropyHex = hex.encode(entropy);

  //   // Generate mnemonic from entropy
  //   return entropyToMnemonic(entropyHex);
  // }
}
