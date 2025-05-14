import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:hashlib/hashlib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account.notifier.g.dart';

// ignore: constant_identifier_names
const int MAX_PIN_ATTEMPTS = 5;
// ignore: constant_identifier_names
const int WARNING_THRESHOLD = 3; // Show warning when this many attempts remain

final myMnenomics = FutureProvider<String>((ref) async {
  return await ref.watch(solanaServiceProvider).showMnemonics();
});

final validationIndicesProvider = StateProvider<List<int>>((ref) => []);

final selectedWordsProvider = StateProvider<Set<int>>((ref) => {});

final isWalletBackedUp = FutureProvider<String?>((ref) async {
  final storage = ref.watch(securedStorageServiceProvider);

  return await storage.readFromStorage(Strings.backupMnenomic);
});

final userHasBackedUpPhrase = FutureProvider<bool>((ref) async {
  final storage = ref.watch(securedStorageServiceProvider);

  final result = await storage.doesExistInStorage(Strings.backupMnenomic);

  return result;
});

@riverpod
class AccountNotifier extends _$AccountNotifier {
  @override
  AccountNotifier build() {
    return this;
  }

  List<int> generateRandomIndices(int phraseLength, int count) {
    final random = Random();
    final Set<int> indices = {};

    while (indices.length < count) {
      // Generate 1-based indices (1 to phraseLength)
      indices.add(random.nextInt(phraseLength) + 1);
    }

    return indices.toList()..sort();
  }

  Future<void> hasBackedUpPhrase() async {
    await ref.watch(securedStorageServiceProvider).writeToStorage(
          key: Strings.backupMnenomic,
          value: DateTime.now().toIso8601String(),
        );
  }

  // Get the current failure count and check if it needs to be reset
  Future<int> _getPinFailureCount() async {
    final storage = ref.watch(securedStorageServiceProvider);

    // Get the current failure count and last failure date
    final failureCountStr =
        await storage.readFromStorage(Strings.pinFailureCount);
    final failureDateStr =
        await storage.readFromStorage(Strings.pinFailureDate);

    int failureCount = 0;

    // If there's a previous failure count
    if (failureCountStr != null) {
      failureCount = int.parse(failureCountStr);

      // Check if we need to reset due to a new day
      if (failureDateStr != null) {
        final failureDate = DateTime.parse(failureDateStr);
        final now = DateTime.now();

        // Reset count if it's a new day
        if (failureDate.day != now.day ||
            failureDate.month != now.month ||
            failureDate.year != now.year) {
          failureCount = 0;
          await _resetPinFailureCount();
        }
      }
    }

    return failureCount;
  }

  // Update the failure count
  Future<void> _incrementPinFailureCount() async {
    final storage = ref.watch(securedStorageServiceProvider);

    // Get current count
    int failureCount = await _getPinFailureCount();

    // Increment count
    failureCount++;

    // Store updated count and current date
    await storage.writeToStorage(
      key: Strings.pinFailureCount,
      value: failureCount.toString(),
    );

    await storage.writeToStorage(
      key: Strings.pinFailureDate,
      value: DateTime.now().toIso8601String(),
    );
  }

  // Reset the failure count
  Future<void> _resetPinFailureCount() async {
    final storage = ref.watch(securedStorageServiceProvider);

    await storage.writeToStorage(
      key: Strings.pinFailureCount,
      value: '0',
    );

    await storage.writeToStorage(
      key: Strings.pinFailureDate,
      value: DateTime.now().toIso8601String(),
    );
  }

  // Wipe all sensitive data from storage
  Future<void> _wipeData() async {
    final storage = ref.watch(securedStorageServiceProvider);

    await storage.removeFromStorage(removeAll: true);

    // Reset failure count after wipe
    await _resetPinFailureCount();
  }

  // Enhanced PIN validation with security checks
  Future<PinValidationResult> validatePin(String pin) async {
    final storage = ref.watch(securedStorageServiceProvider);

    // Get current failure count
    int failureCount = await _getPinFailureCount();

    // Check if we've already reached max attempts
    if (failureCount >= MAX_PIN_ATTEMPTS) {
      await _wipeData();
      return PinValidationResult.wiped;
    }

    // Validate pin
    final pinHash = sha256.string(pin);
    final cachedPinHash = await storage.readFromStorage(Strings.accessCode);
    final bool isCorrect = pinHash.base64() == cachedPinHash;

    if (isCorrect) {
      // Reset failure count on successful login
      await _resetPinFailureCount();
      return PinValidationResult.correct;
    } else {
      // Increment failure count
      await _incrementPinFailureCount();
      failureCount++; // Include this attempt

      // Check if this attempt triggered a wipe
      if (failureCount >= MAX_PIN_ATTEMPTS) {
        await _wipeData();
        return PinValidationResult.wiped;
      }

      // Check if we should warn the user
      int attemptsRemaining = MAX_PIN_ATTEMPTS - failureCount;
      if (attemptsRemaining <= WARNING_THRESHOLD) {
        return PinValidationResult.incorrect(attemptsRemaining);
      }

      return PinValidationResult.incorrect(attemptsRemaining);
    }
  }

  Future<bool> isPinCorrect(String pin) async {
    final storage = ref.watch(securedStorageServiceProvider);

    final pinHash = sha256.string(pin);
    final cachedPinHash = await storage.readFromStorage(Strings.accessCode);

    return pinHash.base64() == cachedPinHash;
  }

  Future<String> userWallet() async {
    final sol = ref.read(solanaServiceProvider);

    return await sol.walletAddress();
  }

  Future<String?> username() async {
    return await ref.read(myUsernameProvider.future);
  }
}

// Create a result class to represent different validation outcomes
enum PinValidationStatus { correct, incorrect, wiped }

class PinValidationResult {
  final PinValidationStatus status;
  final int? attemptsRemaining;

  const PinValidationResult._(this.status, [this.attemptsRemaining]);

  static const PinValidationResult correct =
      PinValidationResult._(PinValidationStatus.correct);
  static const PinValidationResult wiped =
      PinValidationResult._(PinValidationStatus.wiped);
  static PinValidationResult incorrect(int attemptsRemaining) =>
      PinValidationResult._(PinValidationStatus.incorrect, attemptsRemaining);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PinValidationResult) return false;
    return status == other.status;
  }

  @override
  int get hashCode => status.hashCode;
}
