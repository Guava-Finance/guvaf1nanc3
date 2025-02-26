class EnvConfig {
  final String baseUrl;
  final String mixpanel;

  EnvConfig({
    required this.baseUrl,
    required this.mixpanel,
  });

  factory EnvConfig.fromEnvironment() {
    return EnvConfig(
      baseUrl: String.fromEnvironment(
        prefixEnvKey('BASE_URL'),
        defaultValue: 'https://',
      ),
      mixpanel: String.fromEnvironment(
        prefixEnvKey('MIXPANEL'),
        defaultValue: 'dev',
      ),
    );
  }

  static String prefixEnvKey(String data) {
    return 'GUAVA_FINANCE_$data';
  }
}
