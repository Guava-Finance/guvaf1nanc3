// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:convert/convert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/encrypt.dart';
import 'package:guava/features/home/data/models/spl_token.dart';
import 'package:guava/features/home/data/models/token_account.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/transfer/data/models/params/solana_pay.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
// import 'package:solana/encoder.dart';
import 'package:solana/encoder.dart' as encoder;
import 'package:solana_web3/programs.dart' as web3Program;
import 'package:solana/solana.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

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
    ref: ref,
  );
});

final class SolanaService {
  SolanaService({
    required this.rpcClient,
    required this.storageService,
    required this.networkInterceptor,
    required this.configService,
    required this.ref,
  });

  final RpcClient rpcClient;
  final SecuredStorageService storageService;
  final NetworkInterceptor networkInterceptor;
  final ConfigService configService;
  final Ref ref;

  Future<TokenAccount> getSolBalanceAsTokenAccount() async {
    final wallet = await _getWallet();

    final lamports = await rpcClient.getBalance(wallet.address);
    const solDecimals = 9;

    final solToken = SplToken(
      chainId: 101,
      address: 'So11111111111111111111111111111111111111112',
      symbol: 'SOL',
      name: 'Solana',
      decimals: solDecimals,
      logoURI:
          'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/solana/info/logo.png',
      tags: ['native'],
      extensions: {},
    );

    return TokenAccount(
      mint: solToken.address,
      owner: wallet.address,
      amount: (lamports.value / pow(10, solDecimals)),
      splToken: solToken,
    );
  }

  Future<List<TokenAccount>> allAssets() async {
    final wallet = await _getWallet();

    final result = await rpcClient.getTokenAccountsByOwner(
      wallet.address,
      TokenAccountsFilter.byProgramId(
        'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
      ),
      encoding: Encoding.base64,
    );

    return result.value
        .map((e) =>
            _decodeTokenAccount((e.account.data?.toJson() as List).first))
        .toList();
  }

  TokenAccount _decodeTokenAccount(String base64Data) {
    final data = base64.decode(base64Data);

    final mint = data.sublist(0, 32);
    final owner = data.sublist(32, 64);
    final amountBytes = data.sublist(64, 72);

    final amount =
        ByteData.sublistView(amountBytes).getUint64(0, Endian.little);

    final mintStr = base58encode(mint);
    final ownerStr = base58encode(owner);

    final splToken = ref.read(splTokenAccounts)[mintStr];

    double readableAmount = amount.toDouble();

    if (splToken != null) {
      readableAmount = amount / pow(10, splToken.decimals);
    } else {
      readableAmount = amount / lamportsPerSol;
    }

    return TokenAccount(
      mint: mintStr,
      owner: ownerStr,
      amount: readableAmount,
      splToken: splToken,
    );
  }

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

  Future<bool> doesSPLTokenAccountExist() async {
    try {
      // Get the associated token account address for this mint and owner
      final address = await _getTokenAddress();

      // Fetch the token account info
      final accountInfo = await rpcClient.getAccountInfo(
        address.toBase58(),
        encoding: Encoding.jsonParsed, // Use jsonParsed for structured data
      );

      // Check if the account exists and is initialized
      if (accountInfo.value != null) {
        // For additional safety, verify it's an SPL token account with correct programs
        final accountProgram = accountInfo.value?.owner;

        return accountProgram != null;
      }

      return false;
    } catch (e) {
      // Depending on your error handling strategy:
      // Option 1: Return false on any error (account lookup failed)
      return false;
      // Option 2: Rethrow for upstream handling
      // rethrow;
    }
  }

