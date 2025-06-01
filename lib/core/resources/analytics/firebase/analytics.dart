import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final firebaseAnalyticsProvider = Provider<MyFirebaseAnalytics>((ref) {
  return MyFirebaseAnalytics();
});

class MyFirebaseAnalytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    _analytics.app.setAutomaticDataCollectionEnabled(true);
  }

  Future<void> triggerEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  Future<void> triggerAppOpened({Map<String, Object>? parameters}) async {
    await _analytics.logAppOpen(
      parameters: parameters,
    );
  }

  Future<void> triggerScreenLogged(
    String screen, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logScreenView(
      screenClass: screen,
      parameters: parameters,
    );

    triggerEvent('$screen opened');
  }

  // Set user properties for targeting
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(
      name: _sanitizePropertyName(name),
      value: value,
    );
  }

  static String _sanitizePropertyName(String name) {
    // Remove invalid characters and ensure it meets requirements
    String sanitized = name
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '') // Remove invalid chars
        .toLowerCase();

    // Ensure it doesn't start with a number
    if (sanitized.isNotEmpty && RegExp(r'^[0-9]').hasMatch(sanitized)) {
      sanitized = 'prop_$sanitized';
    }

    // Ensure it's not empty
    if (sanitized.isEmpty) {
      sanitized = 'custom_property';
    }

    // Truncate to 24 characters max
    if (sanitized.length > 24) {
      sanitized = sanitized.substring(0, 24);
    }

    return sanitized;
  }
}
