import 'dart:js' as js;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:solana/solana.dart';

/// Enum for wallet connection status
enum WalletConnectionStatus { disconnected, connecting, connected, error }

class WalletConnectionService extends StateNotifier<WalletConnectionStatus> {
  WalletConnectionService() : super(WalletConnectionStatus.disconnected);

  Ed25519HDPublicKey? _publicKey;
  String? _error;

  Ed25519HDPublicKey? get publicKey => _publicKey;
  String? get error => _error;

  /// Call this to initiate wallet connection
  Future<void> connect() async {
    state = WalletConnectionStatus.connecting;
    _error = null;
    try {
      // Check if Phantom is installed
      if (js.context.hasProperty('solana')) {
        final phantom = js.context['solana'];
        if (phantom != null) {
          // Request connection
          final response = await js.context['solana'].callMethod('connect');
          final pubKey = response['publicKey'].toString();

          AppLogger.log(pubKey);

          _publicKey = Ed25519HDPublicKey.fromBase58(pubKey);
          state = WalletConnectionStatus.connected;
          return;
        }
      }
      throw Exception(
          'Phantom wallet not found. Please install Phantom wallet.');
    } catch (e) {
      _error = e.toString();
      state = WalletConnectionStatus.error;
    }
  }

  void disconnect() {
    if (js.context.hasProperty('solana')) {
      js.context['solana'].callMethod('disconnect');
    }
    _publicKey = null;
    state = WalletConnectionStatus.disconnected;
  }

  /// Sign a transaction
  Future<String> signTransaction(String transaction) async {
    if (_publicKey == null) {
      throw Exception('No wallet connected');
    }

    try {
      final response =
          await js.context['solana'].callMethod('signTransaction', [
        js.JsObject.jsify({
          'transaction': transaction,
        })
      ]);
      return response.toString();
    } catch (e) {
      throw Exception('Failed to sign transaction: ${e.toString()}');
    }
  }
}

/// Provider for the WalletConnectionService
final walletConnectionProvider =
    StateNotifierProvider<WalletConnectionService, WalletConnectionStatus>(
  (ref) => WalletConnectionService(),
);

/// Provider for the connected public key
final connectedWalletPublicKeyProvider = Provider<Ed25519HDPublicKey?>((ref) {
  final service = ref.watch(walletConnectionProvider.notifier);
  return service.publicKey;
});

/// Provider for the connection error (if any)
final walletConnectionErrorProvider = Provider<String?>((ref) {
  final service = ref.watch(walletConnectionProvider.notifier);
  return service.error;
});
