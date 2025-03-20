import 'package:guava/core/resources/env/env.dart';
import 'package:injectable/injectable.dart';
import 'package:pubnub/pubnub.dart';

@lazySingleton
class PubSubService {
  final String walletAddress;

  PubSubService({
    required this.walletAddress,
  }) {
    _init();
  }

  late final PubNub _pubNub;

  bool _isPubNubInitialized = false;

  Stream<bool> get isConnected => _pubNub.signals.networkIsConnected;
  Stream<void> get networkDown => _pubNub.signals.networkIsDown;
  Stream<void> get networkUp => _pubNub.signals.networkIsUp;

  void _init() {
    if (!_isPubNubInitialized) {
      _pubNub = PubNub(
        defaultKeyset: Keyset(
          subscribeKey: Env.pubNubSubscribeKey,
          publishKey: Env.pubNubPublishKey,
          userId: UserId(walletAddress),
        ),
        crypto: CryptoModule.aesCbcCryptoModule(
          CipherKey.fromUtf8(Env.aesEncryptionKey),
        ),
      );

      _isPubNubInitialized = true;
    }

    _listenForReconnection();
  }

  bool _isNetworkDown = false;

  void _listenForReconnection() {
    isConnected.listen((e) {
      if (!e) _pubNub.reconnect();
    });

    networkDown.listen((_) {
      _isNetworkDown = true;
    });

    networkUp.listen((_) {
      if (_isNetworkDown) {
        if (!_isPubNubInitialized) _init();

        _pubNub.reconnect();
        _isNetworkDown = false;
      }
    });
  }

  Future<bool> publishMessage({
    required String channel,
    required dynamic message,
    bool storeMessage = false,
    Map<String, dynamic>? metaData,
  }) async {
    final result = await _pubNub.publish(
      channel,
      message,
      storeMessage: storeMessage,
      meta: metaData,
    );

    return result.isError;
  }

  Stream<dynamic> subscribeToChannels(Set<String> channels) {
    try {
      final subscription = _pubNub.subscribe(channels: channels);

      return subscription.messages.map<dynamic>((message) => message.payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unsubscribeAllChannels() async {
    try {
      return await _pubNub.unsubscribeAll();
    } catch (e) {
      rethrow;
    }
  }
}
