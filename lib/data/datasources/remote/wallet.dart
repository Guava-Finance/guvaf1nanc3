import 'package:bip39/bip39.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

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
  /// ANd it return the transactionId after creating
  Future<String> enableUSDCForWallet();

  /// The splToken address is passed and the balance is gotten from
  /// Solana blockchain via RPC network call
  Future<TokenAmount> checkBalance();

  /// The amount would be converted to [lamport] the unit of measurement
  /// on solana
  /// And the transaction would be signed locally using the user's
  /// private key securely kept on the device.
  Future<dynamic> transferUSDC({
    required double amount,
    required String receiverAddress,
    String? narration,
  });

  /// The user's Sol balance is checked to know if it can cover the gas fee
  /// else the user would be pre-funded before proceed to send the transaction.
  /// The amount would be converted to [lamport] to unit of measurement for solana ///
  Future<bool> isGasFeeSufficient({int noOfSignatures = 1});

  /// This sends the wallet's public address so that the system can credit it
  /// with enough SOL to cover for gas fee for the month
  /// Wallet would always be pre-funded
  Future<dynamic> prefund();
}

@LazySingleton(as: RemoteWalletFunctions)
class RemoteWalletFunctionsImpl extends RemoteWalletFunctions {
  RemoteWalletFunctionsImpl({
    required this.rpcClient,
    required this.secureStorage,
    required this.networkInterceptor,
  });

  final RpcClient rpcClient;
  final FlutterSecureStorage secureStorage;
  final NetworkInterceptor networkInterceptor;

  @override
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

  @override
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
      onSigned: (signature) {
        AppLogger.log(signature);
      },
    );

    return transactionId;
  }

  @override
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

  @override
  Future prefund() {
    throw UnimplementedError();
  }

  @override
  Future<TokenAmount> checkBalance() async {
    final Ed25519HDPublicKey tokenAddress = await _getTokenAddress();

    final TokenAmountResult tokenBalance =
        await rpcClient.getTokenAccountBalance(
      tokenAddress.toBase58(),
    );

    return tokenBalance.value;
  }

  @override
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
    final String? mnemonics = await secureStorage.read(key: Strings.mnemonics);

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
