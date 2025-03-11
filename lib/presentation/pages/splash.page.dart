import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:metamap_plugin_flutter/metamap_plugin_flutter.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            MetaMapFlutter.showMetaMapFlow(
              clientId: "YOUR_CLIENT_ID",
              flowId: "YOUR_FLOW_ID",
            );
            MetaMapFlutter.resultCompleter.future.then((result) {
              AppLogger.log(result);
            });
          },
          child: const Text('Launch Metamap'),
        ),
      ),
    );
  }
}
