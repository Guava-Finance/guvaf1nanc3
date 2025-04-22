import 'dart:convert';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/event_options.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final amplitudeProvider = Provider<AmplitudeService>((ref) {
  return AmplitudeService(
    solanaService: ref.read(solanaServiceProvider),
    storageService: ref.read(securedStorageServiceProvider),
  );
});

class AmplitudeService {
  AmplitudeService({
    required this.solanaService,
    required this.storageService,
  }) {
    amplitude = Amplitude(Configuration(
      apiKey: Env.amplitudeApiKey,
    ));
  }

  final SolanaService solanaService;
  final SecuredStorageService storageService;

  Amplitude? amplitude;

  Future<void> trackInstrument(String event) async {
    final wallet = await solanaService.walletAddress();
    final data = await storageService.readFromStorage(Strings.myAccount);

    final myAccount = AccountModel.fromJson(jsonDecode(data!));

    amplitude?.track(
      BaseEvent(event),
      EventOptions(
        userId: wallet,
        timestamp: DateTime.now().millisecond,
        ip: myAccount.ipAddress,
        country: myAccount.deviceInfo['country'] ?? '',
      ),
    );
  }
}
