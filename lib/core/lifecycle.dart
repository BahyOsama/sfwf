import 'dart:developer';

import 'package:flutter/widgets.dart';

/// Hook interface for responding to application lifecycle changes.
abstract class AppLifecycleHook {
  /// Called when the application lifecycle state changes.
  void onStateChanged(AppLifecycleState state);
}

/// A lifecycle hook that logs app state changes to the console.
class LoggerHook implements AppLifecycleHook {
  @override
  /// Logs the lifecycle state change.
  void onStateChanged(AppLifecycleState state) {
    log('App lifecycle: $state');
  }
}
