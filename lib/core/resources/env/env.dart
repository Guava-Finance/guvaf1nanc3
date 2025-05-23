import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(
  path: '.env',
  obfuscate: true,
)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'RPC_CLIENT')
  static String rpcClient = _Env.rpcClient;

  @EnviedField(varName: 'MIXPANEL_TOKEN')
  static String mixpanelToken = _Env.mixpanelToken;

  @EnviedField(varName: 'AES_ENCRYPTION_KEY')
  static String aesEncryptionKey = _Env.aesEncryptionKey;

  @EnviedField(varName: 'AES_ENCRYPTION_IV')
  static String aesEncryptionIv = _Env.aesEncryptionIv;

  @EnviedField(varName: 'DOJAH_API_ID')
  static String dojahApiId = _Env.dojahApiId;

  @EnviedField(varName: 'DOJAH_PUBLIC_KEY')
  static String dojahPublicKey = _Env.dojahPublicKey;

  @EnviedField(varName: 'DOJAH_WIDGET_ID')
  static String dojahWidgetId = _Env.dojahWidgetId;

  @EnviedField(varName: 'PUB_NUB_SUBCRIBE_KEY')
  static String pubNubSubscribeKey = _Env.pubNubSubscribeKey;

  @EnviedField(varName: 'PUB_NUB_PUBLISH_KEY')
  static String pubNubPublishKey = _Env.pubNubPublishKey;

  @EnviedField(varName: 'APP_ID')
  static String appId = _Env.appId;

  @EnviedField(varName: 'AMPLITUDE_API_KEY')
  static String amplitudeApiKey = _Env.amplitudeApiKey;

  @EnviedField(varName: 'SPL_TOKEN_URL')
  static String splTokenUrl = _Env.splTokenUrl;
}
