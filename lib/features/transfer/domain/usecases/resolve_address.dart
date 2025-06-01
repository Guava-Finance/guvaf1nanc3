import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final receipentAddressProvider = StateProvider<String?>((ref) {
  return null;
});

final isUsingUsername = StateProvider<bool>((ref) => false);

final resolveAddressUsecaseProvider = Provider<ResolveAddressUsecase>((ref) {
  return ResolveAddressUsecase(
    ref: ref,
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  );
});

class ResolveAddressUsecase extends UseCase<AppState, String> {
  ResolveAddressUsecase({
    required this.repository,
    required this.solanaService,
    required this.ref,
  });

  final TransferRepository repository;
  final SolanaService solanaService;
  final Ref ref;

  @override
  Future<AppState> call({required String params}) async {
    if (solanaService.isValidAddress(params)) {
      ref.read(receipentAddressProvider.notifier).state = params;

      ref.watch(isUsingUsername.notifier).state = false;

      navkey.currentContext!.mixpanel.timetrack(
        MixpanelEvents.sendViaWallet,
      );

      return LoadedState(params);
    } else {
      final result =
          await repository.resolveUsername(params.toLowerCase().trim());

      if (result.isError) {
        navkey.currentContext!.notify.addNotification(
          NotificationTile(
            notificationType: NotificationType.error,
            content:
                '''Failed to resolve. Please check username or wallet address and try again''',
          ),
        );

        ref.read(receipentAddressProvider.notifier).state = null;
      } else {
        ref.read(receipentAddressProvider.notifier).state =
            (result as LoadedState).data['data']['wallet_address'];

        ref.watch(isUsingUsername.notifier).state = true;

        navkey.currentContext!.mixpanel.timetrack(
          MixpanelEvents.sendViaUsername,
        );
      }

      return result;
    }
  }
}
