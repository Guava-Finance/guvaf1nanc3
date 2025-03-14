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
              clientId: "robor.eminokanju@gmail.com",
              flowId: "67d1763ea42cc8175d533901",
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
