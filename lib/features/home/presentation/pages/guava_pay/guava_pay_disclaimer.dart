import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/services/encrypt.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';

class GuavaPayDisclaimer extends ConsumerStatefulWidget {
  const GuavaPayDisclaimer({
    this.encryptedData,
    super.key,
  });

  final String? encryptedData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GuavaPayDisclaimerState();
}

class _GuavaPayDisclaimerState extends ConsumerState<GuavaPayDisclaimer> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(firebaseAnalyticsProvider)
          .triggerScreenLogged(runtimeType.toString());

      final encrytpionService = ref.read(encryptionServiceProvider);

      if (widget.encryptedData != null) {
        final wallet = encrytpionService.decryptData(
          widget.encryptedData.toString(),
        );

        ref.watch(receipentAddressProvider.notifier).state = wallet;

        Future.delayed(Durations.medium1, () {
          navkey.currentContext!.push(pEnterAmountWallet).then((_) {
            navkey.currentContext!.pop();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
