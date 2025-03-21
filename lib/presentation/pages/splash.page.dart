import 'package:flutter/material.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/services/liveliness.dart';
import 'package:guava/core/service_locator/injection_container.dart';
import 'package:pubnub/pubnub.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Launch Dojah.io KYC'),
        ),
      ),
    );
  }
}