  /// This method sets up SPLToken account for Solana Wallet
  /// Newly created wallet would be pre-funded by the system to enable
  /// wallet create the USDC SPL Token account on the blockchain
  /// ANd it return the transactionId after creating
  Future<String> enableUSDCForWallet([String? mintAddress]) async {
    final config = await configService.getConfig();
    final wallet = await _getWallet();

    final usdcMint = Ed25519HDPublicKey.fromBase58(
      mintAddress ?? config!.walletSettings.usdcMintAddress,
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

  Future<String?> checkAndEnableATAForWallet(String walletAddress) async {
    try {
      final config = await configService.getConfig();
      final wallet = await _getWallet();

      // Use provided mint address or default to USDC mint
      final tokenMint = Ed25519HDPublicKey.fromBase58(
        config!.walletSettings.usdcMintAddress,
      );

      // Get the associated token account address for this mint and owner
      final ataAddress = await findAssociatedTokenAddress(
        owner: Ed25519HDPublicKey.fromBase58(walletAddress),
        mint: tokenMint,
      );

      // Check if the token account exists
      final accountInfo = await rpcClient.getAccountInfo(
        ataAddress.toBase58(),
        encoding: Encoding.base64,
      );

      // If account doesn't exist, create it
      if (accountInfo.value == null) {
        final instruction = AssociatedTokenAccountInstruction.createAccount(
          funder: wallet.publicKey,
          address: ataAddress,
          owner: Ed25519HDPublicKey.fromBase58(walletAddress),
          mint: tokenMint,
        );

        // Sign and send the transaction
        final transactionId = await rpcClient.signAndSendTransaction(
          Message.only(instruction),
          [wallet],
        );

        return transactionId;
      }

      // If account exists, return null
      return null;
    } catch (e) {
      AppLogger.log('Error in checkAndEnableATAForWallet: $e');
      rethrow;
    }
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
        await rpcClient.getTokenAccountBalance(tokenAddress.toBase58());

    return tokenBalance.value;
  }

  /// The amount would be converted to [lamport] the unit of measurement
  /// on solana
  /// And the transaction would be signed locally using the user's
  /// private key securely kept on the device.
  Future<dynamic> transferUSDC({
    required double amount,
    required String receiverAddress,
    double? transactionFee,
    String? narration,
  }) async {
    final config = await configService.getConfig();

    SplToken? splToken;

    if (ref
        .read(splTokenAccounts)
        .containsKey(config?.walletSettings.usdcMintAddress)) {
      splToken =
          ref.read(splTokenAccounts)[config?.walletSettings.usdcMintAddress];
    }

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

    final Ed25519HDPublicKey companyFeeUSDCWallet =
        await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(
        config.companySettings.companFeeyWalletAddress,
      ),
      mint: Ed25519HDPublicKey.fromBase58(
        config.walletSettings.usdcMintAddress,
      ),
    );

    // Convert to solana_web3 types
    final web3SenderATA = web3.Pubkey.fromBase58(senderUSDCWallet.toBase58());
    final web3RecipientATA =
        web3.Pubkey.fromBase58(recipientUSDCWallet.toBase58());
    final web3CompanyATA =
        web3.Pubkey.fromBase58(companyFeeUSDCWallet.toBase58());
    final web3WalletPubkey =
        web3.Pubkey.fromBase58(wallet.publicKey.toBase58());

    // Create transfer instruction
    final transferAmount = config.isMainnet
        ? splToken == null
            ? (amount * 1e6).toInt()
            : (pow(10, splToken.decimals) * amount).toInt()
        : (amount * lamportsPerSol).toInt();

    final connection = web3.Connection(web3.Cluster.mainnet);
    final blockhash = await connection.getLatestBlockhash();

    List<web3.TransactionInstruction> instructions = [];

    instructions.add(web3Program.TokenProgram.transfer(
      amount: BigInt.from(transferAmount),
      source: web3SenderATA,
      destination: web3RecipientATA,
      owner: web3WalletPubkey,
    ));

    // Add fee transfer if present
    if (transactionFee != null) {
      final feeAmount = config.isMainnet
          ? splToken == null
              ? (transactionFee * 1e6).toInt()
              : (pow(10, splToken.decimals) * transactionFee).toInt()
          : (transactionFee * lamportsPerSol).toInt();

      instructions.add(
        web3Program.TokenProgram.transfer(
          amount: BigInt.from(feeAmount),
          source: web3SenderATA,
          destination: web3CompanyATA,
          owner: web3WalletPubkey,
        ),
      );
    }

    // Add memo if present
    if (narration != null) {
      instructions.add(
        web3Program.MemoProgram.create(narration),
      );
    }

    // Create transaction v0 with the wallet as fee payer
    final transaction = web3.Transaction.v0(
      payer: web3WalletPubkey, // Use wallet as fee payer
      instructions: instructions,
      recentBlockhash: blockhash.blockhash,
    );

    // Sign the transaction using the wallet
    final signedTx = await wallet.sign(transaction.serialize().toList());

    // Return the transaction data for the relayer
    return {
      'tx': signedTx.toBase58(),
      'address': web3WalletPubkey.toBase58(),
    };
  }

  Future<String> walletSignature() async {
    final wallet = await _getWallet();
    // Message to sign (usually a challenge from your backend)
    String message =
        'Please sign this message to authenticate: ${DateTime.now().millisecondsSinceEpoch}';

// Convert message to bytes
    Uint8List messageBytes = Uint8List.fromList(utf8.encode(message));

// Sign the message
    final signature = await wallet.sign(messageBytes);

    return signature.toBase58();
  }

  Future<encoder.Instruction> _getGuavaWatermark() async {
    final wallet = await _getWallet();
    final myAccountData = await storageService.readFromStorage(
      Strings.myAccount,
    );

    final myAccount = AccountModel.fromJson(jsonDecode(myAccountData!));
    final crypt = ref.read(encryptionServiceProvider);

    return MemoInstruction(
      memo: crypt.encryptData(
        '''Powered by Guava: ${myAccount.deviceInfo['loc']} ${myAccount.deviceInfo['identifierForVendor'] ?? ''}''',
      ),
      signers: <Ed25519HDPublicKey>[wallet.publicKey],
    );
  }

  bool isMnemonicValid(String mnemonic) {
    return validateMnemonic(mnemonic);
  }

  bool isValidAddress(String address) {
    try {
      // Attempt to create a PublicKey from the address string
      // This will throw an exception if the address is invalid
      Ed25519HDPublicKey.fromBase58(address);
      return true;
    } catch (e) {
      // If an exception occurs, the address is invalid
      return false;
    }
  }

  Future<void> destroyMyWaller() async {
    final wallet = await _getWallet();

    return wallet.destroy();
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

  Future<String> solanaPay(SolanaPayUrl solanaPayUrl) async {
    final wallet = await _getWallet();

    List<encoder.Instruction> instructions = [];

    // Process memo if it exists - needs to be added before transfer instruction
    if (solanaPayUrl.memo != null) {
      instructions.add(
        encoder.Instruction(
          programId: Ed25519HDPublicKey.fromBase58(
            'MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr',
          ),
          accounts: [],
          data: encoder.ByteArray(utf8.encode(solanaPayUrl.memo!)),
        ),
      );
    }

    // Add transfer instructions based on SPL token or native SOL
    if (solanaPayUrl.splToken == null) {
      instructions.addAll(await _isSolanaPayNative(solanaPayUrl));
    } else {
      instructions.addAll(await _isSolanaPaySpl(solanaPayUrl));
    }

    return await rpcClient.signAndSendTransaction(
      Message(instructions: instructions),
      [wallet],
    );
  }

  Future<List<encoder.Instruction>> _isSolanaPayNative(
    SolanaPayUrl payUrl,
  ) async {
    final wallet = await walletAddress();
    final config = await configService.getConfig();

    // Create the base transfer instruction
    final transferInstruction = SystemInstruction.transfer(
      fundingAccount: Ed25519HDPublicKey.fromBase58(wallet),
      recipientAccount: Ed25519HDPublicKey.fromBase58(payUrl.recipient),
      lamports: (double.parse(payUrl.amount!) * lamportsPerSol).toInt(),
    );

    // Add reference accounts if present
    if (payUrl.reference != null && payUrl.reference!.isNotEmpty) {
      // Split multiple references if present (comma-separated)
      final List<String> references = payUrl.reference!.split(',');

      // Add each reference as a read-only, non-signer account
      for (final ref in references) {
        final trimmedRef = ref.trim();
        if (trimmedRef.isNotEmpty) {
          try {
            final refPubKey = Ed25519HDPublicKey.fromBase58(trimmedRef);
            transferInstruction.accounts.add(
              encoder.AccountMeta(
                pubKey: refPubKey,
                isWriteable: false,
                isSigner: false,
              ),
            );
          } catch (e) {
            AppLogger.log('Invalid reference key: $trimmedRef - $e');
          }
        }
      }
    }

    final instructions = [transferInstruction];

    // Add fee transfer if present
    if (payUrl.fee != null) {
      instructions.add(
        SystemInstruction.transfer(
          fundingAccount: Ed25519HDPublicKey.fromBase58(wallet),
          recipientAccount: Ed25519HDPublicKey.fromBase58(
            config!.companySettings.companyWalletAddress,
          ),
          lamports: (double.parse(payUrl.fee!) * lamportsPerSol).toInt(),
        ),
      );
    }

    return instructions;
  }

  Future<List<encoder.Instruction>> _isSolanaPaySpl(SolanaPayUrl payUrl) async {
    final wallet = await walletAddress();
    final config = await configService.getConfig();
    final walletPubKey = Ed25519HDPublicKey.fromBase58(wallet);
    final tokenMintPubKey = Ed25519HDPublicKey.fromBase58(payUrl.splToken!);
    final recipientPubKey = Ed25519HDPublicKey.fromBase58(payUrl.recipient);

    final senderATA = await findAssociatedTokenAddress(
      owner: walletPubKey,
      mint: tokenMintPubKey,
    );

    final receiverATA = await findAssociatedTokenAddress(
      owner: recipientPubKey,
      mint: tokenMintPubKey,
    );

    if (!(await doesSPLTokenAccountExist())) {
      // In case the company doesn't have the SPLToken account
      // create it
      await enableUSDCForWallet(payUrl.splToken!);
    }

    // Create the base transfer instruction
    final transferInstruction = TokenInstruction.transfer(
      amount: (double.parse(payUrl.amount!) * lamportsPerSol).toInt(),
      source: senderATA,
      destination: receiverATA,
      owner: walletPubKey,
    );

    // Add reference accounts if present
    if (payUrl.reference != null && payUrl.reference!.isNotEmpty) {
      // Split multiple references if present (comma-separated)
      final List<String> references = payUrl.reference!.split(',');

      // Add each reference as a read-only, non-signer account
      for (final ref in references) {
        final trimmedRef = ref.trim();
        if (trimmedRef.isNotEmpty) {
          try {
            final refPubKey = Ed25519HDPublicKey.fromBase58(trimmedRef);
            transferInstruction.accounts.add(
              encoder.AccountMeta(
                pubKey: refPubKey,
                isWriteable: false,
                isSigner: false,
              ),
            );
          } catch (e) {
            AppLogger.log('Invalid reference key: $trimmedRef - $e');
          }
        }
      }
    }

    final instructions = [transferInstruction];

    // Add fee transfer if present
    if (payUrl.fee != null) {
      final companyATA = await findAssociatedTokenAddress(
        owner: Ed25519HDPublicKey.fromBase58(
          config!.companySettings.companyWalletAddress,
        ),
        mint: tokenMintPubKey,
      );

      instructions.add(
        TokenInstruction.transfer(
          amount: (double.parse(payUrl.fee!) * lamportsPerSol).toInt(),
          source: senderATA,
          destination: companyATA,
          owner: walletPubKey,
        ),
      );
    }

    return instructions;
  }
}
