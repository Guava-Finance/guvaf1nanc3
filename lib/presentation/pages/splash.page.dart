import 'package:flutter/material.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:pubnub/pubnub.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            DojahKYC? dojahKYC;

            /// Use your appId and publicKey
            dojahKYC = DojahKYC(
              appId: Env.dojahApiId,
              publicKey: Env.dojahPublicKey,
              type: 'custom',
              userData: {
                // add the user's wallet address here
                'user_id': '9FGvJ1odLGcjbfzZVvE514Grk6dAvnTLnYpWsNS4nAaa'
              },
              metaData: {
                // add the user's wallet address here
                'user_id': '9FGvJ1odLGcjbfzZVvE514Grk6dAvnTLnYpWsNS4nAaa',
              },
              config: {
                'widget_id': Env.dojahWidgetId,
              },
            );

            dojahKYC.open(
              context,
              onSuccess: (result) {
                AppLogger.log(result);
                context.nav.pop();
              },
              onClose: (close) {
                AppLogger.log(close);
              },
              onError: (error) {
                AppLogger.log(error);
              },
            );
          },
          child: const Text('Launch Dojah.io KYC'),
        ),
      ),
    );
  }

}
