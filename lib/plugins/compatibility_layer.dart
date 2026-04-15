import 'package:flutter/foundation.dart';

class PluginFallback {
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
