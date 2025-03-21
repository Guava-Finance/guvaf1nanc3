import 'package:bip39/bip39.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

import 'storage.dart';

@lazySingleton
class SolanaService {
  SolanaService({
    required this.rpcClient,
    required this.storageService,
    required this.networkInterceptor,
  });

  final RpcClient rpcClient;
  final SecuredStorageService storageService;
  final NetworkInterceptor networkInterceptor;

  /// Using [bip39] either 12 or 24 secret phrases is generated
  /// The secret phrase i.e. [mnemonics] would be kept
  /// securely within the device
  Future<String> createANewWallet({int walletStrength = 256}) async {
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
      hdPath: Strings.derivativePath,
    );

    /// return wallets public key for display
    return wallet.address;
  }

  /// The [mnemonics] is reversed to generate the wallet private key
  /// This mnemonics should be kept securely to avoid lost of money
  /// And it should be kept locally within the
  /// user's device to ensure decentralization
  Future<String> restoreAWallet(String mnemonics) async {
    final List<String> noOfMnemonics = mnemonics.split(' ').toList();

    if (noOfMnemonics.length != 12 || noOfMnemonics.length != 24) {
      throw Exception('Invalid mnemonics');
    }

    /// Save correct mnemonics to a secure storage on User's device
    await storageService.writeToStorage(
      key: Strings.mnemonics,
      value: mnemonics,
    );

    final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: mnemonicToSeed(mnemonics),
      hdPath: Strings.derivativePath,
    );

    /// Display the public address of user's wallet
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
    final accountInfo = await rpcClient.getAccountInfo(address.toBase58());

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
    final wallet = await _getWallet();

    final usdcMint = Ed25519HDPublicKey.fromBase58(
      Strings.usdcMintTokenAddress,
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

  /// This sends the wallet's public address so that the system can credit it
  /// with enough SOL to cover for gas fee for the month
  /// Wallet would always be pre-funded
  Future prefund() {
    throw UnimplementedError();
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
    final Ed25519HDKeyPair wallet = await _getWallet();

    final Ed25519HDPublicKey senderUSDCWallet =
        await findAssociatedTokenAddress(
      owner: wallet.publicKey,
      mint: Ed25519HDPublicKey.fromBase58(Strings.usdcMintTokenAddress),
    );

    final Ed25519HDPublicKey recipientUSDCWallet =
        await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(receiverAddress),
      mint: Ed25519HDPublicKey.fromBase58(Strings.usdcMintTokenAddress),
    );

    final Ed25519HDPublicKey companyUSDCWallet =
        await findAssociatedTokenAddress(
      // todo: fetch companies wallet from Config
      owner: Ed25519HDPublicKey.fromBase58(''),
      mint: Ed25519HDPublicKey.fromBase58(Strings.usdcMintTokenAddress),
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

  Future<Ed25519HDKeyPair> _getWallet() async {
    final String? mnemonics = await storageService.readFromStorage(
      Strings.mnemonics,
    );

    if (mnemonics != null) {
      final Ed25519HDKeyPair wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: mnemonicToSeed(mnemonics),
        hdPath: Strings.derivativePath,
      );

      return wallet;
    }

    throw Exception('No Wallet found');
  }

  Future<Ed25519HDPublicKey> _getTokenAddress() async {
    final Ed25519HDKeyPair wallet = await _getWallet();

    final Ed25519HDPublicKey usdcMint = Ed25519HDPublicKey.fromBase58(
      Strings.usdcMintTokenAddress,
    );

    /// This get the associated wallet address for that token mint
    final Ed25519HDPublicKey address = await findAssociatedTokenAddress(
      owner: wallet.publicKey,
      mint: usdcMint,
    );

    return address;
  }
}
