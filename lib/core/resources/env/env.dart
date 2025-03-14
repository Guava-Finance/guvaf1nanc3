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

  @EnviedField(varName: 'DOJAH_API_ID')
  static String dojahApiId = _Env.dojahApiId;

  @EnviedField(varName: 'DOJAH_PUBLIC_KEY')
  static String dojahPublicKey = _Env.dojahPublicKey;

  @EnviedField(varName: 'DOJAH_WIDGET_ID')
  static String dojahWidgetId = _Env.dojahWidgetId;
}
