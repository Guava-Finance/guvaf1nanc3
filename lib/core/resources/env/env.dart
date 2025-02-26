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

  @EnviedField(varName: 'MIXPANEL')
  static String mixpanel = _Env.mixpanel;
}
