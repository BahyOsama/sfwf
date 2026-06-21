import 'package:flutter/foundation.dart';

/// Provides safe fallback between web and native implementations.
class PluginFallback {
  /// Runs [webImplementation] on web, otherwise runs [fallback].
  static T safeCall<T>({
    required T Function() webImplementation,
    required T Function() fallback,
  }) {
    if (kIsWeb) {
      return webImplementation();
    }
    return fallback();
  }
}
