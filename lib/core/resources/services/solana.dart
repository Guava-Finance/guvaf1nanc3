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
import 'package:solana/solana.dart';

import 'storage.dart';

final rpcClientProvider = Provider<RpcClient>((ref) {
  return RpcClient(Env.rpcClient);
});

final solanaServiceProvider = Provider<SolanaService>((ref) {
  return SolanaService(
    rpcClient: ref.watch(rpcClientProvider),
    networkInterceptor: ref.watch(networkInterceptorProvider),
    configService: ref.watch(configServiceProvider),
    ref: ref,
  );
});

class SolanaService {
  SolanaService({
    required this.rpcClient,
    required this.networkInterceptor,
    required this.configService,
    required this.ref,
  });

  final RpcClient rpcClient;
  final NetworkInterceptor networkInterceptor;
  final ConfigService configService;
  final Ref ref;

  // Store the connected wallet's public key
  Ed25519HDPublicKey? _connectedWallet;

  // Connect to external wallet
  Future<void> connectWallet(Ed25519HDPublicKey publicKey) async {
    _connectedWallet = publicKey;
  }

  // Disconnect from external wallet
  Future<void> disconnectWallet() async {
    _connectedWallet = null;
  }

  // Get connected wallet address
  Future<String> walletAddress() async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }
    return _connectedWallet!.toBase58();
  }

  Future<TokenAccount> getSolBalanceAsTokenAccount() async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final lamports = await rpcClient.getBalance(_connectedWallet!.toBase58());
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
      owner: _connectedWallet!.toBase58(),
      amount: (lamports.value / pow(10, solDecimals)),
      splToken: solToken,
    );
  }

  Future<List<TokenAccount>> allAssets() async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final result = await rpcClient.getTokenAccountsByOwner(
      _connectedWallet!.toBase58(),
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

  Future<bool> doesSPLTokenAccountExist() async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    try {
      final address = await _getTokenAddress();

      final accountInfo = await rpcClient.getAccountInfo(
        address.toBase58(),
        encoding: Encoding.jsonParsed,
      );

      if (accountInfo.value != null) {
        final accountProgram = accountInfo.value?.owner;
        return accountProgram != null;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> enableUSDCForWallet([String? mintAddress]) async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final config = await configService.getConfig();

    final usdcMint = Ed25519HDPublicKey.fromBase58(
      mintAddress ?? config!.walletSettings.usdcMintAddress,
    );

    final address = await findAssociatedTokenAddress(
      owner: _connectedWallet!,
      mint: usdcMint,
    );

    final instruction = AssociatedTokenAccountInstruction.createAccount(
      funder: _connectedWallet!,
      address: address,
      owner: _connectedWallet!,
      mint: usdcMint,
    );

    // For dApp, we return the transaction for the wallet to sign
    final message = Message.only(instruction);
    final recentBlockhash =
        (await rpcClient.getLatestBlockhash()).value.blockhash;
    final compiled = message.compile(
        recentBlockhash: recentBlockhash, feePayer: _connectedWallet!);
    return base58encode(compiled.toByteArray().toList());
  }

  Future<String> transferUSDC({
    required double amount,
    required String receiverAddress,
    double? transactionFee,
    String? narration,
  }) async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final config = await configService.getConfig();

    final senderUSDCWallet = await findAssociatedTokenAddress(
      owner: _connectedWallet!,
      mint: Ed25519HDPublicKey.fromBase58(
        config!.walletSettings.usdcMintAddress,
      ),
    );

    final recipientUSDCWallet = await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(receiverAddress),
      mint: Ed25519HDPublicKey.fromBase58(
        config.walletSettings.usdcMintAddress,
      ),
    );

    final companyUSDCWallet = await findAssociatedTokenAddress(
      owner: Ed25519HDPublicKey.fromBase58(
        config.companySettings.companyWalletAddress,
      ),
      mint: Ed25519HDPublicKey.fromBase58(
        config.walletSettings.usdcMintAddress,
      ),
    );

    List<encoder.Instruction> instructions = [];

    // Add memo if provided
    if (narration != null) {
      instructions.add(
        MemoInstruction(
          memo: narration,
          signers: <Ed25519HDPublicKey>[_connectedWallet!],
        ),
      );
    }

    // Add transfer instruction
    instructions.add(
      TokenInstruction.transfer(
        amount: (amount * lamportsPerSol).toInt(),
        source: senderUSDCWallet,
        destination: recipientUSDCWallet,
        owner: _connectedWallet!,
      ),
    );

    // Add fee transfer if provided
    if (transactionFee != null) {
      instructions.add(
        TokenInstruction.transfer(
          amount: (transactionFee * lamportsPerSol).toInt(),
          source: senderUSDCWallet,
          destination: companyUSDCWallet,
          owner: _connectedWallet!,
        ),
      );
    }

    // Create and serialize the message
    final message = Message(instructions: instructions);
    final recentBlockhash =
        (await rpcClient.getLatestBlockhash()).value.blockhash;
    final compiled = message.compile(
        recentBlockhash: recentBlockhash, feePayer: _connectedWallet!);
    return base58encode(compiled.toByteArray().toList());
  }

  Future<Ed25519HDPublicKey> _getTokenAddress() async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final config = await configService.getConfig();

    final usdcMint = Ed25519HDPublicKey.fromBase58(
      config!.walletSettings.usdcMintAddress,
    );

    return findAssociatedTokenAddress(
      owner: _connectedWallet!,
      mint: usdcMint,
    );
  }

  Future<String> solanaPay(SolanaPayUrl solanaPayUrl) async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    List<encoder.Instruction> instructions = [];

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

    if (solanaPayUrl.splToken == null) {
      instructions.addAll(await _isSolanaPayNative(solanaPayUrl));
    } else {
      instructions.addAll(await _isSolanaPaySpl(solanaPayUrl));
    }

    final message = Message(instructions: instructions);
    final recentBlockhash =
        (await rpcClient.getLatestBlockhash()).value.blockhash;
    final compiled = message.compile(
        recentBlockhash: recentBlockhash, feePayer: _connectedWallet!);
    return base58encode(compiled.toByteArray().toList());
  }

  Future<List<encoder.Instruction>> _isSolanaPayNative(
    SolanaPayUrl payUrl,
  ) async {
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final config = await configService.getConfig();

    final transferInstruction = SystemInstruction.transfer(
      fundingAccount: _connectedWallet!,
      recipientAccount: Ed25519HDPublicKey.fromBase58(payUrl.recipient),
      lamports: (double.parse(payUrl.amount!) * lamportsPerSol).toInt(),
    );

    if (payUrl.reference != null && payUrl.reference!.isNotEmpty) {
      final List<String> references = payUrl.reference!.split(',');

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

    if (payUrl.fee != null) {
      instructions.add(
        SystemInstruction.transfer(
          fundingAccount: _connectedWallet!,
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
    if (_connectedWallet == null) {
      throw Exception('No wallet connected');
    }

    final config = await configService.getConfig();
    final tokenMintPubKey = Ed25519HDPublicKey.fromBase58(payUrl.splToken!);
    final recipientPubKey = Ed25519HDPublicKey.fromBase58(payUrl.recipient);

    final senderATA = await findAssociatedTokenAddress(
      owner: _connectedWallet!,
      mint: tokenMintPubKey,
    );

    final receiverATA = await findAssociatedTokenAddress(
      owner: recipientPubKey,
      mint: tokenMintPubKey,
    );

    final transferInstruction = TokenInstruction.transfer(
      amount: (double.parse(payUrl.amount!) * lamportsPerSol).toInt(),
      source: senderATA,
      destination: receiverATA,
      owner: _connectedWallet!,
    );

    if (payUrl.reference != null && payUrl.reference!.isNotEmpty) {
      final List<String> references = payUrl.reference!.split(',');

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
          owner: _connectedWallet!,
        ),
      );
    }

    return instructions;
  }
}
